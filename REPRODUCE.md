MCB Data Integration — Reproduction Guide

This document explains how to reproduce and run the MCB Data Integration demo stack (DB2, PostgreSQL, poller, monitoring) on another computer. It includes prerequisites, exact Docker Compose commands, verification steps, and how to insert test data into DB2 and verify it was piped into PostgreSQL.

WARNING

- The DB2 image (ibmcom/db2) requires accepting IBM's license and uses privileged container features. Only run this in a safe test environment (not production).
- This guide assumes the repository root is the working directory (where this file lives).

Prerequisites

- macOS / Linux / Windows with Docker Desktop installed and running.
  - Docker Compose v2 (`docker compose ...`) is preferred. If you only have the old `docker-compose` binary the equivalent commands are provided.
- At least 8GB RAM recommended for DB2 + Postgres + other services.
- Git (if cloning repository)

Quick start (full stack)

1. Clone the repo (if required):

```bash
git clone <repo-url> mcb
cd mcb
```

2. Build and start the full stack (detached):

```bash
# Preferred (Docker Compose v2)
docker compose up --build -d

# OR if you must use the old binary
# docker-compose up --build -d
```

3. Wait for DB2 and Postgres to become healthy (DB2 may take a couple minutes on first start).

Check service status:

```bash
docker compose ps
# OR
docker-compose ps
```

Accessing services

- Monitoring web UI (Flask + front-end): http://localhost:5000
- WebSocket server (monitoring): ws://localhost:8765 (used by the front-end)
- Postgres (inside container)
  - Host port: 5432 -> container `postgres`
  - DB: bot_db, user: postgres, password: postgres
- DB2 (inside container)
  - Host port: 50000 -> container `db2`

Verify monitoring API

```bash
curl -sS http://localhost:5000/api/status | jq
curl -sS http://localhost:5000/api/metrics | jq
curl -sS http://localhost:5000/api/tables | jq
```

(If you don't have `jq` installed, just run curl without it.)

How the pipeline works (overview)

- `poller` container reads from DB2 schema `CBS_SCHEMA` (tables like `PERSONAL_DATA_INDIVIDUALS`) and writes to Postgres `bot_personal_data_individuals`.
- `monitoring` container runs a Flask API (port 5000) and a WebSocket background server (port 8765) that provide metrics and real-time updates to the front-end.

Insert a test row into DB2 (example)

- The `PERSONAL_DATA_INDIVIDUALS` table is created by `create_db2_tables.sql`. The only column required by DDL is `REPORTINGDATE` (NOT NULL). Below is a safe minimal INSERT that sets a handful of fields.

Copy/paste this exact command into your shell (zsh):

```bash
cd /Users/shauritanga/Desktop/MCB  # or the repo root
# Insert a test row into DB2, commit, and show new row count
docker exec -it db2 bash -lc "su - db2inst1 -c \"db2 connect to cbs_db; \
  db2 \\\"insert into CBS_SCHEMA.PERSONAL_DATA_INDIVIDUALS \
  (REPORTINGDATE, CUSTOMERIDENTIFICATIONNUMBER, FIRSTNAME, SURNAME, GENDER, DATEOFBIRTH, MOBILENUMBER, EMAILADDRESS, COUNTRY) \
  values ('071020251200','CUST12345','John','Doe','M','19800101','255712345678','john.doe@example.com','Tanzania')\\\"; \
  db2 \\\"commit\\\"; \
  db2 \\\"select count(*) from CBS_SCHEMA.PERSONAL_DATA_INDIVIDUALS\\\"\""
```

Notes:

- The quoting is intentionally verbose because we're invoking `docker exec` -> `su - db2inst1 -c` -> `db2 "..."`. If you copy the single-line command above it will run correctly in a zsh shell.
- Change `REPORTINGDATE` to an appropriate value if you prefer a different reporting stamp.

Verify DB2 row exists

```bash
docker exec -it db2 bash -lc "su - db2inst1 -c \"db2 connect to cbs_db; db2 \"select count(*) from CBS_SCHEMA.PERSONAL_DATA_INDIVIDUALS\"\""
```

(You can also `select *` with `fetch first 5 rows only` to preview rows.)

Check whether the row was piped to Postgres (target table)

```bash
# Show table structure in Postgres (useful to confirm column names)
docker exec -it postgres psql -U postgres -d bot_db -c "\d+ bot_personal_data_individuals"

# Count rows
docker exec -it postgres psql -U postgres -d bot_db -c "SELECT count(*) FROM bot_personal_data_individuals;"

# Find the inserted test record (customer id CUST12345)
docker exec -it postgres psql -U postgres -d bot_db -c "SELECT * FROM bot_personal_data_individuals WHERE LOWER(customeridentificationnumber) = LOWER('CUST12345') LIMIT 5;"
```

If the record is not present in Postgres

- Check `poller` container logs for errors:

```bash
docker logs --tail 200 poller
# OR to follow
docker logs -f poller
```

- Look for DB2 connection errors or insert errors in logs.
- Check `docker compose ps` to confirm `poller` is running.

Start only monitoring (dev fast loop)

- To start only the monitoring service and skip DB services (useful for front-end development; monitoring will show fallback sample data when DBs are not reachable):

```bash
docker compose up --build -d --no-deps monitoring
# OR docker-compose up --build -d --no-deps monitoring
```

Useful debugging / helper commands

```bash
# Show all containers and their status
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

# Show last 200 lines of a service's logs
docker logs --tail 200 monitoring

docker logs --tail 200 poller

# Connect to Postgres interactively
docker exec -it postgres psql -U postgres -d bot_db

# Connect to monitoring container shell
docker exec -it mcb-monitoring bash

# Test WebSocket endpoint from your machine (example using websocat)
# Install websocat: brew install websocat
websocat ws://localhost:8765
```

Troubleshooting

- If `db2` container fails to start the first time, make sure Docker has enough RAM and privileged mode is allowed on your system. DB2 container in the compose uses `privileged: true`.
- If `db2` shows connection refused, check container health with `docker logs db2` and give it time for initial setup (it can take a few minutes).
- If the poller is not copying rows, check for errors in `docker logs poller` (look for SQL errors or connection problems to DB2/Postgres).
- If the monitoring UI displays mock data only, the monitoring container couldn't fetch data from DBs or the poller; check monitoring logs:

```bash
docker logs --tail 200 mcb-monitoring
```

Optional — bulk loading sample rows

- I can generate a `sample_personal_data.csv` and a small shell script that loads it into DB2 or Postgres if you want to stress-test the pipeline.

Next steps I can help with

- Provide a small script to automate the insert -> wait -> verify workflow.
- Create a `monitoring/README.md` with focused front-end dev instructions.
- Generate a sample CSV and loader script for bulk inserts into DB2.

If you run the commands and paste the outputs (describe/SELECT results, `docker logs poller`), I will analyze and propose any necessary fixes or improvements.

## DB2 schema creation (ensure CBS_SCHEMA and tables exist)

The repository includes the DDL in `create_db2_tables.sql`. The Docker Compose expects an initialization file at `./init_db2.sql` which is mounted into the DB2 container at `/database/init_db2.sql`. If `init_db2.sql` is missing or is a directory, DB2 won't run the DDL automatically. Use one of the approaches below to ensure the schema is present.

1. Manual (recommended if DB2 container is already running)

Copy the DDL into the container and execute it as the DB2 instance user:

```bash
# from the repo root
docker cp create_db2_tables.sql db2:/tmp/create_db2_tables.sql

# run the script inside the container
docker exec -it db2 bash -lc 'su - db2inst1 -c "db2 connect to cbs_db; db2 -tvf /tmp/create_db2_tables.sql"'

# verify (describe table or count rows)
docker exec -it db2 bash -lc 'su - db2inst1 -c "db2 connect to cbs_db >/dev/null 2>&1; db2 \"describe table CBS_SCHEMA.PERSONAL_DATA_INDIVIDUALS\""'
docker exec -it db2 bash -lc 'su - db2inst1 -c "db2 connect to cbs_db >/dev/null 2>&1; db2 \"select count(*) from CBS_SCHEMA.PERSONAL_DATA_INDIVIDUALS\""'
```

2. Make it automatic (fix the repo for future runs)

If `init_db2.sql` is currently a directory, recreate it as a file so the compose mount provides a SQL file to the image:

```bash
# careful: remove any existing directory named init_db2.sql first
rm -rf init_db2.sql
cp create_db2_tables.sql init_db2.sql

# recreate the db2 container so it sees the init script on startup
docker compose up -d --force-recreate db2
```

3. Notes & caveats

- DB2 container initialization may take several minutes; watch `docker logs db2`.
- Re-running the same DDL may produce "object already exists" errors; if you need idempotent behavior edit the SQL or check existence first.
- After the schema is created, the poller should be able to read from DB2 and write into Postgres. Tail `docker logs poller` to confirm data flow.

If you'd like, I can modify the repository now to create `init_db2.sql` from `create_db2_tables.sql` so future `docker compose up` runs on a fresh machine will initialize DB2 automatically — say the word and I'll apply that change.
