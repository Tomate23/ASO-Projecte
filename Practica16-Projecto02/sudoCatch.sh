#!/bin/bash
clear

while true
do
  read -p " " login
  IFS=" "
  read -a strarr <<< "$login"
  command=${strarr[0]}
  userName=${strarr[1]}
  echo $command
  echo $userName
  echo "${strarr[@]}"
done