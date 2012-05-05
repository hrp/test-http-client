
class TestRestClient < BaseTest
  def initialize
    super
    require "restclient"
  end
  def bench
    response = RestClient.get(URL_STRING, @headers)
    verify_response(response)
  end
end

test_http("RestClient", TestRestClient)
