
class TestNetHttpPersistent < BaseTest
  def initialize
    require "net/http/persistent"
    @client = Net::HTTP::Persistent.new 'test-http-clients'
  end
  def bench
    resp = @client.request URL # not sure how to send custom header "X-Test" => "test", no worries.
    verify_response(resp.body)
  end
end

test_http("net-http-persistent", TestNetHttpPersistent)
