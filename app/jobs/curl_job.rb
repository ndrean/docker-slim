class CurlJob < ApplicationJob
    require 'oj'
    require 'net/http'
    require 'rest-client'
    require 'uri'
    queue_as :default

  def perform
    # Path to ServiceAccount token
    serviceaccount = '/var/run/secrets/kubernetes.io/serviceaccount'
    namespace = File.read("#{serviceaccount}/namespace")
    apiserver = 'https://kubernetes.default.svc'
    token = File.read("#{serviceaccount}/token")
    cacert = "#{serviceaccount}/ca.crt"
    uri = URI("#{apiserver}/api/v1/namespaces/#{namespace}/pods")
    # or uri = URI("https://#{ENV['KUBERNETES_SERVICE_HOST']}/api/v1/namespaces/#{namespace}/pods")
    request = `curl --cacert #{cacert} --header "Authorization: Bearer #{token}" #{uri} `
    


    # with proxy the side-car k8 server
    # uri = "http://127.0.0.1:8001/api/v1/namespaces/#{namespace}/pods"
    # data = URI.open(uri).read

    data = {}
    parsed_data = Oj.load(request)['items'].map { |item| item['metadata']['name'] }#.map.with_index { |i,v| [i,v] }.to_h
    
    # <- too much calls to db
    # parsed_data.each do |host|
    #   record  = Counter.find_or_create_by(hostname: host)
    #   record.nb = 1 if !record.nb
    #   record.nb += 1 if record.hostname == REDIS.get('railsID')
    #   # record.update(nb: record.nb )
    #   data[host.to_sym] = {
    #     nb: record.nb,
    #     created_at:  record.created_at.strftime("%H:%M:%S:%L"),
    #   }
    # end
    
    existing_records = Counter.where(hostname: parsed_data)
    existing_records.each do |record_obj| 
      record_obj.nb += 1 if record_obj.hostname == REDIS.get('railsID')
      record_obj.update(nb: record_obj.nb)
      data[record_obj.hostname.to_sym] = {
        nb: record_obj.nb,
        created_at:  record_obj.created_at.strftime("%H:%M:%S:%L"),
      }
    end
    new_records = parsed_data - existing_records.pluck(:hostname)
    new_records.each { |record|  
      new_record = Counter.create!(hostname: record, nb: 1)  
      data[record.to_sym] = {
        nb: 1,
        created_at:  new_record.created_at.strftime("%H:%M:%S:%L"),
      }
    }

    ActionCable.server.broadcast('list_channel', data.as_json)

    response = send_request({token: token, cacert: cacert, uri: uri})
    puts ans = {ans: response.body} if response['status'] != 500
    # puts add = {k8s: k8s}
    # `curl --cacert #{cacert} --header "Authorization: Bearer #{token}" #{k8s}/healthz`
  rescue StandardError => e
    puts e.message
  end



  def send_request(opt={})
    uri = opt[:uri]
    puts res = {res: "#{uri}"}
    store = OpenSSL::X509::Store.new
    store.set_default_paths
    store.add_file(opt[:cacert])

    http = Net::HTTP.start(uri.to_s) do |h|
      h.use_ssl = true
      h['Authorization'] = "Bearer #{opt[:token]}"
      h['Content-Type'] = 'application/json'
      h.cert_store = store
      h.verify_mode = OpenSSL::SSL::VERIFIY_PEER
    end
    response = http.request_get(uri).body
    
    http.finish
    return response
  rescue StandardError => e
    puts e.message
    { 'status' => 500, 'detail' => 'Something went wrong' }
  end

  # def send_request(opt={})
  #   store = OpenSSL::X509::Store.new
  #   store.set_default_paths
  #   store.add_file(opt[:cacert])

  #   # k8s = "https://#{ENV['KUBERNETES_SERVICE_HOST']}:#{ENV['KUBERNETES_SERVICE_PORT_HTTPS']}"

  #   request = RestClient::Resource.new(
  #     opt[:uri],
  #     ssl_cert_store: store, 
  #     verify_ssl: OpenSSL::SSL::VERIFY_PEER,
  #   )
  #   request.get( 
  #     {Authorization: "Bearer #{opt[:token]}"}
  #   )
  # end
end





