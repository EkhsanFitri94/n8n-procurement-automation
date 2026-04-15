param(
    [string]$BaseUrl = "http://localhost:5678",
    [string]$Username = "admin",
    [string]$Password = "change-me"
)

$ErrorActionPreference = "Stop"

function Invoke-N8nWebhook {
    param(
        [string]$Url,
        [hashtable]$Body,
        [hashtable]$Headers
    )

    return Invoke-RestMethod -Method Post -Uri $Url -Headers $Headers -Body ($Body | ConvertTo-Json -Depth 10) -ContentType "application/json"
}

$pair = "{0}:{1}" -f $Username, $Password
$bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
$auth = [Convert]::ToBase64String($bytes)
$headers = @{ Authorization = "Basic $auth" }

Write-Host "Testing approval chain against $BaseUrl"

$req = @{
    request_id = "REQ-CHAIN-0001"
    requester = "Ekhsan"
    department = "Procurement"
    item = "Firewall Appliance"
    amount = 12800
    manager_email = "manager@example.com"
    procurement_queue = "procurement-team"
}

$decision = @{
    request_id = $req.request_id
    decision = "approve"
    amount = $req.amount
    manager_email = $req.manager_email
    comment = "Approved for operations"
}

$notify = @{
    request_id = $req.request_id
    requester_name = "Ekhsan"
    requester_email = "requester@example.com"
    decision = "approved"
    amount = $req.amount
    manager_comment = "Approved for operations"
}

$step06Url = "$BaseUrl/webhook/procurement/approval-chain"
$step07Url = "$BaseUrl/webhook/procurement/manager-decision"
$step08Url = "$BaseUrl/webhook/procurement/requester-notify"

Write-Host "Step 06 -> $step06Url"
$r06 = Invoke-N8nWebhook -Url $step06Url -Body $req -Headers $headers
$r06 | ConvertTo-Json -Depth 10

Write-Host "Step 07 -> $step07Url"
$r07 = Invoke-N8nWebhook -Url $step07Url -Body $decision -Headers $headers
$r07 | ConvertTo-Json -Depth 10

Write-Host "Step 08 -> $step08Url"
$r08 = Invoke-N8nWebhook -Url $step08Url -Body $notify -Headers $headers
$r08 | ConvertTo-Json -Depth 10

Write-Host "Approval chain smoke test completed."
