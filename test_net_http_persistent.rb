
class TestNetHttpPersistent < BaseTest
  def initialize
    super
    require "net/http/persistent"
    @client = Net::HTTP::Persistent.new 'test-http-clients'
    @req = Net::HTTP::Get.new(URL_PATH)
    @req.add_field("X-Test", "test")
  end
  def bench
    resp = @client.request(URL, @req)
    verify_response(resp.body)
  end
end

test_http("net-http-persistent", TestNetHttpPersistent)
