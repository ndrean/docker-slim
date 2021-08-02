class CounterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "counters_channel"
  end

  def receive(data)
    # rebroadcasting the received message to any other connected client
    ActionCable.server.broadcast('counters_channel',data)
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
