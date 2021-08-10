class CounterChannel < ApplicationCable::Channel
  def subscribed
    # pubsub
    stream_from "counter_channel"
  end

  def receiving(msg)
    puts msg
    data = {}
    data['countPG'] = msg['countPG']
    # the value of the counter is incremented client-side
    counter = Counter.create!(nb: data['countPG'] )
    ActionCable.server.broadcast('counter_channel', data.as_json) if counter.valid?
  end

  def unsubscribed
    stop_all_streams
  end
end
