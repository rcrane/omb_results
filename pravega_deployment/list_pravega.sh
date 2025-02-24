#!/bin/bash

set +e
set +x 

echo "Clusterroles"
kubectl get clusterroles | egrep "pravega|zookeeper|bookkeeper"
echo "Roles"
kubectl get roles -n neardata2
echo "Clusterrolebinding"
kubectl get clusterrolebinding | egrep "pravega|zookeeper|bookkeeper"
echo "CRDs"
kubectl get crd | grep "pravega"
echo "mutatingwebhookconfigurations"
kubectl get mutatingwebhookconfigurations
echo "validatingwebhookconfigurations"
kubectl get validatingwebhookconfigurations
echo "Secrets"
kubectl get secrets -n neardata2
echo "Deployments"
kubectl get deployments -n neardata2
echo "Replicasets"
kubectl get replicasets -n neardata2
echo "Statefulsets"
kubectl get statefulsets -n neardata2
echo "Daemonsets"
kubectl get daemonsets -n neardata2
echo "Jobs"
kubectl get jobs -n neardata2
echo "Cronjobs"
kubectl get cronjobs -n neardata2
echo "Pods"
kubectl get pods -n neardata2
echo "Helm list"
helm list -n neardata2
echo "bookkeeper-operator"
helm history bookkeeper-operator -n neardata2
echo "bookkeeper"
helm history bookkeeper -n neardata2
echo "pravega-operator"
helm history pravega-operator -n neardata2
echo "pravega"
helm history pravega -n neardata2


