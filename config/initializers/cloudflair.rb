Cloudflair.configure do |config|
  config.cloudflare.auth.key = ENV['CLOUDFLARE_KEY']
  config.cloudflare.auth.email = ENV['CLOUDFLARE_EMAIL']
end
