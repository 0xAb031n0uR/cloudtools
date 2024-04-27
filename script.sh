#!/bin/bash

# Function to check if a package is installed
check_installed() {
    dpkg -l "$1" &> /dev/null
}

# Update apt
sudo apt update
sudo apt install -y docker.io docker-compose


# Check if apt-transport-https is installed
if ! check_installed apt-transport-https; then
    # Install required packages
    sudo apt install -y apt-transport-https ca-certificates curl
fi

# Check if kubectl is installed
if ! check_installed kubectl; then
    # Download the public signing key for the Kubernetes package repositories
    sudo mkdir -p -m 755 /etc/apt/keyrings # Create keyrings directory if not exists
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    # Add the appropriate Kubernetes apt repository
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

    # Update apt and install kubectl
    sudo apt update
    sudo apt install -y kubectl
fi

# Check if Minikube is installed
if ! command -v minikube &> /dev/null; then
    # Install Minikube
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
fi

# Check if user is in the docker group
if ! groups "$USER" | grep -q '\bdocker\b'; then
    # Add user to the docker group
    sudo chmod 666 /var/run/docker.sock
    sudo addgroup --system docker
    sudo adduser "$USER" docker
fi

# Start Docker service
sudo systemctl start docker

# Start Minikube
minikube start

# Display completion message
echo -e "\e[1m\e[34mAll tools have been installed and required services are running\e[0m"
echo -e "\e[1m\e[31mDeveloped by Aboelnour\e[0m"