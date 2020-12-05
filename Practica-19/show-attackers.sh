#!/bin/bash
clear

#===============================================================================
#
#          FILE: show-attackers.sh
#
#         USAGE: ---
#
#   DESCRIPTION: This script displays the number of failed login attempts
#				by IP address and location.
#        AUTHOR: Osmar Vallecillo
#  ORGANIZATION: INS Pedralbes
#       CREATED: 04/12/2020 11:00:05 AM
#      REVISION:  ---
#===============================================================================


#Let's check if the script is running as superUser
if ! [ $(id -u) = 0 ]
then
    echo -e "\e[97;41mERROR:\e[0m You must be root to execute this this program"
    echo -e "\n"
    exit 1
else
    echo -e "\e[94mWelcome home root\e[0m"
    echo -e "\n"
fi

# Usage function
usage() {
  echo -e "Usage: $0 FILENAME ..."
  echo -e "\n"
  echo -e "### Files in current directory ###\n"
  ls
  echo -e "\n"
}

# This funtion will read the file that we need to analyze
# if the file is not provided or a error will be displayed
# exit with a status of 1

openFile() {
# Supposing the file is in the same directory where is the script o the user provide a route
if [[ $1 -eq 0 ]] >> /dev/null 2>&1
then
  echo -e "\e[97;41mERROR:\e[0m You have to specify a file to be in order to be analyze"
  echo -e "\n"
  usage
  exit 1
  
elif ! [[ -e $1 ]] 
then
  echo -e "Cannot open log file: $1\n"
  exit 1
  
else
  file=$1
  while IFS= read -r line # read (-r) explain later
  do
    echo "$line"
  done < "$1"
fi
}

# execute the function
openFile $1
