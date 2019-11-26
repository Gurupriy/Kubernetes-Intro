#!/bin/bash

# Import the demo variables
source demo_variables.sh

echo ""
echo "### Setting up Demo App on K8s Cluster per file:" $my_demo_app_yaml
echo ""
echo ""
echo "### Executing: kubectl apply -f" $my_demo_app_yaml
echo ""
# Environment Variable Substitution to make use of the variables from our demo_variables.sh file before applying
envsubst < $my_demo_app_yaml | kubectl apply -f -
#kubectl apply -f $my_demo_app_yaml

echo ""
echo ""
echo "### Executing: kubectl get namespace"
echo ""
kubectl get namespace

echo ""
echo ""
echo "### Executing: kubectl get deployments -n" $my_namespace
echo ""
kubectl get deployments -n $my_namespace

echo ""
echo ""
echo "### Executing: kubectl get pods -n" $my_namespace
echo ""
kubectl get pods -n $my_namespace

echo ""
echo ""
echo "### Executing: kubectl get svc -n" $my_namespace
echo ""
kubectl get svc -n $my_namespace

echo ""
echo ""
