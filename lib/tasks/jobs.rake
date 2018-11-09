namespace :jobs do
  desc "Fetch the latest news"
  task daily_news: :environment do
    data = [ScraperService::Pcgamer].map do |service|
      service.new.to_object
    end
    client = GithubService.new
    client.update_gist_content(data)
  end
end
