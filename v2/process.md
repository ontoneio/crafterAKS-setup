# Setting up CrafterCMS on Azure Kubernetes Service
## Brief
`v1` was able to be spun up and accessed via public IP address, however once I tried to assign it a URL
I realized I was missing needed Azure resources in order to get the configuration for deployment as close as possible to a production type of setup.

What prompted `v2` was coming across an Azure Resource Manager Template that looked as though it could meet the needs of this project. This template is located in this repo under `templates/template.json`

This document is going to attempt to keep track of all the necessary steps involved in deploying CrafterCMS on AKS using the resource manager template. Going to try and do this all in `Powershell` for consistency.

## Process
1. Define variables
    - `$keyVaultName = <azure key-vault-name>`
    - `$resourceGroupName = <resource-group>`
    - `$resourceGroupLocation = <location>`
    - 
    ```powershell
    $resourceGroupTags = @{ 
    'environment' = '<env> == poc, dev, test, prod';
    'dept' = '<itd-dept>';
    'developer' = '<developer-name>'
    }
    ```
    - `$certName = '<certificate-name>'`

2. Create a new Resource Group for Crafter to house needed Cloud Resources
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Tag $resourceGroupTags

3. Create New Azure KeyVault
New-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation

3. Create AD Service principal
    - a. Generate Certificate for Authentication

```powershell
$servicePrincipal = New-AzADServicePrincipal

$clientSecret = [System.Net.NetworkCredential]::new("", $servicePrincipal.Secret).Password
$tenantID = (get-aztenant).Id
$jsonresp = 
@{
    client_id=$servicePrincipal.ApplicationId 
    client_secret=$clientSecret
    tenant_id=$tenantID
    }
$jsonresp | ConvertTo-Json
```
From the above, `ApplicationId`, `Password`, and `ObjectId` all need to be recorded