#!/usr/bin/env bash

# Demo Setup - Variables
#
# These will be used in the various scripts, but importantly
# they will also be substituted into the Demo_App_Template.yaml that Kubernetes will apply and deployment
#

# Use the same base template
############################
export my_demo_app_yaml="Demo_App_Template.yaml"


# DC SEVT Demo
##############
export my_namespace="dc-sevt"
export my_deployment_name="dc-sevt-demo-deployment"
export my_app_label="dc-sevt-demo"
export my_container_name="dc-sevt-demo-k8s"
export my_container_image="mipetrin/hello:latest"
export my_service_name="dc-sevt-demo-deployment-service"


# Cisco Live Demo
#################
#export my_namespace="cisco-live"
#export my_deployment_name="cisco-live-demo-deployment"
#export my_app_label="cisco-live-demo"
#export my_container_name="cisco-live-demo-k8s"
#export my_container_image="mipetrin/hello:latest"
#export my_service_name="cisco-live-demo-deployment-service"

