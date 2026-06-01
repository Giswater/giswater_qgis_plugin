# giswater-admin

Headless CLI and engine for the Giswater database schema lifecycle (create, upgrade, drop, inspect). It reads the same YAML manifests under `dbmodel/manifests/` and runs the same `SchemaBuilder` as the QGIS plugin (`GwSchemaBuilderTask` + `QtDbAdapter`), so automation, CI, and the desktop UI do not diverge on SQL execution logic.

**See also:** [dbmodel README — Schema architecture](../dbmodel/README.md#schema-architecture) · [dbmodel README — Testing](../dbmodel/README.md#testing)

## Table of contents

1. [Overview](#overview)
2. [Where to run it](#where-to-run-it)
3. [Architecture](#architecture)
4. [Install](#install)
5. [Connection](#connection)
6. [Invocation rules](#invocation-rules)
7. [Global options](#global-options)
8. [Commands reference](#commands-reference)
9. [Kinds and manifest profiles](#kinds-and-manifest-profiles)
10. [Timing and output](#timing-and-output)
11. [QGIS integration](#qgis-integration)
12. [Unit tests](#unit-tests)
13. [Extending the model](#extending-the-model)
14. [Keeping docs in sync](#keeping-docs-in-sync)

---

## Overview

| Piece | Role |
|-------|------|
| `giswater_admin/cli.py` | Argument parsing and dispatch |
| `giswater_admin/commands/` | Subcommand handlers (`create`, `update`, …) |
| `giswater_admin/engine/` | `SchemaBuilder`, manifest loader, `sql_runner` |
| `dbmodel/manifests/*.yaml` | Phase graphs per schema kind |
| `dbmodel/schemas/` | SQL sources (DDL, functions, updates, samples) |

Typical flow for a new database:

1. Create an empty PostgreSQL database (outside this CLI).
2. `init-db` — cluster extensions once per database.
3. `create` — build a project schema (`ws`, `ud`, …) from a manifest profile.
4. Optionally `update`, `status`, `drop`.

---

## Where to run it

| Context | Working directory | Command |
|---------|-----------------|---------|
| Plugin repo (recommended) | Repository root (`giswater/`, sibling of `dbmodel/` and `giswater_admin/`) | `python3 -m giswater_admin …` |
| Custom dbmodel tree | Any | Add `--dbmodel-path /path/to/dbmodel` |
| CI / Docker tests | Inside `runner` container | See [dbmodel testing](../dbmodel/README.md#testing) |
| QGIS | N/A (in-process) | `GwSchemaBuilderTask` — no subprocess |

**Requirements:** Python 3.9+, `PyYAML`, `psycopg2-binary` ([requirements.txt](requirements.txt)). PostgreSQL with PostGIS/pgRouting packages on the **server** (not installed by `pip`).

Default `--dbmodel-path` resolves to `../dbmodel` relative to this package (the plugin repo’s `dbmodel/` folder).

---

## Architecture

```mermaid
flowchart TB
  subgraph hosts [Execution contexts]
    CLI["python -m giswater_admin"]
    QGIS["GwSchemaBuilderTask + QtDbAdapter"]
    CI["dbmodel/test/bootstrap_inner.sh"]
  end
  subgraph engine [giswater_admin/engine]
    Manifest["manifests/*.yaml"]
    Builder["SchemaBuilder"]
    Runner["sql_runner"]
  end
  subgraph dbmodel_tree [dbmodel/]
    Schemas["schemas/..."]
    Updates["updates M/m/p"]
  end
  PG[(PostgreSQL)]
  CLI --> Builder
  QGIS --> Builder
  CI --> CLI
  Builder --> Manifest
  Builder --> Runner
  Runner --> Schemas
  Runner --> Updates
  Runner --> PG
```

**Phase types** (declared in manifests, implemented in `engine/manifest.py`):

| Type | Behavior |
|------|----------|
| `sql_dir` | Run every `*.sql` in listed folders (optional `recursive`) |
| `version_walk` | Walk `updates/<M>/<m>/<p>/` semver-ordered; `roots:` for ws/ud (common then kind) |
| `sql_function` | `SELECT schema.fn($${JSON}$$)` (e.g. `lastprocess`) |
| `sql_file` | Single file with optional `fallback_source` |
| `sql_inline` | Literal SQL in YAML |

---

## Install

From the **plugin repository root**:

```bash
cd /path/to/giswater
python3 -m pip install -r giswater_admin/requirements.txt
```

Optional virtualenv:

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r giswater_admin/requirements.txt
```

**OS packages (server side)** — names vary by distro; install PostGIS and pgRouting for your PostgreSQL major version:

- Debian/Ubuntu: `postgresql-16-postgis-3`, `postgresql-16-pgrouting`, …
- macOS (Homebrew): `postgresql@16`, `postgis`
- Windows: PostGIS/pgRouting matching your PostgreSQL installer

Verify:

```bash
python3 -m giswater_admin --help
```

---

## Connection

Resolution order (first match wins):

1. `--conn` — `postgresql://user:pass@host:port/dbname` (or `postgres://…`)
2. `--config` — YAML with `host`, `port`, `user`, `password`, `dbname`, and/or `service`
3. Environment — `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`, `PGSERVICE`

### Linux / macOS

```bash
export CONN='postgresql://gisadmin:secret@127.0.0.1:5432/giswater_cli'
python3 -m giswater_admin status --conn "$CONN"
```

### Windows (PowerShell)

```powershell
$env:CONN = "postgresql://gisadmin:secret@127.0.0.1:5432/giswater_cli"
py -3 -m giswater_admin status --conn $env:CONN
```

### Config file

```yaml
host: 127.0.0.1
port: 5432
user: gisadmin
password: secret
dbname: giswater_cli
```

```bash
python3 -m giswater_admin status --config /path/conn.yaml
```

**`--check`:** many subcommands only print the plan or SQL and do not write to the database. `init-db --check` does not require a connection.

---

## Invocation rules

Global options are on the **parent parser of each subcommand**. They must appear **after** the subcommand name:

```bash
# Correct
python3 -m giswater_admin create --kind ws --schema demo --profile empty --json

# Wrong (root parser does not define --json)
python3 -m giswater_admin --json create ...
```

---

## Global options

Available on subcommands that include the shared parent parser (`create`, `update`, `status`, `drop`, `init-db`, `audit …`, `manifest list|validate`).

| Option | Description |
|--------|-------------|
| `--json` | Single JSON object on **stdout** (for `jq`, CI, scripts). |
| `--quiet` | Suppress info-level progress on stderr; errors/warnings remain. |
| `-v` / `--verbose` | One aligned line per executed SQL path on stderr. |
| `-d` / `--debug` | Like `-v` plus `DEBUG` logs with SQL previews. |
| `--timing` | `── Done … ──` summary (per phase + slowest files). With `-v`, adds ms per file. |
| `--timing-threshold-ms N` | With `-v --timing`, only log files with duration ≥ N ms. |
| `--timing-top K` | Number of slowest files in summary (default: 20). |
| `--timing-detail` | With `--json --timing`, include full per-file list in the JSON payload. |
| `--dbmodel-path DIR` | Root of the dbmodel tree (default: sibling `dbmodel/` in the plugin repo). |

**Connection group** (where applicable):

| Option | Description |
|--------|-------------|
| `--conn` | PostgreSQL URL. |
| `--config` | Path to connection YAML. |

---

## Commands reference

Base syntax:

```text
python3 -m giswater_admin <subcommand> [subcommand options] [global options]
```

Exit codes: **0** success, **1** failure (parse, I/O, PostgreSQL, SQL, invalid plan).

### `init-db`

Creates extensions in order: `postgis` → `postgis_raster` → `tablefunc` → `pgrouting` → `unaccent` (optional `postgres_fdw` with `--with-fdw`). Run **once per database** before the first `create`.

| Option | Description |
|--------|-------------|
| `--with-fdw` | Also `CREATE EXTENSION postgres_fdw`. |
| `--continue-on-error` | Try all extensions after a failure (default: stop on first error). |
| `--check` | Print SQL only; no connection required. |
| `--conn` / `--config` | Connection (optional with `--check`). |

```bash
python3 -m giswater_admin init-db --conn "$CONN"
python3 -m giswater_admin init-db --conn "$CONN" --with-fdw
python3 -m giswater_admin init-db --check --json
```

---

### `create`

Builds a schema from `dbmodel/manifests/<kind>.yaml` and the chosen profile.

| Option | Description |
|--------|-------------|
| `--kind` | **Required.** `ws` \| `ud` \| `utils` \| `am` \| `cm` |
| `--schema` | **Required.** Target schema name. |
| `--srid` | EPSG code (default `25831`). |
| `--profile` | Manifest profile (default `empty`). |
| `--locale` | i18n folder (default `en_US`). |
| `--plugin-version` | Upper bound for `updates/` patches (default `4.9.0`). |
| `--db-user` | Author in `lastprocess` (default: connection user). |
| `--ws-schema` | Parent ws schema (`utils` profiles `integrate_ws` / optional context). |
| `--ud-schema` | Parent ud schema (`utils` profiles `integrate_ud` / optional context). |
| `--copy-source-schema` | Parent schema for `utils` profile `copy_data`. |
| `--parent-schema` | Parent ws/ud schema (**required** for `kind=cm`). |
| `--parent-type` | `ws` \| `ud` — override auto-detection for `cm`. |
| `--main-version` | Legacy alias; utils version is stored in `utils.sys_version.giswater`. |
| `--check` | Plan only; no SQL execution. |
| `--conn` / `--config` | Connection. |

```bash
python3 -m giswater_admin create --kind ws --schema ws1 --srid 25831 --profile sample_full --conn "$CONN"
python3 -m giswater_admin create --kind ud --schema ud1 --profile empty --conn "$CONN"
python3 -m giswater_admin create --kind utils --schema utils --profile empty --conn "$CONN"
python3 -m giswater_admin create --kind utils --schema utils --profile integrate_ws --ws-schema ws1 --conn "$CONN"
python3 -m giswater_admin create --kind cm --schema cm1 --parent-schema ws1 --parent-type ws --conn "$CONN"
python3 -m giswater_admin create --kind ws --schema x --profile empty --check --json
```

---

### `update`

Applies the manifest `update` profile to an existing schema (patches between `sys_version.giswater` and target version).

| Option | Description |
|--------|-------------|
| `--schema` | **Required.** Existing schema. |
| `--kind` | Optional override; else inferred from `sys_version.project_type`. |
| `--to-version` | Target version (default: `--plugin-version`). |
| `--plugin-version` | Default `4.9.0`. |
| `--locale` | Default `en_US`. |
| `--check` | Plan only. |
| `--conn` / `--config` | Connection. |

```bash
python3 -m giswater_admin update --schema ws_legacy --conn "$CONN"
python3 -m giswater_admin update --schema ws_legacy --to-version 4.9.0 --conn "$CONN"
python3 -m giswater_admin update --schema ws_legacy --kind ws --check --json
```

---

### `status`

Lists schemas that expose `sys_version`, or details for one schema.

| Option | Description |
|--------|-------------|
| `--schema` | If omitted, list all candidates. |
| `--conn` / `--config` | Connection. |

```bash
python3 -m giswater_admin status --conn "$CONN"
python3 -m giswater_admin status --schema ws_demo --conn "$CONN" --json
```

---

### `drop`

Drops a schema. Irreversible.

| Option | Description |
|--------|-------------|
| `--schema` | **Required.** |
| `--yes` | **Required** to execute (confirmation). |
| `--cascade` | `DROP SCHEMA … CASCADE` (default `RESTRICT`). |
| `--check` | Show SQL without executing. |
| `--conn` / `--config` | Connection. |

```bash
python3 -m giswater_admin drop --schema old_ws --yes --conn "$CONN"
python3 -m giswater_admin drop --schema old_ws --yes --cascade --conn "$CONN"
python3 -m giswater_admin drop --schema old_ws --yes --check
```

---

### `audit`

Subcommands: `structure` | `activate` | `drop` (required third level).

#### `audit structure`

Builds the `audit` schema.

| Option | Description |
|--------|-------------|
| `--with-checkproject` | Also load `audit_checkproject` helpers. |
| `--locale` | Default `en_US`. |
| `--plugin-version` | Default `4.9.0`. |
| `--check` | Plan only. |
| `--conn` / `--config` | Connection. |

```bash
python3 -m giswater_admin audit structure --conn "$CONN"
python3 -m giswater_admin audit structure --with-checkproject --conn "$CONN"
```

#### `audit activate`

Wires audit triggers into a ws/ud project schema.

| Option | Description |
|--------|-------------|
| `--schema` | **Required.** Target ws/ud schema. |
| `--locale` | Default `en_US`. |
| `--plugin-version` | Default `4.9.0`. |
| `--check` | Plan only. |
| `--conn` / `--config` | Connection. |

```bash
python3 -m giswater_admin audit activate --schema ws_demo --conn "$CONN"
```

#### `audit drop`

| Option | Description |
|--------|-------------|
| `--yes` | Confirm drop. |
| `--check` | SQL only. |
| `--conn` / `--config` | Connection. |

```bash
python3 -m giswater_admin audit drop --yes --conn "$CONN"
```

---

### `manifest`

#### `manifest list`

Lists YAML files under `--dbmodel-path/manifests/`.

```bash
python3 -m giswater_admin manifest list
python3 -m giswater_admin manifest list --dbmodel-path ./dbmodel --json
```

#### `manifest validate`

Validates a manifest file.

| Argument | Description |
|----------|-------------|
| `path` | Path to `<kind>.yaml` |

```bash
python3 -m giswater_admin manifest validate dbmodel/manifests/ws.yaml
python3 -m giswater_admin manifest validate dbmodel/manifests/ws.yaml --json
```

---

### End-to-end example (ws + ud + utils)

```bash
set -e
export CONN='postgresql://gisadmin:secret@127.0.0.1:5432/giswater_cli'

python3 -m giswater_admin init-db --conn "$CONN"
python3 -m giswater_admin create --kind ws --schema ws_test --srid 25831 --profile sample_full --conn "$CONN"
python3 -m giswater_admin create --kind ud --schema ud_test --srid 25831 --profile sample_full --conn "$CONN"
python3 -m giswater_admin create --kind utils --schema utils --profile empty --conn "$CONN"
python3 -m giswater_admin create --kind utils --schema utils --profile integrate_ws --ws-schema ws_test --conn "$CONN"
python3 -m giswater_admin status --conn "$CONN" --json | python3 -m json.tool
```

---

## Kinds and manifest profiles

| `kind` | Typical profiles | Notes |
|--------|------------------|-------|
| **ws** | `empty`, `sample_full`, `sample_inv`, `dev`, `ci`, `update` | Water supply. Updates: `schemas/main/common/updates` then `schemas/main/ws/updates`. |
| **ud** | same as ws | Sewerage. Updates: common then `schemas/main/ud/updates`. |
| **utils** | `empty`, `integrate_ws`, `integrate_ud`, `copy_data`, `update` | Standalone create; integrate ws/ud separately; version in `utils.sys_version`. |
| **am** | `empty`, `update` | Asset management singleton. |
| **cm** | `empty`, `with_sample`, `update` | Requires `--parent-schema`; uses `parent_schema/ws` or `ud`. |
| **audit** | CLI subcommands | No semver `updates/` tree; `structure` once, `activate` per project. |

**ws/ud profiles** (from [manifests/ws.yaml](../dbmodel/manifests/ws.yaml)):

| Profile | Phases (summary) |
|---------|------------------|
| `empty` | `load_base` → `updates` → `lastprocess` → `final_pass` |
| `sample_full` | … → `load_sample` → `final_pass` |
| `sample_inv` | … → `load_sample` → `load_inv` → `final_pass` |
| `dev` | … → `load_dev` → `final_pass` |
| `ci` | … → `load_sample` → `final_pass` (used by pgTAP bootstrap) |
| `update` | `reload_fct_ftrg` → `updates` → `lastprocess_upgrade` |

Details and folder layout: [dbmodel README — Schema architecture](../dbmodel/README.md#schema-architecture).

---

## Timing and output

| Stream | Content |
|--------|---------|
| **stdout** | Final result (YAML or JSON with `--json`). |
| **stderr** | Progress (`log_format.py`), warnings, errors; `-v`/`-d` add per-file lines. |

Example stderr with `-v --timing`:

```text
── Schema build: ws / gw_ws_test  profile=empty  v4.9.0 ──
[581/723]  phase  updates
[581/723]   1.2s  ws/updates/4/2/0/dml.sql
── Done  10.4s  723 files ──
  updates              7.1s  (612 files, 68.0%)
Slowest:
   3241ms  updates  ws/updates/4/2/0/dml.sql
```

Paths are shortened using `--dbmodel-path` as the root prefix.

```bash
# Slow SQL files during create
python3 -m giswater_admin create --kind ws --schema gw_ws_test --profile empty \
  --timing --timing-top 30 -v --timing-threshold-ms 30 \
  --conn "$CONN" 2>&1 | tee /tmp/gw_create_timing.log

# JSON timing for jq
python3 -m giswater_admin create --kind ws --schema gw_ws_test --profile empty \
  --timing --timing-detail --json --conn "$CONN" 2>/dev/null | \
  jq '.timing.slowest_by_phase.updates[:20]'
```

Timing is **per SQL file** only (not per PL/pgSQL function step).

---

## QGIS integration

The plugin builds `BuildParams`, runs `SchemaBuilder` in `core/threads/schema_builder_task.py` via `QtDbAdapter`, and can show the same formatted progress in the **Giswater PY** log. After a build, `summarize_build()` from `engine/timing_report.py` feeds the create-project dialog timing label.

---

## Unit tests

No Docker required:

```bash
# From plugin repo root
python3 -m pytest test/engine -v
```

Optional smoke tests against a real cluster (skipped without `PGSERVICE` / `PGDATABASE`):

```bash
PGSERVICE=localhost_giswater python3 -m pytest test/engine/smoke -v
```

Database integration tests: [dbmodel/README.md#testing](../dbmodel/README.md#testing).

---

## Extending the model

1. Add or edit `dbmodel/manifests/<kind>.yaml`.
2. For a new `kind`, register it in `giswater_admin/cli.py` (`--kind` choices and command validation if needed).
3. Validate: `python3 -m giswater_admin manifest validate dbmodel/manifests/<kind>.yaml`.

Supported phase types: `sql_dir`, `version_walk` (`root:` or `roots:`), `sql_file`, `sql_function`, `sql_inline`. `dir_walk` is deprecated.

---

## Keeping docs in sync

When you add or change CLI flags, update **both** `giswater_admin/cli.py` and this README (global options + affected subcommand tables). A future improvement could dump `argparse` help in CI; that is not automated yet.
