class HardJob < ApplicationJob
    include PagesHelper
    require "net/http"
    queue_as :default
  class Error < StandardError
  end

  def perform(*args)
    puts Rails.logger.info ' !!!!!!!! I am a job, doing a heavy job: curl to Google ......!!!!!!!'
    
    obj = PagesHelper.scrap(2)
    puts Rails.logger.info "JOB:.#{obj}..||..#{obj["title"]}...is...#{obj["completed"]}"
    
    # system('curl -I http://google.com')

    uri = URI('https://google.com')
    res = Net::HTTP.get_response(uri)
    puts res.body
    raise HardJob::Error.new('could not get Google') if (res.code != '301')

  end
end
