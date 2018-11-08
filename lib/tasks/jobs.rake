namespace :jobs do
  desc "Fetch the latest news"
  task daily_news: :environment do
    data = [ScraperService::Pcgamer].map do |service|
      service.new.to_object
    end
    Rails.cache.write('news', data)
  end
end
