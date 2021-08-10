class HitsChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "hits_channel"
  end

    # the "hits_channel.js" has a "connected" method that will call
    #  the "HitsChannel::hits" method to increment and broadcast 
  def trigger_hits
    puts REDIS.get('hits_count') 
    REDIS.incr('hits_count')
    data = {}
    data['hits_count'] = REDIS.get('hits_count').to_i
    puts data
    ActionCable.server.broadcast('hits_channel', data.as_json)
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
