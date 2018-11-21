require 'test_helper'

class GithubServiceTest < ActionDispatch::IntegrationTest
  test 'it gets the gist content' do
    VCR.use_cassette('get_gist_content', re_record_interval: 7.days) do
      @service = GithubService.new('7dcb22cd0f2b1ecc3b2ed87171a16f4a')
      data = @service.get_gist_content
      data = JSON.parse(data)
      assert_equal 1, data.keys.count
      assert_equal 'hello', data.keys.first
    end
  end

  test 'it updates the gist content' do
    VCR.use_cassette('update_gist_content', re_record_interval: 7.days) do
      @service = GithubService.new('7dcb22cd0f2b1ecc3b2ed87171a16f4a')
      data = @service.update_gist_content({ hello: 'world' })
      data = data.to_h
      assert_equal '7dcb22cd0f2b1ecc3b2ed87171a16f4a', data[:id]
    end
  end
end
