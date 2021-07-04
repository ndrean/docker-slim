class HardWorker
  include Sidekiq::Worker
  include PagesHelper

  def perform(*args)
    p Rails.logger.info ' !!!!!!! I am a WORKER, doing a heavy work: CURL to Google ......!!!!!!!'

    obj = PagesHelper.scrap(1)
    puts Rails.logger.info "WORKER:..#{obj}..||..#{obj["title"]}...is...#{obj["completed"]}"

    system('curl -I http://google.com')
    
  end
end
