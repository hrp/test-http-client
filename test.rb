require 'rubygems'
require 'bundler'
Bundler.require :default
require 'uri'
require 'benchmark'
require 'yajl/json_gem'
require 'net/http'

COMMAND = ARGV.shift
ITERATIONS = (COMMAND == 'benchmark') ? ARGV.shift.to_i : 0
PATH = ARGV.shift
FILES = ARGV.shift || "test_*.rb"
# FILES = ARGV.shift || "test_curb.rb"
TESTS = []

def test_http(name, &block)
  TESTS << [name, block]
end

def verify_response(body)
  if COMMAND == 'verify'
    data = body.is_a?(String) ? JSON.parse(body) : body
    raise Exception.new('response body is not valid') if data.first["number"] != 123123
  end
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
  if COMMAND == 'benchmark'
    puts "Execute http performance test using ruby #{RUBY_DESCRIPTION}"
    puts "  doing #{ITERATIONS} request in each test..."
    Benchmark.bm(20) do |x|
      for name, block in TESTS do
        EventMachine.run do
          begin
            x.report("testing #{name}") do
              ITERATIONS.times(&block)
            end
          rescue => ex
            puts " --> failed #{ex}"
          end
          EventMachine.stop
        end
      end
    end
  elsif COMMAND == 'verify'
    puts "Execute verification test using ruby #{RUBY_DESCRIPTION}"
    for name, block in TESTS do
      EventMachine.run do
        begin
          block.call
        rescue => ex
          puts " --> failed #{ex}"
        end
        EventMachine.stop
      end
    end
  end
end
