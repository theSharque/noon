# Noon deploy

Production stack at `/opt/noon`. TLS on shared edge (`/qs/edge`).

## Setup

```bash
cp _deploy.sh.example deploy.sh
chmod +x deploy.sh
```

## Deploy

```bash
./deploy.sh
```

Requires Docker network `edge` (create via edge deploy).

Default deploy is **files-only**:
1. `npm run build` → copy into `www/app` + `www/admin`
2. rsync `www/`, `db/`, compose, env sync to `/opt/noon`
3. recreate php/nginx/cron so they share bind-mount `./www`

**Runtime images are not transferred** on every deploy. When Dockerfiles / nginx.conf /
PHP extensions change:

```bash
DEPLOY_IMAGES=1 ./deploy.sh
```

`php`, `nginx`, and `cron` all mount the same host path `./www` → `/var/www/noon`, so SPA
hashes cannot diverge. Flyway migrations stay in repo-root `db/migration/` (copied into the
temporary bundle under `deploy/.tmp/`, gitignored).

From the repo-root `.env`, `RESEND_API_KEY`, `EMAIL_FROM`, and `PUBLIC_BASE_URL` are merged
into the server `/opt/noon/.env` on each deploy (MySQL passwords on the server are left unchanged).

After first deploy, issue certificate from edge:

```bash
cd /qs/edge
ISSUE_NOON_CERT=1 ./deploy.sh
```

## Local development

Root `docker-compose.yml` — ports `3080` (nginx) and `3306` (mysql).
`./www` is bind-mounted into php/nginx/cron. Build SPA with `./local-deploy.sh --skip-icons`
(or `cd frontend && npm run build` then copy `dist`/`dist-admin` into `www/app`/`www/admin`).
