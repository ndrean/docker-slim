class PagesController < ApplicationController
  include SidekiqHelper
  class Error < StandardError
  end

  # skip_before_action :verify_authenticity_token

  def home    
    # <- test Redis database: to be rescued
    res = REDIS.ping
    Rails.logger.info "Redis db is UP" if (REDIS.ping == 'PONG')
    raise PagesController::Error.new('Redis DB down') if (res != "PONG")

    Rails.logger.info( "Redis db:  #{res}")
    
    # PSQL <- test PG connection
    begin
      one = ActiveRecord::Base.connection.execute("SELECT 1").getvalue(0,0)
      raise PagesController::Error.new("PG is down") if (one != 1)
      puts "PG is UP"
    rescue => e
      puts e.message
    end
    # <- rescued Sidekiq test
    SidekiqHelper.check
    
    @origin = request.remote_ip

    # CurlJob.perform_later

    # APISERVER= 'https://kubernetes.default.svc'
    # # Path to ServiceAccount token
    # SERVICEACCOUNT= '/var/run/secrets/kubernetes.io/serviceaccount'
    # # Read this Pod's namespace
    # NAMESPACE= File.read(SERVICEACCOUNT + "/namespace")
    # # Read the ServiceAccount bearer token
    # TOKEN= File.read(SERVICEACCOUNT + '/token')
    # # Reference the internal certificate authority (CA)
    # CACERT= SERVICEACCOUNT + '/ca.crt'
    
    # uri = URI('APISERVER' + '/api/v1/namespaces/' + NAMESPACE + '/pods')
    # response = Farady.new(uri,
    #   headers: {
    #     'Authorization': 'Bearer'+ "#{TOKEN}",
    #     'Accept': 'application/json',
    #     'cacert': CACERT
    #   }
    # )
  end

  def start_workers
    # background WORKER with Sidekiq: 
    HardWorker.perform_async
    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    # HardJob.perform_later 
    return render json: { status: :no_content }
  rescue StandardError => e
    puts e.message
    render json: { status: 500}
  end
end

