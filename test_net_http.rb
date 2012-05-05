
class TestNetHttp < BaseTest
  def initialize
    require "net/http"
    @req = Net::HTTP::Get.new(URL_PATH)
    @req.add_field("X-Test", "test")
  end
  def bench
    resp = Net::HTTP.new(URL_HOST, URL_PORT).start do |http|
      http.request(@req)
    end
    verify_response(resp.body)
  end
end

test_http("net/http", TestNetHttp)
