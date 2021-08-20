class HitChannel < ApplicationCable::Channel
  def subscribed
    stream_from "hit_channel" # pubsub
    HitJob.perform_later #<- on connection()
  end

    # the "hitsChannel.connected()" method always calls "HitChannel::subscribed"
    # so we can put "HitJob.perform_later" in it.
    # Alternatively, since we defined "this.perform("trigger_hits")", it will call
    # the "HitsChannel::trigger_hits" method.
  def trigger_hits
    # HitJob.perform_later
  end
  
  # to illustrate the "send"
  def receive(data)
    puts data
  end

  def unsubscribed
    stop_all_streams
  end
end