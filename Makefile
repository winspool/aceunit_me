#subs:=lib test examples #$(patsubst %/Makefile,%,$(wildcard */Makefile))

include recurse.mk

## all:		Build and test AceUnit (library, generator, and integration).
## clean:		Remove all generated files.
## lib-all:	Build and self-test the AceUnit library.

test-all examples-all install: lib-all

versions:=c90 c99 c11 c17 c2x gnu90 gnu99 gnu11 gnu17 gnu2x
## compiler-test:	Test AceUnit with different versions of C.
compiler-test: $(versions:%=compiler-test-%)

compiler-test-%:
	$(MAKE) clean
	$(MAKE) CFLAGS+="-std=$* -Werror" CVERSION:=$*

PREFIX?=/usr/local/

FILES_TO_INSTALL:=\
    $(PREFIX)/share/man/man1/aceunit.1 \
    $(PREFIX)/share/man/man3/aceunit.3 \
    $(PREFIX)/bin/aceunit \
    $(PREFIX)/lib/libaceunit-simple.a \
    $(PREFIX)/lib/libaceunit-abort.a \
    $(PREFIX)/lib/libaceunit-setjmp.a \
    $(PREFIX)/lib/libaceunit-fork.a \
    $(PREFIX)/include/aceunit.h

.PHONY: install
## install:	Install AceUnit for the local system (Unix/POSIX/Cygwin/MinGW).
install: $(FILES_TO_INSTALL)

$(PREFIX)/%: %
	install $^ $@

.PHONY: install
## uninstall:	Remove AceUnit from the local system (Unix/POSIX/Cygwin/MinGW).
uninstall:
	$(RM) $(FILES_TO_INSTALL)

.PHONY: help
## help:		Print this help text.
help:
	@sed -n 's/^## \?//p' $(MAKEFILE_LIST)
