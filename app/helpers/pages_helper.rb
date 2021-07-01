module PagesHelper
   require 'open-uri'

   def self.get_api(id)
      url="https://jsonplaceholder.typicode.com/todos/#{id}"
      response = URI.open(url)
      json = JSON.parse(response.read)
      return json
   end
end
