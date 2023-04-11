LUAFILES  = $(shell find -type f -name '*.fnl' | sed 's/.fnl$$/.lua/')
OBJFILES = $(shell find -type f -name '*.lua' | sed 's/.lua$$/.o/')

%.lua: %.fnl
	fennel -c $< >$@

%.o: %.lua
	luajit -b $< $@

all: ${OBJFILES} ${LUAFILES}
	ar rcs libluabatteries.a ${OBJFILES}

clean:
	find . -type f -name \*.o -exec rm '{}' \;
	rm -f *.a

deps:
	git submodule update
	curl https://raw.githubusercontent.com/slembcke/debugger.lua/master/debugger.lua >debugger.lua
