class ListChannel < ApplicationCable::Channel
  def subscribed
    stream_from "list_channel"
  end

  def get_pods()
    # stream the GET to the Kubernetes API (Sidekiq with sidecar K8 server)
    CurlJob.perform_later
  end

  def unsubscribed
    stop_all_streams
  end
end
