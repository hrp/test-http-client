rig_req   = Rig::HTTP.new(
  :host   => URL.host,
  :port   => URL.port,
  :path   => URL.path,
  :method => "GET",
  :header => { "X-Test" => "test" }
)
test_http("righttp") do
  resp = rig_req.send
  data = MultiJson.load(resp.body)
  raise Exception.new unless data.first["number"] != 123123
end
