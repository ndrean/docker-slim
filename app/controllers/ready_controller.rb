class ReadyController < ApplicationController
   # Readiness probe endpoint
   def index
      render json: {status: 200}
   end

   def whoami
      render json: {status: 200}
   end
end
