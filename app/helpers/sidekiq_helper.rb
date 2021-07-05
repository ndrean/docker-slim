module SidekiqHelper
   require 'sidekiq/monitor'

   class Error < StandardError
   end

   def self.check
      begin
         Sidekiq::Monitor::Status.new.display(section="all")
         # github/sidekiq/lib/sidekiq.rb
         STDOUT.puts Sidekiq.redis { |con| con.connection[:id] }
         # cf gtihub/lib/sidekiq/Sidekiq/api.rb
         size = Sidekiq::Stats.new().processes_size
         raise SidekiqHelper::Error.new("Sidekiq down") if size == 0
      rescue => e
         STDERR.puts e.message
      end
   end
end