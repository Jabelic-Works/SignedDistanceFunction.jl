
test: 
	./test/test.sh
runtest: 
	./test/unittest.sh
initial:
	./init.sh
bench:
	./benchmarks/benchmarks.sh

.PHONY: test clean