#!/usr/bin/env bash
# Start cmc-userdb under procServ (no root needed).
# INSTALL_DIR defaults to the checkout this script is in (override: INSTALL_DIR=... bash deploy/procserv-start.sh).

set -euo pipefail

SERVICE_USER="${USER}"
CONDA_PATH="${HOME}/anaconda3"
CONDA_ENV="cmc-userdb"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_DIR="${INSTALL_DIR:-$REPO_ROOT}"
CTRL_PORT=60640   # procServ management port — choose a free port
LOG_FILE=/tmp/cmc-userdb.log
SECRETS="/etc/cmc-userdb/secrets.env"

ENV_UVICORN="$CONDA_PATH/envs/$CONDA_ENV/bin/uvicorn"

# Load credentials
[ -f "$SECRETS" ] && set -a && source "$SECRETS" && set +a

exec procServ \
    --logfile "$LOG_FILE" \
    --name cmc-userdb \
    --noautorestart \
    "$CTRL_PORT" \
    "$ENV_UVICORN" app.main:app \
        --app-dir "$INSTALL_DIR" \
        --host 0.0.0.0 \
        --port "${PORT:-8088}" \
        --log-level info
