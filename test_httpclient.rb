client = HTTPClient.new
test_http("httpclient") do
  resp = client.get_content(URL, nil, "X-Test" => "test")
  verify_response(resp)
end
