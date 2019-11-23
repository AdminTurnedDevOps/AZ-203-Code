function SecureRetrieve-Secret {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = 'getSec', ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'getSec', HelpMessage = 'Please enter keyvault name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string]$vaultName,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'getSec', HelpMessage = 'Please enter Resource Group name')]
        [ValidateNotNullOrEmpty()]
        [Alias('RG')]
        [string]$resourceGroup
    )

    try {
        $vault = az keyvault show -g $resourceGroup -n $vaultName -o json | ConvertFrom-Json
        $vaultName = $vault | select -ExpandProperty Name 
    }
    catch {
        Write-Warning 'There was an issue getting your keyvault data. Please confirm you are in the right context/subscription via PowerShell'
        Pause
        Exit
    }

    Write-Warning 'Your secret is about to be shown in plain text on your screen.'

    try {
        $i = Read-Host 'Is this okay? 1 for yes 2 for no'

        if ($PSCmdlet.ShouldProcess('vaultName')) {
            if ($i -like '1')
            { az keyvault secret show --name "mysecret" --vault-name $vaultName --query value }

            elseif ($i -like '2')
            { Write-Warning '1 was not selected, exiting..'; exit }

            else {
                Write-Warning '1 or 2 was not selected. Exiting...'
                Pause
                exit
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}