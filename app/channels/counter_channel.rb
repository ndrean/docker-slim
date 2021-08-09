class CounterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "counters_channel"
  end

  def receive(data)
    # rebroadcasting the received message to any other connected client
    puts data
    ActionCable.server.broadcast('counters_channel',data.as_json)
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
