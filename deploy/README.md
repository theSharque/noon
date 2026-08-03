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

`deploy.sh` builds `noon-php` / `noon-nginx` / `noon-cron`, copies `db/` and `docker/mysql/`
from the repo root into a temporary bundle, rsyncs to the server, then removes local copies
and tarballs. **Flyway migrations live only in `db/migration/` at the repo root** — do not
edit `deploy/db/` (it is recreated each deploy and not tracked in git).

From the repo-root `.env`, `RESEND_API_KEY`, `EMAIL_FROM`, and `PUBLIC_BASE_URL` are merged
into the server `/opt/noon/.env` on each deploy (MySQL passwords on the server are left unchanged).

Force-recreates app containers and verifies that php and nginx serve the **same** SPA
bundle (`page.php` reads `/var/www/noon/app/index.html` from php; static `/app/` from nginx).

After first deploy, issue certificate from edge:

```bash
cd /qs/edge
ISSUE_NOON_CERT=1 ./deploy.sh
```

## Local development

Root `docker-compose.yml` — ports `3080` (nginx) and `3306` (mysql).
Both php and nginx Dockerfiles build `frontend/` into `/var/www/noon/app`.
