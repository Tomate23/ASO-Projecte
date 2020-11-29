# Disabling / Removing Users 
---
> Asciinema recording link **<>**

> Asciinema recording link **<>**
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
