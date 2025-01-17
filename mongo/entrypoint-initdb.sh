
#!/usr/bin/env bash
set -euo pipefail

MONGO_NON_ROOT_ROLE="${MONGO_NON_ROOT_ROLE:-readWrite}"

if [[ -n "${MONGO_NON_ROOT_USERNAME:-}" ]] &&
   [[ -n "${MONGO_NON_ROOT_PASSWORD:-}" ]]; then
  "${mongo[@]}" "$MONGO_INITDB_DATABASE" <<-EOJS
    db.createUser({
      user: $(_js_escape "$MONGO_NON_ROOT_USERNAME"),
      pwd: $(_js_escape "$MONGO_NON_ROOT_PASSWORD"),
      roles: [
        {
          role: $(_js_escape "$MONGO_NON_ROOT_ROLE"),
          db: $(_js_escape "$MONGO_INITDB_DATABASE")
        }
      ]
    })
EOJS
else
  printf 'Please specify MONGO_NON_ROOT_USERNAME and MONGO_NON_ROOT_PASSWORD\n'
  exit 1
fi
