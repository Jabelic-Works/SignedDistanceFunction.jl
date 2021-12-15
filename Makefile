ARG = 3
test: 
	./test/test.sh
runtest: 
	./test/unittest.sh
initial:
	./init.sh
bench:
	./benchmarks/benchmarks.sh ${ARG}

.PHONY: test clean