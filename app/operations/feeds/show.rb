module Operations
  module Feeds
    class Show < Operations::Base
      def call
        {
          json: feed,
          meta: meta
        }
      end

      private

      def feed
        Feed.find(id)
      end

      def id
        params.fetch(:id)
      end

      def meta
        {
          feeds_count: Feed.count,
          posts_count: Post.count,
          subscriptions_count: nil,
          updated_at: updated_at,
          last_post_created_at: last_post_created_at,
        }
      end

      def updated_at
        DataPoint.ordered.for('pull').first.try(:created_at)
      end

      def last_post_created_at
        Post.order(created_at: :desc).first.try(:created_at)
      end
    end
  end
end
