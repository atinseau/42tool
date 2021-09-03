#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'
ROOT="`dirname \"$0\"`"

commands=$(ls $ROOT)

printf "${YELLOW}List of commands in $(echo $ROOT | rev | cut -d/ -f1| rev) namespace\n${NO}"

i=0
for command in ${commands[@]}; do
	name=$(echo $command | sed "s/.sh//g")
	printf "${i}: ${name}\n"
	((i++))
done;