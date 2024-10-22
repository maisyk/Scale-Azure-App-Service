# Scale-Azure-App-Service
The `ScaleWebApp.ps1` script automates the vertical scaling of an Azure App Service Plan. By running this script, you can increase or decrease the number of instances by one, while ensuring the instance count does not drop below a specified minimum.

This script is designed to be used within Azure Automation and leverages the system-assigned managed identity for authentication.

# Prerequisites
- **Azure Subscription:** An active Azure subscription.
- **Azure Automation Account:** An Automation account with a system-assigned managed identity enabled.
- **Permissions:** The managed identity must have sufficient permissions (e.g., Contributor role) on the resource group containing the App Service Plan.
- **Azure PowerShell Modules:** The Automation account should have the necessary Azure PowerShell modules imported.

# Parameters
- `resourceGroupName` (String, Mandatory):
The name of the resource group containing the App Service Plan.

- `appServicePlan` (String, Mandatory):
The name of the Azure App Service Plan (case-sensitive).

- `ScaleDirection` (String, Optional, Default='up'):
The direction to scale the App Service Plan. Accepted values are 'up' or 'down'.

- `MinInstanceCount` (Integer, Optional, Default=1):
The minimum number of instances to maintain when scaling down.
