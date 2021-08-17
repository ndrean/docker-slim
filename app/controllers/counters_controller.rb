class CountersController < ApplicationController
   class Error < StandardError
   end

   def get_counters
      begin
        render json: {
          hitCount: REDIS.get('hitCount').to_i,
          clickCount: REDIS.get('clickCount').to_i,
          status: :ok
        }
      rescue StandardError => e
          puts e.message
          render json: { status: 500 } 
      end
   end
end
