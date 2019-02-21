#!/bin/bash

echo ""
echo "### Checking Demo Environment"
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