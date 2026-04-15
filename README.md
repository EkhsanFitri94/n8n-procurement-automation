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
├── scripts/
│   ├── start.ps1
│   ├── stop.ps1
│   ├── reset.ps1
│   └── test-approval-chain.ps1
└── workflows/
    └── examples/
        ├── 01_manual_test_workflow.json
        ├── 02_daily_procurement_stub.json
        ├── 03_vendor_followup_email_draft.json
        ├── 04_google_sheets_overdue_followup_stub.json
        ├── 05_purchase_request_webhook_triage_stub.json
        ├── 06_purchase_request_approval_chain_stub.json
        ├── 07_manager_decision_callback_stub.json
        └── 08_requester_notification_stub.json
```

## Quick Start

1. Copy env template:

```bash
cp .env.example .env
```

Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

2. Edit `.env` and set secure values:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_ENCRYPTION_KEY`

3. Start n8n:

```bash
docker compose up -d
```

Windows helper (creates `.env` if missing, then starts Docker):

```powershell
.\scripts\start.ps1
```

4. Open n8n:

- http://localhost:5678

## Common Commands

Start in background:

```bash
docker compose up -d
```

View container status:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f n8n
```

Stop the project:

```bash
docker compose down
```

Windows stop helper:

```powershell
.\scripts\stop.ps1
```

Reset and restart project:

```powershell
.\scripts\reset.ps1
```

Reset, restart, and clear local n8n data:

```powershell
.\scripts\reset.ps1 -DeleteData
```

Run approval chain smoke test (`06 -> 07 -> 08`):

```powershell
.\scripts\test-approval-chain.ps1
```

If your Basic Auth credentials are different:

```powershell
.\scripts\test-approval-chain.ps1 -Username "admin" -Password "your-password"
```

## Import Example Workflows

In n8n UI:

1. Create new workflow
2. Click menu (three dots) -> Import from file
3. Choose files from `workflows/examples/`

Suggested first practical workflow:

- `03_vendor_followup_email_draft.json`: daily draft message for overdue procurement follow-up.
- Replace the final "Draft Reminder Message" node with your real Email or Telegram node.

Second practical workflow template:

- `04_google_sheets_overdue_followup_stub.json`: Cron -> mock row (replace with Google Sheets node) -> overdue check -> follow-up payload.
- Replace "Mock Google Sheets Row" with a real Google Sheets read node, then connect Email/Telegram after "Prepare Follow-up Payload".

Third practical workflow template:

- `05_purchase_request_webhook_triage_stub.json`: Webhook intake -> normalize request -> high-value check -> triage result response.
- Use this as a starter for approval routing (manager approval for high-value requests).

Fourth practical workflow template:

- `06_purchase_request_approval_chain_stub.json`: Webhook intake -> amount threshold check -> route to manager or procurement -> JSON status response.
- Use this as a base for approval chain automation with real notification/integration nodes.

Example test payload for `06`:

```json
{
    "request_id": "REQ-2026-0007",
    "requester": "Ekhsan",
    "department": "Procurement",
    "item": "Network Switch",
    "amount": 12800,
    "manager_email": "manager@example.com",
    "procurement_queue": "procurement-team"
}
```

Fifth practical workflow template:

- `07_manager_decision_callback_stub.json`: Manager callback webhook -> decision normalization -> approve/reject branching -> JSON response.
- Use this as the second endpoint after `06` to complete the decision handoff.

Example test payload for `07`:

```json
{
    "request_id": "REQ-2026-0007",
    "decision": "approve",
    "amount": 12800,
    "manager_email": "manager@example.com",
    "comment": "Approved for Q2 operations"
}
```

Sixth practical workflow template:

- `08_requester_notification_stub.json`: Decision payload intake -> approved/rejected message generation -> channel-ready output.
- Use this after `07` to notify requester by Email/Telegram/Slack/Teams.

Example test payload for `08`:

```json
{
    "request_id": "REQ-2026-0007",
    "requester_name": "Ekhsan",
    "requester_email": "requester@example.com",
    "decision": "approved",
    "amount": 12800,
    "manager_comment": "Approved for Q2 operations"
}
```

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
- The compose file includes a healthcheck so container status reflects real service readiness.
- For webhook smoke testing, import and activate workflows `06`, `07`, and `08` in n8n.

## CI

- GitHub Actions validates that example workflow JSON files are syntactically correct on each push and pull request.
