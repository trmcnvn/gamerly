ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'vcr'

# VCR replays
VCR.configure do |config|
  config.cassette_library_dir = 'test/vcrs'
  config.hook_into :webmock
end

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
