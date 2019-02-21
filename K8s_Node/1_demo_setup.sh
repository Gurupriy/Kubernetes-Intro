#!/bin/bash

echo ""
echo "### Setting up Cisco Live Demo App on K8s Cluster per Cisco_Live_Demo.yaml file"
echo ""
echo ""
echo "### Executing: kubectl apply -f Cisco_Live_Demo.yaml"
echo ""
kubectl apply -f Cisco_Live_Demo.yaml

echo ""
echo ""
echo "### Executing: kubectl get namespace"
echo ""
kubectl get namespace

echo ""
echo ""
echo "### Executing: kubectl get deployments -n clmel"
echo ""
kubectl get deployments -n clmel

echo ""
echo ""
echo "### Executing: kubectl get pods -n clmel"
echo ""
kubectl get pods -n clmel

echo ""
echo ""
echo "### Executing: kubectl get svc -n clmel"
echo ""
kubectl get svc -n clmel

echo ""
echo ""