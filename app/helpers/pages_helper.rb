module PagesHelper
   require 'open-uri'


   def self.scrap(id)
      url="https://jsonplaceholder.typicode.com/todos/#{id}"
      response = URI.open(url)
      json = JSON.parse(response.read)
      return json
   end
end
