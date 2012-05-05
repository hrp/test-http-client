
class TestPatron < BaseTest
  def initialize
    super
    require "patron"
    @sess = Patron::Session.new
  end
  def bench
    resp = @sess.get(URL_STRING, @headers)
    verify_response(resp.body)
  end
end

test_http("patron", TestPatron)
