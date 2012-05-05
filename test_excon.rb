
class TestExcon < BaseTest
  def initialize
    super
    require "excon"
    @excon = Excon.new(PATH)
  end
  def bench
    resp = @excon.get(:headers => @headers)
    verify_response(resp.body)
  end
end

test_http("excon", TestExcon)
