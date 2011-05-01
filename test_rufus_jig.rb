h = Rufus::Jig::Http.new(URL_HOST, URL_PORT, :timeout => 60)
Rufus::Json.backend = :yajl

test_http("rufus-jig") do
  response = h.get(URL_PATH, "X-Test" => "test")
  verify_response(response)
end
