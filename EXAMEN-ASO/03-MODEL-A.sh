#!/bin/bash
clear
#03-MODEL-A.sh
##Qualifica 4/10 punts
# Aquest script crea (-c), canvia el nom (-m) o esborra directoris(-r), *només directoris*.
# L'has de fer amb getops i case, i has de verificar que els arguments que es passen 
# *són directoris* i tenim *els permisos* necessaris per dur a terme l'operació
# Ha de reconèixer que l'opció passada es correcta, i també si falten els paràmetres.

#----------------EXEMPLES D'EXECUCIÓ----------------------
#$ ./03-MODEL-A.sh 
#Has despecificar una opció per crear, canviar de nom o esborrar un dir
#Usage: ./04-MODEL-A.sh [-c <dir>] [-m '<dir1> <dir2>'] [-r <dir>]
#---------------------------------------------------
#$ ./03-MODEL-A.sh -x
#ERROR: Invalid option -x
#Usage: ./04-MODEL-A.sh [-c <dir>] [-m '<dir1> <dir2>'] [-r <dir>]
#---------------------------------------------------
#$ ./03-MODEL-A.sh -c
#ERROR: Option -c requires an argument
#Usage: ./04-MODEL-A.sh [-c <dir>] [-m '<dir1> <dir2>'] [-r <dir>]
#---------------------------------------------------
#$ ./03-MODEL-A.sh -m dsdf hola
#Aquest directori no existeix
#---------------------------------------------------
#COMENTA EL TEU CODI PERQUÈ T'AJUDARÀ A ENTENDRE'L MILLOR!!!
usage() {
    echo "Usage: ./04-MODEL-A.sh [-c <dir>] [-m '<dir1> <dir2>'] [-r <dir>]"
}
changename() {
    mv $1 $2
}

file2=$3
while getopts ":c:m:r:" opt; do
    case "${opt}" in
    c)
        file=$OPTARG
        ls
        sleep 1
        echo -e "\n"
        mkdir $file
        ls
        ;;
    m) 
        file=$OPTARG
        if [[ -d $file ]]
        then
            echo "El directorio existe"
            changename $file $file2
        else
            echo "ERROR: Este directorio no existe"
        fi
        ;;
    r)
        file=$OPTARG
        if [[ -d $file ]]
        then
            echo "El directorio existe... "
            echo "Borrando directorio... "
            ls
            sleep 1
            rmdir $file
            echo -e "\n"
            ls
        else
            echo "ERROR: Este directorio no existe"
        fi
        ;;
    :)
        echo "ERROR: opcion $OPTARG requiere un argumento"
        usage
        ;;
    \?) 
        echo "ERROR: la opcion $OPTARG no es valida"
        usage
        ;;
    esac
done

if ((OPTIND == 1)) #si esto se cumple quiere decir que no se ha psado ninguna opcion
then
    echo "ERROR: Has despecificar una opció per crear, canviar de nom o esborrar un dir"
    usage
fi








