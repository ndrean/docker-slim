class CounterChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "click_counter"
    
  end

  def receive(data)
    # rebroadcasting the received message to any other connected client
    ActionCable.server.broadcast('click_counter',data)
  end

  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
