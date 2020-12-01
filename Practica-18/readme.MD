# Disabling / Removing Users 
---
> Asciinema recording link **<https://asciinema.org/a/AdF5N7XrAu6MOxqauloNGzafp>**

> Asciinema recording link **<https://asciinema.org/a/royg33rldonI9fK8liXqVcsX5>**

---
> This script will allow us **Desable**, **Remove** o **Create a backup of home directory** of a user that we specify. 

> The script will show us the rigth way of itself usage with the `usage()` function, this function will appear any time we execute the script in a wrong way.

---
* `usage()` function 
~~~
usage() {
    echo "Usage: ${0} [-d] [-r] [-a] USER ..." >&2
    echo 'Disable/delete/backup a local Linux account.' >&2
    echo '  -d  Disable account' >&2
    echo '  -r  Remove the account' >&2
    echo '  -a  Creates an archive of the home directory associated with the account(s).' >&2
    exit 1
}
~~~

---

> the option **a** will create a backup of the home directory of the user that we specify.

> **IMPORTANT** this user has **must have** a directory in /home

> Another important rule is that the user id (uid) must be **greater than 1000**, because the users under 1000 are associated with the system itself.

---

### Backup dire (my version)

> What i've done is a little menu, where the user can choose the  compress method to do the directory user backup

~~~
#Selecting the compression method
echo "Enter the compression method:"
echo "Type > gzip"
echo "Type > bzip2"
echo "Type > xz"
echo -e "\n"
read -p "Chose > " meth
~~~

> depending of the the user's choice a `case` statement will specify the values of the proper variables in order to make the backup.

~~~
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
        echo "Wrong method [gzip|bzip2|xz]"
        exit 1 # and exit with return code 1 which means error
        ;;
    esac
~~~

> Check if the user directory in **/home** exists and if this exists the script will make the backup with the specified method.

~~~
if [ ! -d /home/$1 ]; then # id not(!) existing directory(-d) /home/login ($2 is the second argument of script) then
        echo "User directorty does not exists"
        exit 1
    fi
    tar -${meth} -cf ${1}_$(date +%F).tar.${method} /home/${1}
    echo -e 'Verification...\n'
    ls -l
~~~

---
~~~
#===============================================================================
#          CHECK TESTS ASCIINEMA
#===============================================================================
# 1- Cap opció ni paràmetre: sudo ./18-disable-user.sh
# 2- Amb opció correcta sense paràmetre: sudo ./18-disable-user.sh -d
# 3- Usuari no existent: sudo ./18-disable-user.sh -d fdsfs
# 4- Usuari id inferior a 1000: sudo ./18-disable-user.sh -d mail
# 5- Usuari a esborrar:  sudo cat /etc/shadow|grep u1
#						sudo ./18-disable-user.sh -r u1
#                       sudo cat /etc/shadow|grep u1
# 6- Usuari a deshabilitar: sudo cat /etc/shadow|grep u3
#						   sudo ./18-disable-user.sh -d u3
#                          sudo cat /etc/shadow|grep u3
# 7- Usuari a fer backup la home usuari: sudo cat /etc/shadow|grep u3
# sudo ./18-disable-user.sh -a u3
# sudo ls -la /archives
~~~

## Explanation 
the **18-Disable-User-Fancy.sh** is for an experiment, don´t consider this script. The good one, is the ***18-Disable-User.sh***
