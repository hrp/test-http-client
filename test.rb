#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
require 'uri'
require 'benchmark'
require 'net/http'

require 'oj'
require 'multi_json'
require 'yajl'

require "eventmachine"

COMMAND = ARGV.shift
ITERATIONS = (COMMAND == 'benchmark') ? ARGV.shift.to_i : 0
PATH = ARGV.shift
FILES = ARGV.shift || "test_*.rb"
TESTS = []

# Will do CONCURRENCY requests concurrently in
# in ruby threads. If 0, all tests done in main
# thread. If 1, only one at a time, but in seperate
# thread. More than 1, well, you see how it goes.
CONCURRENCY = (ENV['CONCURRENCY'] || 1).to_i


# Any tests to skip?
SKIP = (ENV['SKIP'] || "").split(",")


def test_http(name, clazz)
  TESTS << [name, clazz]
end

class BaseTest
  attr_reader :errs
  def initialize
    @headers = {"X-Test" => "test"}
    @errs = 0
  end
  def thread_safe?
    true
  end
  def verify_response(body)
    return if COMMAND != 'verify'
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

  if COMMAND == 'benchmark' then

    num_threads = CONCURRENCY
    per_thread = ITERATIONS / CONCURRENCY
    total = per_thread * CONCURRENCY

    puts "Execute http performance test using ruby #{RUBY_DESCRIPTION}"
    puts "  doing #{total} requests" + ( num_threads > 0 ? " (#{num_threads} threads of #{per_thread} each)" : "" )

    Benchmark.bm(28) do |x|
      for name, clazz in TESTS do
        fork do
          clazz.new # make sure files are required early before threading
          begin
            errs = 0
            x.report("testing #{name}") do

              if not clazz.new.thread_safe? then
                num_threads = 1
                per_thread = ITERATIONS
                total = ITERATIONS

              else
                num_threads = CONCURRENCY
                per_thread = ITERATIONS / CONCURRENCY
                total = per_thread * CONCURRENCY
              end

              threads = []
              num_threads.times do
                t = Thread.new do
                  test = clazz.new
                  per_thread.times { test.bench(); }
                  errs += test.errs
                end
                threads << t
              end
              threads.each {|t| t.join}

            end # report

            if not clazz.new.thread_safe? then
              puts "   NOTE: #{name} is not thread safe, only 1 thread used"
            end

            puts "   #{errs} requests failed" if errs > 0

          rescue Exception => ex
            puts " --> failed #{ex}"
            puts ex.backtrace if ex.message !~ /requests failed/
          end
        end # fork
        Process.wait

      end
    end

  elsif COMMAND == 'verify' then

    puts "Execute verification test using ruby #{RUBY_DESCRIPTION}"
    for name, clazz in TESTS do
      print name
      fork do
        test = clazz.new
        begin
          test.bench()
          if test.errs > 0 then
            raise Exception.new("(#{test.errs} requests failed)")
          end
          puts " --> passed "
        rescue Exception => ex
          puts " --> failed #{ex}"
          puts ex.backtrace if ex.message !~ /requests failed/
        end
      end # fork
      Process.wait
    end

  end

end
