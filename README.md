# MCB Real-Time Data Integration — local demo

This repository is a compact, reproducible demo of a real-time data integration pipeline that reads source data from an IBM DB2 schema and replicates it to PostgreSQL. It also includes a small monitoring service (Flask + WebSocket) and a single-page dashboard to visualize processing counts, recent logs and system resource snapshots.

This README focuses on how to run the repository locally (Docker Compose), how to initialize DB2, how to verify replicated data, and where to find the monitoring UI and APIs.

## What is in this repo

- `docker-compose.yml` — Compose file that defines four services: `db2`, `postgres`, `poller`, and `monitoring`.
- `create_db2_tables.sql` — DB2 DDL (schema + tables + sample INSERT) used to seed DB2.
- `init_db2.sql` — init script mounted into the DB2 container (used on first run).
- `poller/` — poller application that reads DB2 and writes to Postgres (image built from `poller/Dockerfile`).
- `monitoring/` — Flask API (`api.py`), WebSocket server (`websocket_server.py`), templates and static UI files.

## Quickstart (recommended)

Requirements

- Docker and Docker Compose (v2) available on your machine.

Start the entire stack:

```bash
docker compose up -d --build
```

This builds the `monitoring` and `poller` images and starts the `db2`, `postgres`, `poller`, and `monitoring` services.

Wait for health checks

DB2 can take some time to initialize. Check service status with:

```bash
docker compose ps

docker logs db2 --tail 200
```

If DB2 was started previously with a persistent volume the `init_db2.sql` may not be re-applied automatically (see DB2 init section below).

Open the monitoring UI

- Dashboard (Flask): http://localhost:5000
- WebSocket (used by the dashboard): ws://localhost:8765

The UI shows processed-record counts (from Postgres), a small recent log view, and system resource bars (CPU, memory, disk, network cumulative bytes).

## DB2 initialization and sample data

The SQL to create `CBS_SCHEMA` and the two sample tables is in `create_db2_tables.sql`. The file `init_db2.sql` is mounted into the DB2 container so the container can run it at first boot. If your DB2 container already has a persistent volume, the init script will not re-run.

To manually apply the schema inside the DB2 container:

```bash
# copy init SQL into container
docker cp create_db2_tables.sql db2:/tmp/init.sql

# run the SQL as the DB2 instance owner
docker exec -it db2 bash -lc "su - db2inst1 -c \"db2 connect to cbs_db && db2 -tvf /tmp/init.sql\""
```

To insert a test row (example):

```bash
docker exec -it db2 bash -lc "su - db2inst1 -c \"db2 connect to cbs_db && db2 \"INSERT INTO CBS_SCHEMA.PERSONAL_DATA_INDIVIDUALS (REPORTINGDATE, CUSTOMERIDENTIFICATIONNUMBER, FIRSTNAME, SURNAME, CREATEDDATE) VALUES ('07102025','TEST-001','Jane','Doe', CURRENT TIMESTAMP)\"\""
```

Note: the DB2 commands above run inside the container and assume the default `db2inst1` account (as configured in `docker-compose.yml`).

## Verify DB2 → Postgres replication

1. Tail the poller logs to ensure it's running and processing:

```bash
docker logs poller -f --tail 200
```

2. Query Postgres to see replicated rows:

```bash
docker exec -it postgres psql -U postgres -d bot_db -c "SELECT COUNT(*) FROM bot_personal_data_individuals;"
```

If counts are not changing, check `poller` logs for errors and confirm DB2 connectivity.

## Monitoring service (how it works)

- REST endpoint: `GET /api/metrics` (http://localhost:5000/api/metrics)

  - Returns JSON with keys: `polling` (records counts), `errors` (recent log messages), `resources` (system snapshot), `timestamp`.

- WebSocket server: ws://localhost:8765
  - Broadcasts the same JSON payload to connected clients every few seconds.

If the dashboard shows demo/static values:

```bash
curl http://localhost:5000/api/metrics | jq
docker logs mcb-monitoring -f --tail 200
```

## Development notes & design decisions

- `monitoring/Dockerfile.monitoring` installs Python dependencies from `monitoring/requirements.txt` and starts both `websocket_server.py` and `api.py` in the same container for simplicity.
- System resources are sampled using `psutil` and are returned as a small snapshot (cpu_percent, memory_percent, disk_percent, network_bytes_total). The UI shows cumulative network bytes; bandwidth (bytes/sec) requires sampling deltas across time.
- The `poller` service is intentionally simple — it demonstrates the DB2→Postgres flow and the monitoring integration.

## Useful commands

- Start / stop / rebuild the stack

```bash
docker compose up -d --build
docker compose down
docker compose build monitoring
```

- Tail logs

```bash
docker logs -f poller --tail 200
docker logs -f mcb-monitoring --tail 200
```

- Inspect containers

```bash
docker compose ps
docker exec -it postgres psql -U postgres -d bot_db -c "\dt"
```

## Troubleshooting

- Missing Python packages inside `monitoring` container:

```bash
docker compose build monitoring
docker compose up -d monitoring
```

- DB2 init script not applied: either apply manually (see DB2 init section) or recreate DB2 with a fresh volume:

```bash
docker compose down
docker volume rm mcb_db2_data  # adjust volume name if different
docker compose up -d
```

## Ideas / next improvements (optional)

- Extract `get_system_resources()` into a small shared module so `api.py` and `websocket_server.py` share a single implementation.
- Compute network bandwidth (KB/s) by tracking previous counters and exposing deltas.
- Add an automated verification script that inserts test rows into DB2 and asserts they appear in Postgres.
