.POSIX:

CONFIGFILE = config.mk
include $(CONFIGFILE)


all: alarm

.c.o:
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

.o:
	$(CC) -o $@ $< $(LDFLAGS)

check: alarm
	./alarm 1 sleep 2 & a=$$! ;\
	./alarm 1s sleep 2 & b=$$! ;\
	./alarm 0h2s sleep 1 & c=$$! ;\
	{ ! wait $$a; } && { ! wait $$b; } && { wait $$c; }

install: alarm
	mkdir -p -- "$(DESTDIR)$(PREFIX)/bin"
	mkdir -p -- "$(DESTDIR)$(MANPREFIX)/man1"
	cp -- alarm "$(DESTDIR)$(PREFIX)/bin/"
	cp -- alarm.1 "$(DESTDIR)$(MANPREFIX)/man1/"

uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)/bin/alarm"
	-rm -- "$(DESTDIR)$(MANPREFIX)/man1/alarm.1"

clean:
	-rm -rf -- alarm *.o *.su

.SUFFIXES:
.SUFFIXES: .o .c

.PHONY: all check install uninstall clean
