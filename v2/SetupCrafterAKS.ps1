# Get Azure Tenant ID
$tenantID = (Get-AzContext).Tenant.Id
# Write-Output $tenantID
$keyVaultName = 'crafterPoC-Vault'
$resourceGroupName = 'dss-lab-crafter'
$resourceGroupLocation = 'EastUS'
$resourceGroupTags = @{ 
    'environment' = 'PoC-dev';
    'dept' = 'DSS';
    'developer' = 'Jonathan A. Mitchell'
}
$certName = 'craftercms-poc-cert'

# Create a new Resource Group for Crafter to house needed Cloud Resources
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Tag $resourceGroupTags

# Create New Azure KeyVault
New-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation
# Create AzKeyVault Certificate Policy
$CertPolicy = New-AzKeyVaultCertificatePolicy -IssuerName 'Self' -SecretContentType 'application/x-pem-file' -SubjectName 'crafter-poc-demo' -KeySize 2048 -KeyType 'RSA'
Add-AzKeyVaultCertificate -VaultName $keyVaultName -Name $certName -CertificatePolicy $CertPolicy
Get-AzKeyVaultCertificateOperation -VaultName $keyVaultName -Name $certName
# AzAd Service Principal Certificate
$servicePrincipalCertificate = Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $certName

# Create New Service Principal
$servicePrincipal = New-AzADServicePrincipal -DisplayName 'crafterDemoSP' -Role 'Contributor' -CertValue $servicePrincipalCertificate
# Generate a Service Pricipal Password
# $clientSecret = [System.Net.NetworkCredential]::new("", $servicePrincipal.Secret).Password

# $jsonresp = 
# @{
#     client_id=$servicePrincipal.ApplicationId 
#     client_secret=$clientSecret
#     tenant_id=$tenantID
#     }
# $jsonresp | ConvertTo-Json