class Push
  include Callee

  param :post

  def call
    attachment_ids = create_attachments
    post_id = create_post(attachment_ids)
    post.update(freefeed_post_id: post_id)
    create_comments(post_id)
    post.update(status: PostStatus.published)
  rescue StandardError
    post.update(status: PostStatus.error)
    raise
  end

  # TODO: Test coverage
  # TODO: Use data objects for Freefeed API wrapper

  private

  def create_post(attachment_ids)
    response = freefeed.create_post(
      post: {
        body: post.text,
        attachments: attachment_ids
      },
      meta: {
        feeds: [post.feed.name]
      }
    )

    response.parse.dig('posts', 'id')
  end

  def create_comments(post_id)
    post.comments.each do |comment|
      freefeed.create_comment(
        comment: {
          body: comment,
          postId: post_id
        }
      )
    end
  end

  def create_attachments
    post.attachments.map { |url| create_attachment(url) }
  end

  def create_attachment(url)
    Downloader.call(url) do |io, content_type|
      response = freefeed.create_attachment(io, content_type: content_type)
      response.parse.dig('attachments', 'id')
    end
  end

  def freefeed
    @freefeed ||= FreefeedClientBuilder.call
  end
end
