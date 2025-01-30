KERN=bfs
ALG=queue

CFLAGS?=-O3 -Wall -Wno-unused-label

SRCS=$(KERN).cpp local_support.cpp ../../common/support.cpp
FILES=$(SRCS) $(KERN).hpp ../../common/support.hpp

$(KERN): $(FILES) ../../common/harness.cpp
	$(CC) $(CFLAGS) -I../../common -g -o $(KERN) -fopenmp -DTHREAD_NUMBER=4 $(SRCS) ../../common/harness.cpp

run: $(KERN) input.data check.data
	./$(KERN) input.data check.data

generate: $(FILES) generate.cpp
	$(CC) $(CFLAGS) -I../../common -g -m64 -o generate $(SRCS) generate.cpp
	./generate

hls: $(KERN).cpp $(KERN).hpp
	vitis_hls hls.tcl

clean:
	rm -f $(KERN) generate output.data

test:

