class ClickChannel < ApplicationCable::Channel
  def subscribed
    stream_from "click_channel" # pubsub
  end

  def receiving(data) 
    # nb: the value of the click is incremented client-side. 
    # Save click to Redis & per process to PGSQL & stream
    REDIS.set('clickCount', data['clickCount'])

    host_name = Socket.gethostname
    record = Counter.find_or_create_by(hostname: host_name)
    !record.nb ? (record.nb = 1) : (record.nb += 1)
    record.update(nb: record.nb)
    
    msg = {
      'clickCount'=> REDIS.get('clickCount').to_i, 
      host_name.to_sym => record.nb
    }
    ActionCable.server.broadcast('click_channel', msg.as_json)
    puts msg
  rescue StandardError => e
    puts e.message
  end

  def unsubscribed
    stop_all_streams
  end
end