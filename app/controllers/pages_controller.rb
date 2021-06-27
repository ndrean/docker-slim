class PagesController < ApplicationController

  # include PagesHelper

  def home
    # <- check ENV vars
    # Rails.logger.debug "........................... #{ENV['REDIS_URL']}"

    # background worker with Sidekiq: console.log the curl to Google
    HardWorker.perform_async

    # ACTIVE_JOB with Sidekiq (intializer with REDIS_URL, config.active_job.queue_adapter)
    HardJob.perform_later 

    # PSQL <- connection test
    ActiveRecord::Base.connection.execute("SELECT 1") 

    @nb = 0
    if (Counter.last == nil)
      Counter.create!(nb:1)
      @nb = 1
    else
      @nb = Counter.last.nb + 1
      Counter.create!(nb:@nb)
    end
    
     
    # UI -> execute an increment counter on page refresh, retrieved from a Redis db
    @compteur = PagesHelper.count
    
  end
end
