Coderwall::Application.configure do
  config.threadsafe! unless $rails_rake_task
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.action_controller.perform_caching = false
  config.host = 'localhost:3000'

  # Allow pass debug_assets=true as a query parameter to load pages with unpackaged assets
  config.assets.allow_debugging = true
end
