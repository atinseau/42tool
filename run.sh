#!/bin/bash
# MENU
GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'
ROOT="`dirname \"$0\"`"

format_menu ()
{
	name=$(echo $2 | sed "s/_/ /g;s/.sh//g" | tr a-z A-Z)
	printf "${YELLOW}[${1}] $GREEN$name$NO\n"
}

sh update.sh
clear

scripts=($(ls ${ROOT}/script))

let i=0
for script in ${scripts[@]}; do
	format_menu $i $script
	((i++))
done;

printf "what do you want ? "
read -r line;

if [ $line -lt 0 -o $line -ge $i ]; then
	echo "${RED}Wtf ?!"
	exit 1
fi;

clear
printf "${GREEN}running ${scripts[line]}...$NO\n"
sh $ROOT/script/${scripts[line]}
if [[ $? == 0 ]]; then
	echo "done !"
fi;