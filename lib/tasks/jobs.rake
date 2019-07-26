namespace :jobs do
  desc "Fetch the latest news"
  task daily_news: :environment do
    # scrape data
    data = [
      ScraperService::Pcgamer,
      ScraperService::Gematsu,
      ScraperService::Gamespot,
      ScraperService::Polygon
    ].map do |service|
      service.new.to_a rescue nil
    end
    data.compact!
    data.flatten!

    # remove articles that are > 24 hours old
    past_time = 24.hours.ago
    data.reject! { |article| article[:metadata][:pubdate] < past_time }

    # remove articles with short text
    data.reject! { |article| article[:summary].split(' ').length < 50 }

    # sort by pubdate
    data.sort_by! { |article| article[:metadata][:pubdate] }.reverse!

    # attempt to remove duplicates by comparing title distance
    data.reverse_each do |a|
      match = data.any? { |x| a != x && String::Similarity.cosine(a[:title], x[:title]) > 0.9 }
      data.delete(a) if match
    end

    # upload data to our gist database
    client = GithubService.new
    client.update_gist_content(data)

    # add to rails cache
    Rails.cache.write('gamerly_content', { articles: data, updated_at: client.last_updated_at })
  end

  desc "Send out notification"
  task notify_users: :environment do
    # send out one_signal notification that new data is available
    OneSignal::Notification.create(params: {
      app_id: ENV['ONE_SIGNAL_APP_ID'],
      included_segments: ['Subscribed Users'],
      contents: {
        en: 'Daily gaming news has been updated. Check it out!'
      }
    })
  end
end
