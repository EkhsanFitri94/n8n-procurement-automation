# n8n Procurement Automation Starter

A starter n8n project you can run locally and upload to GitHub.

## What You Get

- Docker-based n8n setup
- Environment template (`.env.example`)
- Example workflows you can import
- Clean repository structure for version control

## Project Structure

```text
n8n-procurement-automation/
├── .env.example
├── .gitignore
├── docker-compose.yml
├── README.md
└── workflows/
    └── examples/
        ├── 01_manual_test_workflow.json
        └── 02_daily_procurement_stub.json
```

## Quick Start

1. Copy env template:

```bash
cp .env.example .env
```

2. Edit `.env` and set secure values:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_ENCRYPTION_KEY`

3. Start n8n:

```bash
docker compose up -d
```

4. Open n8n:

- http://localhost:5678

## Import Example Workflows

In n8n UI:

1. Create new workflow
2. Click menu (three dots) -> Import from file
3. Choose files from `workflows/examples/`

## GitHub Upload

If this is a new repo:

```bash
git init
git add .
git commit -m "feat: initialize n8n automation starter"
git branch -M main
git remote add origin https://github.com/<your-username>/n8n-procurement-automation.git
git push -u origin main
```

## Notes

- `.n8n/` runtime data is ignored by git.
- Do not commit `.env` with real credentials.
- For production, run behind HTTPS reverse proxy.
