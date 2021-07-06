class PagesController < ApplicationController
  include SidekiqHelper

  class Error < StandardError
  end

  # skip_before_action :verify_authenticity_token

  def home    
    # <- test Redis database: to be rescued
    STDOUT.puts "Redis db is UP" if (REDIS.ping == 'PONG')
    # <- test Sidekiq/Redis connection (github/sidekiq/lib/sidekiq.rb)
    STDOUT.puts "Redis-Sidekiq @  #{Sidekiq.redis { |con| con.connection[:id] }}"

    # PSQL <- test PG connection
    begin
      ActiveRecord::Base.connection.execute("SELECT 1").getvalue(0,0)
      # raise PagesController::Error.new("PG is down") if (one != 1)
      STDOUT.puts "PG is UP"
    rescue => e
      STDERR.puts e.message
    end

    # <- rescued Sidekiq test
    SidekiqHelper.check
  end

  def start_workers
    #<- to be rescued
    # background WORKER with Sidekiq: 
    HardWorker.perform_async
    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    HardJob.perform_later 
    
    head :no_content
  end

  def get_counters
    begin
      cPG = Counter.last
      cRed = REDIS.get('compteur')
      raise PagesController::Error.new("database down") if (!cPG)

      countPG = (cPG == nil) ? 0 : cPG.nb
      countRedis = (cRed == '') ? 0 : cRed

      return render json: {
        countPG: countPG,
        countRedis: countRedis,
        status: :ok
      }
    rescue => e
      STDERR.puts e.message
    end

    return render json: { status: 500 }
  end

  def create
    begin
      if (Counter.create!(nb: params[:countPG]) && REDIS.set("compteur", params[:countRedis]))
        return render json: { status: :created }
      end
      raise PagesController::Error.new("database down")
    rescue => e
      STDERR.puts e.message
    end
    return render json: { status: 500}
  end
end
