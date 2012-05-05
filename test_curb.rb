
class TestCurb < BaseTest
  def initialize
    require "curb"
    @c = Curl::Easy.new
    @c.url = URL_STRING
    @c.headers["X-Test"] = "test"
  end
  def bench
    @c.perform
    verify_response(@c.body_str)
  end
end

test_http("curb", TestCurb)
