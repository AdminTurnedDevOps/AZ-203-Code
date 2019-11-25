param(
$Key = "your_batch_account_primary_key",
$region = "your_batch_account_region",
$BatchAccount = "your_batch_account_name",
$BatchAccountURL = "Https://$BatchAccount.$region.batch.azure.com"
)

$sharedKey = [System.Convert]::FromBase64String($Key)
$date = [System.DateTime]::UtcNow.ToString("R")

$stringToSign = "GET`n`n`n`n`n`n`n`n`n`n`n`nocp-date:$date`n/$BatchAccount/jobs`napi-version:2019-08-01.10.0"

[byte[]]$dataBytes = ([System.Text.Encoding]::UTF8).GetBytes($stringToSign)
$hmacsha256 = New-Object System.Security.Cryptography.HMACSHA256
$hmacsha256.Key = [Convert]::FromBase64String($key)
$sig = [Convert]::ToBase64String($hmacsha256.ComputeHash($dataBytes))

$authhdr = "SharedKey $BatchAccount`:$sig"
$headers = @{
    "ocp-date" = $date;
    "Authorization" = "$authhdr";
}

Invoke-restmethod -Headers $headers -Uri "$BatchAccountURL/jobs?api-version=2019-08-01.10.0"