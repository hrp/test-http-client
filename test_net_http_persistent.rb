client = Net::HTTP::Persistent.new 'test-http-clients'
test_http("net-http-persistent") do
  response = client.request URL # not sure how to send custom header "X-Test" => "test", no worries.
  data = MultiJson.load(response.body)
  raise Exception.new unless data.first["number"] != 123123
end
