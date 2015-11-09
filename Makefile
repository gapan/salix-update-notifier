PREFIX ?= /usr/local
DESTDIR ?= /
PACKAGE_LOCALE_DIR ?= /usr/share/locale

all: mo desktop

mo:
	for i in `ls po/*.po`; do \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

desktop:
	intltool-merge po/ -d -u salix-update-notifier.desktop.in salix-update-notifier.desktop


updatepo:
	for i in `ls po/*.po`; do \
		msgmerge -UNs $$i po/salix-update-notifier.pot; \
	done

pot:
	intltool-extract --type="gettext/ini" salix-update-notifier.desktop.in
	xgettext --from-code=utf-8 -L shell -o po/salix-update-notifier.pot src/salix-update-notifier
	xgettext --from-code=utf-8 -j -L C -kN_ -o po/salix-update-notifier.pot salix-update-notifier.desktop.in.h
	rm salix-update-notifier.desktop.in.h

clean:
	rm -f salix-update-notifier.desktop
	rm -f po/*.mo
	rm -f po/*.po~

install:
	install -d -m 755 $(DESTDIR)/$(PREFIX)/bin/
	install -d -m 755 $(DESTDIR)/etc/xdg/autostart
	install -d -m 755 $(DESTDIR)/etc/cron.hourly
	install -d -m 755 $(DESTDIR)/usr/share/pixmaps
	install -d -m 755 $(DESTDIR)/var/run/salix-update-notifier
	install -m 755 src/salix-update-notifier $(DESTDIR)/$(PREFIX)/bin/
	install -m 644 salix-update-notifier.desktop $(DESTDIR)/etc/xdg/autostart/
	install -m 755 src/slapt-get-update $(DESTDIR)/etc/cron.hourly/
	install -m 644 src/salix-update-notifier.conf $(DESTDIR)/etc/
	install -m 644 src/salix-update-notifier.png $(DESTDIR)/usr/share/pixmaps/
	for i in `ls po/*.mo|sed "s|po/\(.*\).mo|\1|"`; do \
		install -d -m 755 $(DESTDIR)/$(PACKAGE_LOCALE_DIR)/$${i}/LC_MESSAGES ;\
		install -m 644 po/$${i}.mo \
		$(DESTDIR)/$(PACKAGE_LOCALE_DIR)/$${i}/LC_MESSAGES/salix-update-notifier.mo; \
	done


.PHONY: all man mo updatepo pot clean install
