$ErrorActionPreference = "Stop"

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env from .env.example. Update credentials before production use."
}

docker compose up -d
Write-Host "n8n is starting at http://localhost:5678"