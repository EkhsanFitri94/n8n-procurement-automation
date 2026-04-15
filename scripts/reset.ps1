param(
    [switch]$DeleteData
)

$ErrorActionPreference = "Stop"

docker compose down

if ($DeleteData) {
    if (Test-Path ".n8n") {
        Remove-Item ".n8n" -Recurse -Force
        Write-Host "Deleted .n8n data directory."
    } else {
        Write-Host "No .n8n directory found."
    }
}

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env from .env.example"
}

docker compose up -d
Write-Host "n8n has been reset and started at http://localhost:5678"
