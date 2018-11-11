require 'test_helper'

class GematsuTest < ActionDispatch::IntegrationTest
  setup do
    @service = ScraperService::Gematsu.new
  end

  test '#to_a returns expected results' do
    VCR.use_cassette('gematsu_scraper', re_record_interval: 7.days) do
      data = @service.to_a
      assert data.count > 0
      assert_equal 'Gematsu', data[0][:source]
    end
  end
end
