# frozen_string_literal: true

class SafelyendangeredNormalizer < FeedjiraNormalizer
  option :image_urls, optional: true, default: -> { nil }

  protected

  def attachments
    @attachments ||= image_urls || comic_slides
  end

  def validation_errors
    super.tap do |errors|
      errors << 'no images included' if attachments.blank?
    end
  end

  private

  def comic_slides
    result = fetch_image_urls
    return [] if result.length < 3
    result[1..-2]
  end

  SELECTOR = '#_imageList ._images'
  ATTR = 'data-url'

  def fetch_image_urls
    content = RestClient.get(link).body
    Html.image_urls(content, selector: SELECTOR, attribute: ATTR)
  rescue StandardError
    Rails.logger.error("error fetching record url from #{link}")
    []
  end
end
