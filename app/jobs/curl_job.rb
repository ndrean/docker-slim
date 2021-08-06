class CurlJob < ApplicationJob

    require "net/http"
    queue_as :default
    
  class Error < StandardError
  end

  def perform(*args)
    puts Rails.logger.info ' !!!!!!!! I am a JOB, doing a heavy job: CURL to Google ......!!!!!!!'

    uri = URI('https://google.com')
    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)
    
    # raise CurlJob::Error.new('could not get Google') if (res.code != '301')

  end
end
