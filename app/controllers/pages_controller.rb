class PagesController < ApplicationController
  include SidekiqHelper


  def home    
    # <- test Redis database: to be rescued
    res = REDIS.ping
    Rails.logger.info "Redis db is UP" if (REDIS.ping == 'PONG')
    raise PagesController::Error.new('Redis DB down') if (res != "PONG")

    Rails.logger.info( "Redis db:  #{res}")
    
    # PSQL <- test PG connection
    
    one = ActiveRecord::Base.connection.execute("SELECT 1").getvalue(0,0)
    raise PagesController::Error.new("PG is down") if (one != 1)
    puts "PG is UP"
  

    # <- rescued Sidekiq test
    SidekiqHelper.check
    
    @origin = request.remote_ip

    #<- grab Rails podID
    REDIS.set('railsID', ENV['HOSTNAME'])

  rescue StandardError => e
      puts e.message
  end

  def start_workers
    # background WORKER with Sidekiq: 
    HardWorker.perform_async
    return render json: {status: :no_content}
  rescue StandardError => e
    puts e.message
    render json: { status: 500}
  end
end

