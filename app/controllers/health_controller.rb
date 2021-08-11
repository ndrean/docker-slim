class HealthController < ApplicationController
   def index
      # results = { status: :ok}
      # respond_to do |format|
      #    format.html { render :status => 200, :html => "ok" and return }
      #    format.json { render :status => 200, :json => results.to_json and return }
      # end
      render json: { status: 200 }
   end
end