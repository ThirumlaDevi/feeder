module Normalizers
  class NichtlustigDeNormalizer < Normalizers::RssNormalizer
    protected

    def text
      [super, "!#{link}"].join(separator)
    end

    def attachments
      [image_url]
    rescue
      []
    end

    def image_url
      Nokogiri::HTML(entity.description).css('img')[1]['src']
    end
  end
end
