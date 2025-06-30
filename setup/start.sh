#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"


sudo kubectl apply -f ../app/deployment.yaml


echo -e "${GREEN}PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080${RESET}"