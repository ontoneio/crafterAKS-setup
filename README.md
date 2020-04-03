# Setting up CrafterCMS on Azure Kubernetes Service
## Brief
`v1` was able to be spun up and accessed via public IP address, however once I tried to assign it a URL
I realized I was missing needed Azure resources in order to get the configuration for deployment as close as possible to a production type of setup.

What prompted `v2` was coming across an Azure Resource Manager Template that looked as though it could meet the needs of this project. This template is located in this repo under `templates/template.json`

This document is going to attempt to keep track of all the necessary steps involved in deploying CrafterCMS on AKS using the Azure DevOps. Going to try and use Powershell where scripting is needed.

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

### Prerequisites & Setup
- Resource Group for ACR
- Azure Container Repo (ACR)

In your Azure DevOps project located at `https://dev.azure.com/<YOUR_ORG_NAME>/<DEVOPS_PROJECT_NAME>/_settings/adminservices`

1. Need to create a `Service Connection` to `Azure Resource-Manager` API or (ARM) as it's sometimes referred.
2. Select `Service Principal (automatic)` , then select your `Scope`: [ Subscription,  Management Group,  Machine Learning Workspace]

I am going to use a `Management Group` as it gives ownership access to a scope of resources.

3. Create 3 more `Service Connection`'s Github, Docker Hub, Azure Container Repo(ACR).

*Note* I also setup a service connection to manage Azure Key Vault: Keys, Secrets, & Certificates.


### Notes






- Note:  Following this tutorial [Continuous Deployment with AKS and AGIC using Azure Pipelines](https://github.com/Azure/application-gateway-kubernetes-ingress/blob/master/docs/how-tos/continuous-deployment.md) in combination with [Learning Azure Kubernetes Service (AKS)](https://www.linkedin.com/learning/learning-azure-kubernetes-service-aks)