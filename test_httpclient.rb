
class TestHttpClient < BaseTest
  def initialize
    require "httpclient"
    @client = HTTPClient.new
  end
  def bench
    resp = @client.get_content(URL, nil, "X-Test" => "test")
    verify_response(resp)
  end
end

test_http("httpclient", TestHttpClient)
