#!/bin/bash
#Maintainer Name: Mayank Singh
#Usage: bash ./go.sh
#Description: Install and build python flask app with required services on kubernetes

#set -e

# define signal handler and its variable
allowAbort=true;
myInterruptHandler()
{
    if $allowAbort; then
        exit 1;
    fi;
}

# register signal handler
#trap myInterruptHandler SIGINT;


# keep track of the last executed command
#trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
#trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

#source env variables to build image
source .env

#checking if SERVER_PORT ENV variable exist
[[ -z "$SERVE_PORT" ]] && echo "SERVE_PORT env variable is not defined exiting" && exit

#Building docker image 
sudo docker build -t sample-app:$version --build-arg BUILD_SERVE_PORT=$SERVE_PORT --build-arg BUILD_MONGO_URI=$MONGO_URI --build-arg BUILD_FLASK_ENV=$FLASK_ENV .

minikube addons enable ingress

#Creating app serverice, ingress, mongo replication controller, mongodb and sample-app application
sudo kubectl create -f minikube/flask-service.yml
sudo kubectl create -f minikube/ingress.yml
sudo kubectl create -f minikube/mongo-controller.yml
sudo kubectl create -f minikube/mongo-service.yml
envsubst < minikube/sample-app.yml | sudo kubectl apply -f -

#Run test cases sleep fot 5 sec so that pod can start
sleep 5
POD=$(kubectl get pod -l app=sample-app -o jsonpath="{.items[0].metadata.name}")
sudo kubectl exec -it $POD python test.py
