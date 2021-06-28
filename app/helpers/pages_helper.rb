module PagesHelper
   require 'open-uri'
   
   # private
   # <- module method (self) => called with PagesHelper.count
   def self.increment
      # REDIS.ping     #<- test redis
      compteur = REDIS.get("compteur") || 0
      REDIS.incr('compteur')
      # need to specify Rails.logger in the module method
      # Rails.logger.debug "REDIS_DB: ...............#{redis.get('compteur')}"
      @compteur = compteur.to_i + 1
   end

   def self.scrap(id)
      url="https://jsonplaceholder.typicode.com/todos/#{id}"
      response = URI.open(url)
      json = JSON.parse(response.read)
      return json
   end
end
