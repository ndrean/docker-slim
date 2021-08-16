class CurlJob < ApplicationJob
    require 'faraday'
    
    queue_as :default
    
  class Error < StandardError
  end

  def perform(*args)
    # Point to the internal API server hostname
    # apiserver= 'https://kubernetes.default.svc'
    # # Path to ServiceAccount token
    serviceaccount= '/var/run/secrets/kubernetes.io/serviceaccount'
    # # Read this Pod's namespace
    namespace=File.read("#{serviceaccount}/namespace")
    # # Read this Pod's namespace
    # token= File.read("#{serviceaccount}/token")
    # # Reference the internal certificate authority (CA)
    # cacert= "#{serviceaccount}/ca.crt"
    # uri = URI("#{apiserver}/api/v1/namespaces/#{namespace}/pods")
    # headers = {
    #   'Authorization'=> "Bearer #{token}",
    #   'Content-Type'=> 'application/json',
    #   'Accept' => 'application/json',
    #   'carcert' => "#{cacert}"
    # }
    # res={}
    # res['net'] = Net::HTTP.get_response(uri, nil, headers).body
    # puts res

    uri = URI("http://127.0.0.1:8001/api/v1/namespaces/#{namespace}/pods")
    # data = {}
    # data['response'] = Faraday.get(uri).body
    response = Faraday.get(uri).body
    data = JSON.parse(response)['items'].map {|item| item['metadata']['name'] }.map.with_index { |i,v| [v,i] }.to_h
    puts data
    # File.open('pods.json','w') { |f| f.write } #-> to be save in PGSQL
    ActionCable.server.broadcast('list_channel', data.as_json)
  end
end

