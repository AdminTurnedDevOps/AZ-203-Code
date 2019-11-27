$keyVault = Read-Host 'Please enter keyvault name'
$location = Read-Host 'Please enter location'
$vmName = Read-Host 'Please enter VM name'
$RG = Read-Host 'Please enter resource group name'


az keyvault create --name $keyVault --resource-group $RG --location $location --enabled-for-disk-encryption
az vm encryption enable -g $RG --name $vmName --disk-encryption-keyvault $keyVault
az vm show --name $vmName -g $RG
