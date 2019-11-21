function New-KeyVault {

    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = 'Please enter keyvault name')]
        [ValidateNotNullOrEmpty()]
        [string]$keyvaultName,

        [Parameter(Mandatory, Position = 1, HelpMessage = 'Please enter Resource Group name')]
        [ValidateNotNullOrEmpty()]
        [string]$resourceGroupName,

        [Parameter(Mandatory, Position = 2, HelpMessage = 'Please enter location')]
        [ValidateNotNullOrEmpty()]
        [string]$location
    )
    
    try { 
        $context = az account show
        $context
    }

    catch {
        Write-Warning 'Please confirm AZ CLI is installed'
        $PSCmdlet.ThrowTerminatingError($_)
    }

    try {

        if (!($context)) {
            Write-Warning 'Warning: No AZ CLI Context/Subscription is set'
            $setAccount = Read-Host 'Would you like to set an account? 1 for yes or 2 for no'

            switch ($setAccount) {
                1 {
                    $account = Read-Host 'Please enter subscription name'
                    az account set -s $account
                }

                2 {
                    Write-Warning 'Warning: No account has been set. Exiting...'
                    Pause
                    exit
                }
            }
        }

        else {
            az keyvault create --name $keyvaultName --resource-group $resourceGroupName --location $location
        }

    }

    catch {
        Write-Warning 'An error has occurred creating your keyvault'
        $PSCmdlet.ThrowTerminatingError($_)
    }
}