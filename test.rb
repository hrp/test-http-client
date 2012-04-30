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

URL = URI.parse(PATH)

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
 
  
  puts "Execute http performance test using ruby #{RUBY_DESCRIPTION}"
  puts "  doing #{ITERATIONS} requests (#{outer_loop_iterations} iterations with concurrency of #{CONCURRENCY}, #{PER_THREAD} requests per-thread) in each test..."
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
      rescue => ex
        puts " --> failed #{ex}"
      end
    end
  end
end
