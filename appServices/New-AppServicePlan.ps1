param(
    [string]$location = 'eastus',
    [string]$resourceGroupName = 'Development',
    [string]$tier = 'F1',
    [string]$webAppName = 'mjlapp'
)

Write-Host 'Pricing tier for app service plan default is Free 1 (F1)'

$random = Get-Random -Count 10
$random1 = $random[0]
$random2 = $random[1]

$appServicePlanParams = @{
    'Name'              = "$webAppName-$random1"
    'Location'          = $location
    'Tier'              = $tier
    'ResourceGroupName' = $resourceGroupName
}

$appServicePlan = New-AzAppServicePlan @appServicePlanParams