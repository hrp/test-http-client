
class TestExcon < BaseTest
  def initialize
    require "excon"
    @excon = Excon.new(PATH)
  end
  def bench
    resp = @excon.get()
    verify_response(resp.body)
  end
end

test_http("excon", TestExcon)
