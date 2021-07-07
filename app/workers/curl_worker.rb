class CurlWorker
  # include Sidekiq::Worker
  require "net/http"
  

  class Error < StandardError
  end

  def perform(*args)
    p Rails.logger.info ' !!!!!!! I am a WORKER, doing a heavy work: CURL to Google ......!!!!!!!'
    # system('curl -I http://google.com')
    uri = URI('https://google.com')
    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)
    raise CurlWorker::Error.new('could not get Google') if (res.code != '301')

    
  end
end
