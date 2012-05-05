c = Curl::Easy.new
test_http("curb") do
  c.url = URL.to_s
  c.headers["X-Test"] = "test"
  c.perform
  data = MultiJson.load(c.body_str)
  raise Exception.new unless data.first["number"] != 123123
end
