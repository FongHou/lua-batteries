FNL_SRC= $(shell find -type f -name '*.fnl' | sed 's/.fnl$$/.lua/')
OBJS= $(shell find -type f -name '*.lua' | sed 's/.lua$$/.o/')

%.lua: %.fnl
	fennel -c $< >$@

%.o: %.lua
	luajit -b $< $@

all: ${OBJS}
	ar rcs libluabatteries.a ${OBJS}

clean:
	find . -type f -name \*.o -exec rm '{}' \;
	rm -f *.a

deps:
	curl https://raw.githubusercontent.com/slembcke/debugger.lua/master/debugger.lua >debugger.lua
