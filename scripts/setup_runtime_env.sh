#!/usr/bin/env bash
set -Eeuo pipefail

target="${SHOWCASE_ENV_FILE:-/tmp/showcase-e2e.env}"
read -r -p 'Showcase API base URL: ' base_url
read -r -p 'Showcase test email: ' email
read -r -s -p 'Showcase test password: ' password
printf '\n'

umask 077
cat > "$target" <<EOF
BASE_URL=$(printf '%q' "$base_url")
E2E_EMAIL=$(printf '%q' "$email")
E2E_PASSWORD=$(printf '%q' "$password")
EOF
chmod 600 "$target"
unset password base_url

echo "Runtime credential file created: $target"
echo "Mode: $(stat -c '%a' "$target")"
