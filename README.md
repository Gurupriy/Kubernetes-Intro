# Introduction to Kubernetes [BRKDCT-1710]

## Cisco Live Melbourne 2019 Session

**By Michael Petrinovic (mipetrin@cisco.com)**

Please let me know if you find any issues or have any questions.


## Pre-requisites:
* Python environment (for the Python script for automatic testing of your environment), running at minimum 2.7, with these packages; requests, argparse, tabulate
* Docker running on your localhost for local testing, otherwise please tailor the Docker steps to your environment setup
* Kubernetes cluster, with at least 1 Master Node and 1 Worker Node, in addition to having a CNI Plugin installed to provide network connectivity

## Directory Structure:

```
.
├── Docker_Localhost
│   └── local_docker_demo.sh
├── Hello_Web_App
│   ├── Dockerfile
│   ├── hello.py
│   └── requirements.txt
├── Images
│   ├── Browser_K8s.png
│   └── Browser_Localhost.png
├── K8s_Node
│   ├── 0_demo_check_environment.sh
│   ├── 1_demo_setup.sh
│   ├── 2_demo_scale_up.sh
│   ├── 3_demo_scale_down.sh
│   ├── 4_demo_destroy.sh
│   └── Cisco_Live_Demo.yaml
├── LICENSE
├── README.md
└── Tests
    ├── 1_test_docker_container_demo.sh
    ├── 2_test_k8s_container_demo.sh
    └── test_container_demo.py

5 directories, 17 files
```

* Docker_Localhost = Script to run local instance of the Docker Container Image
* Hello_Web_App = Simple Flask Web Application
* Images = Screenshots for this README
* K8s_Node = Files to copy over to your Kubernetes cluster to execute
* Tests = Python scripts to test the demo and environment


## Customizing Web App (optional)

Files supplied:
* Dockerfile
* hello.py
* requirements.txt

Feel free to modify the hello.py Flask Web Application. However, depending on the changes you make, the "test_container_demo.py" script may not work for automated testing/validation

Additionally, you will then need to build a copy of the container with your version of the "hello.py" Web App. You can achieve that on your development environment with Docker installed, by executing:

```
MIPETRIN-M-R4JL:Hello_Web_App mipetrin$ docker build . -t mipetrin/hello
```

This will then build a new container based of the Dockerfile in the current directory and tag it "mipetrin/hello". Feel free to change this name tag.

You should then, using your Docker Hub account, look to push this to your repo, again using your specific name tag. **This is important**, so that when you do the Kubernetes configuration, each node has a central repo where it can download your specific container image from.

```
MIPETRIN-M-R4JL:Hello_Web_App mipetrin$ docker push mipetrin/hello:latest
The push refers to repository [docker.io/mipetrin/hello]
b55fc872d60e: Pushed 
ea6790703a90: Pushed 
0921e65d8d9e: Pushed 
f6c31eefbe9f: Pushed 
70bee118a4bd: Pushed 
d44ff7a4fe91: Mounted from library/python 
f0471e0a730a: Mounted from library/python 
9b544a6417e1: Mounted from library/python 
21c09f8186d9: Mounted from library/python 
56a89222b908: Mounted from library/python 
a89464ad2a8f: Mounted from library/python 
76dfa41f0a1d: Mounted from library/python 
c240c542ed55: Mounted from library/python 
badfbcebf7f8: Waiting 
```


## Running the Web App (locally) in Docker

You can either run my container that is available on DockerHub (https://hub.docker.com/r/mipetrin/hello), or using the name tag that you provided in the above "docker build" command. Then execute "docker run" to have the instance created. Alternatively, make use of "./local_docker_demo.sh" on your local machine, ensuring it has execute permissions (ie. "chmod +x local_docker_demo.sh")

```
MIPETRIN-M-R4JL:Docker_Localhost mipetrin$ docker run -p5000:5000 mipetrin/hello
 * Serving Flask app "hello" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

This will also redirect the host port 5000 to the container port 5000, as that is what the Flask Web App (hello.py) is configured to do so

You can then validate it is running with the "docker ps" command:

```
MIPETRIN-M-R4JL:Docker_Localhost mipetrin$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                    NAMES
e1ae3f89fe30        mipetrin/hello      "/app/hello.py"     About a minute ago   Up 59 seconds       0.0.0.0:5000->5000/tcp   wizardly_liskov
MIPETRIN-M-R4JL:Docker_Localhost mipetrin$
```


## Kubernetes (K8s)

Copy the following files over to your Kubernetes master, to make things easier. Ensure that all 5 bash scripts (numbered 0-4) have Execute permissions (ie. "chmod +x 0_demo_check_environment.sh", etc)

These files help to bring up the test environment, based off the "Cisco_Live_Demo.yaml" configuration (which you can modify to meet your needs. Furthermore, if you are using a customer container image that you built and pushed to DockerHub, be sure to change in this YAML file)

Files supplied:
* 0_demo_check_environment.sh  # Show that nothing is configured from this demo
* 1_demo_setup.sh  # Setup the specifics for this demo, as per Cisco_Live_Demo.yaml
* 2_demo_scale_up.sh  # Scale up the container instances to 20
* 3_demo_scale_down.sh  # Scale down the container instances to 1
* 4_demo_destroy.sh  # Remove the namespace, K8s virtual cluster and destroy all running instances of your container image
* Cisco_Live_Demo.yaml  # Specific demo configuration that setups up the; Namespace, Pod Deployment, NodePort Service

### Execution

0. Check the current environment

Useful to highlight that potentially only have the default elements running, such as in a fresh install of Kubernetes

```
root@k8s-master:/home/cisco/K8s# ./0_demo_check_environment.sh

### Checking Demo Environment


### Executing: kubectl get namespace

NAME          STATUS   AGE
default       Active   3d22h
kube-public   Active   3d22h
kube-system   Active   3d22h


### Executing: kubectl get pods -n clmel

No resources found.


root@k8s-master:/home/cisco/K8s#
```

1. Setup the Demo environment

This will utilize the Cisco_Live_Demo.yaml configuration file

```
root@k8s-master:/home/cisco/K8s# ./1_demo_setup.sh

### Setting up Cisco Live Demo App on K8s Cluster per Cisco_Live_Demo.yaml file


### Executing: kubectl apply -f Cisco_Live_Demo.yaml

namespace/clmel created
deployment.apps/cisco-live-demo-deployment created
service/cisco-live-demo-deployment-service created


### Executing: kubectl get namespace

NAME          STATUS   AGE
clmel         Active   1s
default       Active   3d22h
kube-public   Active   3d22h
kube-system   Active   3d22h


### Executing: kubectl get deployments -n clmel

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
cisco-live-demo-deployment   0/3     3            0           1s


### Executing: kubectl get pods -n clmel

NAME                                          READY   STATUS              RESTARTS   AGE
cisco-live-demo-deployment-558bfc87fb-kxphq   0/1     ContainerCreating   0          0s
cisco-live-demo-deployment-558bfc87fb-lv7ch   0/1     ContainerCreating   0          0s
cisco-live-demo-deployment-558bfc87fb-whcnw   0/1     ContainerCreating   0          1s


### Executing: kubectl get svc -n clmel

NAME                                 TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
cisco-live-demo-deployment-service   NodePort   10.105.4.47   <none>        5000:32269/TCP   1s


root@k8s-master:/home/cisco/K8s#
```

It is important to take note of the 5000:32269, as this means that the NodePort of 32269 is being redirected to the container image port of 5000. This 32269 is necessary if we want to connect to the Web App via our Web Browser or Python Script.

After a few seconds, we should then see that all containers/Pods are up and running in our deployment:

```
root@k8s-master:/home/cisco/K8s# kubectl get deployments -n clmel
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
cisco-live-demo-deployment   3/3     3            3           43s
root@k8s-master:/home/cisco/K8s#
root@k8s-master:/home/cisco/K8s# kubectl get pods -n clmel
NAME                                          READY   STATUS    RESTARTS   AGE
cisco-live-demo-deployment-558bfc87fb-kxphq   1/1     Running   0          55s
cisco-live-demo-deployment-558bfc87fb-lv7ch   1/1     Running   0          55s
cisco-live-demo-deployment-558bfc87fb-whcnw   1/1     Running   0          56s
root@k8s-master:/home/cisco/K8s#
```


2. Scale up

We can simply and easily scale our deployment from 3 pods up to 20, with a single command

```
root@k8s-master:/home/cisco/K8s# ./2_demo_scale_up.sh

### Scaling Demo Up to 20 replicas


### Executing: kubectl -n clmel scale --replicas=20 deployment/cisco-live-demo-deployment

deployment.extensions/cisco-live-demo-deployment scaled


### Executing: kubectl get pods -n clmel

NAME                                          READY   STATUS              RESTARTS   AGE
cisco-live-demo-deployment-558bfc87fb-2nk6x   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-4tpl6   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-6pz9d   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-7dvhm   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-8rtt8   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-c7hjj   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-cjx2m   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-cwd28   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-dxzkz   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-jq7s9   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-jsxvt   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-kxphq   1/1     Running             0          117s
cisco-live-demo-deployment-558bfc87fb-lv7ch   1/1     Running             0          117s
cisco-live-demo-deployment-558bfc87fb-ptpb4   0/1     ContainerCreating   0          0s
cisco-live-demo-deployment-558bfc87fb-sd67t   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-sjkbg   0/1     Pending             0          0s
cisco-live-demo-deployment-558bfc87fb-whcnw   1/1     Running             0          118s
cisco-live-demo-deployment-558bfc87fb-wkqz7   0/1     ContainerCreating   0          0s


### Executing: kubectl get deployments -n clmel

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
cisco-live-demo-deployment   3/20    3            3           118s


root@k8s-master:/home/cisco/K8s#
```

Eventually all 20 pod instances should be up and running:

```
root@k8s-master:/home/cisco/K8s# kubectl get deployments -n clmel
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
cisco-live-demo-deployment   20/20   20           20          2m36s
root@k8s-master:/home/cisco/K8s#
```

3. Scale down

Likewise, we can just as easily scale our deployment down to 1

```
root@k8s-master:/home/cisco/K8s# ./3_demo_scale_down.sh

### Scaling Demo Down to 1 replica


### Executing: kubectl -n clmel scale --replicas=1 deployment/cisco-live-demo-deployment

deployment.extensions/cisco-live-demo-deployment scaled


### Executing: kubectl get pods -n clmel

NAME                                          READY   STATUS        RESTARTS   AGE
cisco-live-demo-deployment-558bfc87fb-2nk6x   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-4tpl6   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-6pz9d   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-7dvhm   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-8rtt8   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-c7hjj   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-cjx2m   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-cwd28   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-dxzkz   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-jq7s9   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-jsxvt   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-kxphq   1/1     Terminating   0          3m13s
cisco-live-demo-deployment-558bfc87fb-lv7ch   1/1     Terminating   0          3m13s
cisco-live-demo-deployment-558bfc87fb-ptpb4   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-sd67t   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-sjkbg   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-vh2nf   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-whcnw   1/1     Running       0          3m14s
cisco-live-demo-deployment-558bfc87fb-wkqz7   1/1     Terminating   0          76s
cisco-live-demo-deployment-558bfc87fb-zlrz2   1/1     Terminating   0          76s


### Executing: kubectl get deployments -n clmel

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
cisco-live-demo-deployment   1/1     1            1           3m14s


root@k8s-master:/home/cisco/K8s#
```

4. Cleaning up

Once we are finished, we can execute the following in order to remove our namespace, pod deployment, and node port service

```
root@k8s-master:/home/cisco/K8s# ./4_demo_destroy.sh

### Destroying Demo


### Executing: kubectl delete namespace clmel

namespace "clmel" deleted


### Executing: kubectl get namespace

NAME          STATUS   AGE
default       Active   3d22h
kube-public   Active   3d22h
kube-system   Active   3d22h


### Executing: kubectl get pods -n clmel

No resources found.


root@k8s-master:/home/cisco/K8s#
```

We now see that the "clmel" namespace no longer exists and there are no pod resources found


## Testing your instance of the App

NOTE: Melbourne is a variable, so you could specify anything in order to have it displayed on the Web page "Hello Cisco Live"

Lastly, instead of /Melbourne, can also point to /shutdown to shut the container

### Web Browser

You can point your Web Browser to 

#### Docker Example

```
http://localhost:5000/Melbourne
```

![Image of Localhost Example](https://raw.githubusercontent.com/mipetrin/Kubernetes-Intro/master/Images/Browser_Localhost.png)


#### Kubernetes Example

```
http://<master node IP>:<svc port>/Melbourne
```
NOTE: Obtain your svc node port from the output of "kubectl get svc -n clmel", which is also run as part of "1_demo_setup.sh"

![Image of Kubernetes Example](https://raw.githubusercontent.com/mipetrin/Kubernetes-Intro/master/Images/Browser_K8s.png)

### Python Script

Using the supplied Python script, you can specify either "-d localhost" or "-d k8s" to choose your instance, while also supplying the necessary port number and how many test 500 connections you wish to perform. If you get stuck, there is always the "--help" option.

NOTE: You can also make use of the "-s #" option to invoke the Flask Web App "shutdown" function, to shutdown the container. # specifies how many instances of the container image to shutdown. Obviously should be less than or equal to the amount of instances you have.

#### Docker

In this example, we see that all 500 test connections hit the single instance of the Docker container running on my local laptop. Can be crossed checked with the ouptut of 'docker ps'
```
MIPETRIN-M-R4JL:Tests mipetrin$ python test_container_demo.py -d localhost -p 5000 -c 500


  #  Container ID      Hit Count
---  --------------  -----------
  1  e1ae3f89fe30            500


================================================================================
--- Total Execution Time: 4.5770919323 seconds ---

MIPETRIN-M-R4JL:Tests mipetrin$ 
```

#### Kubernetes

As before, using the "test_container_demo.py" python script, however specifying slightly different command line arguments:
* "-d k8s" to specify your Kubernetes cluster. NOTE that you need to update the Master Node IP address within the "test_container_demo.py" file
* "-p 32269" which should match the service node port - as per output of "kubectl get svc -n clmel"
* "-c 500" to define how many test connections to make

```
MIPETRIN-M-R4JL:Tests mipetrin$ python test_container_demo.py -d k8s -p 32269 -c 500


  #  Container ID                                   Hit Count
---  -------------------------------------------  -----------
  1  cisco-live-demo-deployment-558bfc87fb-2p756           24
  2  cisco-live-demo-deployment-558bfc87fb-548xm           27
  3  cisco-live-demo-deployment-558bfc87fb-7k87z           36
  4  cisco-live-demo-deployment-558bfc87fb-82bpr           22
  5  cisco-live-demo-deployment-558bfc87fb-fgp8s           26
  6  cisco-live-demo-deployment-558bfc87fb-gj9lz           24
  7  cisco-live-demo-deployment-558bfc87fb-h2qjw           15
  8  cisco-live-demo-deployment-558bfc87fb-l652g           25
  9  cisco-live-demo-deployment-558bfc87fb-nkj2f           26
 10  cisco-live-demo-deployment-558bfc87fb-p7tbv           28
 11  cisco-live-demo-deployment-558bfc87fb-r468d           23
 12  cisco-live-demo-deployment-558bfc87fb-spjbz           26
 13  cisco-live-demo-deployment-558bfc87fb-vrjj5           24
 14  cisco-live-demo-deployment-558bfc87fb-w995j           22
 15  cisco-live-demo-deployment-558bfc87fb-w9j6n           18
 16  cisco-live-demo-deployment-558bfc87fb-wpxss           23
 17  cisco-live-demo-deployment-558bfc87fb-x24tc           22
 18  cisco-live-demo-deployment-558bfc87fb-xgrtd           17
 19  cisco-live-demo-deployment-558bfc87fb-zsf2h           40
 20  cisco-live-demo-deployment-558bfc87fb-zws8n           32


================================================================================
--- Total Execution Time: 14.3501369953 seconds ---

MIPETRIN-M-R4JL:Tests mipetrin$ 
```


### WARNING:

These scripts are meant for educational/proof of concept purposes only - as demonstrated at Cisco Live and/or my other presentations. Any use of these scripts and tools is at your own risk. There is no guarantee that they have been through thorough testing in a comparable environment and I am not responsible for any damage or data loss incurred as a result of their use
