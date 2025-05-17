#!/usr/bin/env bash
set -euo pipefail

# Ensure required environment variables are set
if [[ -z "${POSTGRES_USER:-}" || -z "${POSTGRES_DB:-}" ]]; then
  echo "Error: POSTGRES_USER and POSTGRES_DB must be set" >&2
  exit 1
fi

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -a -f /app/scripts/db/seed.sql