#!/bin/sh

install -d -m 755 $DESTDIR/usr/bin/
install -d -m 755 $DESTDIR/etc/xdg/autostart
install -d -m 755 $DESTDIR/etc/cron.hourly
install -m 755 src/salix-update-notifier $DESTDIR/usr/bin/
install -m 644 salix-update-notifier.desktop $DESTDIR/etc/xdg/autostart/
install -m 644 src/slapt-get-update $DESTDIR/etc/cron.hourly/

