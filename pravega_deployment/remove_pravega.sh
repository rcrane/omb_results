#!/bin/bash

set +e
set +x 

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
if [ -z $PRPOD ]; then
	kubectl delete pod $PRPOD --wait -n neardata2
	if [ $? -eq 0 ]; then
	    sleep 30
	fi
fi

kubectl delete secrets sh.helm.release.v1.pravega-operator.v1 -n neardata2
if [ $? -eq 0 ]; then
    sleep 30
fi

NFSPOD=$(kubectl get pods -n neardata2 | grep nfs-server-provisioner | awk '''{print $1}''')
if [ -z $NFSPOD ]; then
	helm uninstall $NFSDOD -n neardata2
	if [ $? -eq 0 ]; then
	    sleep 10
	fi
fi

kubectl delete pod $NFSPOD --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

kubectl delete pvc pravega-tier2 --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

helm uninstall bookkeeper pravega/bookkeeper --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

helm uninstall bookkeeper-operator pravega/bookkeeper-operator --wait -n neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

kubectl delete secret sh.helm.release.v1.bookkeeper-operator.v1 -n neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

helm uninstall zookeeper pravega/zookeeper --wait --namespace neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

helm uninstall zookeeper-operator pravega/zookeeper-operator --wait --namespace neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi


kubectl delete deployment bookkeeper-operator --wait --namespace neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

kubectl delete deployment zookeeper-operator --wait --namespace neardata2
if [ $? -eq 0 ]; then
    sleep 10
fi

kubectl delete service bookkeeper-webhook-svc -n neardata2
kubectl delete service pravega-webhook-svc -n neardata2 

kubectl delete secrets cert-manager-webhook-ca -n neardata2
kubectl delete secrets selfsigned-cert-tls -n neardata2
kubectl delete secrets selfsigned-cert-tls-bk -n neardata2
kubectl delete secrets sh.helm.release.v1.bookkeeper-operator.v1 -n neardata2
kubectl delete secrets sh.helm.release.v1.bookkeeper.v1 -n neardata2
kubectl delete secrets sh.helm.release.v1.zookeeper-operator.v1 -n neardata2
kubectl delete secrets sh.helm.release.v1.zookeeper.v1 -n neardata2

kubectl delete role bookkeeper-operator -n neardata2
kubectl delete role pravega-operator -n neardata2
kubectl delete role pravega-operator-post-install-upgrade -n neardata2
kubectl delete role pravega-post-install-upgrade-rollback -n neardata2
kubectl delete role zookeeper-post-install-upgrade -n neardata2
kubectl delete role zookeeper-operator -n neardata2

kubectl delete clusterrole bookkeeper-operator
kubectl delete clusterrole bookkeeper-operator-pre-delete
kubectl delete clusterrole pravega-operator
kubectl delete clusterrole pravega-operator-pre-delete
kubectl delete clusterrole zookeeper-operator
kubectl delete clusterrole zookeeper-pre-delete
kubectl delete clusterrole zookeeper-operator-pre-delete

kubectl delete clusterrolebinding bookkeeper-operator              
kubectl delete clusterrolebinding bookkeeper-operator-pre-delete                               
kubectl delete clusterrolebinding pravega-operator                                   
kubectl delete clusterrolebinding pravega-operator-pre-delete 
kubectl delete clusterrolebinding zookeeper-operator 
kubectl delete clusterrolebinding zookeeper-pre-delete
kubectl delete clusterrolebinding zookeeper-operator-pre-delete

kubectl delete mutatingwebhookconfiguration cert-manager-webhook                 

kubectl delete validatingwebhookconfiguration bookkeeper-webhook-config 
kubectl delete validatingwebhookconfiguration cert-manager-webhook                   
kubectl delete validatingwebhookconfiguration pravega-webhook-config                           

kubectl patch crd pravegaclusters.pravega.pravega.io -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl patch crd bookkeeperclusters.bookkeeper.pravega.io -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl patch crd zookeeperclusters.zookeeper.pravega.io -p '{"metadata":{"finalizers":[]}}' --type=merge

kubectl delete crd bookkeeperclusters.bookkeeper.pravega.io -n neardata2
kubectl delete crd zookeeperclusters.zookeeper.pravega.io -n neardata2
kubectl delete crd pravegaclusters.pravega.pravega.io -n neardata2

kubectl delete pvc -l app=zookeeper -n neardata2



