#!/bin/bash

#update
sudo apt update

#docker install steps  
sudo apt install -y docker.io docker-compose

# Install required packages
sudo apt-get install -y apt-transport-https ca-certificates curl

# Download the public signing key for the Kubernetes package repositories
sudo mkdir -p -m 755 /etc/apt/keyrings # Create keyrings directory if not exists
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the appropriate Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

#update and isntall kubectl
sudo apt-get update
sudo apt-get install -y kubectl
kubectl cluster-info dump


#install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

#ADD USER to the docker group
sudo chmod 666 /var/run/docker.sock
sudo addgroup --system docker
sudo adduser $USER docker

#Start Minikube
minikube start

#
kubectl cluster-info dump

echo -e "\e[1m\e[34mDone\e[0m"  # Bold and blue
echo -e "\e[1m\e[31mDeveloped by Aboelnour\e[0m"  # Bold and red
