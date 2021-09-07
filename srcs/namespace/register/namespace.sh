#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'
ROOT="`dirname \"$0\"`"

NAME=""
SCRIPT=""

args=($@)

for arg in ${args[@]}; do
	echo "$arg" | grep "\-\-name=" &> /dev/null
	if [ $? = 0 ]; then
		NAME=$(echo $arg | sed "s/--name=//g")
	fi;

	echo "$arg" | grep "\-\-script=" &> /dev/null
	if [ $? = 0 ]; then
		SCRIPT=$(echo $arg | sed "s/--script=//g")
	fi;

	if [ "$arg" = "--help" ]; then
		printf "${YELLOW}Help for register namespace${NO}\n"
		echo
		echo "--name=\"NAME\""
		echo "      Set the name of the new namespace"
		echo
		echo "--script=\"NAME\""
		echo "      Set path to a script to add in the new namespace"
		echo
		exit 0
	fi;
done;

if [ "$NAME" != "" ]; then
	echo 
else
	printf "${YELLOW}Namespace name ?${NO} "
	read -r NAME;
fi;

ls "${ROOT}/namespace/${NAME}" &> /dev/null
if [ $? = 0 ]; then
	printf "${RED}Namespace already exists !${NO}\n"
	exit 1
fi;


mkdir "${HOME}/42tool/namespace/${NAME}"
if [ $? != 0 ]; then
	printf "${RED}Namespace not created, somethings wrong...${NO}\n"
	exit 1
fi

printf "${GREEN}Namespace successfully created !${NO}\n"

if [ "$SCRIPT" != "" ]; then
	cat $SCRIPT &> /dev/null
	if [ $? != 0 ]; then
		printf "${RED}Script not exists !${NO}\n"
	else
		cp $SCRIPT "${HOME}/42tool/namespace/${NAME}"
		printf "${GREEN}Script successfully added!${NO}\n"
	fi;
fi;