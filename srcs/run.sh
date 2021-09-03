#!/bin/bash
# MENU
GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'
ROOT="`dirname \"$0\"`"

# GOOD PRINTING FOR SCRIPT MENU
format_menu ()
{
	name=$(echo $2 | sed "s/_/ /g;s/.sh//g" | tr a-z A-Z)
	printf "${YELLOW}[${1}] $GREEN$name$NO\n"
}


scripts=()
exec_path="namespace"

# DETECT IF THERE IS ASKED NAMESPACE
if [ $1 ]; then

	# NAMESPACE LIST
	if [ "$1" = "--namespace" ]; then
		printf "${YELLOW}List of available namespace${NO}\n"
		lists=($(ls -d $ROOT/namespace/*/))
		i=0
		for list in ${lists[@]}; do
			name=$(echo $list | rev | cut -d/ -f2 | rev)
			printf "${i}: ${name}\n"
			((i++))
		done;
		exit 0
	fi;

	# HELP COMMAND
	if [ "$1" = "--help" ]; then
		cat $ROOT/README.md
		exit 0
	fi;

	# GET LIST OF ALL SCRIPT NAMESPACE
	scripts=($(ls -p ${ROOT}/namespace/$1 2> /dev/null | grep -v /))
	# HANDLE UNEXIST NAMESPACE
	if [ $? != 0 ]; then
		printf "${RED}Namespace $1 not exists !${NO}\n"
		exit 1
	fi

	# UPDATE SCRIPT PATH
	exec_path="namespace/$1"

	# DETECT IF COMAND IS ASKED FOR CURRENT NAMESPACE
	if [ $2 ]; then

		# EXEC THE HELP NAMESPACE SCRIPT
		if [ "$2" = "--help" ]; then
			bash $ROOT/$exec_path/_help.sh
			exit 0
		fi;

		# CHOOSE RIGHT ASKED SCRIPT IN CURRENT NAMESPACE
		for script in ${scripts[@]}; do
			name=$(echo $script | sed "s/.sh//g")
			if [ "$2" = "$name" ]; then
				printf "${GREEN}starting ${exec_path}/${2}.sh...$NO\n"
				bash $ROOT/$exec_path/$2.sh ${@:3}
				exit 0
			fi;
		done;
		printf "${RED}Commande not found !${NO}\n"
		exit 1
	fi;
else
	scripts=($(ls -p ${ROOT}/namespace | grep -v /))
fi;

# REMOVE HELP SCRIPT 
scripts=(${scripts[@]/"_help.sh"}) 

# PRINT MENU
let i=0
for script in ${scripts[@]}; do
	format_menu $i $script
	((i++))
done;

printf "what do you want ? "
read -r line;

# EXECUTE THE RIGHT SRIPT DEPENDING ON EXEC_PATH
entries=($line)
for entry in ${entries[@]}; do
	if [ $entry -lt 0 -o $entry -ge $i ]; then
		printf "${RED}Commande not found !${NO}\n"
		exit 1
	fi;
	printf "${GREEN}starting ${exec_path}/${scripts[entry]}...$NO\n"
	bash $ROOT/$exec_path/${scripts[entry]}
done;

