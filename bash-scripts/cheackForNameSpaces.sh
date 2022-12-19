#! /bin/bash

namespaces=$(kubectl get namespaces)


if [[ $namespaces = *dev* ]]
then

echo "Dev  exist "

else
echo  " create namespace Dev deployment "
kubectl create namespace  Dev

fi 


if [[ $namespaces = *prod* ]]
then

echo "Prod exist "

else 
echo  " create namespace Prod "
kubectl create namespace  Prod

fi 
