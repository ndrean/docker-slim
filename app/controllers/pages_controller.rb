class PagesController < ApplicationController

  include PagesHelper

  

  def home    
    # <- test Redis database
    p "Redis db:  #{REDIS.ping}"

    # <- test Sidekiq/Redis connection
    p "Redis-Sidekiq: #{Sidekiq.redis { |conn| conn.connection[:id] }}"

    # PSQL <- test PG connection
    ActiveRecord::Base.connection.execute("SELECT 1") 
      
  end

  def start_workers
    # background WORKER with Sidekiq
    HardWorker.perform_async
    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    HardJob.perform_later 
  end

  def get_counters
    render json: {
      countPG: Counter.last.nb,
      countRedis: REDIS.get('compteur').to_i
    }
  end

  def incr_counters
    nb = 0
    if (Counter.last == nil)
      Counter.create!(nb: 1)
      nb = 1
    else
      nb = Counter.last.nb + 1
      Counter.create!(nb: nb)
    end

    compteur = PagesHelper.incr_redis

    render json: {countPG: nb, countRedis: compteur}

  end
end