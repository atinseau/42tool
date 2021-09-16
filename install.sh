#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'

cp -r srcs ~/42tool
if [ "$?" != "0" ]; then
	echo "${RED}already installed...${NO}"
	exit 1
fi;


if [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
	grep "alias 42tool" ~/.zshrc &> /dev/null
	if [ $? == 0 ]; then
		printf "${RED}already installed...${NO}\n"
		exit 1
	fi;
	echo "alias 42tool=\"$HOME/42tool/run.sh\"" >> ~/.zshrc
	chmod +x ~/42tool/run.sh
	mkdir ~/42tool/installed
	printf "${GREEN}Install completed, restart zsh !${NO}\n"
fi;
