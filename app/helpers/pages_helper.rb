module PagesHelper
   require 'open-uri'
   
   # <- module method (self) => called with PagesHelper.count
   # def self.incr_redis
   #    compteur = REDIS.get("compteur") || 0
   #    REDIS.incr('compteur')
   #    # Rails.logger.debug "REDIS_DB: ...............#{redis.get('compteur')}"
   #    compteur = compteur.to_i + 1
   #    return compteur
   # end

   def self.scrap(id)
      url="https://jsonplaceholder.typicode.com/todos/#{id}"
      response = URI.open(url)
      json = JSON.parse(response.read)
      return json
   end
end
