#!/bin/bash


sudo kubectl apply -f ../app/deployment.yaml
sudo kubectl apply -f ../argo/application.yaml


echo "PORT-FORWARD : sudo kubectl port-forward svc/playground-service -n dev 8888:8080"