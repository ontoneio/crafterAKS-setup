# Setting up CrafterCMS on Azure Kubernetes Service
## Brief
`v1` was able to be spun up and accessed via public IP address, however once I tried to assign it a URL
I realized I was missing needed Azure resources in order to get the configuration for deployment as close as possible to a production type of setup.

What prompted `v2` was coming across an Azure Resource Manager Template that looked as though it could meet the needs of this project. This template is located in this repo under `templates/template.json`

This document is going to attempt to keep track of all the necessary steps involved in deploying CrafterCMS on AKS using the Azure DevOps. Going to try and use Powershell where scripting is needed.

## Continuous Deployment with AKS and AGIC using Azure Pipelines
### Process Notes:

#### Prerequisites 
- Azure Account or Tenant
- Azure DevOps Organization
- 

- Note:  Following this tutorial [Continuous Deployment with AKS and AGIC using Azure Pipelines](https://github.com/Azure/application-gateway-kubernetes-ingress/blob/master/docs/how-tos/continuous-deployment.md) in combination with [Learning Azure Kubernetes Service (AKS)](https://www.linkedin.com/learning/learning-azure-kubernetes-service-aks)



1. Setup Service Principal for Azure Pipelines to access Azure Resource Manager(ARM). This most likely only need to happen once.