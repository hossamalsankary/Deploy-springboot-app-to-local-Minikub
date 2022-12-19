#! /bin/bash

namespaces=$(kubectl get namespaces)


if [[ $namespaces = *Dev* ]]
then

echo "Dev  exist "

else
echo  " create namespace Dev deployment "
kubectl create namespace  Dev

fi 


if [[ $namespaces = *Prod* ]]
then

echo "Prod exist "

else 
echo  " create namespace Prod "
kubectl create namespace  Prod

fi 
