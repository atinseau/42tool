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

fetch_files ()
{
	local files=(${@:2})
	local path="$1"

	for file in ${files[@]}; do
		if [ -d $file ]; then
			local level
			if [ "$path" != "" ]; then
				level="$path/$file"
			else
				level=$file
			fi;
			fetch_files $level $(ls $level) 
		else
			local extension=$(echo $file | cut -d '.' -f2)
			if [[ "$extension" == "$EXT" ]] || [ -z "$EXT" ]; then
					if [ "$path" = "" ]; then
						fs+=(${file}) 
					else
						fs+=(${path}/${file}) 
					fi;
			fi;
		fi;
	done;
}

fetch_files "" $(ls)

let count=0
for file in ${fs[@]}; do
	((count++))
done

cat <<EOF > Makefile
# AUTO-GENERATE FILE
# BY 42tool
# creator: https://github.com/atinseau
# project author: $USER
#######################
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
#######################
OBJS=\${SRCS:.cpp=.o}
#######################
.cpp.o:
	\$(CC) \$(FLAGS) -c \$< -o \${<:.cpp=.o}
#######################
\$(NAME): \$(OBJS)
	@\$(CC) \$(FLAGS) \$(OBJS) -o \$(NAME)
#######################
all: \$(NAME)
#######################
clean:
	@rm -f \$(OBJS)
#######################
fclean: clean
	@rm -f \$(NAME)
#######################
re: fclean all
#######################
.PHONY: all clean fclean re
EOF

printf "${GREEN}Makefile created !${NO}\n"


