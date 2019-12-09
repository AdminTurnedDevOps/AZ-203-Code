# Check if AZ CLI is installed. If not, tell user to install AZ CLI
# Check if AZ CLI is set for a specific subscription. If not, tell user to set up 
# Create an Azure Function plan
# Create Azure function

# Function 1 - Create an AZ Function Plan
# Function 2 - Create an Azure Function

function New-AZFunctionPlan {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    param(
        [parameter(Mandatory,
            Position = 0,
            ValueFromPipeline = $true,
            HelpMessage = 'Please enter the resource group name')]
        [ValidateNotNullOrEmpty()]
        [Alias('RG')]
        [string]$resourceGroup,

        [parameter(Position = 1,
            ValueFromPipeline = $true,
            HelpMessage = 'Please enter the SKU type. Default is S1')]
        [ValidateNotNullOrEmpty()]
        [string]$sku = 'S1',

        [parameter(Mandatory,
            Position = 2,
            HelpMessage = 'Please enter the function app plan name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string]$functionAppPlanName,

        [parameter(Mandatory,
            Position = 3,
            HelpMessage = 'Please enter the region')]
        [ValidateNotNullOrEmpty()]
        [Alias('location')]
        [string]$region
    )

    begin {
        Write-Output 'Please ensure AZ CLI is installed'
        Start-Sleep .5

        $sub = az account show
        if (-not($sub)) { Write-Error 'No AZ subscription set'; Write-Host -ForegroundColor Green 'Running AZ Login to log into your subscription'; az login }
    }

    process {
        try {
            az functionapp plan create --name $functionAppPlanName --resource-group $resourceGroup --sku $sku --location $region
        }

        catch {
            Write-Warning 'An error has occurred'
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }

    end { }
}


function New-AZFunctionApp {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [parameter(Mandatory,
            Position = 0,
            ValueFromPipeline = $true,
            HelpMessage = 'Please enter the resource group name')]
        [ValidateNotNullOrEmpty()]
        [Alias('RG')]
        [string]$resourceGroup,

        [parameter(Mandatory,
            ValueFromPipeline = $true,
            Position = 1,
            HelpMessage = 'Please enter the name of your Function App')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string]$functionAppName,

        [parameter(Mandatory,
            Position = 2,
            HelpMessage = 'Please enter the name of your app service plan')]
        [ValidateNotNullOrEmpty()]
        [Alias('Plan')]
        [string]$appServicePlan,

        [parameter(Mandatory,
            Position = 3,
            HelpMessage = 'Please enter the region')]
        [ValidateNotNullOrEmpty()]
        [Alias('location')]
        [string]$region,

        [parameter(Mandatory,
            Position = 4,
            HelpMessage = 'Please enter the OS type')]
        [ValidateNotNullOrEmpty()]
        [Alias('OS')]
        [ValidateSet('Windows', 'Linux')]
        [string]$osType,

        [parameter(Position = 5,
            HelpMessage = 'Please enter the runtime for your application. Defalt is dotnet')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('dotnet', 'java', 'node', 'powershell', 'python')]
        [string]$runtime
    )

    begin {
        Write-Output 'Please ensure AZ CLI is installed'
        Start-Sleep .5

        $sub = az account show
        if (-not($sub)) { Write-Error 'No AZ subscription set'; Write-Host -ForegroundColor Green 'Running AZ Login to log into your subscription'; az login }
    }

    process {
        Write-Output 'Creating necessary storage account for function app'
        $storageAccountName = $functionAppName + 'strg'
        $store = az storage account create --name $storageAccountName --resource-group $resourceGroup

        az functionapp create --resource-group $resourceGroup --plan $appServicePlan --name $functionAppName --storage-account $storageAccountName
    }

    end { }
}