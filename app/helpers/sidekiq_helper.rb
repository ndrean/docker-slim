module SidekiqHelper
   require 'sidekiq/monitor'

   class Error < StandardError
   end

   def self.check
      Sidekiq::Monitor::Status.new.display(section="all")
      # cf gtihub/lib/sidekiq/Sidekiq/api.rb
      size = Sidekiq::Stats.new().processes_size

      begin
         raise SidekiqHelper::Error.new("Sidekiq down") if size == 0
      rescue => e
         STDERR.puts e.message
      end
      
      # github/sidekiq/lib/sidekiq.rb
      puts Sidekiq.redis { |con| con.connection[:id] }
   end
   
end