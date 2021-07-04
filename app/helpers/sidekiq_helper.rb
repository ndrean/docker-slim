module SidekiqHelper
   require 'sidekiq/monitor'

   def self.run
      section = ARGV[0] if ARGV.size == 1
      Sidekiq::Monitor::Status.new.display(section)
   end
   
end