
class TestEmHttp < BaseTest
  def initialize
    gem "em-http-request"
    gem "eventmachine"
    require "em-http-request"
    require "eventmachine"
    @evm_count = ITERATIONS
    @thread = Thread.new { EventMachine.run }
    loop do
      break if EventMachine.reactor_running?
    end
  end
  def bench
    http = EventMachine::HttpRequest.new(URL.to_s).get \
      :head => {"X-Test" => "test"}, :timeout => 60

    http.errback { EM.stop; raise Exception.new }

    http.callback do
      verify_response(http.response)
      @evm_count -= 1
      EM.stop if @evm_count <= 0
    end
  end
end

test_http("em-http", TestEmHttp)
