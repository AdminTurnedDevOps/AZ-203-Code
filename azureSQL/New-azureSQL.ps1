function New-AzureSQLDB {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'low', DefaultParameterSetName = 'newDB')]
    param(
        [parameter(Mandatory,
            ParameterSetName = 'newDB',
            Position = 0,
            HelpMessage = 'Please enter your Resource Group name')]
        [ValidateNotNullOrEmpty()]
        [Alias('RG')]
        [string]$resourceGroup,

        [parameter(Mandatory,
            ParameterSetName = 'newDB',
            Position = 1,
            HelpMessage = 'Please enter your location')]
        [ValidateNotNullOrEmpty()]
        [string]$location,

        [parameter(Mandatory,
            ParameterSetName = 'newDB',
            Position = 2,
            HelpMessage = 'Please enter your SQL server name')]
        [ValidateNotNullOrEmpty()]
        [string]$serverName,

        [parameter(Mandatory,
            ParameterSetName = 'newDB',
            Position = 2,
            HelpMessage = 'Please enter your database name')]
        [ValidateNotNullOrEmpty()]
        [Alias('DBName')]
        [string]$databaseName,

        [parameter(Mandatory,
            ParameterSetName = 'newDB',
            Position = 3,
            HelpMessage = 'Please enter starting IP address of IPs that should have access to your SQL server')]
        [ValidateNotNullOrEmpty()]
        [string]$startingIP,

        [parameter(Mandatory,
            ParameterSetName = 'newDB',
            Position = 4,
            HelpMessage = 'Please enter ending IP address of IPs that should have access to your SQL server')]
        [ValidateNotNullOrEmpty()]
        [string]$endingIP
    )

    begin {
        $azSub = Get-AzContext
        if (-not($azSub.Name)) {
            Write-Warning 'No az subscription is set. Please set one...'
            Set-AzContext
        }
    }

    process {
        $newServer = Read-Host 'Would you like to create a new SQL server and firewall rules or use an existing? 1 for yes or 2 for no'

        try {
            switch ($newServer) {
                1 {
                    Write-Output 'Prompting for SQL username and password. Text will be hidden...'
                    $user = Read-Host 'Please enter username'
                    $pass = Read-Host 'Please enter password' -AsSecureString

                    $creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass

                    $serverParams = @{
                        'ResourceGroupName'           = $resourceGroup
                        'ServerName'                  = $serverName
                        'Location'                    = $location
                        'SqlAdministratorCredentials' = $creds
                    }

                    $firewallRuleParams = @{
                        'ResourceGroupName' = $resourceGroup
                        'ServerName'        = $serverName
                        'FirewallRuleName'  = 'allowedIPs'
                        'StartIpAddress'    = $startingIP
                        'EndIpAddress'      = $endingIP
                    }

                    New-AzSqlServer @serverParams
                    New-AzSqlServerFirewallRule @firewallRuleParams
                }

                2 {
                    $null
                }
            }
        }

        catch {
            Write-Error 'An issue occurred while creating your SQL server and/or firewall rules'
            $PSCmdlet.ThrowTerminatingError($_)
        }

        try {
            $databaseParams = @{
                'ServerName'        = $serverName
                'DatabaseName'      = $databaseName
                'ResourceGroupName' = $resourceGroup
            }

            New-AzSqlDatabase @databaseParams
        }

        catch {
            Write-Error "An issue occurred while creating a database in: $serverName"
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    end { }
}