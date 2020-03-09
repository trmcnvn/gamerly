require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'it returns a HTML response' do
    VCR.use_cassette('html_response', re_record_interval: 7.days) do
      get root_url
      assert_response :success
      assert_equal 'text/html', @response.media_type
      assert_select 'link[rel="amphtml"]', 1
    end
  end

  test 'it returns the correct response for AMP' do
    VCR.use_cassette('amp_response', re_record_interval: 7.days) do
      get "#{root_url}?format=amp"
      assert_response :success
      assert_equal 'text/html', @response.media_type
      assert_select 'script[src="https://cdn.ampproject.org/v0.js"]', 1
    end
  end
end
