module SidekiqHelper
   require 'sidekiq/monitor'
   class Error < StandardError
   end
   
   def self.check
      begin
         # cf gtihub/lib/sidekiq/Sidekiq/api.rb
         size = Sidekiq::Stats.new().processes_size
         raise SidekiqHelper::Error.new("Sidekiq down") if (size == 0)
         STDOUT.puts "Sidekiq is UP" if (size>0)
         # github/sidekiq/lib/sidekiq/monitor.rb
         Sidekiq::Monitor::Status.new.display(section="processes")
      rescue => e
         STDERR.puts e.message
      end
   end
end