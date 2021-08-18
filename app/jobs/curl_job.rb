class CurlJob < ApplicationJob
    require 'faraday'
    
    queue_as :default
    
  class Error < StandardError
  end

  def perform
    
    # # Path to ServiceAccount token
    serviceaccount= '/var/run/secrets/kubernetes.io/serviceaccount'
    # # Read this Pod's namespace
    namespace=File.read("#{serviceaccount}/namespace")
  
    uri = "http://127.0.0.1:8001/api/v1/namespaces/#{namespace}/pods"
    data = {}
    
    response = URI.open(uri).read

    # current_host = Socket.gethostname
    result_array = JSON.parse(response)['items'].map { |item| item['metadata']['name'] }#.map.with_index { |i,v| [i,v] }.to_h
    result_array.each do |host|
      record  = Counter.find_or_create_by(hostname: host)
      record.nb = 1 if !record.nb
      # record.nb += 1 if record.hostname == current_host
      # record.update(nb: record.nb )
      data[host.to_sym] = {
        nb: record.nb,
        created_at:  record.created_at.strftime("%H:%M:%S:%L")
      }
    end
    
    ActionCable.server.broadcast('list_channel', data.as_json)
    puts data

  rescue StandardError => e
    puts e.message
  end
end
# Point to the internal API server hostname
# apiserver= 'https://kubernetes.default.svc'
# token= File.read("#{serviceaccount}/token")
# Reference the internal certificate authority (CA)
# cacert= "#{serviceaccount}/ca.crt"
# request = URI.open("#{apiserver}/api/v1/namespaces/#{namespace}/pods",
#   {
#       'Authorization'=> "Bearer #{token}",
#       'Content-Type'=> 'application/json',
#       'Accept' => 'application/json',
#       'cacert' => "#{cacert}"
#     }
#   )