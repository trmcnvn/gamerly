require 'test_helper'

class GematsuTest < ActionDispatch::IntegrationTest
  setup do
    @service = ScraperService::Gematsu.new
  end

  test '#to_object returns expected results' do
    VCR.use_cassette('gematsu_scraper', re_record_interval: 7.days) do
      data = @service.to_object
      assert_equal 'Gematsu', data[:source]
      assert_equal ScraperCategories::GENERAL, data[:category]
      assert data[:articles].count > 0
    end
  end
end
