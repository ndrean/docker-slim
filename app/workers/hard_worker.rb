class HardWorker
  include Sidekiq::Worker
  include PagesHelper
  require "net/http"
  
  class Error < StandardError
  end

  def perform(*args)
    p Rails.logger.info ' !!!!!!! I am a worker, doing a heavy work: curl to Google ......!!!!!!!'

    obj = PagesHelper.scrap(1)
    puts Rails.logger.info "WORKER:..#{obj}..||..#{obj["title"]}...is...#{obj["completed"]}"

    # system('curl -I http://google.com')
    uri = URI('https://google.com')
    res = Net::HTTP.get_response(uri)
    puts res.body
    raise HardJob::Error.new('could not get Google') if (res.code != '301')

    
  end
end
