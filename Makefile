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
	cp ~/github/fennel/fennel.lua .
	curl https://raw.githubusercontent.com/slembcke/debugger.lua/master/debugger.lua >debugger.lua
	curl https://raw.githubusercontent.com/mpeterv/argparse/master/src/argparse.lua >argparse.lua
	curl https://raw.githubusercontent.com/bluebird75/luaunit/master/luaunit.lua >luaunit.lua
	# curl https://raw.githubusercontent.com/allegory-software/allegory-sdk/dev/lua/coro.lua >coro.lua
	# curl https://raw.githubusercontent.com/allegory-software/allegory-sdk/dev/lua/path.lua >path.lua
	# curl https://raw.githubusercontent.com/allegory-software/allegory-sdk/master/lua/time.lua >time.lua
