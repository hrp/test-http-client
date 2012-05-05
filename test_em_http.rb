
# warning: test will launch 'ITERATIONS' concurrent requests due to the nature
# of em-http-request. EM.HttpRequest.new automatically opens the connection

class TestEmHttp < BaseTest
  def initialize
    super
    require "eventmachine"
    require "em-http-request"
    @evm_count = ITERATIONS
  end
  def bench
    EM.run do
      http = EventMachine::HttpRequest.new(PATH).get(
        :head => @headers, :timeout => 60
      )

      http.errback {
        @errs += 1
        @evm_count -= 1
        EM.stop
      }

      http.callback do
        verify_response(http.response)
        @evm_count -= 1
        EM.stop
      end
    end
  end
end

test_http("em-http", TestEmHttp)
