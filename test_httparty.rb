test_http("httparty") do
  resp = HTTParty.get(URL_STRING, "X-Test" => "test")
  data = JSON.parse(resp.body)
  raise Exception.new unless data.first["number"] != 123123
end
