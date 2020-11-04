#!/bin/bash

#a Fanfiction grabber for Fanfiction.net
#the Set up
title=$(curl $1 | grep -o -P '(?<=xcontrast_txt).*(?=</b>)' | sed 's/..//'| sed 's/ /\_/g')
author=$(curl $1 | sed -n '310p' | grep -o -P 'href=.*<span' | grep -o -P '>.*</' | sed 's/.//' | sed 's/..$//')
mkdir $title
cd $title
x=1

#this helps create a nice titlepage
<< COMMENT
curl https://raw.githubusercontent.com/endercreeper1000/scripts/main/FanfictionDownloaderThingies/TitlePage.html > $title.html

T=$(sed -n '46p' $title.html)
M=$(sed -n '48p' $title.html)
B=$(sed -n '50p' $title.html)
N=53
echo $title | sed -i '5r /dev/stdin' $title.html
echo $title | sed -i '32r /dev/stdin' $title.html
echo $author | sed -i '37r /dev/stdin' $title.html
desc=$(curl $1 | sed '311!d' | grep -o -P '>.*<' | sed 's/.//' | sed 's/.$//')
echo $desc | sed -i '41r /dev/stdin' $title.html
COMMENT

#download section
while [ $x -le $2 ]
	do
		#extension of the titlepage
		<< COMMENT
		echo $T | sed -i -e '$Nr /dev/stdin' $title.html
		N=$(( $N + 1 ))
		echo $x.html | sed -i -e '$Nr /dev/stdin' $title.html
		N=$(( $N + 1 ))
		echo $M | sed -i -e '$Nr /dev/stdin' $title.html
		N=$(( $N + 1 ))
		echo $x | sed -i -e '$Nr /dev/stdin' $title.html
		N=$(( $N + 1 ))
		echo $B | sed -i -e '$Nr /dev/stdin' $title.html
		N=$(( $N + 1 ))

COMMENT

		#makes it look nice
		curl https://raw.githubusercontent.com/endercreeper1000/scripts/main/FanfictionDownloaderThingies/ChapterTemplate.html > $x.html
		NC=$(( $x + 1 ))
		PC=$(( $x - 1 ))
		echo $NC.html | sed -i '94r /dev/stdin' $x.html
		echo $PC.html | sed -i '86r /dev/stdin' $x.html
		if [ $x == $2 ]
			then
				sed -i 95,100d $x.html
			fi
		if [ $x == 1 ]
			then
				sed -i 83,90d $x.html
			fi

		#below is the only part that is actually required in the loop
		strt=$(echo $1 | cut -c -38)
		ext=$(echo $1 | cut -c 40-)
		link=$strt$x$ext
		if [ $x -lt $2 ]
			then
				curl $link | sed '327!d' | sed -i '81r /dev/stdin' $x.html
			else
				curl $link | sed '331!d' | sed -i '81r /dev/stdin' $x.html
			fi
		#above is the only part that is required in the loop

		#this is only useful if you don't get rid of the template cuurl
		echo $title | sed -i '5r /dev/stdin' $x.html
		echo $title | sed -i '62r /dev/stdin' $x.html
		echo $x | sed -i '78r /dev/stdin' $x.html
		echo $author | sed -i '71r /dev/stdin' $x.html

		#Let's you know how many more chapters need to be downloaded,
		echo $x " of " $2

		# I LIED THIS IS ALSO A KEY PART OF THE LOOP
				x=$(( $x + 1 ))

	done
