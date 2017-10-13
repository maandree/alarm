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
	mkdir -p -- "$(DESTDIR)$(PREFIX)/bin"
	mkdir -p -- "$(DESTDIR)$(PREFIX)/share/licenses/alarm"
	mkdir -p -- "$(DESTDIR)$(MANPREFIX)/man1"
	cp -- alarm "$(DESTDIR)$(PREFIX)/bin/"
	cp -- LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/alarm/"
	cp -- alarm.1 "$(DESTDIR)$(MANPREFIX)/man1/"

uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)/bin/alarm"
	-rm -- "$(DESTDIR)$(PREFIX)/share/licenses/alarm/LICENSE"
	-rm -- "$(DESTDIR)$(MANPREFIX)/man1/alarm.1"
	-rmdir -- "$(DESTDIR)$(PREFIX)/share/licenses/alarm"

clean:
	-rm -r -- alarm *.o

.PHONY: all check install uninstall clean
