#!/bin/bash
clear

# Let's try if the user is root
uid=`id -u`

if [ "$uid" != "0" ]
then
	# If ain't root he or she will have to execute the script as root
	echo -e "You must be \e[31mRoot \e[0mTo do this!"
	echo -e "\n"
	exit
else
	echo -e "\e[32mWelcome root!\e[0m"
        echo -e "\n"
fi

usage(){
    echo -e "> In order to create the user, you have to specify the \e[30;104mUsername\e[0m and at least one \e[30;104mComment\e[0m"
    echo "> The password of the user will be generated automatically"
    echo -e "\n"
    echo -e "¿?Example of usage > sudo userCreation.sh \e[95mPepe \e[94mPalotes\e[0m"
    echo -e "\n"
    exit
}

# User creation function
useraddFUN() {
	#Creation of the user
	useradd -c "$3" $1
  echo "$1:$2" | chpasswd
	# Display any error
	if [[ $? -eq 0 ]]
	then
	  echo -e "\e[1;102mUser $1 has been created!\e[0m"
    echo -e "\n"
	else
	  echo -e "Something went wrong \e[31mError:\e[0m $?"
    echo -e "\n"
	fi
}

if [[ $# -eq 0 ]]
then
  usage
elif [[ $# -eq 1 ]]
then
  user_name=$1
  echo -e "You have given a userName > \e[32m$user_name\e[0m"
  echo -e "\e[41mWarning:\e[0m at least one comment needed"
  echo -e "\n"
  usage

elif [[ $# -eq 2 ]]
then
  user_name=$1
  shift;
  # Having shifted once, separate the username and comments
  comment=$@

  echo -e "\e[95mNice, all parameters have been given!\e[0m"
  echo -e "\n"
  echo -e "\e[1;30m User name\e[0m >  \e[32m$user_name \e[0m"
  echo -e "\e[1;30m Comment\e[0m >  \e[32m$comment \e[0m"
  echo -e "\n"

  # Creation of the random password
  ran_pass=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
  useraddFUN $user_name $ran_pass $comment
  echo -e "\n"
  echo -e "\e[1;30m Password\e[0m > \e[32m$ran_pass \e[0m"
  echo -e "\n"

  # Search for the new user in the /etc/passw file
  echo -e "\e[1;95mVerification...\e[0m"
  echo -e "\n"
  cat /etc/passwd | grep $user_name
  echo -e "\n"
fi

# Force password change on first login.
passwd -e ${user_name}
