class PagesController < ApplicationController

  include PagesHelper
  include SidekiqHelper

  

  def home    
    # <- test Redis database
    p "Redis db:  #{REDIS.ping}"
    # <- test Sidekiq/Redis connection
    p "Redis-Sidekiq: #{Sidekiq.redis { |conn| conn.connection[:id] }}"
    # PSQL <- test PG connection
    ActiveRecord::Base.connection.execute("SELECT 1") 
    #<- check Sidekiq
    SidekiqHelper.check
      
  end

  def start_workers
    # background WORKER with Sidekiq
    HardWorker.perform_async
    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    HardJob.perform_later 
    
    head :no_content
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
    # console
    # p params
    Counter.create!(nb: params[:countPG])
    REDIS.set("compteur", params[:countRedis])
    
    render json: { status: :created }
  end

end