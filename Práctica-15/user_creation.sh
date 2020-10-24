#!/bin/bash
clear

uid=`id -u`
if [ "$uid" != "0" ]
then
	echo "You must be root to do this!"
	exit
else
	echo "Welcome root!"
fi


read -p "Your name > " real_name
read -p "Your user name > " user_name
read -s -p "Set a password > " user_password
echo -e "\n"

useradd -c "$real_name" -p $user_password $user_name

if [[ $? -eq 0 ]]
then
	echo "User $user_name has been created!"
else
	echo "Something gone wrong Error:$?"
fi

echo -e 'Verification...\n'
cat /etc/passwd | grep $user_name

# User Login
i=3
while [ $i -gt 0 ]
do
	read -p "Please enter username: " username
	((i=i-1))
	if [[ $i -eq 0 ]]
	then
	    echo "No more attemps"
		exit
	else
		echo "$i attemps left..."
	fi

	if [[ $username = $user_name ]]
	then
	    echo "$username exists... changing password"
	    read -s -p "Please enter the new password: " password1
		echo -e '\n'
	    read -s -p "Please repeat the new password: " password2

		# Check both passwords match
	    if [ $password1 != $password2 ]
	    then
	        echo "Passwords do not match"
    		exit
	    else
	        echo 'Passwords Ok'
			# Change password
			echo -e "$password1\n$password1" | passwd $username
			echo "Password has been changed!"
			#$(su $username)
			#echo -e "Current user > $(whoami) \n"
			exit
	fi

	elif [[ $username != $user_name ]]
	then
 	    echo "$username does not exist - Password could not be updated for $username"
	fi

done

