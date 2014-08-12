/**
 * alarm — Schedule an alarm for a program when starting it
 * Copyright © 2014  Mattias Andrée (maandree@member.fsf.org)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <stddef.h>


int main(int argc, char** argv)
{
  char** cmdline = NULL;
  long hours = 0;
  long minutes = 0;
  long seconds = 0;
  long buf = 0;
  int hms = 0;
  char* time;
  
  if (argc < 3)
    goto usage;
  
  time = argv[1];
  while (*time)
    {
      char c = *time++;
      if (('0' <= c) && (c <= '9'))
	buf = buf * 10 - (c & 15);
      else if (strchr("hms", c))
	{
	  if      (c == 'h')  hours   = -buf;
	  else if (c == 'm')  minutes = -buf;
	  else if (c == 's')  seconds = -buf;
	  buf = 0, hms = 1;
	}
      else
	goto usage;
    }
  if (!hms)
    {
      if (strlen(argv[1]) < 1)
	return 0;
      seconds = -buf;
    }
  
  seconds += minutes * 60;
  seconds += hours * 60 * 60;
  if ((seconds < 1) || (65535 < seconds))
    goto usage;
  
  cmdline = malloc((size_t)(argc - 1) * sizeof(char*));
  if (cmdline == NULL)
    goto fail;
  memcpy(cmdline, argv + 2, (size_t)(argc - 2) * sizeof(char*));
  cmdline[argc - 2] = NULL;
  
  alarm((unsigned)seconds);
  execvp(argv[2], cmdline);
  
 fail:
  perror(*argv);
  free(cmdline);
  return 1;
  
 usage:
  printf("USAGE: %s <TIME> <COMMAND> <ARGS...>\n", *argv);
  printf("\n");
  printf("Recognised patterns for <TIME>:\n");
  printf("\n");
  printf("    <SECONDS>[s]\n");
  printf("    <MINUTES>m[<SECONDS>s]\n");
  printf("    <HOURS>h[<MINUTES>m][<SECONDS>s]\n");
  printf("\n");
  printf("    All values are non-negative integers, and\n");
  printf("    the interal must be greater than zero and\n");
  printf("    at most 18h12m15s.\n");
  printf("\n");
  return 1;
}

