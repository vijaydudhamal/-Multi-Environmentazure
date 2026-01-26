🏗️ Multi-Environment Azure Platform (AKS & Key Vault)
This repository contains the Infrastructure as Code (IaC) for a production-grade, multi-environment Kubernetes platform on Azure. It leverages a modular design to deploy Networking, Security, and Compute resources consistently across Dev, QA, and Prod.
📍 Architecture Overview
The following diagram illustrates the flow from the Terraform configuration to the final Azure environment.
Code snippet
graph TD
    subgraph Local_Dev [Local Development]
        A[Terraform Code] --> B[Environment .tfvars]
    end

    subgraph Pipeline [CI/CD Pipeline - Azure DevOps]
        B --> C{Validation & Plan}
        C -->|Success| D[Manual Approval]
        D -->|Approved| E[Terraform Apply]
    end

    subgraph Azure_Cloud [Azure Subscription]
        E --> F[VNet / Subnet]
        F --> G[AKS Cluster]
        E --> H[Key Vault]
        G -->|Managed Identity| H
    end

    subgraph Storage [State Management]
        E <--> I[(Azure Blob Storage)]
    end
________________________________________
🛠️ Tech Stack
•	IaC: Terraform (v1.7.0+)
•	Cloud: Azure (Provider v3.0+)
•	CI/CD: Azure Pipelines & GitHub Actions
•	Compute: Azure Kubernetes Service (AKS)
•	Security: Azure Key Vault & RBAC
________________________________________
📂 Directory Structure
Plaintext
.
├── .github/workflows/    # GitHub Actions for automated linting
├── modules/              # Reusable infrastructure blocks
│   └── network/          # VNet, Subnet, AKS, and Key Vault logic
├── environments/         # Environment-specific configurations
│   ├── dev/              # Development (Sandboxed)
│   ├── qa/               # Quality Assurance (Testing)
│   └── prod/             # Production (High Availability)
├── scripts/              # Helper scripts (validate_all.sh)
└── azure-pipelines.yml   # Main CI/CD orchestration
________________________________________
🚀 Getting Started
Prerequisites
1.	Azure CLI installed and authenticated (az login).
2.	Terraform CLI (v1.7+) installed.
3.	An existing Azure Storage Account for remote state.
Local Deployment (Dev)
To test changes locally before pushing to the pipeline:
Bash
cd environments/dev
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
________________________________________
🛡️ Security Standards
•	Identity-Based Access: AKS uses System-Assigned Managed Identity to access Key Vault. No client secrets are stored in the cluster.
•	Network Isolation: Key Vault is protected by Network ACLs, allowing traffic only from the AKS Subnet.
•	State Locking: Remote state is stored in Azure Blob Storage with lease-locking enabled to prevent concurrent modification.
•	Least Privilege: resource_provider_registrations = "none" is used to ensure the deployment identity doesn't require over-privileged subscription-level permissions.
________________________________________
🔄 CI/CD & Drift Detection
The project includes a 2-step deployment process:
1.	Plan Stage: Generates a .tfplan file and waits for manual approval.
2.	Apply Stage: Executes the approved plan.
3.	Drift Check: A daily cron job (3:00 AM) runs a plan to check if the manual changes were made in the Azure Portal.
________________________________________
✍️ Authors
•	Vijay Dudhamal - Initial Work - @YourGithub
________________________________________

🔍 Troubleshooting & Common Issues
1. Permission Denied (Key Vault)
Symptom: Your Pods in AKS fail to start with a 403 Forbidden error when trying to fetch secrets.
•	Cause: The AKS System-Assigned Identity hasn't been granted access in the Key Vault Access Policy yet.
•	Solution: Ensure terraform apply completed successfully. Check the Key Vault "Access Policies" in the Portal; you should see a "Managed Identity" with Get and List permissions.
2. Provider Registration Errors
Symptom: The client does not have authorization to perform action 'Microsoft.Resources/subscriptions/providers/register/action'.
•	Cause: You are using resource_provider_registrations = "none" but a required provider (like Microsoft.ContainerService) isn't registered in your subscription.
•	Solution: Ask an Owner to run the manual registration script:
Bash
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.Network
3. IP Address Exhaustion
Symptom: AKS fails to scale or create new nodes/pods.
•	Cause: Since we are using Azure CNI, every Pod gets a real IP from your Subnet. If your subnet_cidr is too small (e.g., /27), you will run out of IPs.
•	Solution: Check your subnet_cidr in terraform.tfvars. For production AKS, a /24 (256 IPs) or /23 (512 IPs) is recommended.
4. Terraform State Lock
Symptom: Error: Error acquiring the state lock.
•	Cause: A previous pipeline run crashed or someone else is currently running an apply.
•	Solution: If you are sure no one else is deploying, go to the Azure Storage Account, find the .tfstate blob, and click "Break Lease".
________________________________________
🚀 Final Deployment Checklist
Before you hand this over to the team, ensure:
•	[ ] The azureServiceConnection is authorized for the Resource Group.
•	[ ] The Storage Account for Terraform State has "Versioning" enabled (to recover from accidental state deletion).
•	[ ] You've run the ./validate_all.sh script locally one last time.
Would you like me to help you write a "Destruction Script" that safely tears down the Dev/QA environments without touching Prod?

