#!/bin/bash

# 1. kind クラスタ作成
kind create cluster --config kind/kind-config.yaml

# 2. Ingress Controller をインストール
kubectl apply -f ingress-controller/deploy-ingress-nginx.yaml

# 3. Ingress Controller が Ready になるまで待つ
#kubectl wait --namespace ingress-nginx \
#  --for=condition=ready pod \
#  --selector=app.kubernetes.io/component=controller \
#  --timeout=90s

