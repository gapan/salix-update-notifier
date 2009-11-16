#!/bin/sh

for i in `ls locale/*.po`;do
	echo "Compiling `echo $i|sed "s|locale/||"`"
	msgfmt $i -o `echo $i |sed "s/salix-update-notifier-//"|sed "s/.po//"`.mo
done
