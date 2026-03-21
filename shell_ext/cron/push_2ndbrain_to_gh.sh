#!/bin/bash

NOW="$(date +'%Y-%m-%d_%H-%M-%S')"
#SCRIPT="$(echo "$FILE" | cut -d'.' -f1)"
LOGFILE="/Users/pnowosie/.shell_ext/cron/.log"

cd /Users/pnowosie/Library/CloudStorage/Dropbox/notes/obsidian
echo "Switched to $(pwd)"

CURRHEAD=$(git rev-parse --short HEAD)
#echo "CURRHEAD=${CURRHEAD}"

git add .
git commit -m "Auto-commit 2nd Brain - thank you KbM"
echo "Commited!"

HEAD=$(git rev-parse --short HEAD)
#echo "HEAD=${HEAD}"
if [[ "${HEAD}" != "${CURRHEAD}" ]]; then
	echo "Write changes to the logfile: ${LOGFILE}"
	printf "\n========= ${NOW} =========\n" >> $LOGFILE
	git log --name-status ${CURRHEAD}..HEAD >> $LOGFILE
else
	echo "Nothing to change ${CURRHEAD} .. ${HEAD}"
fi

git pull --rebase
git push
echo "Pushed to origin!"

echo "Done."
