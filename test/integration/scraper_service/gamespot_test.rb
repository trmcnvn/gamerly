require 'test_helper'

class GamespotTest < ActionDispatch::IntegrationTest
  setup do
    @service = ScraperService::Gamespot.new
  end

  test '#to_a returns expected results' do
    VCR.use_cassette('gamespot_scraper', re_record_interval: 2.weeks) do
      data = @service.to_a
      assert data.count > 0
      assert_equal 'Gamespot', data[0][:source]
    end
  end
end
