#!/bin/bash

function imprimirString (){
  echo -e "\n\nA string digitada foi $1 \n\n"
}

echo -n "Qual a string que vai ser impressa?"
read _msg

imprimirString "$_msg"
