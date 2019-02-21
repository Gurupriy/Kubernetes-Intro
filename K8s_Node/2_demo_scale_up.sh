#!/bin/bash

echo ""
echo "### Scaling Demo Up to 20 replicas"
echo ""
echo ""
echo "### Executing: kubectl -n clmel scale --replicas=20 deployment/cisco-live-demo-deployment"
echo ""
kubectl -n clmel scale --replicas=20 deployment/cisco-live-demo-deployment

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