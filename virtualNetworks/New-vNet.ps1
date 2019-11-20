function New-DevNet {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    param(
        [parameter(Position = 0,
            HelpMessage = 'Please enter your Resource Group name')]
        [string]$resourceGroup,

        [parameter(Position = 1,
            HelpMessage = 'Please enter address prefix for vnet. Example: 10.10.0.0/16')]
        [string]$vNetAddressPrefix,

        [parameter(Position = 2,
            HelpMessage = 'Please enter subnet prefix. Example: 10.10.1.0/24')]
        [string]$subnetPrefix,

        [parameter(Position = 3,
            HelpMessage = 'Please enter vNet name')]
        [string]$vNetName
    
    )

    begin { 
        $sub = Get-AzContext
        Write-Output "Start Development network creation on: $sub.SubscriptionName"
    }

    process {
        if ($resourceGroup -like $null) {
            Write-Output 'Resource Group is empty'
            $sw = Read-Host 'Would you like to create a resource group? 1 for yes or 2 for no'
            
            if ($sw -like '1') {
                $RGName = Read-Host 'Please enter Resource Group name that you would like to create'
                $location = Read-Host 'Please enter location for resource group'
            }

            switch ($sw) {
                1 {
                    $newRG = New-AzResourceGroup -Name $RGName -Location $location
                    $newRG
                }
                2 {
                    Write-Warning 'Warning: No Resource Group was selected or created. Exiting...'
                    Pause
                    exit
                }
            }
        }

        try {

            if ($resourceGroup) {
                az network vnet create --resource-group $resourceGroup --name $vNetName --address-prefix $vNetAddressPrefix --subnet-name $($vNetName + '-subnet') --subnet-prefix $subnetPrefix
                az network public-ip create --resource-group $resourceGroup --name $($vNetName + '-pubip')
                az network nsg create --resource-group $resourceGroup --name $($vNetName + '-nsg')
                az network nic create --resource-group $resourceGroup --name $($vNetName + '-nic') --vnet-name $vNetName --subnet $($vNetName + '-subnet') --network-security-group $($vNetName + '-nsg') --public-ip-address $($vNetName + '-pubip')
            }

            elseif ($sw -like '1') {
                az network vnet create --resource-group $newRG.ResourceGroupName --name $vNetName --address-prefix $vNetAddressPrefix --subnet-name $($vNetName + '-subnet') --subnet-prefix $subnetPrefix
                az network public-ip create --resource-group $newRG.ResourceGroupName --name $($vNetName + '-pubip')
                az network nsg create --resource-group $newRG.ResourceGroupName --name $($vNetName + '-nsg')
                az network nic create --resource-group $newRG.ResourceGroupName --name $($vNetName + '-nic') --vnet-name $vNetName --subnet $($vNetName + '-subnet') --network-security-group $($vNetName + '-nsg') --public-ip-address $($vNetName + '-pubip')
            }
        }

        catch {
            Write-Warning 'An error has occurred'
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }

    end { }
}