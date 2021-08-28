class ApplicationController < ActionController::Base
   def global_request_logging
      begin
         yield
      ensure
         logger.info "USER_AGENT: #{request.headers['HTTP_USER_AGENT']}" 
      end
   end
end
