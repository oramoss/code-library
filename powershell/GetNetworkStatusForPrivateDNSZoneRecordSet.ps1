# Define the list of DNS zones to interrogate
$zones = @(
    [PSCustomObject]@{
        ZoneName = "privatelink.vaultcore.azure.net"
        ZoneType = "Microsoft.KeyVault/vaults"
    }
    # ,
    # [PSCustomObject]@{
    #     ZoneName = "privatelink.database.windows.net"
    #     ZoneType = "Microsoft.Sql/servers"
    # }
)

$subscriptions = @(
    [PSCustomObject]@{
        SubscriptionName = "dv-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "dv-sub-02"
    },
    [PSCustomObject]@{
        SubscriptionName = "tt-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "tt-sub-02"
    },
    [PSCustomObject]@{
        SubscriptionName = "pp-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "pp-sub-02"
    },
    [PSCustomObject]@{
        SubscriptionName = "pd-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "pd-sub-02"
    },
    [PSCustomObject]@{
        SubscriptionName = "hub-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "sb-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "ssv-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "tpnp-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "tp-sub-01"
    },
    [PSCustomObject]@{
        SubscriptionName = "idt-sub-01"
    }
)

# Ensure the Azure PowerShell module is installed
if (-not (Get-Module -ListAvailable -Name Az)) {
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
}

# Import the Azure PowerShell module
Import-Module Az

# Login to Azure
Connect-AzAccount

Set-AzContext "hub-sub-01"

# Function to list private DNS zones
function Get-PrivateDnsZones {
    Get-AzPrivateDnsZone
}

# Function to list record sets for a given DNS zone
function Get-RecordSets {
    param (
        [string]$ZoneName
    )
    Get-AzPrivateDnsRecordSet -ResourceGroupName "hub-rg-uks-vnet-01" -ZoneName $ZoneName
}

# Function to get network settings of a Key Vault
function Get-KeyVaultNetworkSettings {
    param (
        [string]$KeyVaultName,
        [string]$ResourceGroupName
    )

    $keyVault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName
    if (-not $keyVault) {
        Write-Output "Key Vault not found."
        return
    }

    $networkAcls = $keyVault.Properties.NetworkAcls
    Write-Output "Key Vault: $KeyVaultName"
    Write-Output "Resource Group: $ResourceGroupName"
    Write-Output "Default Action: $($networkAcls.DefaultAction)"
    Write-Output "Bypass: $($networkAcls.Bypass)"
    Write-Output "IP Rules: $($networkAcls.IpRules)"
    Write-Output "Virtual Network Rules: $($networkAcls.VirtualNetworkRules)"
}

# Function to get the resource group name of an Azure resource
function Get-ResourceGroupName {
    param (
        [string]$ResourceName,
        [string]$ResourceType
    )

    $resource = Get-AzResource -Name $ResourceName -ResourceType $ResourceType
    if (-not $resource) {
        Write-Output "Resource not found."
        return
    }

    $resourceGroupName = $resource.ResourceGroupName
    Write-Output "Resource Name: $ResourceName"
    Write-Output "Resource Type: $ResourceType"
    Write-Output "Resource Group: $resourceGroupName"
}

# Function to get the resource group and subscription of an Azure resource
function Get-ResourceGroupAndSubscription {
    param (
        [string]$ResourceName,
        [string]$ResourceType
    )

    foreach ($subscription in $subscriptions) {

        Set-AzContext -SubscriptionName $subscription.SubscriptionName

        $resource = Get-AzResource -Name $ResourceName -ResourceType $ResourceType
        if ($resource) {
            $resourceGroupName = $resource.ResourceGroupName
            $subscriptionId = $resource.SubscriptionId
            Write-Output "Resource found in subscription $($subscription.SubscriptionName)."
            return [PSCustomObject]@{
                ResourceGroupName = $resourceGroupName
                SubscriptionId    = $subscriptionId
            }
        }
    }
    return
}

# Function to get network settings of a Key Vault
function Get-KeyVaultNetworkSettings {
    param (
        [string]$KeyVaultName,
        [string]$ResourceGroupName
    )

    $keyVault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName
    if (-not $keyVault) {
        Write-Output "Key Vault not found."
        return
    }

    $networkAcls = $keyVault.Properties.$networkAcls
    return [PSCustomObject]@{
        DefaultAction = $networkAcls.DefaultAction
        Bypass = $networkAcls.Bypass
        IpRules = $networkAcls.IpRules
        VirtualNetworkRules = $networkAcls.VirtualNetworkRules
        PublicNetworkAccess = $keyVault.Properties.PublicNetworkAccess
    }
}

# Main script
if (-not $zones) {
    Write-Output "No DNS zones provided."
    return
}

foreach ($zone in $zones) {
    Write-Output "DNS Zone: $($zone.ZoneName)"
    $recordSets = Get-RecordSets -ZoneName $($zone.ZoneName)
    if ($recordSets.Count -eq 0) {
        Write-Output "No record sets found for zone: $($zone.ZoneName)"
        continue
    }

    foreach ($record in $recordSets) {
        if ($record.RecordType -eq "A") {
            Set-AzContext -Subscription "hub-sub-01"
            $ResourceName = $($record.Name)
            Write-Output "Resource Name: $($ResourceName)"
            $ResourceType = "$($zone.ZoneType)"
            Write-Output "Resource Type: $($ResourceType)"
            $resourceInfo = Get-ResourceGroupAndSubscription -ResourceName $ResourceName -ResourceType $ResourceType
            if ($resourceInfo) {
                $ResourceGroupName = $resourceInfo.ResourceGroupName
                $SubscriptionId = $resourceInfo.SubscriptionId
                Write-Output "Resource Group: $ResourceGroupName"
                Write-Output "Subscription ID: $SubscriptionId"
                Set-AzContext -Subscription $SubscriptionId
                $KeyVaultNetworkSettings = Get-KeyVaultNetworkSettings -KeyVaultName $ResourceName -ResourceGroupName $ResourceGroupName
                Write-Output "  Default Action: $($KeyVaultNetworkSettings.DefaultAction)"
                Write-Output "  Bypass: $($KeyVaultNetworkSettings.Bypass)"
                Write-Output "  IP Rules: $($KeyVaultNetworkSettings.IpRules)"
                Write-Output "  Virtual Network Rules: $($KeyVaultNetworkSettings.VirtualNetworkRules)"
                Write-Output "  Public Network Access: $($KeyVaultNetworkSettings.PublicNetworkAccess)"
            }
        }
    }
}
