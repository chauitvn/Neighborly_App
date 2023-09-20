uniqueId=20230918
resourceGroupName="neighbors_${uniqueId}_rg"
webAppName="neighbors-${uniqueId}-web-app"
myAppServicePlan="neighbors-${uniqueId}-app-service-plan"

# Create the App Service plan in FREE tier and with a Linux container
az appservice plan create --name $myAppServicePlan --resource-group $resourceGroupName --is-linux --sku FREE --location eastus 

# Create a web app
az webapp create --resource-group $resourceGroupName --plan $myAppServicePlan --name $webAppName --runtime "PYTHON|3.9"