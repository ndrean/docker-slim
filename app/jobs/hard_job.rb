class HardJob < ApplicationJob

    include PagesHelper
    require "net/http"
    queue_as :default

  class Error < StandardError
  end

  def perform(*args)
    puts Rails.logger.info ' ==> I am a JOB, doing a heavy job: fetching an API ......!!!!!!!'
    
    obj = PagesHelper.get_api(2) || nil
    puts Rails.logger.info "JOB:.#{obj}..||..#{obj["title"]}...is...#{obj["completed"]}"
    
    raise HardJob::Error.new('could not get the api') if obj == nil

  end
end
