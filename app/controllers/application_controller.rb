class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :global_request_logging

  def global_request_logging
#    def global_request_logging 
#     logger.info "USERAGENT: #{request.headers['HTTP_USER_AGENT']}"
#     begin 
#       yield 
#     ensure 
#       logger.info "response_status: #{response.status}"
#     end 
#   end
   #  http_request_header_keys = request.headers.env.keys.select{|header_name| header_name.match("^HTTP.*|^X-User.*")}
   #  http_request_headers = request.headers.env.select{ |header_name, header_value| http_request_header_keys.index(header_name) }
   #  puts '*' * 40
   #  pp request.method
   #  pp request.url
   #  pp request.remote_ip
   #  pp http_request_headers
   # #  pp ActionController::HttpAuthentication::Token.token_and_options(request)

   #  http_request_header_keys.each do |key|
   #    puts ["%20s" % key.to_s, ':', request.headers[key].inspect].join(" ")
   #  end
   #  puts '-' * 40
   #  params.keys.each do |key|
   #    puts ["%20s" % key.to_s, ':', params[key].inspect].join(" ")
   #  end
   #  puts '*' * 40

   begin
      yield
   ensure
      logger.info "USERAGENT: #{request.headers['HTTP_USER_AGENT']}" 
   end
  end
end
