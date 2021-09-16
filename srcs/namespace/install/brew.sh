#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'

remove_line ()
{
	grep -vwE "($1)" ~/.zshrc > zsh_clean
	cat zsh_clean > ~/.zshrc
	rm zsh_clean
}

already ()
{
	if [ "$1" = "--remove" ] || [ "$1" = "-r" ]; then
		remove_line "alias brew="
		rm -rf ~/42tool/installed/brew
		printf "${GREEN}brew unistalled...!${NO}\n"
		exit 0
	else
		printf "${RED}Brew is already installed...!${NO}\n"
		exit 1
	fi;
}

grep "alias brew=" ~/.zshrc &> /dev/null
if [ $? = 0 ]; then
	already $1
fi;

cat ~/42tool/installed/brew/bin/brew &> /dev/null
if [ $? = 0 ]; then
	already $1
fi;

git clone https://github.com/Homebrew/brew.git ~/42tool/installed/brew
if [ $? != 0 ]; then
	rm -rf ~/42tool/installed/brew
	printf "${RED}Somethings wrong during the install, please retry${NO}\n"
fi;

bash ${HOME}/42tool/installed/brew/bin/brew
echo "alias brew=\"${HOME}/42tool/installed/brew/bin/brew\" #42tool" >> ~/.zshrc
printf "${GREEN}Succesfully installed !, please restart zsh${NO}\n";
