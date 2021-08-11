class CountersController < ApplicationController

   class Error < StandardError
   end

   def get_counters
      cPG = Counter.last
      countPG = cPG.nil? ? 0 : cPG.nb
      render json: {
        countPG: countPG,
        status: :ok
      }
   rescue StandardError => e
      puts e.message
      render json: { status: 500 }
   end 

   # def create
   #    data = {}
   #    data['countPG'] = params[:countPG]
   #    counter = Counter.create!(nb: data['countPG'] )
   #    if counter.valid?
   #       # broadcast the message on the channel
   #       ActionCable.server.broadcast('counters_channel', data.as_json) 
   #       render json: { status: :created }
   #    else
   #       raise PagesController::Error.new("database down")
   #    end
   # rescue StandardError => e
   #    puts e.message
   #    render json: { status: 500 }
   # end 
end