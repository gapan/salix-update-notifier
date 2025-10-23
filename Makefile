PREFIX ?= /usr/local
DESTDIR ?= /
PACKAGE_LOCALE_DIR ?= $(PREFIX)/share/locale

SUBDIRS = src

.PHONY: all
all: mo desktop policy $(SUBDIRS)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ CFLAGS="$(CFLAGS)"

.PHONY: mo
mo:
	for i in `ls po/*.po`; do \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

.PHONY: desktop
desktop:
	intltool-merge po/ -d -u salix-update-notifier.desktop.in salix-update-notifier.desktop
	intltool-merge po/ -d -u salix-update-manager.desktop.in salix-update-manager.desktop

.PHONY: policy
policy:
	itstool -j org.salixos.salix-update-manager.policy.in \
		-o org.salixos.salix-update-manager.policy \
		po/*.mo

.PHONY: updatepo
updatepo:
	for i in `ls po/*.po`; do \
		msgmerge -UNs $$i po/salix-update-notifier.pot; \
	done

.PHONY: pot
pot:
	itstool -i /usr/share/gettext/its/polkit.its \
		-o po/salix-update-notifier.pot org.salixos.salix-update-manager.policy.in
	intltool-extract --type="gettext/ini" salix-update-notifier.desktop.in
	intltool-extract --type="gettext/ini" salix-update-manager.desktop.in
	xgettext --from-code=utf-8 -j -L shell -o po/salix-update-notifier.pot src/salix-update-notifier-loop
	xgettext --from-code=utf-8 -j -L C -kN_ -o po/salix-update-notifier.pot salix-update-notifier.desktop.in.h
	xgettext --from-code=utf-8 -j -L C -kN_ -o po/salix-update-notifier.pot salix-update-manager.desktop.in.h
	xgettext --from-code=utf-8 \
		-j \
		-L C \
		--keyword=_ \
		-o po/salix-update-notifier.pot \
		src/salix-update-notifier-tray-icon.c
	xgettext --from-code=utf-8 \
		-j \
		-L C \
		--keyword=_ \
		-o po/salix-update-notifier.pot \
		src/salix-update-manager-select-window.c
	xgettext --from-code=utf-8 \
		-j \
		-L Glade \
		-o po/salix-update-notifier.pot \
		src/salix-update-manager.ui
	xgettext --from-code=utf-8 \
		-j \
		-L Python \
		-o po/salix-update-notifier.pot \
		src/salix-update-manager
	rm salix-update-notifier.desktop.in.h
	rm salix-update-manager.desktop.in.h

.PHONY: clean
clean:
	rm -f src/salix-update-notifier-tray-icon
	rm -f salix-update-notifier.desktop
	rm -f salix-update-manager.desktop
	rm -f org.salixos.salix-update-manager.policy
	rm -f po/*.mo
	rm -f po/*.po~

.PHONY: install
install:
	install -d -m 755 $(DESTDIR)/$(PREFIX)/bin/
	install -d -m 755 $(DESTDIR)/$(PREFIX)/sbin/
	install -d -m 755 $(DESTDIR)/etc/xdg/autostart
	install -d -m 755 $(DESTDIR)/etc/cron.hourly
	install -d -m 755 $(DESTDIR)/var/run/salix-update-notifier
	install -d -m 755 $(DESTDIR)/usr/libexec
	install -d -m 755 $(DESTDIR)/usr/share/icons/hicolor/scalable/apps
	install -d -m 755 $(DESTDIR)/usr/share/salix-update-notifier
	install -d -m 755 $(DESTDIR)/usr/share/applications
	install -d -m 755 $(DESTDIR)/usr/share/icons/hicolor/scalable/apps
	install -d -m 755 $(DESTDIR)/usr/share/polkit-1/actions
	install -m 755 src/salix-update-notifier $(DESTDIR)/$(PREFIX)/bin/
	install -m 644 salix-update-notifier.desktop $(DESTDIR)/etc/xdg/autostart/
	install -m 755 src/salix-update-notifier-update $(DESTDIR)/etc/cron.hourly/
	install -m 644 src/salix-update-notifier.conf $(DESTDIR)/etc/
	install -m 755 src/salix-update-notifier-check-for-updates $(DESTDIR)/usr/libexec/
	install -m 755 src/salix-update-notifier-loop $(DESTDIR)/usr/libexec/
	install -m 755 src/salix-update-notifier-tray-icon $(DESTDIR)/usr/libexec/
	install -m 755 src/salix-update-manager $(DESTDIR)/usr/bin/
	install -m 755 src/salix-update-manager-select $(DESTDIR)/usr/bin/
	install -m 755 src/salix-update-manager-select-window $(DESTDIR)/usr/libexec/
	install -m 644 src/salix-update-manager.ui $(DESTDIR)/usr/share/salix-update-notifier/
	install -m 644 salix-update-manager.desktop $(DESTDIR)/usr/share/applications/
	install -m 644 icons/updates-notifier.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/
	install -m 644 icons/update-notifier.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/
	install -m 644 icons/flatpak.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/
	install -m 644 icons/salix-update-manager.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps/
	install -m 644 org.salixos.salix-update-manager.policy $(DESTDIR)/usr/share/polkit-1/actions/
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

