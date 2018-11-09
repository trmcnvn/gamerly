class ApiController < ApplicationController
  def index
    data = client.get_gist_content
    render json: data
  end

  private
  def client
    @client ||= GithubService.new
  end
end
