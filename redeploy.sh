#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
REMOTE="${REMOTE:-ubunew}"
REMOTE_PATH="${REMOTE_PATH:-/opt/noon}"
SSH_OPTS="-i ${SSH_KEY:-$HOME/.ssh/id_rsa} -o StrictHostKeyChecking=accept-new"

echo "[redeploy] build SPA → www/app + www/admin"
if [[ ! -d "${ROOT}/frontend/node_modules" ]]; then
  (cd "${ROOT}/frontend" && npm install)
fi
(cd "${ROOT}/frontend" && npm run build)
rm -rf "${ROOT}/www/app" "${ROOT}/www/admin"
cp -a "${ROOT}/frontend/dist" "${ROOT}/www/app"
cp -a "${ROOT}/frontend/dist-admin" "${ROOT}/www/admin"

echo "[redeploy] rsync db + www → ${REMOTE}:${REMOTE_PATH}/"
rsync -avz --delete -e "ssh ${SSH_OPTS}" \
  "${ROOT}/db/migration/" "${REMOTE}:${REMOTE_PATH}/db/migration/"
rsync -avz -e "ssh ${SSH_OPTS}" \
  --exclude 'debug.log' \
  "${ROOT}/www/" "${REMOTE}:${REMOTE_PATH}/www/"

echo "[redeploy] wipe MySQL volume + flyway migrate..."
ssh ${SSH_OPTS} "${REMOTE}" bash -s -- "${REMOTE_PATH}" <<'REMOTE'
set -euo pipefail
cd "$1"
docker compose down -v
docker compose up -d
docker logs noon-flyway 2>&1 | tail -15
MYSQL_ROOT_PASSWORD="$(grep -E '^MYSQL_ROOT_PASSWORD=' .env | tail -1 | cut -d= -f2- | tr -d "\"'")"
docker exec noon-mysql mysql -uroot -p"$MYSQL_ROOT_PASSWORD" noon -N -e "
SELECT CONCAT('flyway v', MAX(version)) FROM flyway_schema_history WHERE success=1;
SELECT CONCAT('elements=', COUNT(*)) FROM objects WHERE class=1;
SELECT CONCAT('ores=', COUNT(*)) FROM objects WHERE class=5;
SELECT CONCAT('chat=', COUNT(*)) FROM chat;
SELECT CONCAT('war_log=', COUNT(*)) FROM war_log;
SELECT CONCAT('co2=', name) FROM objects WHERE id=5001;
"
REMOTE

echo "[redeploy] done"
