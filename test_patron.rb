sess = Patron::Session.new

test_http("patron") do
  resp = sess.get(URL_STRING, {"X-Test" => "test"})
  data = JSON.parse(resp.body)
  raise Exception.new unless data.first["number"] != 123123
end
