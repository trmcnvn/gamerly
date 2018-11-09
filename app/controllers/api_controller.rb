class ApiController < ApplicationController
  before_action :set_headers

  def index
    data = client.get_gist_content
    render json: data
  end

  private
  def client
    @client ||= GithubService.new
  end

  def updated_at
    @updated_at ||= client.last_updated_at
  end

  def set_headers
    expires_in 1.day, public: true
    response.headers['Last-Modified'] = updated_at.strftime("%a, %d %b %Y %T %Z")
    response.headers['Cache-Tag'] = 'gamerly-json'
  end
end
