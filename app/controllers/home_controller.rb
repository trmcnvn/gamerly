class HomeController < ApplicationController
  def index
    @content = Rails.cache.fetch('gamerly_content') { { articles: [], updated_at: Time.now } }
    fresh_when last_modified: @content[:updated_at], public: true
  end
end
