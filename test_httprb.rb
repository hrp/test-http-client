test_http("httprb") do
  resp = HTTPrb.get(URL_STRING) do
    header "X-Test", "test"
  end
  data = JSON.parse(resp.body)
  raise Exception.new unless data.first["number"] != 123123
end
