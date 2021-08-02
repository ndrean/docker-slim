class PagesController < ApplicationController
  include SidekiqHelper

  class Error < StandardError
  end

  # skip_before_action :verify_authenticity_token

  def home    
    # <- test Redis database: to be rescued
    puts "Redis db is UP" if (REDIS.ping == 'PONG')
    
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
  end

  def start_workers
    # background WORKER with Sidekiq: 
    HardWorker.perform_async
    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    HardJob.perform_later 
    return render json: { status: :no_content }
  rescue StandardError => e
    puts e.message
    render json: { status: 500}
  end
end
