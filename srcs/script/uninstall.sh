#!/bin/bash

rm -rf $HOME/42toolbox
grep -vwE "(alias 42toolbox)" ~/.zshrc > zsh_clean

cat zsh_clean > ~/.zshrc
rm zsh_clean