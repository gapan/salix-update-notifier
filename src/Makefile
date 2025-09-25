CC = gcc
PKGCONFIG = pkg-config
CFLAGS ?= -O2 -Wall -Wno-deprecated-declarations
WARNFLAGS = -Wall -Wno-deprecated-declarations
GTKFLAGS = $(shell $(PKGCONFIG) --cflags gtk+-3.0)
GTKLIBS = $(shell $(PKGCONFIG) --libs gtk+-3.0)

TARGET = salix-update-notifier-tray-icon
SRC = salix-update-notifier-tray-icon.c

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(GTKFLAGS) $(WARNFLAGS) -o $@ $^ $(GTKLIBS)

clean:
	rm -f $(TARGET)

