require 'test_helper'
require_relative '../support/normalizer_test_helper'

class SafelyendangeredNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    SafelyendangeredNormalizer
  end

  def sample_data_file
    'feed_safelyendangered.xml'
  end

  def sample_post_file
    'page_safelyendangered.html'
  end

  def processor
    FeedjiraProcessor
  end

  def options
    {
      image_urls: ATTACHMENTS
    }
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.each(&:success?))
  end

  ATTACHMENTS = [
    'https://webtoon-phinf.pstatic.net/20190911_296/1568154416605HLsES_PNG',
    'https://webtoon-phinf.pstatic.net/20190911_181/1568154416605WUiXi_PNG'
  ].freeze

  # rubocop:disable Metric/LineLength
  FIRST_SAMPLE = {
    uid: 'https://www.webtoons.com/en/comedy/safely-endangered/ep-502-snake-oil/viewer?title_no=352&episode_no=502',
    link: 'https://www.webtoons.com/en/comedy/safely-endangered/ep-502-snake-oil/viewer?title_no=352&episode_no=502',
    published_at: DateTime.parse('2019-09-11 01:00:39 UTC'),
    text: 'Ep. 502 - Snake Oil - https://www.webtoons.com/en/comedy/safely-endangered/ep-502-snake-oil/viewer?title_no=352&episode_no=502',
    attachments: ATTACHMENTS,
    comments: [],
    validation_errors: []
  }.freeze
  # rubocop:enable Metric/LineLength

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
