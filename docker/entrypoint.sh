#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 0 ]]; then
    exec "$@"
fi

PORT="${FEYNMAN_PORT:-8787}"
WORKSPACE="${FEYNMAN_WORKSPACE:-/workspace}"
NO_AUTH="${FEYNMAN_NO_AUTH:-true}"

mkdir -p /config "$WORKSPACE"
cd "$WORKSPACE"

args=(
    feynman serve
    --host 0.0.0.0
    --port "$PORT"
    --no-open
)

case "${NO_AUTH,,}" in
    1|true|yes|on)
        args+=(--no-auth)
        echo "WARNING: Feynman Workbench authentication is disabled. Use only on a trusted LAN or behind an authenticated reverse proxy."
        ;;
    *)
        echo "Feynman Workbench token authentication is enabled. Check container logs for the generated URL/token after each start."
        ;;
esac

echo "Starting Feynman Workbench on 0.0.0.0:${PORT}"
echo "Workspace: ${WORKSPACE}"
exec "${args[@]}"
