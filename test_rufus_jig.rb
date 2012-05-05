# broken

# class TestRufusJig < BaseTest
#   def initialize
#     super
#     require "rufus/jig"
#     Rufus::Json.backend = :yajl
#     @h = Rufus::Jig::Http.new(URL, :timeout => 60)
#   end
#   def bench
#     response = h.get(URL_PATH, @headers)
#     verify_response(response)
#   end
# end
#
# test_http("rufus-jig", TestRufusJig)
