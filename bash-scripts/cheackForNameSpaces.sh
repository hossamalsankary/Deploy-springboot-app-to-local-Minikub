#! /bin/bash

namespaces=$(kubectl get namespaces)



if [[ $namespaces = *dev* ]]
then

echo "Dev  exist "

else
echo  " create namespace Dev deployment "
kubectl create namespace  dev

fi 


if [[ $namespaces = *prod* ]]
then

echo "Prod exist "

else 
echo  " create namespace Prod "
kubectl create namespace  prod

fi 
