COUNT  = 10000
HOST   = 192.168.1.2
PORT   = 80
URI    = test.json
URL    = "http://$(HOST):$(PORT)/$(URI)"
RESULT = "result.txt"

all: clean install test csv

clean:
	rm -f $(RESULT)

#
#	Install the environment
#

install: install-ruby install-java

install-ruby:
	rvm 1.9.2,1.8.7 exec bundle install

install-java:
	cd java && mvn clean && mvn package

#
#	Do the test
#

test: test-ruby test-java test-apache test-httperf

test-ruby:
	rvm 1.9.2,1.8.7 exec ruby test.rb benchmark $(COUNT) $(URL) >> $(RESULT)

test-java:
	java -version
	java -server -jar java/target/http-test-0.0.1-SNAPSHOT.jar benchmark $(COUNT) $(URL) >> $(RESULT)
	java -jar java/target/http-test-0.0.1-SNAPSHOT.jar benchmark $(COUNT) $(URL) >> $(RESULT)

test-apache:
	time ab -n $(COUNT) $(URL) >> $(RESULT)
	
test-httperf:
	time httperf --num-conns=$(COUNT) --num-calls=1 --server=$(HOST) --port=$(PORT) --uri=/$(URI) >> $(RESULT)

#
#	Extract the results
#

csv:
	awk -F" " -f extract.awk $(RESULT) > $(RESULT).csv
	open $(RESULT).csv -a numbers
