#!/bin/bash

set +e
set -x 

helm uninstall pravega --wait -n neardata2

if [ $? -eq 0 ]; then
    sleep 30
fi

helm uninstall pravega-operator --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

kubectl delete deployment pravega-operator -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

PRPOD=$(kubectl get pods -n neardata2 | grep pravega-operator | awk '''{print $1}''')
kubectl delete pod $PRPOD --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

kubectl delete secrets sh.helm.release.v1.pravega-operator.v1 -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

NFSPOD=$(kubectl get pods -n neardata2 | grep nfs-server-provisioner | awk '''{print $1}''')

helm uninstall $NFSDOD -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi



kubectl delete pod $NFSPOD --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi


kubectl delete pvc pravega-tier2 --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi


helm uninstall bookkeeper pravega/bookkeeper --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

helm uninstall bookkeeper-operator pravega/bookkeeper-operator --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

helm uninstall zookeeper pravega/zookeeper --wait --namespace neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

helm uninstall zookeeper-operator pravega/zookeeper-operator --wait --namespace neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi



kubectl get pods -A

exit


set -e

helm install stable/nfs-server-provisioner --generate-name -n neardata2
sleep 20

kubectl apply -f ./../tier2_pvc.yaml
sleep 20

kubectl apply -f ./../pravega-op-cert.yaml
sleep 20

HELM_DISABLE_REPOSITORY_CACHE=true helm install pravega-operator pravega/pravega-operator --set webhookCert.certName=selfsigned-cert --set webhookCert.secretName=selfsigned-cert-tls -n neardata2
sleep 20


HELM_DISABLE_REPOSITORY_CACHE=true helm install pravega pravega/pravega -f ./pravega/values.yaml -n neardata2
sleep 20


POD=$(kubectl get pods -A | grep pravega-controller | awk '''{print $2}''')

#kubectl port-forward $POD -n neardata2 9090


