require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test 'it returns a JSON response' do
    VCR.use_cassette('api_response', re_record_interval: 7.days) do
      get root_url
      assert_response :success
      assert_equal 'application/json', @response.content_type

      data = JSON.parse(@response.body)
      assert data.count > 0
    end
  end
end
