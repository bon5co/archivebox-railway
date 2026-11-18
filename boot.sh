#!/bin/sh
# Railway boot for ArchiveBox. Runs as the archivebox user, after upstream's entrypoint has repaired /data.
set -u
: "${PORT:=8080}"
if [ -z "${ADMIN_PASSWORD:-}" ] || [ "${#ADMIN_PASSWORD}" -lt 8 ]; then
  echo "[railway] ADMIN_PASSWORD must be set and at least 8 characters; refusing to start an archive with no administrator" >&2
  exit 1
fi
if [ -z "${SECRET_KEY:-}" ]; then
  echo "[railway] SECRET_KEY is not set; upstream would generate a new one on every start and drop every session" >&2
  exit 1
fi
# BASE_URL decides which host the control plane answers on (the API and sign-in refuse any other host). Take the Railway domain
# unless the deployer set their own.
if [ -z "${BASE_URL:-}" ]; then
  if [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
    BASE_URL="https://$RAILWAY_PUBLIC_DOMAIN"
  else
    echo "[railway] no BASE_URL and no RAILWAY_PUBLIC_DOMAIN; add a public domain to the service or set BASE_URL" >&2
    exit 1
  fi
fi
export BASE_URL
: "${CSRF_TRUSTED_ORIGINS:=$BASE_URL}"
export CSRF_TRUSTED_ORIGINS
echo "[railway] ArchiveBox on 0.0.0.0:$PORT, BASE_URL=$BASE_URL, security mode $SERVER_SECURITY_MODE, public index $PUBLIC_INDEX"
exec archivebox server --init "0.0.0.0:$PORT"
