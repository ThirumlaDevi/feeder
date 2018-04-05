# TODO: Prefer Feedjira noramlizer

module Normalizers
  class YoutubeNormalizer < Normalizers::Base
    def link
      entity.url
    end

    def published_at
      entity.published
    end

    def text
      [entity.title, entity.url].join(separator)
    end

    def comments
      [entity.content]
    end
  end
end
