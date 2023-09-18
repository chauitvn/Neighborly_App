uniqueId = 20230917
resourceGroup = "udacity-resourcce-group"
containerRegistry = "neighborlyappregister"
region = "East US"
AKSCluster = "neighborly_cluster"

# Create an Azure Kubernetes cluster
az aks create --name $AKSCluster --resource-group $resourceGroup --node-count 2 --generate-ssh-keys --attach-acr $containerRegistry --location $region