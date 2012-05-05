# can't get patron to compile, sorry
sess = Patron::Session.new

test_http("patron") do
  resp = sess.get(URL_STRING, {"X-Test" => "test"})
  verify_response(resp.body)
end
