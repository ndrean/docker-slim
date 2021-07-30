class CountersController < ApplicationController

   class Error < StandardError
   end

   def get_counters
    begin
      cPG = Counter.last
      cRed = REDIS.get('compteur')
      countPG = cPG.nil? ? 0 : cPG.nb
      countRedis = cRed.to_i
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
         data['countRedis'] = params[:countRedis]

         counter = Counter.create!(nb: data['countPG'] )
         REDIS.set('compteur', data['countRedis'])

         
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

   # def counter_params
   #    params.require(:counter).permit(:nb, :counter_id, :countPG, :countRedis)
   # end
end