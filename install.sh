
GREEN='\033[0;32m'
RED='\033[0;31m'
NO='\033[0m'
YELLOW='\033[1;33m'

mkdir ~/42toolbox &> /dev/null
if [[ $? != 0 ]]; then
	echo "${RED}already installed...${NO}"
	exit 1
fi;

cp -r * ~/42toolbox
cp -r .git ~/42toolbox

if [[ "$SHELL" == "/bin/zsh" ]]; then
	grep "alias 42toolbox" ~/.zshrc &> /dev/null
	if [[ $? == 0 ]]; then
		echo "${RED}already installed...${NO}"
		exit 1
	fi;
	echo "alias 42toolbox=\"/Users/$(whoami)/42toolbox/run.sh\"" >> ~/.zshrc
	chmod +x ~/42toolbox/run.sh
	echo "${GREEN}Install completed, restart zsh !${NO}"
fi;
