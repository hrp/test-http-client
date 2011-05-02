evm_count = ITERATIONS
test_http("em-http") do
  EventMachine.run do
    http = EventMachine::HttpRequest.new(URL_STRING).get \
      :head => {"X-Test" => "test"}, :timeout => 60

    http.errback { EventMachine.stop }

    http.callback do
      verify_response(http.response)
      EventMachine.stop
    end
  end
end
