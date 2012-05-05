
class TestRestClient < BaseTest
  def initialize
    require "restclient"
  end
  def bench
    response = RestClient.get URL_STRING, { "X-Test" => "test" }
    verify_response(response)
  end
end

test_http("RestClient", TestRestClient)
