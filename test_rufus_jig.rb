h = Rufus::Jig::Http.new(URL_HOST, URL_PORT, :timeout => 60)

test_http("rufus-jig") do
  data = h.get(URL_PATH, "X-Test" => "test")
  raise Exception.new unless data.first["number"] != 123123
end
