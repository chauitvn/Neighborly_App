uniqueId=20230918
resourceGroupName="neighbors_${uniqueId}_rg"
containerRegistry="neighborscontainerregistry$uniqueId"
docker="neighborsdocker$uniqueId"
AKSCluster="neighborskubercluster$uniqueId"

# Part 1: Create a Container Registry
# 1.1 Create ACR
az acr create --resource-group $resourceGroupName --name $containerRegistry --sku Basic

# 1.2 Login to the ACR
az acr login --name $containerRegistry

# 1.2 Get the ACR login server
az acr list --resource-group $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output table

TOKEN = $(az acr login --name $containerRegistry --expose-token --query accessToken --output tsv)

# 1.3 Login to the registry
docker login $containerRegistry.azurecr.io --username 00000000-0000-0000-0000-000000000000 --password $TOKEN

# Part 2: Containerize and upload the web app
# 2.1 Create a Dockerfile
func init --docker-only --python

# 2.2 Build the image
docker build --tag $docker .

# 2.3 Test the image locally
docker run -p 7071:80 -it $docker

# stop the docker container
docker stop $(docker ps -a -q)

# 2.4 Tag your docker image for Azure Container Registry
docker images
docker tag $docker $containerRegistry.azurecr.io/$docker:v1

# 2.5 Push the image to the ACR
az acr repository list --name $containerRegistry.azurecr.io --output table

# Part 3 Create an Azure Kubernetes cluster
az aks update --resource-group $resourceGroupName --name $AKSCluster --node-count 2 --generate-ssh-keys --attach-acr $containerRegistry

# 3.1 Pull the credentials to connect to the cluster
az aks get-credentials --resource-group $resourceGroupName --name $AKSCluster

# 3.2 Verify the connection to the cluster
kubectl get nodes

# Part 4 Deploy the app to kubernetes

# 4.1 Deploy the app to kubernetes
func kubernetes deploy --name $docker --image-name $containerRegistry.azurecr.io/$docker:v1 --dry-run > deployment.yaml

kubectl apply -f deployment.yaml

# 4.2 Verify the deployment
kubectl config get-contexts

kubectl get service --watch