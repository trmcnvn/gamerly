class ApiController < ApplicationController
  def index
    news = Rails.cache.fetch('news') || {}
    render json: news
  end
end
