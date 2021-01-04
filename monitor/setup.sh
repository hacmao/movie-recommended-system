#!/bin/bash


# Install prometheus 
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus --create-namespace --namespace monitoring

# Install grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana \
                              --set persistence.enabled=true,persistence.type=pvc,persistence.size=10Gi \
                              --namespace=monitoring


