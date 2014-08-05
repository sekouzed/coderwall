if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

ENV['RAILS_ENV'] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'

require 'webmock/rspec'
# WebMock.disable_net_connect!(allow_localhost: true)

require 'sidekiq/testing/inline'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

DatabaseCleaner.logger = Rails.logger
Rails.logger.level = 5

LOCAL_ELASTIC_SEARCH_SERVER = %r[^http://localhost:9200] unless defined?(LOCAL_ELASTIC_SEARCH_SERVER)

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.use_transactional_examples = false

  config.before(:all) do
    Redis.current.SELECT(testdb = 1)
    Redis.current.flushdb

  end

  config.before(:suite) do

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    Mongoid::Sessions.default.collections.reject { |c| c.name =~ /^system/ }.each(&:drop)
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
