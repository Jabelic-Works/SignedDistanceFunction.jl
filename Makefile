test: 
	./test/test.sh ${ARG}
runtest: 
	./test/unittest.sh
initial:
	./init.sh
bench:
	./benchmarks/benchmarks.sh

.PHONY: test clean