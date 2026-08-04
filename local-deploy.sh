#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

SKIP_ICONS=false
REBUILD_IMAGES=false

usage() {
  cat <<'EOF'
Local deploy: build SPA into www/, optionally rebuild planet icons / runtime images.

Usage: ./local-deploy.sh [options]

Options:
  --skip-icons      Skip icon reprocessing (frontend-only change)
  --rebuild-images  Rebuild noon-php / noon-nginx images (runtime Dockerfile changes)
  -h, --help        Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-icons) SKIP_ICONS=true ;;
    --rebuild-images|--cache) REBUILD_IMAGES=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
  shift
done

if ! $SKIP_ICONS; then
  if ! command -v python3 >/dev/null; then
    echo "python3 is required for icon processing" >&2
    exit 1
  fi
  if ! python3 -c "import PIL" 2>/dev/null; then
    echo "Install Pillow: pip install pillow" >&2
    exit 1
  fi
  if [[ ! -d old_data/p ]]; then
    echo "Missing source dir: old_data/p" >&2
    exit 1
  fi

  shopt -s nullglob
  sources=(old_data/p/*.png)
  shopt -u nullglob
  if [[ ${#sources[@]} -eq 0 ]]; then
    echo "No PNG sources in old_data/p" >&2
    exit 1
  fi

  echo "==> Rebuilding ${#sources[@]} planet icons from old_data/p/"
  for src in "${sources[@]}"; do
    letter="$(basename "$src" .png)"
    python3 old_data/planet_icon.py "$src" -l "$letter"
  done
else
  echo "==> Skipping icon reprocessing"
fi

echo "==> Building SPA → www/app + www/admin"
if [[ ! -d frontend/node_modules ]]; then
  (cd frontend && npm install)
fi
(cd frontend && npm run build)
rm -rf www/app www/admin
cp -a frontend/dist www/app
cp -a frontend/dist-admin www/admin
mkdir -p www/locks

if $REBUILD_IMAGES; then
  echo "==> docker compose build php nginx cron"
  docker compose build php nginx cron
fi

echo "==> docker compose up -d php nginx cron"
docker compose up -d php nginx cron

PHP_JS="$(docker compose exec -T php grep -o 'index-[^"]*\.js' /var/www/noon/app/index.html | head -1)"
NGINX_JS="$(docker compose exec -T nginx sh -c 'basename "$(ls /var/www/noon/app/assets/*.js)"')"

echo "==> Done"
echo "    php   index: $PHP_JS"
echo "    nginx index: $NGINX_JS"

if [[ "$PHP_JS" != "$NGINX_JS" ]]; then
  echo "WARNING: php and nginx asset hashes differ — shared www mount broken?" >&2
  exit 1
fi

PORT="${NGINX_PORT:-3080}"
if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  val="$(grep -E '^NGINX_PORT=' .env | tail -1 | cut -d= -f2- | tr -d "\"'")"
  [[ -n "$val" ]] && PORT="$val"
fi

echo "    http://localhost:${PORT}/"
