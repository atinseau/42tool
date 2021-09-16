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
		remove_line "alias composer="
		printf "${GREEN}Composer unistalled...!${NO}\n"
		exit 0
	else
		printf "${RED}Composer is already installed...!${NO}\n"
		exit 1
	fi;
}

grep "alias composer=" ~/.zshrc &> /dev/null
if [ $? = 0 ]; then
	already $1
fi;

cat ~/42tool/installed/composer.phar &> /dev/null
if [ $? = 0 ]; then
	already $1
fi;

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

mv composer.phar ~/42tool/installed
echo "alias composer=\"php ${HOME}/42tool/installed/composer.phar\" #42tool" >> ~/.zshrc

printf "${GREEN}Composer succesfully installled, please restart zsh!${NO}\n"