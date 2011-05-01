#evm_count = ITERATIONS
#EventMachine.run do
#  test_http("em-http") do
#    http = EventMachine::HttpRequest.new(URL_STRING).get \
#      :head => {"X-Test" => "test"}, :timeout => 60
#
#    http.callback do
#      verify_response(http.response)
#      evm_count -= 1
#      EventMachine.stop if evm_count <= 0
#    end
#  end
#end
