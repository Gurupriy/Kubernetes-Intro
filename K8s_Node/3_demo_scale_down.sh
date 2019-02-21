#!/bin/bash

echo ""
echo "### Scaling Demo Down to 1 replica"
echo ""
echo ""
echo "### Executing: kubectl -n clmel scale --replicas=1 deployment/cisco-live-demo-deployment"
echo ""
kubectl -n clmel scale --replicas=1 deployment/cisco-live-demo-deployment

echo ""
echo ""
echo "### Executing: kubectl get pods -n clmel"
echo ""
kubectl get pods -n clmel

echo ""
echo ""
echo "### Executing: kubectl get deployments -n clmel"
echo ""
kubectl get deployments -n clmel

echo ""
echo ""