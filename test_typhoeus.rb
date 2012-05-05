
class TestTyphoeus < BaseTest
  def initialize
    super
    require "typhoeus"
  end
  def bench
    response = Typhoeus::Request.get(URL_STRING, :headers => @headers)
    verify_response(response.body)  end
end

test_http("typhoeus", TestTyphoeus)
