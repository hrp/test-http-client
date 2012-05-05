req = Net::HTTP::Get.new(URL_PATH)
req.add_field("X-Test", "test")

test_http("net/http") do
  resp = Net::HTTP.new(URL_HOST, URL_PORT).start do |http|
    http.request(req)
  end

  verify_response(resp.body)
end
