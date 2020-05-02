#!/bin/bash
set -e
echo "Starting init of grafana db role and schema"
if [ -z "${GRAFANA_USER}" ]
then
  echo "GRAFANA_USER env not set, skipping create grafana role"
  exit 0
fi
if [ -z "${GRAFANA_PASSWORD}" ]
then
  echo "GRAFANA_PASSWORD env not set, skipping create grafana role"
  exit 0
fi
if [ -z "${GRAFANA_SCHEMA}" ]
then
  echo "GRAFANA_SCHEMA env not set, using public"
  GRAFANA_SCHEMA="public"
fi
echo "Creating db user ${GRAFANA_USER} and schema ${GRAFANA_SCHEMA}"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE $GRAFANA_USER WITH LOGIN PASSWORD '$GRAFANA_PASSWORD';
    CREATE SCHEMA IF NOT EXISTS $GRAFANA_SCHEMA AUTHORIZATION $GRAFANA_USER;
    ALTER ROLE $GRAFANA_USER SET search_path = $GRAFANA_SCHEMA;
EOSQL