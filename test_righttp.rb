rig_req   = Rig::HTTP.new(
  :host   => URL_HOST,
  :port   => URL_PORT,
  :path   => URL_PATH,
  :method => "GET",
  :header => { "X-Test" => "test" }
)
test_http("righttp") do
  resp = rig_req.send
  verify_response(resp.body)
end
