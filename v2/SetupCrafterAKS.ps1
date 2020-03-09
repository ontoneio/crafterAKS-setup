# Get Azure Tenant ID
$tenantID = (Get-AzContext).Tenant.Id
# Write-Output $tenantID
$initKeyVaultName = 'crafterPoC-Vault'
$resourceGroupName = 'dss-lab-crafter'
$resourceGroupLocation = 'EastUS'
$resourceGroupTags = @{ 
    'environment' = 'PoC-dev';
    'dept' = 'DSS';
    'developer' = 'Jonathan A. Mitchell'
}


# Create a new Resource Group for Crafter to house needed Cloud Resources
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Tag $resourceGroupTags
# Create New Azure KeyVault
New-AzKeyVault -Name $initKeyVaultName -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation
# Get KeyVault Name
$VaultName = (Get-AzKeyVault).VaultName

# Create AzKeyVault Certificate Policy
$certName = 'craftercms-poc-cert'
$CertPolicy = New-AzKeyVaultCertificatePolicy -IssuerName 'Self' -SecretContentType 'application/x-pem-file' -SubjectName 'CN=crafter-poc-demo' -KeySize 2048 -KeyType 'RSA'
Add-AzKeyVaultCertificate -VaultName $VaultName -Name $certName -CertificatePolicy $CertPolicy
Get-AzKeyVaultCertificateOperation -VaultName $VaultName -Name $certName
# AzAd Service Principal Certificate
$servicePrincipalCertificate = Get-AzKeyVaultCertificate -VaultName $VaultName -Name $certName

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