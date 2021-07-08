class ExampleController < ApplicationController
   def self.check
      size = {}
      size[:counts] = Counter.all.count
      render json: size.to_json
   end
end