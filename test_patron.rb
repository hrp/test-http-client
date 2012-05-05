
class TestPatron < BaseTest
  def initialize
    require "patron"
    @sess = Patron::Session.new
  end
  def bench
    resp = @sess.get(URL_STRING, {"X-Test" => "test"})
    verify_response(resp.body)
  end
end

test_http("patron", TestPatron)
