class PagesController < ApplicationController

  include PagesHelper
  include SidekiqHelper

  class Error < StandardError
  end

  def home
    # <- test Redis database
    p "Redis db:  #{REDIS.ping}"
    # <- test Sidekiq/Redis connection (github/sidekiq/lib/sidekiq.rb)
    p "Redis-Sidekiq: #{Sidekiq.redis { |con| con.connection[:id] }}"

    # PSQL <- test PG connection
    begin
      one = ActiveRecord::Base.connection.execute("SELECT 1").getvalue(0,0)
      STDOUT.puts "PG is UP" if (one ==1)
      raise PagesController::Error.new('PG down') if (one != 1)
    rescue => e
      STDOUT.puts e.message
    end
    
    #<- check Sidekiq
    SidekiqHelper.check
      
  end

  def start_workers
    begin
      raise PagesController::Error.new('Workers Sidekiq down') if (Sidekiq::Stats.new().processes_size == 0)
      # Worker with Sidekiq
      HardWorker.perform_async
      # Active_Job with Sidekiq
      HardJob.perform_later 
      render json: { status: 200 }
    rescue => e
      STDERR.puts e.message
      render json: { status: 500}
    end
  end

  def get_counters
    begin
      cPG = Counter.last
      cRed = REDIS.get('compteur')
      countPG = (cPG == nil) ? 0 : cPG.nb
      countRedis = (cRed == '') ? 0 : cRed
      render json: {
        countPG: countPG,
        countRedis: countRedis,
        status: :ok
      }

    rescue => e
      STDERR.puts e.message
      render json: { status: 500}
    end
    
  end

  def create
    # console
    # p params
    begin
      Counter.create!(nb: params[:countPG])
      REDIS.set("compteur", params[:countRedis])
      render json: { status: :created }
    rescue => e
      STDOUT.puts e.message
      render json: {status: 500}
    end
    
  end

end