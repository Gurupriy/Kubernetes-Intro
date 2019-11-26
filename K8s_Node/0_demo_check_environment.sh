#!/bin/bash

# Import the demo variables
source demo_variables.sh

echo ""
echo "### Checking Demo Environment"
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
echo "### Executing: kubectl get nodes"
echo ""
kubectl get nodes

echo ""
echo ""
