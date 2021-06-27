class HardWorker
  include Sidekiq::Worker
  include PagesHelper

  def perform(*args)
    p Rails.logger.info ' !!!!!!! I am a worker, doing a heavy work: curl to Google ......!!!!!!!'

    obj = PagesHelper.scrap(1)
    puts Rails.logger.info "WORKER:..#{obj}..||..#{obj["title"]}...is...#{obj["completed"]}"

    system('curl -I http://google.com')
    
  end
end
