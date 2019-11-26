#!/bin/bash

# Import the demo variables
source demo_variables.sh

echo ""
echo "### Destroying Demo"
echo ""
echo ""
echo "### Executing: kubectl delete namespace" $my_namespace
echo ""
kubectl delete namespace $my_namespace

echo ""
echo ""
echo "### Executing: kubectl get namespace"
echo ""
kubectl get namespace

echo ""
echo ""
echo "### Executing: kubectl get pods -n" $my_namespace
echo ""
kubectl get pods -n $my_namespace

echo ""
echo ""
