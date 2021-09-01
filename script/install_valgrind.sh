
docker_destination="/goinfre/$USER/docker" #=> Select docker destination (goinfre is a good choice)

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'
blue=$'\033[0;34m'
cyan=$'\033[1;96m'
reset=$'\033[0;39m'

launchctl list | grep com.docker.docker &> /dev/null
if [[ $? == 1 ]]; then
	brew uninstall -f docker docker-compose docker-machine &>/dev/null ;:
	if [ ! -d "/Applications/Docker.app" ] && [ ! -d "~/Applications/Docker.app" ]; then
		echo "${blue}Please install ${cyan}Docker for Mac ${blue}from the MSC (Managed Software Center)${reset}"
		open -a "Managed Software Center"
		read -n1 -p "${blue}Press RETURN when you have successfully installed ${cyan}Docker for Mac${blue}...${reset}"
		echo ""
	fi
	pkill Docker
	rm -rf "$docker_destination"/{com.docker.{docker,helper},.docker} &>/dev/null ;:
	unlink ~/Library/Containers/com.docker.docker &>/dev/null ;:
	unlink ~/Library/Containers/com.docker.helper &>/dev/null ;:
	unlink ~/.docker &>/dev/null ;:
	rm -rf ~/Library/Containers/com.docker.{docker,helper} ~/.docker &>/dev/null ;:
	mkdir -p "$docker_destination"/{com.docker.{docker,helper},.docker}
	ln -sf "$docker_destination"/com.docker.docker ~/Library/Containers/com.docker.docker
	ln -sf "$docker_destination"/com.docker.helper ~/Library/Containers/com.docker.helper
	ln -sf "$docker_destination"/.docker ~/.docker
	open -g -a Docker
	echo "${GREEN}Docker${NO} is now starting!"
fi;

cat Makefile &> /dev/null
if [[ $? != 0 ]]; then
	echo "${RED}There is no Makefile for install valgrind rules...${NO}"
	exit 1
fi

required_rules=("fclean" "re")
for rule in ${required_rules[@]}; do
	grep "${rule}:" Makefile &> /dev/null
	if [[ $? != 0 ]]; then
		echo "${RED}There is no \"$rule\" rules in your Makefile...${NO}"
		exit 1
	fi;
done

forbidden_rules=("run:" "valgrind:")
for rule in ${forbidden_rules[@]}; do
	grep "${rule}:" Makefile &> /dev/null
	if [[ $? == 0 ]]; then
		echo "${RED}You can't already have a \"$rule\" rules in your Makefile...${NO}"
		exit 1
	fi;
done

cat <<EOF > Dockerfile
FROM debian:buster-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y libreadline-dev wget cmake valgrind make clang
RUN mkdir /test_dir
WORKDIR /test_dir
RUN useradd -m user1
RUN apt install sudo
ENTRYPOINT cp -r /project/* /test_dir && make run
EOF

cat <<EOF >> Makefile

valgrind: fclean
	docker build -t valgrind \$(shell pwd)
	docker run -it -v \$(shell pwd)/:/project valgrind

# ONLY IN VALGRIND CONTAINER
run: re 
	@valgrind --leak-check=full ./\$(NAME)
EOF

echo "${GREEN}Valgrind is now installed in your Makefile !${NO}"
