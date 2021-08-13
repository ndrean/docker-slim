class HitJob < ApplicationJob
   queue_as :high_priority

   def perform
      REDIS.incr('hits_count')
      data = {}
      data['hits_count'] = REDIS.get('hits_count').to_i
      host_name = Socket.gethostname
      REDIS.incr(host_name)
      value = REDIS.get(host_name).to_i
      data["#{host_name}"] = (value * 100 / data['hits_count']).round(0)
      puts data
      ActionCable.server.broadcast('hit_channel', data.as_json)
   end
end


# list = Open3.capture3("kubectl get pods -l app=rails -o go-template --template '{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}' -o=name")
# array_pods = list.first.split("\n")
# data = array_pods.map.with_index { |v,i| [i,v] }.to_h
# puts "Ready to stream the pods ?"
# puts data
# ActionCable.server.broadcast('list_channel', data.as_json)