function Get-AzAccessToken {   
    
    $mod = Get-Module Az.Accounts 
    if (-not ($mod)) {
        Write-Output 'Importing AZ Module'
        Import-Module Az.Accounts
    }
    $connectedProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    if (-not $connectedProfile.Accounts.Count) {
        Write-Error 'No AZ Account currently being used'
        $login = Read-Host 'Would you like to log into your Azure account with AZ CLI to proceed? 1 for yes 2 for no'

        switch ($login) {
            1 {
                $sub = Read-Host 'Please enter your subscription ID'
                Set-AzContext -Subscription $sub
            }

            2 {
                Write-Error 'No subscription set'
                Pause
                exit
            }
        }
    }
  
    $currentAzureContext = Get-AzContext
    $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($connectedProfile)
    Write-Debug ("Getting access token for tenant" + $currentAzureContext.Tenant.TenantId)
    $token = $profileClient.AcquireAccessToken($currentAzureContext.Tenant.TenantId)
    $token.AccessToken
}

function Get-BearerToken {
    $ErrorActionPreference = 'Stop'
    ('Bearer {0}' -f (Get-AzCachedAccessToken))
}