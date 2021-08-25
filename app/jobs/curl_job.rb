class CurlJob < ApplicationJob
    require 'oj'
    require 'net/http'
    require 'uri'
    queue_as :default

  def perform
    # Path to ServiceAccount token
    serviceaccount= '/var/run/secrets/kubernetes.io/serviceaccount'
    namespace=File.read("#{serviceaccount}/namespace")
    apiserver= 'https://kubernetes.default.svc'
    token= File.read("#{serviceaccount}/token")
    cacert= "#{serviceaccount}/ca.crt"
    request = `curl --cacert #{cacert} --header "Authorization: Bearer #{token}" #{apiserver}/api/v1/namespaces/#{namespace}/pods `


    # puts Oj.load(send_request)

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
    
  rescue StandardError => e
    puts e.message
  end

  # https://yukimotopress.github.io/http
  def build_request
    serviceaccount= '/var/run/secrets/kubernetes.io/serviceaccount'
    namespace=File.read("#{serviceaccount}/namespace")
    apiserver= 'https://kubernetes.default.svc'
    cacert= "#{serviceaccount}/ca.crt"
    token= File.read("#{serviceaccount}/token")
    headers = {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
    return {headers: headers, cacert: cacert, uri: URI("#{apiserver}/api/v1/namespaces/#{namespace}/pods")}
    # return request = `curl --cacert #{cacert} --header "Authorization: Bearer #{token}" #{apiserver}/api/v1/namespaces/#{namespace}/pods `
  end

  def send_request
    store = OpenSSL::X509::Store.new
    store.set_default_paths
    store.add_file(build_request.cacert)

    http = Net::HTTP.new(build_request.uri, 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL:SSL::VERIFIY_PEER
    http.ca_file = store

    http.request.get(Net::HTTP::Get.new('/', build_request.headers)).body
  end
end





