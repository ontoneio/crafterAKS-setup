$CLUSTER_NAME='crafterAKS-CLI-CL'
$CLUSTER_RG='cr-demo-CLI'
$REGION='eastus'
$ACR_NAME='crafterDemoCR'
$K8_VERSION=$(az aks get-versions -l $REGION --query 'orchestrators[-1].orchestratorVersion' -o tsv)
$ACR_REG_ID=$(az acr show --name $ACR_NAME --query 'id' --output tsv) 
$VM_SIZE='Standard_DS2_v2'
$DNS_NAME_PREFIX='cr-demo-cli'

Get-AzVMSize -Location $REGION | Where {($_.NumberOfCores -le 4) -and ($_.MemoryInMB -le 12000)} 

New-AzAks -KubernetesVersion $K8_VERSION -NodeCount 1 