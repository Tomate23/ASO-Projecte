#!/bin/bash
clear
scriptName=$0 #Script's name 

# Is the user does not insert the correct syntax, the usage() fuction will tell him/her the right way of usage
function usage()
{
    # Use cat <<EOF to output multiline string
    cat <<EOF

    Usage: $scriptName [-u user] [-h hostname] [-t]
    Where:
    -u User, of DataBase (mandatory)
    -h Hostname, where is connected (mandatory)
    -p Port, (optional - default port > 3306) if you insert a specific port this must be >1024 and <=65535
    -t Check the connection

    Sample:
    $scriptName -u Alan -h localhost -p 9999 -t

EOF
exit
} 

while getopts ":u:h:p:t" opt; do # The option -t in the loop condition does not have ":" after it, this means that this option don't need argument
    case "${opt}" in
        u)  
            userName=$OPTARG
            if [ ! -z $userName  ]; then echo -e "\e[96mUsername\e[0m given > \e[35m$userName\e[0m"; fi
            ;;
        h)
            Hostname=$OPTARG
            if [ ! -z $Hostname  ]; then echo -e "\e[96mHostname\e[0m given > \e[35m$Hostname\e[0m"; fi
            echo -e "\n"
            ;;
        p)
            PORT=$OPTARG
            if [ $PORT -gt 1024 ] && [ $PORT -le 65535 ]
             then
                echo -e "\e[32mPort Valid\e[0m > $PORT"
            else
                echo -e "\e[97;41mInvalid Port\e[0m > $PORT"
                echo "Port must be >1024 and <=65535"
                echo -e "\n"
                usage
            fi
            ;;
        t)
            check=1
            ;;
        :)
            echo -e "\e[97;41mERROR:\e[0m Option \e[97;104m-$OPTARG\e[0m requires an argument"
            usage
            echo -e "\n"
            ;;
        \?)
            echo -e "\e[97;41mERROR\e[0m > Invalid option \e[97;104m-$OPTARG\e[0m"
            usage
            echo -e "\n"
            ;;
    esac
done

# This option is for verify is any option has been passed script.
# If OPTIND is = 1 means that no argument has been passed
if ((OPTIND == 1))
then
    echo "No options specified"
    echo -e "\e[97;41mERROR\e[0m > Username and Hostname are mandatory options"
    usage
elif [ ! "$userName" ] || [ ! "$Hostname" ]; then
    echo -e "\e[97;41mERROR\e[0m > \e[97;104m-u\e[0m and \e[97;104m-h\e[0m must be provided"
    usage
fi
