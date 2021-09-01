
if [ "$(whoami)" = "atinseau" ] && [ "$DEV" = "1" ]; then
	git checkout -B main &> /dev/null
	git pull origin main &> /dev/null
else
	git checkout -B release &> /dev/null
	git pull origin release &> /dev/null
fi;