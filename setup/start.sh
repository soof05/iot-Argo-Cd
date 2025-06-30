#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"


kubectl apply -f ../app/deployment.yaml


echo -e "${GREEN}PORT-FORWARD : kubectl port-forward svc/playground-service -n dev 8888:8080${RESET}"