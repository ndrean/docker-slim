module SidekiqHelper
   require 'sidekiq/monitor'
   
   class Error < StandardError
   end
   

   def self.check
      # github/sidekiq/lib/sidekiq/monitor.rb
      Sidekiq::Monitor::Status.new.display(section="processes")
      
      # cf gtihub/lib/sidekiq/Sidekiq/api.rb
      size = Sidekiq::Stats.new().processes_size
      begin
         raise Execption.new "Sidekiq down" if size == 0
      rescue => e
         puts e.message
         
      end
      

      # github/sidekiq/lib/sidekiq.rb
      puts Sidekiq.redis { |con| con.connection[:id] }
   end
   
end