#!/bin/bash
clear

#===============================================================================
#
#          FILE: 18-Disable-User.sh
#
#         USAGE: ${0} [-d] [-r] [-a] USER ...
#
#   DESCRIPTION: This script disables, deletes, and/or archives users on the
#				 local system.
#        AUTHOR: Osmar Vallecillo
#  ORGANIZATION: INS Pedralbes
#       CREATED: 28/11/2020 11:00:05 AM
#      REVISION:  ---
#===============================================================================

scriptName=$0 #Script's name

#Display the usage and exit
usage() {
    echo -e "\e[96m"
    echo -e "\n"
    echo "Usage: ${0} [-d] [-r] [-a] USER ..." >&2
    echo 'Disable/delete/backup a local Linux account.' >&2
    echo '  -d  Disable account' >&2
    echo '  -r  Remove the account' >&2
    echo '  -a  Creates an archive of the home directory associated with the account(s).' >&2
    echo -e "\e[0m"
    
    #Display the current users in the system 
    echo -e "### These are the current users in your system ###"
    echo -e "\e[93m"
    getent passwd {1000..2000}
    echo -e "\e[0m"
    exit 1
}

#Check the user id, this must be ay least 1000 no under this number
checkUserID() {
    _uid=$(id -u $1)
    echo -e "User name ID (UID) : \e[44m$_uid\e[0m"

    if [[ $_uid -le 1000 ]]
    then
        echo -e "\e[97;41mERROR:\e[0m The userID must be greater than 1000"
        echo -e "\n"
        exit 1
    else
        echo "Valid userID"
        echo "############################"
        echo -e "\n"
    fi
}

#Check the userName exists or not.
checkUser() {
    username=$1
    if [[ $(id -u $username) ]] >/dev/null 2>&1 #this erase/don't show the error of the system 
    then
        echo "###########################"
        echo -e "User \e[42mexists\e[0m"
        echo "User name > $username"
        echo -e "\n"
        checkUserID $username
    else
        echo "User name > $username"
        echo -e "\e[97;41mERROR:\e[0m This user does not exist"
        echo -e "\n"
        exit 1
    fi
}

# This function creates a backup of a directory.
backup_dir() {
    #Selecting the compression method
    echo -e "\e[104mEnter the compression method:\e[0m"
    echo -e "\n"
    echo "Type > gzip"
    echo "Type > bzip2"
    echo "Type > xz"
    echo -e "\n"
    read -p "Chose an option > " meth
    echo -e "\n"

    case $meth in #with the option chosed the case statement runs code depending of its content. for example: if $meth is equal to "gzip" then set method to "z" 
    "gzip" )
        meth="z"
        method="gzip"
        ;;
    "bzip2" )
        meth="j"
        method="bzip2"
        ;;
    "xz" )
        meth="J"
        method="xz"
        ;;
    *)
        # if $1 is none of above then run this
        echo -e "\e[41mWrong method > \e[0m \e[30;103m($meth)\e[0m \e[42m[gzip|bzip2|xz]\e[0m"
        echo -e "\n"
        exit 1 # and exit with return code 1 which means error
        ;;
    esac
    if [ ! -d /home/$1 ]; then # id not(!) existing directory(-d) /home/login ($2 is the second argument of script) then
        echo -e "\e[97;41mERROR:\e[0m User directorty does not exists"
        echo -e "\n"
        echo "Files in /home >>>"
        echo -e "\n"
        ls /home
        exit 1
    fi
    tar -${meth} -cf ${1}_$(date +%F).tar.${method} /home/${1}
    echo -e 'Backup file verification...\n'
    ls -l

}

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


#Start getopts...
while getopts ":d:r:a:" opt; do
    case "${opt}" in
        d)
            userDISABLE=$OPTARG
            checkUser $userDISABLE
            #in order to lock/disable the user we'll use de "usermod" command
            #the commands adds an exclamation mark (“!”) in the second field of the file /etc/passwdthe commands adds an exclamation mark (“!”) in the second field of the file /etc/passwd
            echo -e "\e[104mDisabling user >\e[0m $userDISABLE"
            echo -e "\n"
            #check before disable the user 
            echo -e "--> \e[40;38;5;82mCheck before >\e[0m $(cat /etc/shadow | grep $userDISABLE)"
            echo -e "\n"
            sleep 3
            usermod -L $userDISABLE
            if [[ $? -eq 0 ]]
            then
                echo "User <$userDISABLE> has been disabled"
                sleep 2
                echo -e "\n"
                #check the exclamation on the user info
                echo -e 'Verification in /etc/shadow directory\n'
                echo -e "--> \e[40;38;5;82mCheck after >\e[0m $(cat /etc/shadow | grep $userDISABLE)"
            else
                echo "Something went wrong: couldn't disable this user > $userDISABLE"
                exit 1
            fi
            ;;
        r)
            userREMOVE=$OPTARG
            checkUser $userREMOVE

            #We'll delete the user using userdel
            echo "Looking for <$userREMOVE> in /etc/passwd"
            check=$(cat /etc/passwd | grep $userREMOVE)
            if [[ $check ]]
            then
                echo $check
            else
                echo -e "\e[97;41mERROR\e[0m > Couldn't find this user"
            fi
            echo "--> Deleting user <$userREMOVE>"
            userdel -r $userREMOVE
            if [[ $? -eq 0 ]]
            then
                echo "--> User <$userREMOVE> has been Removed from the system"
                #check the exclamation on the user info
                echo -e 'Verification...\n'
                echo -e "\e[93m"
                getent passwd {1000..2000}
                echo -e "\e[0m"
            else
                echo -e "\e[97;41mSomething went wrong\e[0m"
                exit 1
            fi
            ;;
        a)
            userBACKUP=$OPTARG
            checkUser $userBACKUP

            backup_dir $userBACKUP
            ;;
        :)
            echo -e "\e[97;41mERROR:\e[0m Option \e[97;104m-$OPTARG\e[0m requires an argument"
            usage
            ;;
        \?)
            echo -e "\e[97;41mERROR\e[0m > Invalid option \e[97;104m-$OPTARG\e[0m"
            usage
            ;;
    esac
done

# This option is for verify is any option has been passed script.
# If OPTIND is = 1 means that no argument has been passed
if ((OPTIND == 1))
then
    echo -e "\e[97;41mERROR:\e[0m No options specified"
    usage
    exit 1
fi
