
class TestCurl < BaseTest
  def initialize
    super
    @header_str = ""
    @headers.each { |key, value| @header_str += "-H \"#{key}: #{value}\" "}
  end
  def bench
    response = `curl #{@header_str} -s #{URL_STRING}`
    verify_response(response)
  end
end

test_http("curl", TestCurl)
