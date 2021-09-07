#!/bin/bash

# ENV ZONE
GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'
ROOT="`dirname \"$0\"`"
EXT=
fs=()

# FUNCTION FOR FETCH ALL FILE WITH RIGHT EXTENSION IN CURRENT PATH
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

# CHECK IF THE MAKEFILE FILE IS VALID 
cat Makefile &> /dev/null
if [ $? != 0 ]; then
	printf "${RED}No makefile found !${NO}\n"
	exit 1
fi;

# CREATE AN ARRAY WITH ALL MAKEFILE LINE
IFS=$'\n' read -d '' -r -a array < Makefile

# INTERATE ON MAKEFILE LINE ARRAY
for line in ${!array[@]}; do

	# AT SRCS LINE
	echo "${array[line]}" | grep "SRCS=" &> /dev/null
	if [ $? = 0 ]; then
		# CHECK IF THE MAKEFILE IS WITH WILDCARD
		echo "${array[line]}" | grep "wildcard" &> /dev/null
		if [ $? = 0 ]; then
			EXT=$(echo ${array[line]} | sed "s/)//g" | cut -d '.' -f2)
			((line++))
		else
			# FORWARD IN FILE WHILE SRCS BLOCK IS NOT PASSED
			while (( $line < ${#array[@]} )); do
				echo "${array[line]}" | grep '\\' &> /dev/null
				if [ $? != 0 ]; then
					# UPDATE EXT
					EXT=$(echo ${array[line]} | cut -d '.' -f2)
					((line++))
					break;
				fi;
				((line++))
			done
		fi;

		# FETCH NEW FILE
		fetch_files "" $(ls)

		# GET NEW FILE
		let count=0
		for file in ${fs[@]}; do
			((count++))
		done

# WRITE IN TMP FOR FILE FOR MAKEFILE UPDATE

cat <<EOF >> $ROOT/tmp_makefile
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
EOF

		# WRITE THE END OF MAKEFILE FILE AFTER SRCS BLOCK
		while (( $line < ${#array[@]} )); do
			printf "${array[line]}\n" >> $ROOT/tmp_makefile
			((line++))
		done; 

		# REPLACE THE OLD MAKEFILE WITH THE NEWEST
		rm Makefile
		cp $ROOT/tmp_makefile Makefile; rm $ROOT/tmp_makefile

		printf "${GREEN}update complete !${NO}\n"
		exit 0
	else
		# JOIN THE BUFFER BEFORE SRCS BLOCK
		printf "${array[line]}\n" >> $ROOT/tmp_makefile
	fi
done;

