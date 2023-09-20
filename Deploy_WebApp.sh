uniqueId=20230918
resourceGroupName="neighbors_${uniqueId}_rg"
webAppName="neighbors-${uniqueId}-web-app"
myAppServicePlan="neighbors-${uniqueId}-app-service-plan"

# navigate to the web app directory
cd NeighborlyFrontEnd/

# Deploy the web app to Azure
az webapp up --name $webAppName --resource-group $resourceGroupName --plan $myAppServicePlan



