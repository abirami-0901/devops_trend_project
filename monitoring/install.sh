#!/bin/bash
# Prometheus + Grafana (kube-prometheus-stack) on the EKS cluster
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set grafana.service.type=LoadBalancer \
  --set grafana.adminPassword='ChangeMe123!'
kubectl -n monitoring get svc monitoring-grafana
