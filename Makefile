SHELL = /bin/bash
LINK_FLAGS = --link-flags "-static"
SRCS = ${wildcard src/prog/*.cr}
PROGS = $(SRCS:src/prog/%.cr=http-mock-%)

.PHONY : all build clean test spec test-compile-bin bin
.PHONY : ${PROGS}

all: build

build: bin ${PROGS}

bin:
	@mkdir -p bin

http-mock-counter: src/prog/counter.cr
	crystal build --release $^ -o bin/$@ ${LINK_FLAGS}

http-mock-feeder: src/prog/feeder.cr
	crystal build --release $^ -o bin/$@ ${LINK_FLAGS}

test: test-compile-bin spec

spec:
	crystal spec -v

test-compile-bin:
	@for x in src/prog/*.cr ; do\
	  crystal build "$$x" -o /dev/null ;\
	done

clean:
	@rm -rf bin tmp
