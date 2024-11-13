# Advanced Kubernetes

## Introduction

In the project, I have completed the Advanced Kubernetes challenge by What the Hack. This project demonstrates the deployment of an application using helm charts on multi-node Azure Kubernetes Service (AKS). The sample pod info application is used for capstone deployments and has various APIs for additional functionalities like /healthz and /readyz for checking the application's readiness and liveliness. It utilizes Kubernetes features such as resiliency, scaling, and ingress.

## Table of Contents

- [Features](#features)
- [Project Architecture](#architecture)

## Features

- I am using stefanprodan's podinfo application to deploy using helm for this project. 

## Project Architecture


File Structure of the project:

```plaintext
.
├── advacned_k8s/
│   └── env/
│       ├── azcli.sh
│       ├── docker.sh
│       ├── helm.sh
│       ├── ingress-controller.sh
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
To use the project, you have to have an Azure account with permissions to create AKS cluster and VM.

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
