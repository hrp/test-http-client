c = Curl::Easy.new

test_http("curb") do
  c.url = URL_STRING
  c.headers["X-Test"] = "test"
  c.perform
  verify_response(c.body_str)
end
