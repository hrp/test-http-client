
class TestTyphoeus < BaseTest
  def initialize
    require "typhoeus"
  end
  def bench
    response = Typhoeus::Request.get(URL_STRING, :headers => {"X-Test" => "test"})
    verify_response(response.body)  end
end

test_http("typhoeus", TestTyphoeus)
