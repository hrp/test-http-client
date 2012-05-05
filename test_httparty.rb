
class TestHttparty < BaseTest
  def initialize
    require "httparty"
  end
  def bench
    resp = HTTParty.get(URL_STRING, "X-Test" => "test")
    verify_response(resp.body)
  end
end

test_http("httparty", TestHttparty)
