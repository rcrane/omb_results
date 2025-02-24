#!/bin/bash

set +e
set +x 

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

while true
do
    read -r -p 'Do you want to continue? ' choice
    case "$choice" in
      n|N) exit;;
      y|Y) break;;
      *) echo 'Please type y or n';;
    esac
done

set -x
set -e 



# kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml 

helm install zookeeper-operator pravega/zookeeper-operator  --namespace neardata2
sleep 20
helm install zookeeper pravega/zookeeper  --namespace neardata2
sleep 20
kubectl apply -f ./../bookkeeper-cert.yaml

helm install bookkeeper-operator pravega/bookkeeper-operator --set webhookCert.certName=selfsigned-cert-bk --set webhookCert.secretName=selfsigned-cert-tls-bk -n neardata2 --replace
sleep 20

kubectl get pods -n neardata2
while true
do
    read -r -p 'Do you want to continue? ' choice
    case "$choice" in
      n|N) exit;;
      y|Y) break;;
      *) echo 'Please type y or n';;
    esac
done




helm install bookkeeper pravega/bookkeeper -n neardata2 --replace
sleep 20
kubectl get pods -n neardata2
while true
do
    read -r -p 'Do you want to continue? ' choice
    case "$choice" in
      n|N) exit;;
      y|Y) break;;
      *) echo 'Please type y or n';;
    esac
done


helm repo add stable https://charts.helm.sh/stable
sleep 20
helm install stable/nfs-server-provisioner --generate-name -n neardata2 --replace
sleep 20
kubectl apply -f ./../tier2_pvc.yaml
sleep 20
kubectl apply -f ./../pravega-op-cert.yaml
sleep 20
HELM_DISABLE_REPOSITORY_CACHE=true helm install pravega-operator pravega/pravega-operator --set webhookCert.certName=selfsigned-cert --set webhookCert.secretName=selfsigned-cert-tls -n neardata2 --replace
sleep 20
HELM_DISABLE_REPOSITORY_CACHE=true helm install pravega pravega/pravega -f ./pravega/values.yaml -n neardata2 --replace
#sleep 20


POD=$(kubectl get pods -A | grep pravega-controller | awk '''{print $2}''')
#kubectl port-forward $POD -n neardata2 9090


