# frozen_string_literal: true

class PagesController < ApplicationController

  include PagesHelper
  include SidekiqHelper

  class Error < StandardError
  end

  def home
    # <- test Redis database
    res = REDIS.ping
    raise PagesController::Error.new('Redis DB down') if (res != "PONG")
    Rails.logger.info( 'Redis db is Up') 

    # <- test Sidekiq/Redis connection (github/sidekiq/lib/sidekiq.rb)
    Rails.logger.info( 'Redis-Sidekiq: #{Sidekiq.redis { |con| con.connection[:id] }}')

    # PSQL <- test PG connection
    begin
      one = ActiveRecord::Base.connection.execute('SELECT 1').getvalue(0,0)
      Rails.logger.info 'PG is UP' if (one == 1)
      raise PagesController::Error.new('PG down') if (one != 1)
    rescue => e
      puts e.message
    end
    # <- check Sidekiq
    SidekiqHelper.check

    @origin = request.remote_ip
  end

  def start_workers
    begin
      raise PagesController::Error.new('Workers Sidekiq down') if (Sidekiq::Stats.new.processes_size.zero?)
      # Worker with Sidekiq
      HardWorker.perform_async
      # Active_Job with Sidekiq
      HardJob.perform_later
      render json: { status: 200 }
    rescue StandardError => e
      puts e.message
      render json: { status: 500}
    end
  end
end