# performs tests and outputs on Sidekiq
module SidekiqHelper
   require 'sidekiq/monitor'
   class Error < StandardError
   end
   
   def self.check
      begin
         # cf gtihub/lib/sidekiq/Sidekiq/api.rb
         size = Sidekiq::Stats.new().processes_size
         Rails.logger.info "Size: #{size}"
         raise SidekiqHelper::Error.new('Sidekiq down') if (size.zero?)

         Rails.logger.info 'Sidekiq is UP' if (size.positive?)
         # github/sidekiq/lib/sidekiq/monitor.rb
         # Sidekiq::Monitor::Status.new.display('processes')
      rescue StandardError => e
         puts e.message
      end
   end
end
