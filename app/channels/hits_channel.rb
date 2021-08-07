class HitsChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "hits_channel"
  end

  def trigger_hits
    # page_count = REDIS.get('page_count').to_i #<- pass to view
    data = {}
    data['hits_count'] = REDIS.get('page_count').to_i
    puts data
    ActionCable.server.broadcast('hits_channel', data.as_json)
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end