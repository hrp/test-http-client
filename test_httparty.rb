
class TestHttparty < BaseTest
  def initialize
    super
    require "httparty"
  end
  def bench
    resp = HTTParty.get(URL_STRING, @headers)
    verify_response(resp.body)
  end
end

test_http("httparty", TestHttparty)
