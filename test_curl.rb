test_http("curl") do
  header = {"X-Test" => "test"}
  header_str = ""
  header.each { |key, value| header_str += "-H \"#{key}: #{value}\" "}
  response = `curl #{header_str} -s #{URL_STRING}`
  verify_response(response)
end
