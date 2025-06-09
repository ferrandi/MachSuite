BENCHMARKS=\
	aes/aes \
	backprop/backprop \
	bfs/bulk \
	bfs/queue \
	fft/strided \
	fft/transpose \
	gemm/ncubed \
	gemm/blocked \
	kmp/kmp \
	md/knn \
	md/grid \
	nw/nw \
	sort/merge \
	sort/radix \
	spmv/crs \
	spmv/ellpack \
	stencil/stencil2d \
	stencil/stencil3d \
	viterbi/viterbi

CFLAGS=-O3 -Wall -Wno-unused-label

.PHONY: build run generate all test clean $(BENCHMARKS)

$(BENCHMARKS):
	@echo "Entering directory '$@' and running target '$(MAKECMDGOALS)'..."
	$(MAKE) -C $@ CFLAGS="$(CFLAGS)" $(MAKECMDGOALS)

build: $(BENCHMARKS)

run: $(BENCHMARKS)

generate: $(BENCHMARKS)

hls: $(BENCHMARKS)


### For regression tests
all: clean build generate run

test:
	$(MAKE) -C common/test
	$(MAKE) all CFLAGS="-O3 -Wall -Wno-unused-label -Werror"
	$(MAKE) all CFLAGS="-O3 -Wall -Wno-unused-label -Werror -std=c99"

clean:
	@( for b in $(BENCHMARKS); do $(MAKE) -C $$b clean || exit ; done )
