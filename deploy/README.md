# Noon deploy

Production stack at `/opt/noon`. TLS on shared edge (`/qs/edge`).

## Setup

```bash
cp deploy.sh.example deploy.sh
chmod +x deploy.sh
```

## Deploy

```bash
./deploy.sh
```

Requires Docker network `edge` (create via edge deploy).

After first deploy, issue certificate from edge:

```bash
cd /qs/edge
ISSUE_NOON_CERT=1 ./deploy.sh
```

## Local development

Root `docker-compose.yml` — ports `3080` (nginx) and `3306` (mysql).
