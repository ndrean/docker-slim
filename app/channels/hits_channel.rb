class HitsChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "hits_channel"
    
  end

  def trigger_hits
    REDIS.incr('hits_count')
    data = {}
    data['hits_count'] = REDIS.get('hits_count').to_i
    ActionCable.server.broadcast('hits_channel', data.as_json)
  end
  
  def unsubscribed
    stop_all_streams
  end
end