class ListChannel < ApplicationCable::Channel
  def subscribed
    stream_from "list_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
