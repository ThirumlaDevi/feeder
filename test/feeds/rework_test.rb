require 'test_helper'

class ReworkTest < Minitest::Test
  def subject
    Pull.call(feed)
  end

  def feed
    build(:feed, **feed_config)
  end

  def feed_config
    {
      name: 'rework',
      processor: 'feedjira',
      normalizer: 'rework',
      url: 'https://feeds.transistor.fm/rework'
    }
  end

  def setup
    stub_request(:get, 'https://feeds.transistor.fm/rework')
      .to_return(
        body: file_fixture('feeds/rework.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def expected_entity
    content = file_fixture('entities/rework.json').read
    result = JSON.parse(content).symbolize_keys
    result[:published_at] = DateTime.parse(result[:published_at])
    result
  end

  def test_entity_normalization
    assert_equal(expected_entity, subject.first)
  end
end
