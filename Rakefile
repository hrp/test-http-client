COUNT  = 10000
HOST   = "192.168.1.4"
PORT   = "8082"
URI    = "test.json"
URL    = "http://#{HOST}:#{PORT}/#{URI}"
RESULT = "result.txt"

task :default => :all

task :all => [:clean, :install, :test, :csv]

task :clean do
  system(%Q{rm -f #{RESULT}})
end

task :install => ['install:ruby', 'install:java']

namespace :install do
  task :ruby do
    system(%Q{rvm 1.9.2,1.8.7 exec bundle install})
  end

  task :java do
    system(%Q{cd java && mvn clean && mvn package})
  end
end

task :verify do
  system(%Q{rvm 1.9.2,1.8.7 exec ruby test.rb verify 1 #{URL}})
  system(%Q{java -version})
  system(%Q{java -server -jar java/target/http-test-0.0.1-SNAPSHOT.jar verify 1 #{URL}})
  system(%Q{java -jar java/target/http-test-0.0.1-SNAPSHOT.jar verify 1 #{URL}})
end

task :test => [:clean, 'test:ruby', 'test:java', 'test:apache', 'test:httperf']

namespace :test do
  task :ruby do
    system(%Q{rvm 1.9.2,1.8.7 exec ruby test.rb benchmark #{COUNT} #{URL} >> #{RESULT}})
  end

  task :java do
    system(%Q{java -version})
    system(%Q{java -server -jar java/target/http-test-0.0.1-SNAPSHOT.jar benchmark #{COUNT} #{URL} >> #{RESULT}})
    system(%Q{java -jar java/target/http-test-0.0.1-SNAPSHOT.jar benchmark #{COUNT} #{URL} >> #{RESULT}})
  end

  task :apache do
    system(%Q{time ab -n #{COUNT} #{URL} >> #{RESULT}})
  end

  task :httperf do
    system(%Q{time httperf --num-conns=#{COUNT} --num-calls=1 --server=#{HOST} --port=#{PORT} --uri=/#{URI} >> #{RESULT}})
  end
end

task :csv do
  system(%Q{awk -F" " -f extract.awk #{RESULT} > #{RESULT}.csv})
  system(%Q{open #{RESULT}.csv -a numbers})
end