$crafterResGroup = 'dss-lab-docker'
$crafterKeyVaultName = 'Crafter-Demo-Vault'
$certName = 'craftercms-pipeline-ci'

# Create KeyVault to Store Certificate
# New-AzKeyVault -Name $crafterKeyVaultName -ResourceGroupName $crafterResGroup -Location 'East US'

# Create Self-Signed Certificate for New Service Principal
# $CertPolicy = New-AzKeyVaultCertificatePolicy -SubjectName "CN=dev.azure.com"  -IssuerName 'Self' -KeySize 2048 -SecretContentType 'application/x-pem-file'  -ValidityInMonths 6 -ReuseKeyOnRenewal -WhatIf 

# $Cert = New-SelfSignedCertificate `
#     -CertStoreLocation 'Cert:\CurrentUser\My'
#     -KeyFriendlyName 'AzPLcrafterCmsCert' `
#     -KeyDescription 'Az Pipelines Crafter CMS CI security certificate' `
#     -KeyAlgorithm 'RSA' `
#     -KeyLength 2048 `
#     -Keyspec KeyExchange `
#     -Subject "CN=CrafterPocDemo" `

# Setup Service Principal for Azure Pipelines to access Azure Resource Manager
$tenantID = (Get-AzTenant).Id
$subscriptionID = Get-AzSubscription -TenantId $tenantID
$subscriptionName = (Get-AzSubscription -TenantId $tenantID).Name
$pipelineName = "sp-crafter-cd"

$pipelineSP = New-AzADServicePrincipal -DisplayName $pipelineName -Role 'Owner' 

# Used To create AppId and Password for Azure DevOps Pipelines
$pl_ClientSecret = [System.Net.NetworkCredential]::new("", $pipelineSP.Secret).Password

$pl_jsonresp = 
@{
    subscription_id = $subscriptionID
    subscription_name= $subscriptionName
    client_id=$pipelineSP.ApplicationId
    client_secret=$pl_ClientSecret
}
$pl_jsonresp | ConvertTo-Json > .\v2\config\pipelineSP.json

$aksSP = New-AzADServicePrincipal -DisplayName 'aksCraferSP'
$aksClientSecret = [System.Net.NetworkCredential]::new("", $aksSP.Secret).Password

$aks_jsonresp = 
@{
    subscription_id = $subscriptionID
    subscription_name= $subscriptionName
    client_id=$aksSP.ApplicationId
    client_secret=$aksClientSecret
    tenant_id=$tenantID
}
$aks_jsonresp | ConvertTo-Json > .\v2\config\aksSP.json

# 2 lines below Assign permission to 
$containerId = (Get-AzContainerRegistry -ResourceGroupName $crafterResGroup).Id
New-AzRoleAssignment -ApplicationId '57af1108-f9c4-4a7d-9f2e-f29fd69240d1' -Scope $containerId -RoleDefinitionName 'Reader'
