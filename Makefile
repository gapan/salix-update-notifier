PREFIX ?= /usr/local
DESTDIR ?= /
PACKAGE_LOCALE_DIR ?= $(PREFIX)/share/locale

.PHONY: all
all: mo desktop

.PHONY: mo
mo:
	for i in `ls po/*.po`; do \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

.PHONY: desktop
desktop:
	intltool-merge po/ -d -u salix-update-notifier.desktop.in salix-update-notifier.desktop

.PHONY: updatepo
updatepo:
	for i in `ls po/*.po`; do \
		msgmerge -UNs $$i po/salix-update-notifier.pot; \
	done

.PHONY: pot
pot:
	intltool-extract --type="gettext/ini" salix-update-notifier.desktop.in
	xgettext --from-code=utf-8 -L shell -o po/salix-update-notifier.pot src/salix-update-notifier
	xgettext --from-code=utf-8 -j -L python -o po/salix-update-notifier.pot src/salix-update-notifier-tray-icon
	xgettext --from-code=utf-8 -j -L C -kN_ -o po/salix-update-notifier.pot salix-update-notifier.desktop.in.h
	rm salix-update-notifier.desktop.in.h

.PHONY: clean
clean:
	rm -f salix-update-notifier.desktop
	rm -f po/*.mo
	rm -f po/*.po~

.PHONY: install
install:
	install -d -m 755 $(DESTDIR)/$(PREFIX)/bin/
	install -d -m 755 $(DESTDIR)/etc/xdg/autostart
	install -d -m 755 $(DESTDIR)/etc/cron.hourly
	install -d -m 755 $(DESTDIR)/var/run/salix-update-notifier
	install -d -m 755 $(DESTDIR)/usr/libexec
	install -d -m 755 $(DESTDIR)/usr/share/icons/hicolor/scalable/panel
	install -d -m 755 $(DESTDIR)/usr/share/icons/hicolor/scalable/apps
	install -m 755 src/salix-update-notifier $(DESTDIR)/$(PREFIX)/bin/
	install -m 644 salix-update-notifier.desktop $(DESTDIR)/etc/xdg/autostart/
	install -m 755 src/slapt-get-update $(DESTDIR)/etc/cron.hourly/
	install -m 644 src/salix-update-notifier.conf $(DESTDIR)/etc/
	install -m 755 src/salix-update-notifier-loop $(DESTDIR)/usr/libexec/
	install -m 755 src/salix-update-notifier-tray-icon $(DESTDIR)/usr/libexec/
	install -m 644 src/updates-notifier.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/panel/
	install -m 644 src/update-notifier.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/
	for i in `ls po/*.mo|sed "s|po/\(.*\).mo|\1|"`; do \
		install -d -m 755 $(DESTDIR)/$(PACKAGE_LOCALE_DIR)/$${i}/LC_MESSAGES ;\
		install -m 644 po/$${i}.mo \
		$(DESTDIR)/$(PACKAGE_LOCALE_DIR)/$${i}/LC_MESSAGES/salix-update-notifier.mo; \
	done

.PHONY: tx-pull
tx-pull:
	tx pull -a
	@for i in `ls po/*.po`; do \
		msgfmt --statistics $$i 2>&1 | grep "^0 translated" > /dev/null \
			&& rm $$i || true; \
	done
	@rm -f messages.mo

.PHONY: tx-pull-f
tx-pull-f:
	tx pull -a -f
	@for i in `ls po/*.po`; do \
		msgfmt --statistics $$i 2>&1 | grep "^0 translated" > /dev/null \
			&& rm $$i || true; \
	done
	@rm -f messages.mo

.PHONY: stat
stat:
	@for i in `ls po/*.po`; do \
		echo "Statistics for $$i:"; \
		msgfmt --statistics $$i 2>&1; \
		echo; \
	done
	@rm -f messages.mo

