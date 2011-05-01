test_http("httprb") do
  resp = HTTPrb.get(URL_STRING) do
    header "X-Test", "test"
  end
  verify_response(resp.body)
end
