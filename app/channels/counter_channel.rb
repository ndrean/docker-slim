class CounterChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "counter_channel"
  end

  def receiving(data)
    # the value of the counter is incremented client-side
    counter = Counter.create!(nb: data['countPG'] )
    msg = {}
    msg['countPG'] = data['countPG']
    puts msg
    ActionCable.server.broadcast('counter_channel', msg.as_json) if counter.valid?
  end

  def unsubscribed
    stop_all_streams
  end
end
