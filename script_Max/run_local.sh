#!/usr/bin/env bash
set -euo pipefail

# One-click local demo runner for My RIME
# - Installs dependencies
# - Approves esbuild postinstall
# - Downloads prebuilt worker.js
# - Starts Vite dev server
#
# Options:
#   --proxy HOST:PORT       Set HTTP(S) proxy, e.g. 127.0.0.1:7890
#   --skip-install          Skip pnpm install
#   --refresh-worker        Force redownload worker.js
#   --port PORT             Dev server port (default 5173)
#   -h, --help              Show usage

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

PORT="${PORT:-5173}"
PROXY_ARG=""
SKIP_INSTALL="false"
REFRESH_WORKER="false"

usage() {
  echo "Usage: $(basename "$0") [--proxy HOST:PORT] [--skip-install] [--refresh-worker] [--port PORT]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --proxy)
      shift
      PROXY_ARG="${1:-}"
      ;;
    --proxy=*)
      PROXY_ARG="${1#*=}"
      ;;
    --skip-install)
      SKIP_INSTALL="true"
      ;;
    --refresh-worker)
      REFRESH_WORKER="true"
      ;;
    --port)
      shift
      PORT="${1:-5173}"
      ;;
    --port=*)
      PORT="${1#*=}"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift || true
done

echo "==> Working directory: ${REPO_ROOT}"

if ! command -v pnpm >/dev/null 2>&1; then
  echo "Error: pnpm not found. Install it via: npm i -g pnpm"
  exit 1
fi

if [[ "${SKIP_INSTALL}" != "true" ]]; then
  echo "==> Installing dependencies with pnpm..."
  pnpm i
fi

echo "==> Approving esbuild postinstall (required by Vite/Rollup)..."
echo "    Command: pnpm approve-builds esbuild"
pnpm approve-builds esbuild || true

WORKER_PATH="public/worker.js"
WORKER_URL="https://cdn.jsdelivr.net/npm/@libreservice/my-rime@0.10.9/dist/worker.js"
if [[ "${REFRESH_WORKER}" == "true" || ! -f "${WORKER_PATH}" ]]; then
  echo "==> Downloading prebuilt worker.js..."
  curl -L "${WORKER_URL}" -o "${WORKER_PATH}"
else
  echo "==> Using existing ${WORKER_PATH}"
fi

if [[ -n "${PROXY_ARG}" ]]; then
  echo "==> Setting proxy to ${PROXY_ARG}"
  export HTTP_PROXY="http://${PROXY_ARG}"
  export HTTPS_PROXY="http://${PROXY_ARG}"
  export http_proxy="${HTTP_PROXY}"
  export https_proxy="${HTTPS_PROXY}"
fi

echo "==> Starting Vite dev server on port ${PORT}..."
echo "    Open http://localhost:${PORT}/ after server starts."
exec pnpm run dev -- --port "${PORT}"