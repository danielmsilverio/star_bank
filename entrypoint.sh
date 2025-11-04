#!/usr/bin/env bash
set -euo pipefail

echo "MIX_ENV=${MIX_ENV:-dev}"

# Optional: wait for Postgres to accept TCP connections
DB_HOST=${POSTGRES_HOST:-localhost}
DB_PORT=${POSTGRES_PORT:-5432}

echo "Waiting for Postgres at ${DB_HOST}:${DB_PORT}..."
retries=30
until (echo > /dev/tcp/${DB_HOST}/${DB_PORT}) >/dev/null 2>&1; do
  retries=$((retries-1))
  if [ $retries -le 0 ]; then
    echo "Postgres did not become available on ${DB_HOST}:${DB_PORT} in time" >&2
    exit 1
  fi
  sleep 1
done

echo "Running mix ecto.setup (create + migrate + seeds, idempotent)..."
if ! mix ecto.setup; then
  echo "mix ecto.setup returned non-zero; continuing (database may already exist)"
fi

echo "Starting Phoenix..."
exec "$@"
