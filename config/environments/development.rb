require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Specify AnyCable WebSocket server URL to use by JS client <--------------------
  # config.after_initialize do
  #   config.action_cable.url = ActionCable.server.config.url = ENV.fetch("CABLE_URL", "ws://localhost:8080/cable") if AnyCable::Rails.enabled?
  # end
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true


  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  

  # Action Cable embedded with Rails, use ".url" on localhost and pass meta_tag
  config.action_cable.url = "ws://localhost:28080/cable" 

  # ActionCable standalone;: remove ".url" and set -> in 'createConsumer(ws:localhost:28080/cable')
  
  # config.action_cable.disable_request_forgery_protection = true <- for any origin
  origins = ['http://localhost:5000', 'http://localhost:9000'] 
  config.action_cable.allowed_request_origins = origins
end
