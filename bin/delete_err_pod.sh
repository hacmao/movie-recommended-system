#!/bin/bash

./pod.sh | grep Error | cut -d ' ' -f 1 | xargs kubectl delete pod -n project

