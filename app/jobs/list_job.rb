class ListJob < ApplicationJob
   queue_as :high_priority

   def perform
      list = Open3.capture3("kubectl get pods -l app=rails -o go-template --template '{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}' -o=name")
      array_pods = list.first.split("\n")
      data = array_pods.map.with_index { |v,i| [i,v] }.to_h
      ActionCable.server.broadcast('list_channel', data.as_json)
   end
end