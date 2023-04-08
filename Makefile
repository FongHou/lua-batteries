LUAFILES  = $(shell find -type f -name '*.fnl' | sed 's/.fnl$$/.lua/')
OBJFILES = $(shell find -type f -name '*.lua' | sed 's/.lua$$/.o/')

%.lua: %.fnl
	fennel -c $< >$@

%.o: %.lua
	luajit -b $< $@

all: ${OBJFILES} ${LUAFILES}
	ar rcs libljbatteries.a ${OBJFILES}

clean:
	find . -type f -name \*.o -exec rm '{}' \;
	rm -f *.a

deps:
	git submodule update
	curl https://raw.githubusercontent.com/slembcke/debugger.lua/master/debugger.lua >debugger.lua
	# curl https://raw.githubusercontent.com/allegory-software/allegory-sdk/master/lua/time.lua >time.lua
