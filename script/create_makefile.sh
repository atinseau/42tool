GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'

cat Makefile &> /dev/null
if [ $? -eq 0 ]; then
	echo ${RED}Makefile already exists...${NO}
	exit 1
fi;

printf "Set your compiler: "
read -r CC;
printf "Set your flags: "
read -r FLAGS;
printf "Set your program name: "
read -r NAME;
printf "Set file extension (.c, .cpp, empty for all...) : "
read -r EXT;

EXT=$(echo $EXT | sed "s/[.]//g")

files=($(ls))
fs=()

fetch_files ()
{
	arr=${@:2}
	for file in ${arr[@]}; do
		if [ -d $file ]; then
			fetch_files $file $(ls $file)
		else
			extension=$(echo $file | cut -d '.' -f2)
			if [[ "$extension" == "$EXT" ]] || [ -z "$EXT" ]; then
				if [ $1 ]; then
					fs+=("${1}/${file}")
				else
					fs+=($file)
				fi;
			fi;
		fi;
	done;
}

fetch_files "" ${files[@]}

let count=0
for file in ${fs[@]}; do
	((count++))
done

cat <<EOF > Makefile
FILE=$(
	if [[ $count != 0 ]]; then
		let i=0
		for file in ${fs[@]}; do
			if [ $i -eq 0 ]; then
				echo "\t ${file} \\"
			else
				echo "\t\t ${file} \\"
			fi
			((i++))
		done
	else
		echo "\$(wildcard *.${EXT})"
	fi;
)
FLAGS=$FLAGS
NAME=$NAME
CC=$CC

all:
	\$(CC) \$(FLAGS) \$(FILE) -o \$(NAME)

clean:
	rm -rf \$(NAME)

fclean: clean

re: fclean all
EOF

echo "${GREEN}Makefile created !${NO}"