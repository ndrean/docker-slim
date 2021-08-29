class ApplicationController < ActionController::Base
   protect_from_forgery with: :exception
   around_action :global_request_logging

   def global_request_logging
      begin
         yield
      ensure
         logger.info "USER_AGENT: #{request.headers['HTTP_USER_AGENT']}" 
      end
   end
end
