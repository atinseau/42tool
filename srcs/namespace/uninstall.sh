

GREEN='\033[0;32m'
NO='\033[0m'

grep -vwE "(alias 42tool)" ~/.zshrc > zsh_clean

cat zsh_clean > ~/.zshrc
rm zsh_clean

rm -rf ~/42tool

printf "${GREEN}Uninstall completed${NO}\n"