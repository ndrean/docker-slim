module SidekiqHelper
   require 'sidekiq/monitor'
   class Error < StandardError
   end

   def self.check
      begin
         # cf github/lib/sidekiq/Sidekiq/api.rb
         size = Sidekiq::Stats.new().processes_size
         raise SidekiqHelper::Error.new("Sidekiq down") if size.zero?
         puts "Sidekiq is UP"
         # <- test Sidekiq/Redis connection (github/sidekiq/lib/sidekiq.rb)
         puts "Redis-Sidekiq @  #{Sidekiq.redis { |con| con.connection[:id] }}"
         Sidekiq::Monitor::Status.new.display(section="all")
      rescue => e
         STDERR.puts e.message
      end
   end
end