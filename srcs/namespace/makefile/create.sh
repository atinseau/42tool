#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'
CC=
FLAGS=" -Wall -Wextra -Wall"

cat Makefile &> /dev/null
if [ "$?" = "0" ]; then
	printf "${RED}Makefile already exists...${NO}\n"
	exit 1
fi;

printf "Your program name ? "
read -r NAME;

printf "File extension (.c, .cpp, empty for all...) ? "
read -r EXT;
EXT=$(echo $EXT | sed "s/[.]//g");

if [ "$EXT" = "cpp" ]; then
	CC=clang++
elif [ "$EXT" = "c" ]; then
	CC=gcc
fi;

if [ -z "$CC" ]; then
	printf "Your compiler ? "
	read -r CC;
fi;


printf "Need extra flags (current: ${YELLOW}${FLAGS}${NO}) [y/n] "
read -r EXTRA;

if [ "$EXTRA" = "y" ]; then
	printf "Your flags ? "
	read -r EXTRA;
	FLAGS="$FLAGS $EXTRA"
fi;

fs=()
level=""
fetch_files ()
{
	array=$@
	for f in ${array[@]}; do
		if [ -d "${level}${f}" ]; then
			level="${level}${f}/"
			fetch_files $(ls $level)
		else
			extension=$(echo $f | cut -d '.' -f2)
			if [[ "$extension" == "$EXT" ]] || [ -z "$EXT" ]; then
				fs+=("${level}${f}")
			fi;
		fi;
	done;
}

fetch_files $(ls)

let count=0
for file in ${fs[@]}; do
	((count++))
done

cat <<EOF > Makefile
# AUTO-GENERATE FILE
# BY 42tool
# creator: https://github.com/alphagameX
# project author: $USER

CC=$CC
NAME=$NAME
FLAGS=$FLAGS
SRCS=$(
	if [[ $count != 0 ]]; then
		let i=0
		for file in ${fs[@]}; do
			if [ $i -eq 0 ]; then
				printf "\t"
				printf "${file}"
			else
				printf "\t\t"
				printf "${file}"
			fi
			((i++))
			if [ "$i" != "$count" ]; then
				echo " \\"
			fi;
		done
	else
		echo "\$(wildcard *.${EXT})"
	fi;
)
OBJS=\$(SRCS:.${EXT}=.o)

\$(NAME):\$(OBJS)
	@\$(CC) \$(FLAGS) \$(OBJS) -o \$(NAME)

all: \$(NAME)

clean:
	@rm -f \$(OBJS)

fclean: clean
	@rm -f \$(NAME)

re: fclean all

.PHONY: all clean fclean re
EOF

printf "${GREEN}Makefile created !${NO}\n"


