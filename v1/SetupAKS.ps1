# 1.
# New-AzResourceGroup -Name myResourceGroup -Location EastUS

# 2.
# Create Azure Container Registry
$registry = New-AzContainerRegistry -ResourceGroupName "dss-lab-docker" -Name "dssTestDocker" -EnableAdminUser -Sku Basic

$creds = Get-AzContainerRegistryCredential -Registry $registry

$creds.Password | docker login $registry.LoginServer -u $creds.Username --password-stdin

# 3. Tag and push to registry:
# docker tag <image-name> <tagged-image-name>
# docker push <tagged-image-name>

# 4. Create Service Principal with Certificate based Authentication
# NOTE: used below command not native Powershell commands because it returned the key JSON I need
az ad sp create-for-rbac --skip-assignment
# Returns below
# {
#     "appId": "b747dbdc-2a6a-4bbf-8266-9537b5a5507c",
#     "displayName": "azure-cli-2020-02-22-01-25-50",
#     "name": "http://azure-cli-2020-02-22-01-25-50",
#     "password": "63e2e698-0b89-4c1b-9d7b-2aaad9dae0cb",
#     "tenant": "9827914a-c91e-473d-958b-04e06e3be030"
#   }

# POWERSHELL ALTERNATIVE

# $sp = New-AzADServicePrincipal 
# $clientsec = [System.Net.NetworkCredential]::new("", $sp.Secret).Password
# $tenantID = (get-aztenant).Id
# $jsonresp = 
# @{client_id=$sp.ApplicationId 
#     client_secret=$clientsec
#     tenant_id=$tenantID}
# $jsonresp | ConvertTo-Json

# 5. Get ACR Resource ID and Create role so AKS cluster can access Azure Container Registry
$appID = "b747dbdc-2a6a-4bbf-8266-9537b5a5507c"
$pass = "63e2e698-0b89-4c1b-9d7b-2aaad9dae0cb"

$acrID = Get-AzContainerRegistry -ResourceGroupName 'dss-lab-docker' -Name 'dssTestDocker' | Select-Object -Property Id | Out-String -Stream | Select-String "/subscriptions"

New-AzRoleAssignment -ApplicationId $appID -Scope $acrID -RoleDefinitionName Reader

# Outputs

# RoleAssignmentId   : /subscriptions/63d1e735-daa2-4379-a057-18f5c450e62c/resourceGroups/dss-lab-docker/providers/Microsoft.ContainerRegistry/registr
#                      ies/dssTestDocker/providers/Microsoft.Authorization/roleAssignments/7829d742-b8be-4707-9d54-d5954b524bba
# Scope              : /subscriptions/63d1e735-daa2-4379-a057-18f5c450e62c/resourceGroups/dss-lab-docker/providers/Microsoft.ContainerRegistry/registr
#                      ies/dssTestDocker
# DisplayName        : azure-cli-2020-02-22-01-25-50
# SignInName         :
# RoleDefinitionName : Reader
# RoleDefinitionId   : acdd72a7-3385-48ef-bd42-f606fba81ae7
# ObjectId           : 10e0dd6c-84ce-4526-a649-adfe66365eeb
# ObjectType         : ServicePrincipal
# CanDelegate        : False

# 6. Create AKS cluster
# Needed for --enable-vmss & --enable-cluster-autoscaler
# --min-count and --max-count associated with --enable-vmss --enable-cluster-autoscaler
# ^^^ Potentially not needed when using for production. More of a Preview feature
az extension add --name aks-preview

az aks create --resource-group 'dss-lab-docker' --name 'craftercmsDemoCluster' --node-count 1 --max-pods 30 --kubernetes-version 1.14.8 --location eastus --generate-ssh-keys --enable-vmss --enable-cluster-autoscaler --min-count 1 --max-count 3 --service-principal b747dbdc-2a6a-4bbf-8266-9537b5a5507c --client-secret 63e2e698-0b89-4c1b-9d7b-2aaad9dae0cb

# 7. Get AKS credentials
Import-AzAksCredential -ResourceGroupName 'dss-lab-docker' -Name 'craftercmsDemoCluster' -Admin

# test with `kubectl get nodes` and should see something partaining to Azure
# Worker Sizing
# --node-os-disk-size = Minimun 30GB size of OS disk per node in nodepool
# --node-vm-size = Size of VM to create as Kubernetes nodes. Default: Standard_DS2_v2
# ^^^ > Get-AzVMSize

# 8. Get Azure Container registry Credentials
Get-AzContainerRegistryCredential -ResourceGroupName 'dss-lab-docker' 

# HARD PART
# GOAL: To use CrafterCMS provided docker compose files to deploy demo version of CrafterCMS Docker Images
# UPDATE: Found Kubernetes Deployment files for CrafterCMS
# Following these instructions 
# https://docs.craftercms.org/en/3.1/system-administrators/activities/kubernetes/simple-kubernetes-deployment.html

# 9.
# - Replaced image names in kubernetes files with ACR tagged ":demo" images to build CrafterCMS Authoring and Delivery

# 10. Launch deployment with:
# kubectl apply -f .\deployment-files

# 11. Setup Load Balancing with Ingress
# Add on Ingress Controller and DNS service

az aks enable-addons --resource-group 'dss-lab-docker' --name 'craftercmsDemoCluster' --addons http_application_routing 1> .\ingress-setup.json
# ^^^ Spits out file `.\ingress-setup.json

# Check to see what root of application DNS will be
az aks show --resource-group 'dss-lab-docker' --name 'craftercmsDemoCluster' --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table
#  ^^^ Shows generated base URL route

# 12. Setup Application Gateway

New-AzApplicationGateway -Name 'crafterdemoGate' -ResourceGroupName 'MC_dss-lab-docker_craftercmsDemoCluster_eastus' -Location 'East US'

# 13. Create Service Pricipal

$sp = New-AzADServicePrincipal 
$clientsec = [System.Net.NetworkCredential]::new("", $sp.Secret).Password
$tenantID = (get-aztenant).Id
$response = 
@{client_id=$sp.ApplicationId 
    client_secret=$clientsec
    tenant_id=$tenantID}

$response > AGIC-SP-Cred.json

$utfEncode = [System.Text.Encoding]::UTF8.GetBytes($response)
[System.Convert]::ToBase64String($utfEncode)


