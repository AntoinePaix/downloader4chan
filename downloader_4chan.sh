#!/bin/bash

# DESCRIPTION: This simple bash script downloads the entire content of a 4chan's thread
# @author: Antoine Paix
# @date: 2019/04/10

# To run this script you need to install curl and wget commands
# On Ubuntu/Debian distro type in terminal: sudo apt install curl wget
# Run chmod +x on this script to make it executable
# Enjoy !

shopt -s extglob

# URL 4chan thread
THREAD_URL="${1}"

# Folder where the content are saved (you can modified the path if you want)
PATH_TO_FOLDER="/home/$USER/4chan"

# ID thread recovery
FOLDER_NAME=$(basename "$1")

# Creating the directory
CONTENT_FOLDER="${PATH_TO_FOLDER}/${FOLDER_NAME}"

usage() {
    echo "DESCRIPTION: this script downloads the entire content of a thread on 4chan.org website"
    echo "USAGE: bash $(basename ${0}) <url_4chan_thread>"
}

if [ $# -ne 1 ]
then
    usage
    exit 1
fi

# Url control
invalid_url() {
    echo "INVALID URL: URL must have this format (example): https://boards.4channel.org/g/thread/20558626"
}

#regex='https://boards.4channel.org/[[:alnum:]]*/thread/[[:digit:]]*'
#if [[ $THREAD_URL =~ $regex ]]
#then
#    echo "[+] Good URL: ${THREAD_URL}"
#else
#    invalid_url && exit 2
#fi

# Creating folder
if [ ! -d "${CONTENT_FOLDER}" ]
then
    echo "[+] Creating the folder "${CONTENT_FOLDER}""
    mkdir -p "${CONTENT_FOLDER}"
else
    echo "[+] Downloading content to the folder ${CONTENT_FOLDER}"
fi

cd $CONTENT_FOLDER


for file in $(curl -s "${THREAD_URL}" | tr " " "\n" | grep "href=\"//is2.4chan.org/*/[[:digit:]]*.[[:lower:]]*" | \
                cut -d'=' -f2 | sed -e 's/"//g ; s/\/\///g' | uniq)
do
    FILE="https://"${file}""

    # echo "${FILE}" # use for debugging only
    
    wget -nc "${FILE}"

done

if [ "$?" -eq 0 ]
then
    echo "[+] Files are saved in "${CONTENT_FOLDER}""
fi
