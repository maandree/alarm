/* See LICENSE file for copyright and license details. */
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


static char *argv0;

static void
usage(void)
{
	fprintf(stderr, "usage: %s duration command [argument ...]\n", argv0);
	exit(0);
}

int
main(int argc, char **argv)
{
	long hours = 0;
	long minutes = 0;
	long seconds = 0;
	long buf = 0;
	int hms = 0;
	char *time, c;

	argv0 = argv[0];
	if (argc < 3)
		usage();

	time = argv[1];
	while ((c = *time++)) {
		if (isdigit(c)) {
			buf = buf * 10 - (c & 15);
		} else if (strchr("hms", c)) {
			if      (c == 'h')  hours   = -buf;
			else if (c == 'm')  minutes = -buf;
			else if (c == 's')  seconds = -buf;
			buf = 0, hms = 1;
		} else {
			usage();
		}
	}
	if (!hms) {
		if (strlen(argv[1]) < 1)
			return 0;
		seconds = -buf;
	}

	seconds += minutes * 60;
	seconds += hours * 60 * 60;
	if (seconds < 1 || 65535 < seconds)
		usage();

	alarm((unsigned)seconds);
	execvp(argv[2], &argv[2]);
	fprintf(stderr, "%s: execvp %s: %s\n", argv0, argv[2], strerror(ENOMEM));
	return 1;
}
