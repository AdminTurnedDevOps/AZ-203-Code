param (
    [parameter(Mandatory, Position = 0, HelpMessage = 'Please enter the name of your ARM deplopyment')]
    [string]$name,

    [parameter(Mandatory, Position = 1, HelpMessage = 'Please enter your Resource Group name')]
    [string]$resourceGroup,

    [parameter(Position = 2, HelpMessage = 'Mode (Incremental or Complete) is set to Incremental by default so your existing resources do not get deleted')]
    [string]$mode = 'Incremental',
    
    [parameter(Mandatory, Position = 3, HelpMessage = 'Please enter name of your Main ARM template file')]
    [string]$mainARMFile,

    [parameter(Mandatory, Position = 4, HelpMessage = 'Please enter name of your parameter ARM template file')]
    [string]$templateARMFile
)

$azContext = Get-AzContext
if ($azContext -like $null) {
    Write-Warning 'Warning: No AZ Context is set. Please run the cmdlet Set-AzContext and try again'
    Pause
    Exit
}

try {
$location = Read-Host 'Please enter directory of where your main ARM template and parameter ARM template exist'
cd $location
}

Catch {
    Write-Warning 'Warning: Path does not exist'
    $PSCmdlet.ThrowTerminatingError($_)
}

try {
$ARMResourceParams = @{
    'Name' = $name
    'ResourceGroupName' = $resourceGroup
    'Mode' = $mode
    'TemplateFile' = ".\$mainARMFile"
    'TemplateParameterFile' = ".\$templateARMFile"
}

Write-Host -ForegroundColor Orange 'Resources Creating. Please be patient as this may take several minutes'
New-AzResourceGroupDeployment @ARMResourceParams

Write-Host -ForegroundColor Green 'Resources created'
}

catch {
    Write-Warning 'Warning: Resources not created'
    $PSCmdlet.ThrowTerminatingError($_)
}