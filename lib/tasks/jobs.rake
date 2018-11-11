namespace :jobs do
  desc "Fetch the latest news"
  task daily_news: :environment do
    # scrape data
    data = []
    [
      ScraperService::Pcgamer,
      ScraperService::Gematsu
    ].each do |service|
      data.push(*service.new.to_a)
    end

    # remove articles that are > 24 hours old
    past_time = 24.hours.ago
    data.reject! { |article| article[:metadata][:pubdate] < past_time }

    # sort by pubdate
    data.sort_by! { |article| article[:metadata][:pubdate] }.reverse!

    # upload data to our gist database
    client = GithubService.new
    client.update_gist_content(data)

    # manually purge cloudflare caches instead of waiting for previous
    # data expiry
    Cloudflair.zone(ENV['CLOUDFLARE_ZONE_ID']).purge_cache.everything(true) # TODO: Selective

    # request the API endpoint so we can cache at CF level
    HTTParty.get('https://gamerly.disvelop.net/')

    # todo: send out one_signal notification that new data is available
  end
end
