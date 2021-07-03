class PagesController < ApplicationController

  include PagesHelper

  

  def home    
    # <- test Redis database
    p "Redis db:  #{REDIS.ping}"
    # <- test Sidekiq/Redis connection
    p "Redis-Sidekiq: #{Sidekiq.redis { |conn| conn.connection[:id] }}"
    # PSQL <- test PG connection
    # ActiveRecord::Base.connection.execute("SELECT 1") 
      
  end

  def start_workers
    # background WORKER with Sidekiq
    HardWorker.perform_async
    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    HardJob.perform_later 
    render json: {status: :ok}
  end

  def get_counters
    cPG = Counter.last
    cRed = REDIS.get('compteur')

    if (cPG == nil )
      countPG = 0
    end
    
    if (cRed == "")
      countRedis = 0
    end

    if (cPG != nil && cRed != "")
      render json: {
        countPG: cPG.nb,
        countRedis: cRed,
        status: :ok
      }
    end

    if (cPG != nil && cRed == "")
      render json: {
        countPG: cPG.nb,
        countRedis: countRedis,
        status: :ok
      }
    end

    if (cPG == nil && cRed != "")
      render json: {
        countPG: countPG,
        countRedis: cRed,
        status: :ok
      }
    end

  end


  def create
    # console
    # p params
    Counter.create!(nb: params[:countPG])
    REDIS.set("compteur", params[:countRedis])
    # end
    render json: {
        status: :created,
    }
  end

end