class HitJob < ApplicationJob
   queue_as :high_priority

   def perform
      REDIS.incr('hitCount')
      host_name = Socket.gethostname
      record = Counter.find_or_create_by(hostname: host_name)
      !record.nb ? (record.nb = 1) : (record.nb += 1)
      record.update(nb: record.nb )

      data = {
         'hitCount' => REDIS.get('hitCount').to_i,
         host_name.to_sym => record.nb,
      }
   
      ActionCable.server.broadcast('hit_channel', data.as_json)
      puts data
      
   rescue StandardError => e
      puts e.message
   end
end


# list = Open3.capture3("kubectl get pods -l app=rails -o go-template --template '{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}' -o=name")
# array_pods = list.first.split("\n")
# data = array_pods.map.with_index { |v,i| [i,v] }.to_h