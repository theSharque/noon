#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

SKIP_ICONS=false
USE_CACHE=false

usage() {
  cat <<'EOF'
Local deploy: rebuild planet icons, then php + nginx containers.

Usage: ./local-deploy.sh [options]

Options:
  --skip-icons   Skip icon reprocessing (frontend-only change)
  --cache        Use Docker layer cache (faster, may miss changes)
  -h, --help     Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-icons) SKIP_ICONS=true ;;
    --cache) USE_CACHE=true ;;
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

BUILD_ARGS=(build)
if ! $USE_CACHE; then
  BUILD_ARGS+=(--no-cache)
fi
BUILD_ARGS+=(php nginx)

echo "==> docker compose ${BUILD_ARGS[*]}"
docker compose "${BUILD_ARGS[@]}"

echo "==> docker compose up -d php nginx"
docker compose up -d php nginx

PHP_JS="$(docker compose exec -T php grep -o 'index-[^"]*\.js' /var/www/noon/app/index.html | head -1)"
NGINX_JS="$(docker compose exec -T nginx sh -c 'basename "$(ls /var/www/noon/app/assets/*.js)"')"

echo "==> Done"
echo "    php   index: $PHP_JS"
echo "    nginx index: $NGINX_JS"

if [[ "$PHP_JS" != "$NGINX_JS" ]]; then
  echo "WARNING: php and nginx asset hashes differ — hard refresh may not be enough" >&2
  exit 1
fi

PORT="${NGINX_PORT:-3080}"
if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  val="$(grep -E '^NGINX_PORT=' .env | tail -1 | cut -d= -f2- | tr -d "\"'")"
  [[ -n "$val" ]] && PORT="$val"
fi

echo "    http://localhost:${PORT}/"
