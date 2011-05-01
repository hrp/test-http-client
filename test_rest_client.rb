test_http("RestClient") do
  response = RestClient.get URL_STRING, { "X-Test" => "test" }
  verify_response(response)
end