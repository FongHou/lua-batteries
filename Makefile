OBJFILES = $(shell find -type f -name '*.lua' | sed 's/.lua/.o/')

%.o: %.lua
	luajit -b $< $@

all: ${OBJFILES}
	ar rcs libljbatteries.a ${OBJFILES}

clean:
	find . -type f -name \*.o -exec rm '{}' \;
	rm -f *.a

deps:
	git submodule update
	cp ~/github/fennel/fennel.lua .
	curl https://raw.githubusercontent.com/slembcke/debugger.lua/master/debugger.lua >debugger.lua
	curl https://raw.githubusercontent.com/mpeterv/argparse/master/src/argparse.lua >argparse.lua
