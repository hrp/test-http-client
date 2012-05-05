
class TestHttpRb < BaseTest
  def initialize
    super
    require "httprb"
  end
  def bench
    resp = HTTPrb.get(URL_STRING) do
      header "X-Test", "test"
    end
    verify_response(resp.body)
  end
end

test_http("httprb", TestHttpRb)
