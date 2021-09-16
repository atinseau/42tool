#!/bin/bash

remove_line ()
{
	grep -vwE "($1)" ~/.zshrc > zsh_clean
	cat zsh_clean > ~/.zshrc
	rm zsh_clean
}

GREEN='\033[0;32m'
NO='\033[0m'

remove_line "alias 42tool"
remove_line "#42tool"

rm -rf ~/42tool

printf "${GREEN}Uninstall completed${NO}\n"