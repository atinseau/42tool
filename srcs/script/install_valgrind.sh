
# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'


cat Makefile &> /dev/null
if [[ $? != 0 ]]; then
	printf "${RED}There is no Makefile for install valgrind rules...${NO}\n"
	exit 1
fi

required_rules=("fclean" "re")
for rule in ${required_rules[@]}; do
	grep "${rule}:" Makefile &> /dev/null
	if [[ $? != 0 ]]; then
		printf "${RED}There is no \"$rule\" rules in your Makefile...${NO}\n"
		exit 1
	fi;
done

forbidden_rules=("run:" "valgrind:")
for rule in ${forbidden_rules[@]}; do
	grep "${rule}:" Makefile &> /dev/null
	if [[ $? == 0 ]]; then
		printf "${RED}You can't already have a \"$rule\" rules in your Makefile...${NO}\n"
		exit 1
	fi;
done

cat <<EOF > Dockerfile
FROM debian:buster-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y build-essential valgrind make clang gcc
WORKDIR /project
CMD make run
EOF

cat <<EOF >> Makefile

valgrind: fclean
	docker build -t valgrind \$(shell pwd)
	docker run -it -v \$(shell pwd)/:/project valgrind

# ONLY IN VALGRIND CONTAINER
run: re 
	@valgrind --leak-check=full ./\$(NAME)
EOF

printf "${GREEN}Valgrind is now installed in your Makefile !${NO}\n"
