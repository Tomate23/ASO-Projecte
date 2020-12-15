#!/bin/bash
clear
#02-MODEL-A.sh
#Qualifica 4/10 punts
#L'script, que ha de fer ús de GETOPS 
#ha de recollir les dades per calcular o bé el valor mitjà dels números 
#que hi ha al fitxer 02-adj-MODEL-A.csv o bé la seva suma. Has de tenir en compte
#que no totes les linies siguin números, en aquest cas passa a la següent 
#sense donar error.
#----------------EXEMPLES D'EXECUCIÓ----------------------
#$ ./02-MODEL-A.sh -o addition -f 02-adj-MODEL-A.csv 
#30
#---------------------------------------------------
#$ ./02-MODEL-A.sh -o average -f 02-adj-MODEL-A.csv 
#10
#---------------------------------------------------
#$ ./02-MODEL-A.sh
#Es necessari especificar les opcions del tipus d'operacio i fitxer
#Usage: ./02-MODEL-A.sh -o <addition|average> -f <fitxer>
#---------------------------------------------------
#$ ./02-MODEL-A.sh -o addition -f
#ERROR: Option -f requires an argument
#Usage: ./02-MODEL-A.sh -o <addition|average> -f <fitxer>
#---------------------------------------------------
#COMENTA EL TEU CODI PERQUÈ T'AJUDARÀ A ENTENDRE'L MILLOR!!!

# Echo usage if something isn't right.

# Creamos la funcion usage()
usage() {
    echo "Usage: ./02-MODEL-A.sh -o <addition|average> -f <fitxer>"
}

#Con esta funcion solo cogemos los numeros

addition() {
    for i in $( cat $1 | awk '{print $1}')
    do
        if [[ $i -gt 0 ]]
        then
            x=$(($x+$i))
        fi
    done
    echo $x
}

average() {
    for i in $( cat $1 | awk '{print $1}')
    do
        if [[ $i -gt 0 ]]
        then
            x=$(($x+$i))
            #letsuma=$((x++))
        fi
    done
    let avg=$(($x/3))
    echo $avg
}

#file=$4
while getopts ":o:f:" opt; do
    case "${opt}" in
      o)
        operation=$OPTARG
        echo "Operacion elegida > $operation"
        ;;
      f)
        filename=$OPTARG
        
        if [[ -s $filename ]]
        then
            echo "El directorio existe"
            if [[ $operation = "addition" ]]
            then
                echo "Let's add"
                addition $filename
            elif [[ $operation = "average" ]]
            then
                echo "Let's do the average"
                average $filename
            else
                echo "ERROR> operation $operation no valid"
                usage
                exit 1
            fi
        else
            echo "ERROR: Este directorio no existe"
            exit 1
        fi
        ;;
      :)
        echo "ERROR: opcion $OPTARG requiere un argumento"
        usage
        ;;
      \?) 
        echo "ERROR: la opcion $OPTARG no es valida"
        usage
      esac
done
#proveNum $1

if ((OPTIND == 1)) #si esto se cumple quiere decir que no se ha psado ninguna opcion
then
    echo "ERROR: Has despecificar una opció per crear, canviar de nom o esborrar un dir"
    usage
elif [ ! "$filename" ] || [ ! "$operation" ]; then
    echo -e "\e[97;41mERROR\e[0m > \e[97;104m-o\e[0m and \e[97;104m-f\e[0m must be provided"
fi























