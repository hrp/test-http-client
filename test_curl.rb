header = {"X-Test" => "test"}
header_str = ""
header.each { |key, value| header_str += "-H \"#{key}: #{value}\" "}

test_http("curl") do
  response = `curl #{header_str} -s #{URL_STRING}`
  verify_response(response)
end
