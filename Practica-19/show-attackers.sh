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


Infodisplay() {
    echo -e "==> \e[96;4mCOUNTING MORE THAN 10 FAILED LOGIN ATTEMPS\e[0m"
    echo "Count,IP,Country"
    for count in $(cat $1 | awk '{print $1}') # For loop taking only the number of failed attemps.
    do
        if [[ $count -gt 10 ]] # if the number of failed attemps is more than 10 let's print the information
            then
            IP=$(fgrep -w "$count" $1 | awk '{print $2}' | tail -1) # this only take the IP corresponding to the number of failed attemps.
            #COUNTRY=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
            COUNTRY=$(geoiplookup $IP | cut -d " " -f 5-6) # Using the geoiplookup() to find the country depending on the IP address
            echo "$count,$IP,$COUNTRY"
        else
            break
            exit 0
        fi
    done
    echo -e "\n"
}


#Let's check if the script is running as superUser
if ! [ $(id -u) = 0 ]
then
    echo -e "\e[97;41mERROR:\e[0m You must be root to execute this this program"
    echo -e "\n"
    exit 1
else
    echo -e "\e[30;42;1;5mWelcome home root\e[0m"
    apt install -y geoip-bin >> /dev/null 2>&1
    geoip=$(which geoiplookup)
    if [[ $geoip ]]
    then
        echo -e "\e[44mgeoiplookup is installed!!!\e[0m"
    else
        echo -e "\e[97;41mERROR:\e[0m you need geoiplookup"
        echo -e "\e[1mtry this\e[0m >>> sudo apt install -y geoip-bin"
    fi
    echo -e "\n"
fi

# Usage function
usage() {
  echo -e "\e[44mUsage:\e[0m $0 FILE/PATH(absolute)"
  echo -e "\e[44mSample\e[0m >> \e[100m/home/tomate/Desktop/my-log-file\e[0m"
  echo -e "\n"
  echo -e "\e[96m### Files in current directory ###\e[0m \n"
  echo -e "\e[93m"
  ls
  echo -e "\e[0m"
  echo -e "\n"
  echo -e "\e[96m### Current path ###\e[0m \n"
  pwd
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
  echo -e "\e[97;41mERROR:\e[0m Cannot open log file: $1\n"
  exit 1
  
else
  file=$1
  # The two type unsuccessful SSH login events that we are going to to have to include.
  # 1- Invalid users, these are users that do not exist on the server.
  # 2- Valid users but incorrect passwords. These are users that exist but an incorrect password was supplied.
  
  
  # Gather invalid user's IP
  # {Apr 15 11:44:38 spark sshd[14153]: "Invalid user" weblogic from 41.223.57.47}
  echo -e "==> \e[96;4mINVALID USERS IP ADDRESS COUNT()\e[0m"
  grep "Failed" $file | awk '{print $(NF - 3)}' >IPs.txt
  cat IPs.txt | sort | uniq -c | sort -rn
  #grep "Invalid user" $file | awk '{print $10}' | sort | uniq -c | sort -rn # $10 only IP field
  sleep 2
  echo -e "\n"
  
  
  # We can now do the same for the second type of login, one with a valid username but incorrect password.
  # {Apr 15 19:56:55 spark sshd[16872]: "pam_unix(sshd:auth): authentication failure"; logname= uid=0 euid=0 tty=ssh ruser= rhost=183.3.202.111 user=root}
  echo -e "==> \e[96;4mVALID USERS (INCORRECT PASSWORDS) IP ADDRESS COUNT()\e[0m"
  grep 'pam_unix(sshd:auth): authentication failure;' $file | awk '{print $14}' | cut -d"=" -f2 | sort | uniq -c | sort -rn
  echo -e "\n"
  
  
  # at this paint we extracted the IP addresses that made unauthorized SSH login attempts.	
  # we'll count only the failed ones.
  # Now we have to had the IPs sorted and ranked
  cat IPs.txt | sort | uniq -c | sort -rn  > sorted-IPs.txt
  
  # Calling the function
  Infodisplay sorted-IPs.txt
fi
}

# execute the function
openFile $1

