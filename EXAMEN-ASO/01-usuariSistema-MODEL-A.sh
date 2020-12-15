#!/bin/bash
#01-usuariSistema-MODEL-A.sh
#Qualifica 2/10 punts
#Mostra per pantalla si un usuari passat per paràmetre
#existeix, i a més mostra el seu uid, sortint amb 0. 
#Si el cridem amb un num de paràmetres 
#incorrecte, o bé no es troba
#l'usuari mostra 'Usuari no existent' i surt amb 1. Cap altre 
#missatge d'error ha de ser mostrat per pantalla.
#----------------EXEMPLES D'EXECUCIÓ----------------------
#$ ./01-usuariSistema-MODEL-A.sh ausias
#Usuari existent i el seu uid es 1000
#$ echo $?
#0
#---------------------------------------------
#$ ./01-usuariSistema-MODEL-A.sh
#Ha de tenir nomes un parametre amb el nom de l'usuari
#$ echo $?
#1
#---------------------------------------------
#$ ./01-usuariSistema-MODEL-A.sh asdfa
#Usuari no existent
#$ echo $?
#1
#--------------
#COMENTA EL TEU CODI PERQUÈ T'AJUDARÀ A ENTENDRE'L MILLOR!!!
#--------------

# Funcion para comprobar el id del usuario
userid() {
    echo "El id del usuario es > $(id -u $1)"
}
#Comprovamos que el usuario existe
userExist() {
    user_id=$(id -u $1)
    if [ $user_id ]>> /dev/null 2>&1
    then
        echo "Este usuario existe > $1"
        userid $1
        exit 0
    else
        echo "ERROR: Este usuario no existe > $1"
        exit 1
    fi
}

# Comprobamos que el usuario ha especificado el nombre de un usuario
if [[ $# = 1 ]]
then
    userExist $1
else
    echo "ERROR: Escribe un usuario para comprobar!"
    exit 1
fi










