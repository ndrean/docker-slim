module SidekiqHelper
   require 'sidekiq/monitor'

   class Error < StandardError
   end

   def self.check
      # cf gtihub/lib/sidekiq/Sidekiq/api.rb
      # github/sidekiq/lib/sidekiq.rb
      # https://github.com/mhfs/sidekiq-failures
      begin
         size = Sidekiq::Stats.new().processes_size
         STDOUT.puts "- Sidekiq is UP" if (size > 0) 
         # <- Sidekiq/Redis connection
         STDOUT.puts "- Sidekiq connect to Redis @ #{Sidekiq.redis { |conn| conn.connection[:id] }}"         
         STDOUT.puts "- Sidekiq failures : #{Sidekiq::Failures.count}"
         Sidekiq::Monitor::Status.new.display(section="all")
         raise SidekiqHelper::Error.new("Sidekiq down") if size == 0
      rescue => e
         STDERR.puts e.message
      end
   end
end