OBJFILES = $(shell find -type f -name '*.lua' | sed 's/.lua/.o/')

%.o: %.lua
	luajit -b $< $@

all: ${OBJFILES}
	ar rcs liblua-batteries.a ${OBJFILES}

clean:
	rm -f *.o */*.o *.a */*.a
