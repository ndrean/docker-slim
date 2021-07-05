class PagesController < ApplicationController
  include SidekiqHelper

  # skip_before_action :verify_authenticity_token

  def home    
    # <- test Redis database
    p "Redis db:  #{REDIS.ping}"
    # <- test Sidekiq/Redis connection
    p "Redis-Sidekiq: #{Sidekiq.redis { |conn| conn.connection[:id] }}"
    # PSQL <- test PG connection
    ActiveRecord::Base.connection.execute("SELECT 1") 
    # <- Sidekiq test
    SidekiqHelper.run
      
  end

  def start_workers
    # background WORKER with Sidekiq
    HardWorker.perform_async
    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    HardJob.perform_later 
    
    render json: { status: :ok}
  end

  def get_counters
    cPG = Counter.last
    cRed = REDIS.get('compteur')

    countPG = (cPG == nil) ? 0 : cPG.nb
    countRedis = (cRed == '') ? 0 : cRed

    render json: {
      countPG: countPG,
      countRedis: countRedis,
      status: :ok
    }
  end

  def create
    Counter.create!(nb: params[:countPG])
    REDIS.set("compteur", params[:countRedis])
    render json:  {
      status: :created
    }       
  end
end
