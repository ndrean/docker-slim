class HitChannel < ApplicationCable::Channel
  def subscribed
    stream_from "hit_channel" # pubsub
  end

    # the "hits_channel.js" has a "connected" method that will call
    #  the "HitsChannel::hits" method to increment and broadcast 
  def trigger_hits
    HitJob.perform_later
  end
  
  # to illustrate the "send"
  def receive(data)
    puts data
  end

  def unsubscribed
    stop_all_streams
  end
end