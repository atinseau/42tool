#!/bin/bash

GREEN='\033[0;32m'
NO='\033[0m'

rm -rf $HOME/42tool
grep -vwE "(alias 42tool)" ~/.zshrc > zsh_clean

cat zsh_clean > ~/.zshrc
rm zsh_clean

printf "${GREEN}Uninstall completed${NO}\n"