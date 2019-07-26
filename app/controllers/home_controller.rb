class HomeController < ApplicationController
  def index
    @content = Rails.cache.fetch('gamerly_content')
    @content = { articles: [], updated_at: Time.now } if @content.nil?
    fresh_when last_modified: @content[:updated_at], public: true unless Rails.env.development?
  end
end
