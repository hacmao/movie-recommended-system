#!/bin/bash


while [[ $(kubectl get pods -n project -o jsonpath='{.items[?(@.metadata.name == "hdfs-hadoop-hdfs-dn-0")].status.containerStatuses[0].ready}') != "true" ]];
do sleep 1;
done

echo "[*] COPY compress data to hdfs ..."
kubectl cp ./ml-100k.tar.xz project/hdfs-hadoop-hdfs-nn-0:/tmp

echo "[*] EXTRACT data ..."
kubectl -n project exec hdfs-hadoop-hdfs-nn-0 -- tar -xvf /tmp/ml-100k.tar.xz


echo "[*] PUT data to hdfs ..."
kubectl -n project exec hdfs-hadoop-hdfs-nn-0 -- hdfs dfs -put ml-100k /ml-100k

