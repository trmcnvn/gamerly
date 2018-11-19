class HomeController < ApplicationController
  before_action :set_headers

  def index
    @articles = JSON.parse client.get_gist_content
    @last_updated_at = updated_at
  end

  private
  def client
    @client ||= GithubService.new
  end

  def updated_at
    @updated_at ||= client.last_updated_at
  end

  def set_headers
    return if not Rails.env.production?
    expires_in 1.day, public: true
    response.headers['Last-Modified'] = updated_at.strftime("%a, %d %b %Y %T %Z")
    response.headers['Cache-Tag'] = 'gamerly-json'
  end
end
