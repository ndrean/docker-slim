class HitsChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "hits"
    
  end

  def hits
    data = {}
    data['hits_count'] = REDIS.get('page_count').to_i
    puts data
    ActionCable.server.broadcast('hits', data.as_json)
  end
  
  def unsubscribed
    stop_all_streams
  end
end