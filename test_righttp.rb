test_http("righttp") do
  request  = Rig::HTTP.new(
    :host   => URL_HOST,
    :port   => URL_PORT,
    :path   => URL_PATH,
    :method => "GET",
    :header => { "X-Test" => "test" }
  )
  resp = request.send
  data = JSON.parse(resp.body)
  raise Exception.new unless data.first["number"] != 123123
end
