#!/bin/bash
# Runs once, on first start of an empty Postgres volume.
# Creates one database and one owning login role per service, so no service can read another's
# tables (database-per-service inside a single container to save memory).
set -euo pipefail

create_service_db() {
  local db="$1" user="$2" password="$3"
  # psql variables (:"x" = identifier, :'x' = literal) keep values safely quoted.
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres \
    -v db="$db" -v user="$user" -v password="$password" <<'EOSQL'
CREATE ROLE :"user" LOGIN PASSWORD :'password';
CREATE DATABASE :"db" OWNER :"user";
REVOKE ALL ON DATABASE :"db" FROM PUBLIC;
EOSQL
  echo "created database $db (owner $user)"
}

create_service_db account_db      account_user      "$ACCOUNT_DB_PASSWORD"
create_service_db payment_db      payment_user      "$PAYMENT_DB_PASSWORD"
create_service_db ledger_db       ledger_user       "$LEDGER_DB_PASSWORD"
create_service_db notification_db notification_user "$NOTIFICATION_DB_PASSWORD"
