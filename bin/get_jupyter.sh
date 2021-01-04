#!/bin/bash

JUPYTER_POD=$(kubectl get pods -n project | grep "^pyspark-notebook" | cut -d ' ' -f 1)
NAMESPACE=project

echo "[*] Install packages ... "
while [ 1 ] 
do 
	if [ $(kubectl get pods -n project | grep "^pyspark-notebook" | cut -d ' ' -f 9) == "Running" ]; then
		kubectl cp  ./big_data.ipynb $NAMESPACE/$JUPYTER_POD:/jupyter/big_data.ipynb 
		kubectl port-forward -n $NAMESPACE $JUPYTER_POD 8888:8888 & 
		kubectl exec -n $NAMESPACE $JUPYTER_POD -- jupyter notebook list
		break 
	fi
done
