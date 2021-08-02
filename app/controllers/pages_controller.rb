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


  # def get_counters
  #   cPG = Counter.last
  #   cRed = REDIS.get('compteur')
  #   countPG = (cPG.nil?) ? 0 : cPG.nb
  #   countRedis = cRed.to_i
  #   return render json: {
  #     countPG: countPG,
  #     countRedis: countRedis,
  #     status: :ok
  #   }
  # end

  # def create
  #   data = {}
  #   data['countPG'] = params[:countPG]
  #   data['countRedis'] = params[:countRedis]

  #   counter = Counter.create!(nb: data['countPG'] )
  #   REDIS.set('compteur', data['countRedis'])

  #   if counter.valid?
  #     # broadcast the message on the channel
  #     ActionCable.server.broadcast('counters_channel', data.as_json) 
  #     render json: { status: :created }
  #   else
  #     raise PagesController::Error.new("database down")
  #   end
  # rescue StandardError => e
  #     puts e.message
  #     render json: { status: 500 }
  # end 


    # begin
    #   if (Counter.create!(nb: params[:countPG])) && REDIS.set("compteur", params[:countRedis]))
    #     return render json: { status: :created }
    #   end
    #   raise PagesController::Error.new("database down")
    # rescue => e
    #   puts e.message
    # end
    # return render json: { status: 500}
  # end
end
