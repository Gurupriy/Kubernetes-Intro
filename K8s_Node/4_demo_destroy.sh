#!/bin/bash

echo ""
echo "### Destroying Demo"
echo ""
echo ""
echo "### Executing: kubectl delete namespace clmel"
echo ""
kubectl delete namespace clmel

echo ""
echo ""
echo "### Executing: kubectl get namespace"
echo ""
kubectl get namespace

echo ""
echo ""
echo "### Executing: kubectl get pods -n clmel"
echo ""
kubectl get pods -n clmel

echo ""
echo ""