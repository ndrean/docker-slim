class CountersController < ApplicationController

   class Error < StandardError
   end

   def get_counters
    begin
      cPG = Counter.last
      cRed = REDIS.get('compteur')
      countPG = cPG.nil? ? 0 : cPG.nb
      countRedis = cRed == '' ? 0 : cRed
      render json: {
        countPG: countPG,
        countRedis: countRedis,
        status: :ok
      }
    rescue StandardError => e
      puts e.message
      render json: { status: 500 }
    end 
   end

   def create
      begin
         data = {}
         data['countPG'] = params[:countPG]
         # the value of the counter is incremented client-side
         counter = Counter.create!(nb: data['countPG'] )
         if counter.valid?
            # broadcast the message on the channel
            ActionCable.server.broadcast('counters_channel', data.as_json) 
            render json: { status: :created }
         else
            raise PagesController::Error.new("database down")
         end
      rescue StandardError => e
         puts e.message
         render json: { status: 500 }
      end 
   end
end
