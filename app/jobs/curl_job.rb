class CurlJob < ApplicationJob
    require 'open3'
    require 'oj'
    queue_as :default
    
  class Error < StandardError
  end

  def perform
    
    # Path to ServiceAccount token
    serviceaccount= '/var/run/secrets/kubernetes.io/serviceaccount'
    namespace=File.read("#{serviceaccount}/namespace")
    apiserver= 'https://kubernetes.default.svc'
    token= File.read("#{serviceaccount}/token")
    cacert= "#{serviceaccount}/ca.crt"
    request = `curl --cacert #{cacert} --header "Authorization: Bearer #{token}" #{apiserver}/api/v1/namespaces/#{namespace}/pods `

    # with proxy the side-car k8 server
    # uri = "http://127.0.0.1:8001/api/v1/namespaces/#{namespace}/pods"
    # data = URI.open(uri).read

    data = {}

    result_array = Oj.load(request)['items'].map { |item| item['metadata']['name'] }#.map.with_index { |i,v| [i,v] }.to_h
    result_array.each do |host|
      record  = Counter.find_or_create_by(hostname: host)
      record.nb = 1 if !record.nb
      record.nb += 1 if record.hostname == REDIS.get('railsID')
      record.update(nb: record.nb )
      data[host.to_sym] = {
        nb: record.nb,
        created_at:  record.created_at.strftime("%H:%M:%S:%L"),
      }
    end
    
    ActionCable.server.broadcast('list_channel', data.as_json)
    puts data

  rescue StandardError => e
    puts e.message
  end
end
#
# request = URI.open("#{apiserver}/api/v1/namespaces/#{namespace}/pods",
#   {
#       'Authorization'=> "Bearer #{token}",
#       'Content-Type'=> 'application/json',
#       'Accept' => 'application/json',
#       'cacert' => "#{cacert}"
#     }
#   )