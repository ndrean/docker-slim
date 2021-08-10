
redis_conf = {
  url: 'redis://localhost:6379/2', 
  # url: ENV.fetch('REDIS_SIDEKIQ',''),
  network_timeout: 5
}


if ENV['RAILS_ENV'] == "production"
  redis_conf = {
    url: ENV['REDISTOGO_URL'],
    network_timeout: 5
  }
end

Sidekiq.configure_server do |config|
  config.redis = redis_conf
  # config.on :startup do
  #   require 'prometheus_exporter/instrumentation'
  #   PrometheusExporter::Instrumentation::SidekiqQueue.start
  #   PrometheusExporter::Instrumentation::Process.start type: 'sidekiq'
  #   PrometheusExporter::Instrumentation::ActiveRecord.start(
  #     custom_labels: { type: "sidekiq" }, #optional params
  #     config_labels: [:database, :host] #optional params
  #   )
  # end
  # config.server_middleware do |chain|
  #   require 'prometheus_exporter/instrumentation'
  #   chain.add PrometheusExporter::Instrumentation::Sidekiq
  # end
  # config.death_handlers << PrometheusExporter::Instrumentation::Sidekiq.death_handler
  
end

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end
