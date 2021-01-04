#!/bin/bash

helm install -n project hdfs \
	--set yarn.nodeManager.resources.requests.cpu=500m stable/hadoop
	
