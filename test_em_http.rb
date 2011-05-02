evm_count = ITERATIONS
test_http("em-http") do
  http = EventMachine::HttpRequest.new(URL_STRING).get \
    :head => {"X-Test" => "test"}, :timeout => 60

  http.callback do
    verify_response(http.response)
  end
end
