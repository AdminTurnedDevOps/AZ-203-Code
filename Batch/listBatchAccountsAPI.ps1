param(
$subscriptionID,
$oAuthToken
)

$headers = @{
    "Authorization" = "Bearer $oAuthToken"
}

Invoke-restmethod -Headers $headers -Uri "https://management.azure.com/subscriptions/$subscriptionID/providers/Microsoft.Batch/batchAccounts?api-version=2019-08-01"