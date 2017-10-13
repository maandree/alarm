.POSIX:

CONFIGFILE = config.mk
include $(CONFIGFILE)

all: alarm

alarm.o: alarm.c
	$(CC) -c -o $@ alarm.c $(CCFLAGS) $(CPPFLAGS)

alarm: alarm.o
	$(CC) -o $@ alarm.o $(LDFLAGS)

check: alarm
	alarm 1 sleep 2 & a=$$! ;\
	alarm 1s sleep 2 & b=$$! ;\
	alarm 0h2s sleep 1 & c=$$! ;\
	{ ! wait $$a; } && { ! wait $$b; } && { wait $$c; }

install: alarm
	install -dm755 -- "$(DESTDIR)$(BINDIR)"
	install -m755 $^ -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	install -dm755 -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 LICENSE -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -dm755 -- "$(DESTDIR)$(MAN1DIR)"
	install -m644 $< -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"

uninstall:
	-rm -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"

clean:
	-rm -r -- alarm *.o

.PHONY: all check install uninstall clean
