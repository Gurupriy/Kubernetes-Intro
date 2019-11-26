#!/bin/bash

# Import the demo variables
source demo_variables.sh

echo ""
echo "### Scaling Demo Up to 20 replicas"
echo ""
echo ""
echo "### Executing: kubectl -n clmel scale --replicas=20 deployment/"$my_deployment_name
echo ""
kubectl -n $my_namespace scale --replicas=20 deployment/$my_deployment_name

echo ""
echo ""
echo "### Executing: kubectl get pods -n" $my_namespace
echo ""
kubectl get pods -n $my_namespace

echo ""
echo ""
echo "### Executing: kubectl get deployments -n" $my_namespace
echo ""
kubectl get deployments -n $my_namespace

echo ""
echo ""
