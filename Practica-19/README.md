# Parsing Log files / Detecting Possible attacks
---
### Recording Links 
> Asciinema recording link **<>**
---
### Explanation

> As it said in the title in this part of the project we have to **parse/analyze** log files (syslog-sample).
> In order to create the script and test it we have the *syslog-sample* file.
> This file contains all the attemps of Login via **ssh** , this have the IPs log
>
>> in this file we have:
>> - The two type unsuccessful SSH login events that we are going to to have to include.
>
>>    1. Invalid users, these are users that do not exist on the server.
>
>>    2. Valid users but incorrect passwords. These are users that exist but an incorrect password was supplied.
>

We have to take this into consideration, because there are valid users that have tried to log in but they have put the wrong password. And there other that are not registrated in the Database (Invalid users) this kind of users may be possibly attackers with bad intentions.
* (Valid Users) but incorrect password **{Apr 15 19:56:55 spark sshd[16872]: "pam_unix(sshd:auth): authentication failure"; logname= uid=0 euid=0 tty=ssh ruser= rhost=183.3.202.111 user=root}**

* (Invalid Users) Possible attackers **{Apr 15 11:44:38 spark sshd[14153]: "Invalid user" weblogic from 41.223.57.47}**
---
### Code's snippets

> **IMPORTANT!!!** This script use the program `geoiplookup` in order to find the country of the IP address, the script will try to install this program when you execute it.

> If the script for any reason can´t install the program you can do it by using `sudo apt install -y geoip-bin`

> Another important thing is that the user has to provide a log file in order to analyze it, this file has to be provided it **absolute path**

* `usage()` Function
~~~
usage() {
  echo -e "Usage: $0 FILE/PATH(absolute)"
  echo -e "Sample >> /home/tomate/Desktop/my-log-file"
  echo -e "### Files in current directory ###\n"
  ls
  echo -e "\e[96m### Current path ###\e[0m \n"
  pwd
}
~~~

* Display more than 10 login attemps `Infodisplay()`
~~~
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
~~~
These are the two more important lines in my script. The script has been made in such a way that generate two `.txt` files:
1. **IPs.txt**
2. **sorted-IPs.txt**

> In `IPs.tx`are stored all the **Failed** IP address attemps, no matter if the user is valid or not.

> In `sorted-IPs.txt` are stores only the IP address of the **Invalid** user that have tried to log in.
---

The `sorted-IPs.txt` is the parameter that we pass to the `Infodisplay` in order to `echo` only the IP that has made more than 10 attemps.
