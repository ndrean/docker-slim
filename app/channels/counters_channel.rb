class CountersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "counters_channel"
  end

  # def receive(data)
  #   puts data
  #   # rebroadcasting the received message to any other connected client
  #   ActionCable.server.broadcast('counters_channel', data.as_json)
  # end
  
  def receiving(data)
    # the value of the counter is incremented client-side
    counter = Counter.create!(nb: data['countPG'] )
    msg = {}
    msg['countPG'] = data['countPG']
    puts msg
    ActionCable.server.broadcast('counters_channel', msg.as_json) if counter.valid?
  end

  def unsubscribed
    stop_all_streams
  end
end
