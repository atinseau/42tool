#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'

echo $@

cat Makefile &> /dev/null
if [ $? != 0 ]; then
	printf "${RED}No makefile found !${NO}\n"
	exit 1
fi;

EXT=

fs=()
level=""
fetch_files ()
{
	array=$@
	for f in ${array[@]}; do
		if [ -d "${level}${f}" ]; then
			level="${level}${f}/"
			fetch_files $(ls $level)
		else
			extension=$(echo $f | cut -d '.' -f2)
			if [[ "$extension" == "$EXT" ]] || [ -z "$EXT" ]; then
				fs+=("${level}${f}")
			fi;
		fi;
	done;
}

fetch_files $(ls)

echo ${fs[@]}
