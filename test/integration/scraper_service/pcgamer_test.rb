require 'test_helper'

class PcgamerTest < ActionDispatch::IntegrationTest
  setup do
    @service = ScraperService::Pcgamer.new
  end

  test '#to_a returns expected results' do
    VCR.use_cassette('pcgamer_scraper', re_record_interval: 2.weeks) do
      data = @service.to_a
      assert data.count > 0
      assert_equal 'PCGamer', data[0][:source]
    end
  end
end
