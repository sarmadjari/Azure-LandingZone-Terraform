# Azure-Terraform

This Terraform template sets up a multi-tier network architecture in Azure, including connectivity, identity, and management virtual networks (VNets). The template is organized into several modules, each responsible for different aspects of the infrastructure.

This template is based on the official Microsoft documentation from the [Cloud Adoption Framework Landing Zone](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/).

![Azure Landing Zone Architecture Diagram - Hub and Spoke](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/media/azure-landing-zone-architecture-diagram-hub-spoke.svg)

Currently the template is to deploy the **Platform**:
- Connectivity
- Identity
- Management


## Modules

### Connectivity Network

The connectivity network module creates the connectivity VNet and its associated subnets. It also sets up virtual network peering with the identity and management VNets.

- **Location**: `platform/connectivity/network`
- **Main Configuration**: [platform/connectivity/network/main.tf](platform/connectivity/network/main.tf)
- **Variables**: [platform/connectivity/network/variables.tf](platform/connectivity/network/variables.tf)
- **Outputs**: [platform/connectivity/network/outputs.tf](platform/connectivity/network/outputs.tf)

### Identity Network

The identity network module creates the identity VNet and its associated subnets. It also sets up virtual network peering with the connectivity VNet.

- **Location**: `platform/identity/network`
- **Main Configuration**: [platform/identity/network/main.tf](platform/identity/network/main.tf)
- **Variables**: [platform/identity/network/variables.tf](platform/identity/network/variables.tf)
- **Outputs**: [platform/identity/network/outputs.tf](platform/identity/network/outputs.tf)

### Management Network

The management network module creates the management VNet and its associated subnets. It also sets up virtual network peering with the connectivity VNet.

- **Location**: `platform/management/network`
- **Main Configuration**: [platform/management/network/main.tf](platform/management/network/main.tf)
- **Variables**: [platform/management/network/variables.tf](platform/management/network/variables.tf)
- **Outputs**: [platform/management/network/outputs.tf](platform/management/network/outputs.tf)

### Connectivity Azure Firewall

The connectivity Azure Firewall module sets up the Azure Firewall in the connectivity VNet and its associated route tables for east-west and forced tunneling traffic.

- **Location**: `platform/connectivity/azure_firewall`
- **Main Configuration**: [platform/connectivity/azure_firewall/main.tf](platform/connectivity/azure_firewall/main.tf)
- **Variables**: [platform/connectivity/azure_firewall/variables.tf](platform/connectivity/azure_firewall/variables.tf)
- **Outputs**: [platform/connectivity/azure_firewall/outputs.tf](platform/connectivity/azure_firewall/outputs.tf)

### Connectivity Azure Application Gateway

The connectivity Azure Application Gateway module sets up the Application Gateway in the connectivity VNet.

- **Location**: `platform/connectivity/azure_application_gateway`
- **Main Configuration**: [platform/connectivity/azure_application_gateway/main.tf](platform/connectivity/azure_application_gateway/main.tf)
- **Variables**: [platform/connectivity/azure_application_gateway/variables.tf](platform/connectivity/azure_application_gateway/variables.tf)
- **Outputs**: [platform/connectivity/azure_application_gateway/outputs.tf](platform/connectivity/azure_application_gateway/outputs.tf)

### Connectivity Azure API Management

The connectivity Azure API Management module sets up the API Management service in the connectivity VNet.

- **Location**: `platform/connectivity/azure_api_management`
- **Main Configuration**: [platform/connectivity/azure_api_management/main.tf](platform/connectivity/azure_api_management/main.tf)
- **Variables**: [platform/connectivity/azure_api_management/variables.tf](platform/connectivity/azure_api_management/variables.tf)
- **Outputs**: [platform/connectivity/azure_api_management/outputs.tf](platform/connectivity/azure_api_management/outputs.tf)

### Connectivity Security

The connectivity security module sets up security components like network security groups and application security groups.

- **Location**: `platform/connectivity/security`
- **Main Configuration**: [platform/connectivity/security/main.tf](platform/connectivity/security/main.tf)
- **Variables**: [platform/connectivity/security/variables.tf](platform/connectivity/security/variables.tf)
- **Outputs**: [platform/connectivity/security/outputs.tf](platform/connectivity/security/outputs.tf)

### Management Azure Bastion

The management Azure Bastion module sets up the Azure Bastion service in the management VNet.

- **Location**: `platform/management/azure_bastion`
- **Main Configuration**: [platform/management/azure_bastion/main.tf](platform/management/azure_bastion/main.tf)
- **Variables**: [platform/management/azure_bastion/variables.tf](platform/management/azure_bastion/variables.tf)
- **Outputs**: [platform/management/azure_bastion/outputs.tf](platform/management/azure_bastion/outputs.tf)

## Usage

To deploy this Terraform template, navigate to the `platform` directory and run the following commands:
```sh
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

Ensure that you have updated the terraform.tfvars file with the necessary variable values before deployment.

If you encounter issues with subscriptions or permissions, try clearing your Azure account and logging in again:
```sh
az account clear
az login --scope https://management.azure.com/.default
```