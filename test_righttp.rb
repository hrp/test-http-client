
class TestRigHttp < BaseTest
  def initialize
    super
    require "righttp"
    @rig_req  = Rig::HTTP.new(
      :host   => URL_HOST,
      :port   => URL_PORT,
      :path   => URL_PATH,
      :method => "GET",
      :header => @headers
    )
  end
  def bench
    resp = @rig_req.send
    verify_response(resp.body)
  end
end

test_http("righttp", TestRigHttp)
