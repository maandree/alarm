# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.


# The package path prefix, if you want to install to another root, set DESTDIR to that root.
PREFIX = /usr
# The command path excluding prefix.
BIN = /bin
# The resource path excluding prefix.
DATA = /share
# The command path including prefix.
BINDIR = $(PREFIX)$(BIN)
# The resource path including prefix.
DATADIR = $(PREFIX)$(DATA)
# The general documentation path including prefix.
DOCDIR = $(DATADIR)/doc
# The info manual path including prefix.
INFODIR = $(DATADIR)/info
# The man page path including prefix.
MANDIR = $(DATADIR)/man
# The man page section 1 path including prefix.
MAN1DIR = $(MANDIR)/man1
# The license base path including prefix.
LICENSEDIR = $(DATADIR)/licenses

# The name of the package as it should be installed.
PKGNAME = alarm
# The name of the command as it should be installed.
COMMAND = alarm


# Optimisation level (and debug flags.)
OPTIMISE = -Og -g

# Enabled Warnings.
WARN = -Wall -Wextra -pedantic -Wdouble-promotion -Wformat=2 -Winit-self       \
       -Wmissing-include-dirs -Wtrampolines -Wfloat-equal -Wshadow             \
       -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls           \
       -Wnested-externs -Winline -Wno-variadic-macros -Wsign-conversion        \
       -Wswitch-default -Wconversion -Wsync-nand -Wunsafe-loop-optimizations   \
       -Wcast-align -Wstrict-overflow -Wdeclaration-after-statement -Wundef    \
       -Wbad-function-cast -Wcast-qual -Wwrite-strings -Wlogical-op            \
       -Waggregate-return -Wstrict-prototypes -Wold-style-definition -Wpacked  \
       -Wvector-operation-performance -Wunsuffixed-float-constants             \
       -Wsuggest-attribute=const -Wsuggest-attribute=noreturn                  \
       -Wsuggest-attribute=pure -Wsuggest-attribute=format -Wnormalized=nfkc

# The C standard used in the code.
STD = c99



.PHONY: default
default: command

.PHONY: all
all: command

.PHONY: base
base: command

.PHONY: command
command: bin/alarm

bin/alarm: obj/alarm.o
	@mkdir -p bin
	$(CC) $(WARN) -std=$(STD) $(OPTIMISE) $(LDFLAGS) -o $@ $^

obj/%.o: src/%.c
	@mkdir -p obj
	$(CC) $(WARN) -std=$(STD) $(OPTIMISE) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<



.PHONY: install
install: install-base install-man

.PHONY: install-all
install-all: install-base install-doc

.PHONY: install-base
install-base: install-command install-license

.PHONY: install-command
install-command: bin/alarm
	install -dm755 -- "$(DESTDIR)$(BINDIR)"
	install -m755 $^ -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"

.PHONY: install-license
install-license:
	install -dm755 -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 COPYING LICENSE -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"

.PHONY: install-doc
install-doc: install-man

install-man: doc/man/alarm.1
	install -dm755 -- "$(DESTDIR)$(MAN1DIR)"
	install -m644 $< -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"



.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(MAN1)/$(COMMAND).1"



.PHONY: clean
clean:
	-rm -r bin obj

