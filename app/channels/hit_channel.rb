class HitChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "hit_channel"
  end

    # the "hits_channel.js" has a "connected" method that will call
    #  the "HitsChannel::hits" method to increment and broadcast 
  def trigger_hits
    # HitJob.perform_later
    REDIS.incr('hits_count')
    data = {}
    data['hits_count'] = REDIS.get('hits_count').to_i
    host_name = Socket.gethostname
    REDIS.incr(host_name)
    value = REDIS.get(host_name).to_i
    data["#{host_name}"] = (value * 100 / data['hits_count']).round(0)
    puts data
    ActionCable.server.broadcast('hit_channel', data.as_json)
  end
  
  # to illustrate the "send"
  def receive(data)
    puts data
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end