test_http("httparty") do
  resp = HTTParty.get(URL_STRING, "X-Test" => "test")
  verify_response(resp.body)
end
