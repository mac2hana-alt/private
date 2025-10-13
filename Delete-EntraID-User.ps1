#Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Force
#Install-Module Microsoft.Graph.Users -Scope CurrentUser -Force

$hexsecret = "6539386165613064636561306161616166373439313163356330306666306730"

$bytes = for ($i = 0; $i -lt $hexsecret.Length; $i += 2) {
    [Convert]::ToByte($hexsecret.Substring($i, 2), 16)
}

$secret = [System.Text.Encoding]::UTF8.GetString($bytes)

$clientId = "0adbcc49-03ef-9d20-b4d5-ctf64378ae39"
$tenantId = "43632083-gggg-9f0b-0000-08889132f79b"
$targetUserUPN = "user@mbpw.co.jp"

$tokenRequestBody = @{
    client_id     = $clientId
    scope         = "https://graph.microsoft.com/.default"
    client_secret = $Secret
    grant_type    = "client_credentials"
}

$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $tokenRequestBody
$accessToken = $tokenResponse.access_token

$headers = @{
    Authorization = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

$userLookupUri = "https://graph.microsoft.com/v1.0/users/$targetUserUPN"
$userInfo = Invoke-RestMethod -Uri $userLookupUri -Headers $headers
$userId = $userInfo.id

$deleteUri = "https://graph.microsoft.com/v1.0/users/$userId"
Invoke-RestMethod -Uri $deleteUri -Headers $headers -Method Delete

Write-Host "ユーザー $targetUserUPN を削除しました。"
