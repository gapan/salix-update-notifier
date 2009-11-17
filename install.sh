#!/bin/sh

install -d -m 755 $DESTDIR/usr/bin/
install -d -m 755 $DESTDIR/etc/xdg/autostart
install -d -m 755 $DESTDIR/etc/cron.hourly
install -m 755 src/salix-update-notifier $DESTDIR/usr/bin/
install -m 644 salix-update-notifier.desktop $DESTDIR/etc/xdg/autostart/
install -m 755 src/slapt-get-update $DESTDIR/etc/cron.hourly/

for i in `ls locale/*.mo|sed "s|locale/\(.*\).mo|\1|"`; do
	install -d -m 755 $DESTDIR/usr/share/locale/${i}/LC_MESSAGES
	install -m 644 locale/${i}.mo \
	$DESTDIR/usr/share/locale/${i}/LC_MESSAGES/salix-update-notifier.mo
done
