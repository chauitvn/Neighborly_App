uniqueId=20230918
resourceGroupName="neighbors_${uniqueId}_rg"
functionAppName="neighbors-${uniqueId}-func-app"

# login to Azure
az login

# Navigate to the function app directory
cd NeighborlyAPI/

# Deploy the function app to Azure
func azure functionapp publish $functionAppName --python