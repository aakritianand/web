#!/bin/sh

set -e
# SP, PASSWORD , CLUSTER_NAME, CLUSTER_RESOURCE_GROUP
az configure --defaults acr=$REGISTRY_NAME

az login \
    --service-principal \
    --username $SP \
    --password $PASSWORD \
    --tenant $TENANT  > /dev/null

az aks get-credentials \
    -g $CLUSTER_RESOURCE_GROUP \
    -n $CLUSTER_NAME 

echo -- helm init  --
helm init  # > /dev/null

echo -- az acr helm repo add --
az acr helm repo add 

echo -- helm fetch $REGISTRY_NAME/importantThings --
helm fetch $REGISTRY_NAME/importantThings

echo -- helm upgrade demo42 ./helm/importantThings --
helm upgrade demo42 ./helm/importantThings 
      --reuse-values 
      --set web.image={{.Run.Registry}}/demo42/web:$RUN_ID

