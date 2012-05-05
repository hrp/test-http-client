#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
Bundler.require :default

require 'uri'
require 'benchmark'
require 'net/http'


COMMAND = ARGV.shift
ITERATIONS = (COMMAND == 'benchmark') ? ARGV.shift.to_i : 0
PATH = ARGV.shift
FILES = ARGV.shift || "test_*.rb"
TESTS = []

# Will do CONCURRENCY requests concurrently in
# in ruby threads. If 0, all tests done in main
# thread. If 1, only one at a time, but in seperate
# thread. More than 1, well, you see how it goes.
CONCURRENCY = (ENV['CONCURRENCY'] || 0).to_i

# If PER_THREAD is more than 1, then we still do
# CONCURRENCY simultaneous threads, but in each thread
# we actually do PER_THREAD requests, rather than one
# request per-thread.
PER_THREAD = (ENV['PER_THREAD'] || 1).to_i

# Any tests to skip?
SKIP = (ENV['SKIP'] || "").split(",")


def test_http(name, &block)
  TESTS << [name, block]
end

def verify_response(body)
  if COMMAND == 'verify'
    data = body.is_a?(String) ? MultiJson.load(body) : body
    raise Exception.new('response body is not valid') if data.first["numbers"] != 123123
  end
end

URL = URI.parse(PATH)
URL_HOST = URL.host
URL_PORT = URL.port
URL_PATH = URL.path
URL_STRING = URL.to_s

dir = File.dirname(__FILE__)

Dir[File.join(dir, FILES)].each do |file|
  next if SKIP.find {|skip_it| file.end_with? skip_it }
  require file
end

at_exit do

  outer_loop_iterations = if CONCURRENCY == 0
    ITERATIONS
  else
    ITERATIONS / (CONCURRENCY * PER_THREAD)
  end

  if COMMAND == 'benchmark' then
    puts "Execute http performance test using ruby #{RUBY_DESCRIPTION}"
    puts "  doing #{ITERATIONS} requests (#{outer_loop_iterations} iterations with concurrency of #{CONCURRENCY}, #{ PER_THREAD.to_s + " requests per-thread" if CONCURRENCY > 0}) in each test..."
    Benchmark.bm(28) do |x|
      for name, block in TESTS do
        begin
          x.report("testing #{name}") do
            outer_loop_iterations.times do
              if CONCURRENCY == 0
                block.call
              else
                threads = []
                CONCURRENCY.times do
                  threads << Thread.new do
                    PER_THREAD.times { block.call  }
                  end
                end
                threads.each {|t| t.join}
              end
            end
          end
        end
      end
    end

  elsif COMMAND == 'verify' then

    puts "Execute verification test using ruby #{RUBY_DESCRIPTION}"
    for name, block in TESTS do
      print name
      EventMachine.run do
        begin
          block.call
          puts " --> passed "
        rescue Exception => ex
          puts " --> failed #{ex}"
          puts ex.backtrace
        end
        EventMachine.stop
      end
    end

  end

end
