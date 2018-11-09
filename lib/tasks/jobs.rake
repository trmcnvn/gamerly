namespace :jobs do
  desc "Fetch the latest news"
  task daily_news: :environment do
    # scape data
    data = [ScraperService::Pcgamer].map do |service|
      service.new.to_object
    end

    # upload data to our gist database
    client = GithubService.new
    client.update_gist_content(data)

    # manually purge cloudflare caches instead of waiting for previous
    # data expiry
    zone = Cloudflair.zones.first
    Cloudflair.zone(zone.id).purge_cache.selective(tags: ['gamerly-json'])

    # todo: send out one_signal notification that new data is available
  end
end
