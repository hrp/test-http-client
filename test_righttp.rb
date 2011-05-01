test_http("righttp") do
  request  = Rig::HTTP.new(
    :host   => URL_HOST,
    :port   => URL_PORT,
    :path   => URL_PATH,
    :method => "GET",
    :header => { "X-Test" => "test" }
  )
  resp = request.send
  verify_response(resp.body)
end
