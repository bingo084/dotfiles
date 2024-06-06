#! /bin/bash
mime=$(file -bL --mime-type "$1")
category=${mime%%/*}
kind=${mime##*/}
if [ -d "$1" ]; then
	eza -l --git --color=always --icons --no-user --no-time --no-permissions --no-filesize "$1"
elif [ "$category" = text ]; then
	bat --color=always "$1"
elif [ "$mime" = application/pdf ]; then
	pdftotext "$1" - | less
elif [ "$category" = image ]; then
	exiftool "$1"
else
	echo $1 is a $kind file
fi
