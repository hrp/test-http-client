client = HTTPClient.new
test_http("httpclient") do
  resp = client.get_content(URL, nil, "X-Test" => "test")
  data = MultiJson.load(resp)
  raise Exception.new unless data.first["number"] != 123123
end
