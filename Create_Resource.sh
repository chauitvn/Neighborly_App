# Declare the variables
uniqueId=20230918
resourceGroupName="neighbors_${uniqueId}_rg"
location='eastus'
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
storageAccountName="neighbors${uniqueId}stoacc"
# can you explain the function app name?
# The function app name must be unique in the history of Azure.
# The function app name must be between 2 and 60 characters in length.
# The function app name can contain only letters, numbers, and hyphens.
functionAppName="neighbors-${uniqueId}-func-app"

# Cosmos account name
# The name must contain only lowercase letters, numbers, and hyphens.
cosmosDbName="neighbors-${uniqueId}-cosmos-db"

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a storage account
az storage account create --name $storageAccountName --location $location --resource-group $resourceGroupName --sku Standard_LRS

# Create a Cosmos DB account for MongoDB API
az cosmosdb create --name $cosmosDbName --resource-group $resourceGroupName --kind MongoDB --default-consistency-level Eventual --locations regionName=$location isZoneRedundant=False

# Create a MongoDB API database
az cosmosdb mongodb database create --account-name $cosmosDbName --name "neighborly-db"

# Create a function app
az functionapp create --resource-group $resourceGroupName --name $functionAppName --storage-account $storageAccountName \
    --consumption-plan-location $location --runtime python --runtime-version 3.9 --os-type linux

# Create a web app
az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name <app-name> --deployment-local-git