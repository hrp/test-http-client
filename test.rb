require 'rubygems'
require 'bundler'
Bundler.require :default
require 'uri'
require 'benchmark'
require 'yajl/json_gem'
require 'net/http'

ITERATIONS = ARGV.shift.to_i
PATH = ARGV.shift
FILES = ARGV.shift || "test_*.rb"
TESTS = []

def test_http(name, &block)
  TESTS << [name, block]
end

def verify_response(body)
  data = body.is_a?(String) ? JSON.parse(body) : body
  raise Exception.new unless data.first["number"] != 123123
end

URL = URI.parse(PATH)
URL_HOST = URL.host
URL_PORT = URL.port
URL_PATH = URL.path
URL_STRING = URL.to_s

dir = File.dirname(__FILE__)

Dir[File.join(dir, FILES)].each do |file|
  require file
end

at_exit do
  puts "Execute http performance test using ruby #{RUBY_DESCRIPTION}"
  puts "  doing #{ITERATIONS} request in each test..."
  Benchmark.bmbm(20) do |x|
    for name, block in TESTS do
      begin
        x.report("testing #{name}") do
          ITERATIONS.times(&block)
        end
      rescue => ex
        puts " --> failed #{ex}"
      end
    end
  end
end
