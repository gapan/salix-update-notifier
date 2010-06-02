#!/bin/sh

intltool-extract --type="gettext/ini" salix-update-notifier.desktop.in
xgettext --from-code=utf-8 -L shell -o po/salix-update-notifier.pot src/salix-update-notifier
xgettext --from-code=utf-8 -j -L C -kN_ -o po/salix-update-notifier.pot salix-update-notifier.desktop.in.h

rm salix-update-notifier.desktop.in.h

cd po
for i in `ls *.po`; do
	msgmerge -U $i salix-update-notifier.pot
done
rm -f ./*~

