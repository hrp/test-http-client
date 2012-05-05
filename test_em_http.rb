evm_count = ITERATIONS
Thread.new { EventMachine.run }

test_http("em-http") do

   http = EventMachine::HttpRequest.new(URL.to_s).get \
     :head => {"X-Test" => "test"}, :timeout => 60

   http.errback { EM.stop; raise Exception.new }

   http.callback do
     verify_response(http.response)
     evm_count -= 1
     EM.stop if evm_count <= 0
   end

end
