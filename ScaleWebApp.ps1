<#
.SYNOPSIS
    Vertically scale up or down an Azure Web App

.DESCRIPTION
    This Azure Automation runbook enables vertical scaling of
    an Azure Web App. You can use this script to increment up or down by 1 instance per run.

.PARAMETER resourceGroupName
    Name of the resource group to which the service plan is
    assigned.

.PARAMETER appServicePlan
    Azure App Service Plan name (case sensitive).

.PARAMETER ScaleDirection
    Specify 'up' to scale up or 'down' to scale down.

.PARAMETER MinInstanceCount
    Minimum number of instances to maintain when scaling.

.EXAMPLE
    .\ScaleWebApp.ps1 -resourceGroupName "myResourceGroup" -appServicePlan "myAppServicePlan" -ScaleDirection "up" -MinInstanceCount 2

.NOTES
    Author: Umais Khan
    Last Update: Oct 2024
#>

param(
    [parameter(Mandatory = $true)]
    [string] $resourceGroupName,

    [parameter(Mandatory = $true)]
    [string] $appServicePlan,

    [parameter(Mandatory = $false)]
    [ValidateSet('up', 'down')]
    [string] $ScaleDirection = 'up',

    [parameter(Mandatory = $false)]
    [int] $MinInstanceCount = 1
)

# Authenticate using the system-assigned managed identity
Connect-AzAccount -Identity

# Retrieve the App Service Plan
$asp = Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServicePlan

if (-not $asp) {
    Write-Error "App Service Plan '$appServicePlan' not found in Resource Group '$resourceGroupName'."
    exit 1
}

# Get the current instance count from Sku.Capacity
$currentInstanceCount = $asp.Sku.Capacity

Write-Output "Current instance count: $currentInstanceCount"

# Determine the new instance count based on the scale direction
switch ($ScaleDirection) {
    'up' {
        $newInstanceCount = [Math]::Max($currentInstanceCount + 1, $MinInstanceCount)
    }
    'down' {
        $newInstanceCount = [Math]::Max($currentInstanceCount - 1, $MinInstanceCount)
    }
    Default {
        Write-Error "Invalid ScaleDirection specified. Use 'up' or 'down'."
        exit 1
    }
}

# Check if the new instance count is valid
if ($newInstanceCount -eq $currentInstanceCount) {
    Write-Output "Instance count remains at $currentInstanceCount (minimum instance count reached or no change needed)."
}
else {
    # Update the App Service Plan with the new instance count
    Set-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServicePlan -NumberOfWorkers $newInstanceCount
    Write-Output "Scaled $ScaleDirection to $newInstanceCount instances."
}
