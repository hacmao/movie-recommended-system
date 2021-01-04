#!/bin/bash

NAMESPACE="project"
SERVICE_ACCOUNT="spark"

if ! [ -x "$(command -v kubectl)" ]; then
	echo "[*] Install kubectl ... "
	curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
fi

if ! [ -x "$(command -v minikube)" ]; then
	echo "[*] Install minikube ... " 
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64	&& chmod +x minikube
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
	sudo apt-get install -y virtualbox
fi
if ! [-x "$(command -v docker)" ]; then
	echo "[*] Install docker ..."
	sudo apt install -y docker.io
	sudo chmod 666 /var/run/docker.sock
        sudo usermod -aG docker $USER
fi

echo "[*] Start minikube ..."
minikube start --cpus 4 --memory 12288 --driver=docker

echo "[*] Change docker to minikube docker ... "
eval $(minikube docker-env)

echo "[*] Create project namespace ..."
kubectl create namespace $NAMESPACE

echo "[*] Add helm repo ... "
sudo snap install helm --classic
helm repo add stable https://charts.helm.sh/stable
helm repo add incubator https://charts.helm.sh/incubator

echo "[*] Install hadoop ... " 
./bin/helm_hdfs.sh

echo "[*] Install kafka ... "
helm install -n $NAMESPACE kafka incubator/kafka

echo "[*] Install pyspark-notebook ... "
kubectl apply -f ./notebook-pyspark/yaml_files 

echo "[*] Create python kafka client for simulate data streaming ... "
kubectl apply -n $NAMESPACE -f ./kafka-client/python-client.yaml

echo "[*] Add data to hdfs ..."
./bin/setup_namenode.sh

echo "[*] Get jupyter notebook ..."
./bin/get_jupyter.sh 

