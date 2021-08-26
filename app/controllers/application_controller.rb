class ApplicationController < ActionController::Base
   def global_request_logging
      begin
         yield
      ensure
         logger.info "USERAGENT: #{request.headers['HTTP_USER_AGENT']}" 
      end
   end
end
