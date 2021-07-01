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


  # def incr_counters
  #   nb = 0
  #   # select * from counters order by id desc limit 1;
  #   if (Counter.last == nil)
  #     Counter.create!(nb: 1)
  #     nb = 1
  #   else
  #     nb = Counter.last.nb + 1
  #     Counter.create!(nb: nb)
  #   end

  #   compteur = PagesHelper.incr_redis
    
  #   render json: {countPG: nb, countRedis: compteur.to_i}
  # end

  def create
    Counter.create!(nb: params[:countPG])
    REDIS.set("compteur", params[:countRedis])
    render json: {
        status: :created,
    }
  end

end