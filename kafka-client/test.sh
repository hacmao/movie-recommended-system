#!/bin/bash

if ! [ -x "$(command -v minikube)" ]; then
    echo "minikube is not installed" >&2
fi
