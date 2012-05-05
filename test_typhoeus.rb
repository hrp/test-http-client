
class TestTyphoeus < BaseTest
  def initialize
    super
    require "typhoeus"
    @req = Typhoeus::Request.new(URL_STRING, :headers => @headers)
  end
  def bench
    hydra = Typhoeus::Hydra.new
    hydra.queue(@req)
    hydra.run
    verify_response(@req.response.body)
  end
end

test_http("typhoeus", TestTyphoeus)
