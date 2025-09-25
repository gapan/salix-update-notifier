CC = gcc
PKGCONFIG = pkg-config
CFLAGS ?= -O2 -Wall -Wno-deprecated-declarations
WARNFLAGS = -Wall -Wno-deprecated-declarations
GTKFLAGS = $(shell $(PKGCONFIG) --cflags gtk+-3.0)
GTKLIBS = $(shell $(PKGCONFIG) --libs gtk+-3.0)

TARGETS = salix-update-notifier-tray-icon salix-update-notifier-upgrade-dialog

# Default target (build all)
all: $(TARGETS)

# Pattern rule for building any target from its corresponding .c file
%: %.c
	$(CC) $(CFLAGS) $(GTKFLAGS) $(WARNFLAGS) -o $@ $< $(GTKLIBS)

clean:
	rm -f $(TARGETS)
