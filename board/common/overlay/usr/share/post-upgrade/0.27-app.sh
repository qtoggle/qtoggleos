#!/bin/bash

# Transform Postgres `value_history` table from the old JSONB format to new time-series (id, oid, ts, val) format.

function run_psql_cmd() {
    psql -U postgres -d qtoggleserver -c "$1"
}

# Don't perform migration unless:
#  - postgres is running
#  - our database `qtoggleserver` is present
#  - it has table `value_history`
#  - table `value_history` has the jsonb content field (i.e. not yet migrated)
run_psql_cmd "\d value_history" 2>/dev/null | grep -q jsonb || exit 0

run_psql_cmd "ALTER TABLE value_history RENAME TO value_history_old;"
run_psql_cmd "SELECT id::BIGINT, TRIM((content->'pid')::TEXT, '\"') AS oid, (content->'ts')::BIGINT AS ts, CASE WHEN content->'val' = 'false' THEN 0 WHEN content->'val' = 'true' THEN 1 ELSE (content->'val')::double precision END AS val INTO value_history FROM value_history_old;"
run_psql_cmd "ALTER TABLE value_history ALTER COLUMN id SET DEFAULT NEXTVAL('value_history_id_seq');"
run_psql_cmd "ALTER TABLE value_history ADD PRIMARY KEY (id);"
