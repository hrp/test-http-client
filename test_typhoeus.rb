test_http("typhoeus") do
  response = Typhoeus::Request.get(URL_STRING, :headers => {"X-Test" => "test"})
  verify_response(response.body)
end