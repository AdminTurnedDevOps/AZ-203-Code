param(
    [string]$method = 'GET',
    [string]$subscriptionID = "",
    [string]$restCall = ""
)

az rest --method $method --uri $restCall