
class TestHttpClient < BaseTest
  def initialize
    super
    require "httpclient"
    @client = HTTPClient.new
  end
  def bench
    resp = @client.get_content(URL, nil, @headers)
    verify_response(resp)
  end
end

test_http("httpclient", TestHttpClient)
