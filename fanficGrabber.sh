#!/bin/bash

#a Fanfiction grabber for Fanfiction.net
title=$(curl $1 | grep -o -P '(?<=xcontrast_txt).*(?=</b>)' | sed 's/..//'| sed 's/ /\_/g')
mkdir $title
cd $title
echo $title
echo $chapters
echo $1 >> rad.txt
cat rad.txt
x=1
y=$(expr $2 - 1 )
while [ $x -le $2 ]
	do
		#curl $1 | sed '331!d' >>$x
		strt=$(cut -c -38 rad.txt)
		ext=$(cut -c 40- rad.txt)
		link=$strt$x$ext
		x=$(( $x + 1 ))
		curl $link > $x.html
	done
rm -rf rad.txt
