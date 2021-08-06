#  frozen_string_literal: true

# curl to Google
class HardJob < ApplicationJob 
  class Error < StandardError
  end

  require 'net/http'
  
  queue_as :default
  include PagesHelper

  def perform(*args)
    Rails.logger.info ' !!!!!!!! I am a job, doing a heavy job: curl to Google ......!!!!!!!'
    
    obj = PagesHelper.scrap(2)
    Rails.logger.info "JOB:.#{obj}..||..#{obj["title"]}...is...#{obj["completed"]}"
    
    # system('curl -I http://google.com')

    uri = URI('https://google.com')
    res = Net::HTTP.get_response(uri)
    puts res.body
    
    begin
      raise HardJob::Error.new('could not get Google') if (res.code != '301')
    rescue => e
      puts e.message
    end

  end
end
