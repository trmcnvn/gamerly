require 'test_helper'

class PolygonTest < ActionDispatch::IntegrationTest
  setup do
    @service = ScraperService::Polygon.new
  end

  test '#to_a returns expected results' do
    VCR.use_cassette('polygon_scraper', re_record_interval: 2.weeks) do
      data = @service.to_a
      assert data.count > 0
      assert_equal 'Polygon', data[0][:source]
    end
  end
end
