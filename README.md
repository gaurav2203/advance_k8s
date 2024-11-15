# Advanced Kubernetes

## Introduction

In the project, I have compeleted the Advanced Kubernetes challenge by What the Hack. Here, this project demonstrates the deployment of an application using helm charts on multi node Azure Kubernetes Service (AKS). The sample podinfo application is used for capstone deployments and has various apis for additional functionalities like /healthz, /readyz for checking readiness and liveliness of the application. It utilizes Kubernetes features such as resiliency, scaling, ingress of the application.

## Table of Contents

- [Features](#features)
- [Project Architecture](#architecture)

## Features

- For this project I am using stefanprodan's podinfo application to deploy using helm. 

## Project Architecture


Below mentioned is the file structure for the project.

```plaintext
.
├── advacned_k8s/
│   └── env/
│       ├── azcli.sh
│       ├── docker.sh
│       ├── helm.sh
│       ├── ingress-controller.sh
│       ├── istio.sh
│       └── kubectl.sh
├── README.md
└── sample-app/
    ├── Chart.yaml
    ├── templates/
    │   ├── deployment.yaml
    │   ├── _helpers.tpl
    │   ├── hpa.yml
    │   ├── ingress.yaml
    │   ├── NOTES.txt
    │   ├── serviceaccont.yaml
    │   ├── service.yaml
    │   └── tests/
    │       └── test-connection.yaml
    └── values.yaml

```
To use the project you have to have an Azure account with permissions to create AKS cluster and VM.

Create a VM of type Standard_DS2_v2 and ssh into the terminal. Follow the below steps to run all the pre-created scripts.

```bash
git clone https://github.com/gaurav2203/advanced_k8s.git
cd env
bash *.sh
```

To create and connect to the AKS cluster follow the below steps:
```bash
az aks create aks --resource-group wth \
    --name mycluster \ 
    --nodepool-name systempool \
    --node-count 1 \
    --node-vm-size Stadnard_DS2_v2 \
    --enable-cluster-autoscaler --min-count 1 \
    --max-count 3 --enable-managed-identity \
    --generate-ssh-keys

az aks get-credentials --resource-group wth \
    --cluster-name mycluster
```
To deploy our applicaiton using helm chart use the following cmd:
```bash
cd ..
helm install sample-app ./sample-app
```
This will create a deployment with 3 containers and create a LoadBalancer exposing the port 9898. It will also create an ingress for the application such that the app is accessable at ``` sample-app.$INGRESS_IP.nip.io```. And the value of ```INGRESS_IP``` can be configured via the following command.

```bash
export INGRESS_IP=$(kubectl get service -n ingress-basic nginx-ingress-ingress-nginx-controller -o json | jq '.status.loadBalancer.ingress[0].ip' -r)
```
I have also added the istio service mesh to this project. The istio service mesh provides additional tools like grafana, loki, kiali, etc to all the resources running on the cluster. To install and use istio service mesh I have included the shell script. 

To install istio service mesh to your kubernetes cluster follow these steps:
```bash
bash ./env/istio.sh
```
This script will install the istio-1.24.0 binary to the vm along with istioctl tool and additional addons like kiali, loki, grafana, prometheus, etc.

To apply the helm chart with the istio sidecar proxy server, re-run the helm chart and you will be able to see additional containers to each of the pod. This additional container is the istio proxy server for each pod.

To use the istio services we can use port-forwarding.
```bash 
kubectl get svc -n istio-system
kubectl port-forward svc/kaili 20001 20001
```
Since, all the services in the istio are ClusterIP thus we cannot normally access then. Thus we need to port-forward each of them and now you can be able to access these services. For example, I have prot-forwared the kiali svc on port 20001. You can access it on ``` 127.0.0.1:20001``` on your local machine.

For additional details, I have added the document file in the github repo with all the screenshots.
