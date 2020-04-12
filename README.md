# Setting up CrafterCMS on Azure Kubernetes Service
## Brief
`v1` was able to be spun up and accessed via public IP address, however once I tried to assign it a URL
I realized I was missing needed Azure resources in order to get the configuration for deployment as close as possible to a production type of setup.

What prompted `v2` was coming across an Azure Resource Manager Template that looked as though it could meet the needs of this project. This template is located in this repo under `templates/template.json`

This document is going to attempt to keep track of all the necessary steps involved in deploying CrafterCMS on AKS using the Azure DevOps. Going to try and use Powershell where scripting is needed.

## Plan Outline
### ***Phase One***

#### Operations (Ops)
- Infrastructure/Application Deployment using Azure DevOps
- Continuous Integration/Delivery using Azure DevOps
- Infrastructure based deployment of Azure resources using ARM templates

#### Networking (Net)
- Kubernetes configuration - Azure CNI or Kubenet
- Network Gateway ? For Intranet/Internet Access?
- Assigned Network team proper Virtual-Network access

#### Security (Sec)
- Azure AD Managed Identities
- Azure Policies
- Azure KeyVault
- CertManager for Kubernetes TLS Certificates
- Assign Security Team - Permissions
- Application User Authentication

#### Application Development (AppDev)
- Application based Deployment using Helm and Azure Pipelines
- Container repository for Base images and Continuous Integration versioning
- Azure Dev Spaces Setup for Kubernetes
- Git Provider - Github Team Account to integrate in build process

## Process Notes:

### Technology Utilized
- ***Docker:*** adds more consistency and quality for your apps, their deployment, and management. Docker allows also to be programming languages agnostic, all your apps packaged as Docker images could be in different languages: .NET Core, Java, Node.js, Go, Python, etc.
- ***Helm:***, as the package manager for Kubernetes, simplifies and automates more your apps deployments in Kubernetes. We will use the new Helm 3 throughout this tutorial.
- ***Kubernetes:*** is a container orchestrator that makes the collaboration between developers and IT pros easy and will for sure help you in the orchestration, management, and monitoring of all your apps containerized, in a consistent way.
- ***Azure DevOps:*** helps to implement your CI/CD pipelines for any platform, any languages.
- ***Azure Active Directory:*** Azure Active Directory (Azure AD) is Microsoft’s cloud-based identity and access management service, which helps your employees sign in and access resources in:
    - External resources, such as Microsoft Office 365, the Azure portal, and thousands of other SaaS applications.

    - Internal resources, such as apps on your corporate network and intranet, along with any cloud apps developed by your own organization.

- ***Azure Kubernetes Service (AKS):*** is a fully managed Kubernetes container orchestration service, simplifying the process around creating, scaling, and upgrading your Kubernetes cluster. You are not paying for the master nodes since that’s part of the managed offer.
- ***Azure Container Registry (ACR):*** is a dedicated enterprise container registry with advanced features like Helm chart repository, geo-replication of your registry across the globe, container build capabilities, security scanning for your images, etc.
- ***Azure Key Vault:*** is a tool for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, or certificates. A vault is a logical group of secrets.


### Process Notes
- Setup Azure DevOps Account and Created a project
- Within project, setup service connections to Github, Docker Hub, and Azure Resource Manager using a newly created Service Principal, and a service connection to Azure KeyVault for Secrets management. 4 total service connections within the Azure DevOps Project.
- ***Ops*** Note: [Cluster configuration](https://docs.microsoft.com/bs-latn-ba/azure/aks/cluster-configuration)
- ***Ops*** Note: [Cluster Node Security Upgrade Configuration](https://docs.microsoft.com/en-us/azure/aks/node-updates-kured)

