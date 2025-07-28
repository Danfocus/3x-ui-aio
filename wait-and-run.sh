#!/bin/sh
set -e

echo "Waiting for .env.generated..."
while [ ! -f /var/lib/angie/acme/.env.generated ]; do
  sleep 1
done

echo "Loading environment variables..."
set -a
. /var/lib/angie/acme/.env.generated
set +a

echo "Starting service: $@"
exec "$@"
