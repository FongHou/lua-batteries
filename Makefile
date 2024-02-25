FNLSRC= $(shell find  -name '*.fnl' | sed 's/.fnl$$/.lua/')
LUAOBJ= $(shell find  -name '*.lua' | sed 's/.lua$$/.o/')

%.lua: %.fnl
	fennel -c $< >$@

%.o: %.lua
	luajit -b $< $@

all: $(LUAOBJ)
	ar rcs libluabatteries.a $(LUAOBJ)

clean:
	find . -name \*.o -exec rm '{}' \;
	rm -f *.a

deps:
	curl https://raw.githubusercontent.com/fonghou/luafun/main/fun.lua >iter.lua
	curl https://raw.githubusercontent.com/slembcke/debugger.lua/master/debugger.lua >debugger.lua
	curl https://raw.githubusercontent.com/kikito/inspect.lua/master/inspect.lua >inspect.lua
	curl https://git.sr.ht/~technomancy/faith/blob/0ec6836d0a8425d0c0c9638804cb43cf50321abb/faith.fnl >faith.fnl
	cp ../fennel/fennel.lua .
