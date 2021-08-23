class HardWorker
  include Sidekiq::Worker
  include PagesHelper
  require "net/http"
  
  class Error < StandardError
  end

  def perform(*args)
    p Rails.logger.info '*** I am a WORKER, doing a heavy work: fetching an API ......!!!!!!!'

    obj = PagesHelper.get_api(1) || nil
    puts Rails.logger.info "WORKER:..#{obj}..||..#{obj["title"]}...is...#{obj["completed"]}"

    raise HardWorker::Error.new('could not fetch the API') if obj == nil

    
  end
end
