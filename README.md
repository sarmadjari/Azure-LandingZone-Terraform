# Azure-Terraform

This Terraform template sets up a multi-tier network architecture in Azure, including connectivity, identity, and management virtual networks (VNets). The template is organized into several modules, each responsible for different aspects of the infrastructure.

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

### Connectivity Security
The connectivity security module sets up the Azure Firewall and its associated route tables for east-west and forced tunneling traffic.

- **Location**: `platform/connectivity/security`
- **Main Configuration**: [platform/connectivity/security/main.tf](platform/connectivity/security/main.tf)
- **Variables**: [platform/connectivity/security/variables.tf](platform/connectivity/security/variables.tf)
- **Outputs**: [platform/connectivity/security/outputs.tf](platform/connectivity/security/outputs.tf)

## Root Configuration
The root configuration ties all the modules together and provides the necessary variables and outputs for the entire infrastructure.

- **Location**: `platform`
- **Main Configuration**: [platform/main.tf](platform/main.tf)
- **Variables**: [platform/variables.tf](platform/variables.tf)
- **Outputs**: [platform/outputs.tf](platform/outputs.tf)
- **Providers**: [platform/providers.tf](platform/providers.tf)
- **Terraform Variables**: [platform/terraform.tfvars](platform/terraform.tfvars)

## Usage
1. Clone the repository.
2. Navigate to the `platform` directory.
3. Initialize Terraform:

