# giswater-admin

CLI y motor **sin Qt** para el ciclo de vida de esquemas Giswater (crear, actualizar, borrar, inspeccionar). Usa los mismos manifiestos YAML y el mismo `SchemaBuilder` que el plugin de QGIS (`GwSchemaBuilderTask` + `QtDbAdapter`), así que automatización, CI y QGIS no divergen en la lógica SQL.

**Tabla de contenidos**

1. [Requisitos](#requisitos)
2. [Instalación por sistema](#instalación-por-sistema)
3. [Cómo ejecutar el CLI](#cómo-ejecutar-el-cli)
4. [Conexión a PostgreSQL](#conexión-a-postgresql)
5. [Opciones globales (todas los subcomandos)](#opciones-globales-todas-los-subcomandos)
6. [Flujo típico: base nueva → extensiones → esquema](#flujo-típico-base-nueva--extensiones--esquema)
7. [Resumen de `kind` y perfiles](#resumen-de-kind-y-perfiles)
8. [Salida, JSON y trazas](#salida-json-y-trazas)
9. [Códigos de salida](#códigos-de-salida)
10. [Integración QGIS](#integración-qgis)
11. [Tests](#tests)
12. [Referencia rápida: todos los comandos y ejemplos](#referencia-rápida-todos-los-comandos-y-ejemplos)

---

## Requisitos

| Componente | Notas |
|------------|--------|
| **Python** | 3.9+ recomendado (misma familia que suelen traer QGIS 3.28+). |
| **PostgreSQL** | Versión compatible con su **dbmodel** (según proyecto Giswater). |
| **Paquetes Python** | `PyYAML`, `psycopg2-binary` (ver `requirements.txt`). |
| **Extensiones BD** | Antes del primer `create` debe existir en el **cluster** el soporte para: `postgis`, `postgis_raster`, `tablefunc`, `pgrouting`, `unaccent`. El subcomando **`init-db`** las crea en la base si el binario del servidor las tiene instaladas. |

En el **servidor** deben estar los paquetes de PostGIS / pgRouting acordes a la versión de Postgres (no los instala `pip`). Si `CREATE EXTENSION` falla, el error lo devuelve Postgres (falta paquete OS o permisos de superusuario / rol con privilegio `CREATE` en la base).

---

## Instalación por sistema

Desde la **raíz del repositorio del plugin** (donde está la carpeta `giswater_admin/` junto a `dbmodel/`):

### Linux / macOS

```bash
cd /ruta/al/plugin/giswater
python3 -m pip install -r giswater_admin/requirements.txt
# opcional: venv
python3 -m venv .venv && source .venv/bin/activate
pip install -r giswater_admin/requirements.txt
```

Ejemplos de paquetes del sistema (nombres orientativos; ajusta versión de Postgres):

- **Debian / Ubuntu:** `postgresql-16-postgis-3`, `postgresql-16-pgrouting`, …
- **RHEL / Fedora:** grupos `postgresql:server`, postgis desde repos EPEL/distro.
- **macOS (Homebrew):** `brew install postgresql@16 postgis` (y dependencias de pgRouting según fórmula disponible).

### Windows

```powershell
cd C:\ruta\al\plugin\giswater
py -3 -m pip install -r giswater_admin\requirements.txt
```

Instala PostGIS / pgRouting para el mismo major de PostgreSQL que uses (instalador EnterpriseDB / StackBuilder o paquetes que provea tu distro). Después **`init-db`** debe poder crear las extensiones si el usuario de conexión tiene permisos.

---

## Cómo ejecutar el CLI

El punto de entrada es el paquete:

```bash
python3 -m giswater_admin --help
```

En Windows (Launcher de Python):

```powershell
py -3 -m giswater_admin --help
```

**Importante:** Las opciones globales (`--json`, `-v`, `--dbmodel-path`, etc.) deben ir **después del subcomando**, porque están definidas en el parser padre de cada subcomando:

```bash
# Correcto
python3 -m giswater_admin create --kind ws --schema demo --profile empty --json

# Incorrecto (el parser raíz no las tiene)
python3 -m giswater_admin --json create ...
```

Por defecto los manifiestos y el SQL se resuelven desde **`dbmodel/`** en la raíz del repo del plugin (hermano de `giswater_admin/`). Para otra copia del modelo:

```bash
python3 -m giswater_admin manifest list --dbmodel-path /otra/ruta/dbmodel
```

---

## Conexión a PostgreSQL

Orden de resolución (el primero que aplique):

1. **`--conn`** — URL `postgresql://usuario:contraseña@host:puerto/base` (o `postgres://…`).
2. **`--config`** — YAML con claves `host`, `port`, `user`, `password`, `dbname` y/o `service`.
3. **Variables de entorno** — `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`, **`PGSERVICE`**.

### Linux / macOS (`bash` / `zsh`)

```bash
export PGSERVICE=localhost_giswater
# o
export PGHOST=127.0.0.1 PGPORT=5432 PGUSER=gisadmin PGDATABASE=giswater_cli
export PGPASSWORD='...'   # o usa ~/.pgpass

CONN='postgresql://usuario:pass@127.0.0.1:55433/giswater_cli'
python3 -m giswater_admin status --conn "$CONN"
```

### Windows (CMD)

```cmd
set PGHOST=127.0.0.1
set PGPORT=5432
set PGUSER=gisadmin
set PGPASSWORD=secret
set PGDATABASE=giswater_cli
py -3 -m giswater_admin status
```

### Windows (PowerShell)

```powershell
$env:PGHOST = "127.0.0.1"
$env:PGPORT = "5432"
$env:PGUSER = "gisadmin"
$env:PGPASSWORD = "secret"
$env:PGDATABASE = "giswater_cli"
py -3 -m giswater_admin status
```

### Archivo YAML (`--config`)

```yaml
host: 127.0.0.1
port: 55433
user: gisadmin
password: secret
dbname: giswater_cli
```

```bash
python3 -m giswater_admin status --config /ruta/conn.yaml
```

**`--check`:** en muchos subcomandos solo calcula el plan o el SQL y **no escribe en la BD**. `init-db --check` no requiere conexión (solo lista el SQL).

---

## Opciones globales (todas los subcomandos)

Disponibles en cualquier subcomando que incluya el parser padre (`create`, `update`, `status`, `drop`, `init-db`, `audit …`, salvo `manifest validate/list` que también lo incluyen en su rama).

| Opción | Descripción |
|--------|-------------|
| `--json` | Una única línea JSON en **stdout** (útil con `jq`, scripts, CI). |
| `--quiet` | Oculta progreso en stderr; siguen errores/avisos. |
| `-v` / `--verbose` | Una línea alineada `[n/total]  ruta.sql` por archivo (stderr). |
| `-d` / `--debug` | Como `-v` + logs `DEBUG` del paquete `giswater_admin` (vista previa del SQL). |
| `--timing` | Bloque `── Done … ──` al final (por fase + top lentos). Con `-v`, añade duración en cada línea. |
| `--timing-threshold-ms N` | Con `-v --timing`, solo lista archivos con duración ≥ N ms. |
| `--timing-top K` | Cuántos archivos más lentos incluir en el resumen (default: 20). |
| `--timing-detail` | Con `--json --timing`, incluye el listado completo de archivos en el payload. |
| `--dbmodel-path DIR` | Raíz del árbol `dbmodel` (por defecto: repo del plugin). |

Ejemplo para medir tiempos de creación (por fichero SQL):

```bash
# SQL files lentos (resumen por fase + top updates por versión M.m.p):
python3 -m giswater_admin create --kind ws --schema gw_ws_test --profile empty \
  --timing --timing-top 30 -v --timing-threshold-ms 30 \
  --conn "$CONN" 2>&1 | tee /tmp/gw_create_timing.log

# JSON para jq (solo updates, >100ms):
python3 -m giswater_admin create --kind ws --schema gw_ws_test --profile empty \
  --timing --timing-detail --json --conn "$CONN" 2>/dev/null | \
  jq '.timing.updates_by_version[:20], .timing.slowest_by_phase.updates[:20]'
```

---

## Flujo típico: base nueva → extensiones → esquema

1. Crea una base de datos vacía en Postgres (fuera de este CLI: `createdb`, pgAdmin, Docker, etc.).
2. **`init-db`** una vez por base (extensiones).
3. **`create`** según `kind` (ws / ud / …).
4. Opcional: **`update`**, **`status`**, **`drop`**.

```bash
export CONN='postgresql://user:pass@127.0.0.1:5432/mi_base'
python3 -m giswater_admin init-db --conn "$CONN"
python3 -m giswater_admin create --kind ws --schema ws_demo --srid 25831 --profile empty --conn "$CONN"
```

---

## Resumen de `kind` y perfiles

| `kind` | Perfiles habituales | Requisitos / notas |
|--------|---------------------|---------------------|
| **ws** | `empty`, `sample_full`, `sample_inv`, `dev`, `ci`, `update` | Red de abastecimiento. Updates en `dbmodel/schemas/network/{common,ws}/updates/M/m/p/` (per-version: common -> ws). |
| **ud** | igual que ws | Red de saneamiento. Updates en `dbmodel/schemas/network/{common,ud}/updates/M/m/p/` (per-version: common -> ud). |
| **utils** | `empty`, `update` | **`--ws-schema`** y **`--ud-schema`** en `create`. Updates flat en `dbmodel/schemas/utils/updates/M/m/p/*.sql`. |
| **am** | `empty`, `update` | Singleton `am`. Updates flat en `dbmodel/schemas/am/updates/M/m/p/*.sql`. Histórico colapsado en `dbmodel/schemas/am/updates/0/0/0/`. |
| **cm** | `empty`, `with_sample`, `update` | **`--parent-schema`**. `parent_type` ws/ud. `cm/common` + `cm/base`; luego `parent_schema/*` sobre el parent. |
| **audit** | subcomandos `structure`, `activate`, … | **Estructura** una vez; **activate** por esquema ws/ud objetivo. Sin árbol semver de updates. |

Los detalles exactos están en `dbmodel/manifests/<kind>.yaml`.

---

## Salida, JSON y trazas

- **stdout:** resultado final (YAML legible o un JSON si `--json`).
- **stderr:** progreso formateado (fases + archivos con `-v`), `warning:` / `error:`, y logs de depuración con `-d`.
- **QGIS:** mismo formato en el panel **Giswater PY**; el diálogo de crear proyecto muestra `Exec. time` + fase/archivo actual en `lbl_time`.

### Formato de log (CLI y QGIS)

Antes (depuración):

```
info: [581/723] phase:updates
exec: [581/723] 1155ms dbmodel/schemas/network/ws/updates/4/2/0/dml.sql
timing: total 10.4s (723 files)
```

Ahora (`giswater_admin/log_format.py`):

```
── Schema build: ws / gw_ws_test  profile=empty  v4.9.0 ──
[581/723]  phase  updates
[581/723]   1.2s  ws/updates/4/2/0/dml.sql
── Done  10.4s  723 files ──
  updates              7.1s  (612 files, 68.0%)
Slowest:
   3241ms  updates  ws/updates/4/2/0/dml.sql
```

Las rutas se acortan con `--dbmodel-path` (CLI) o `BuildParams.sql_root` (QGIS).

Ejemplo solo JSON a archivo de log:

```bash
python3 -m giswater_admin create --kind ws --schema x --profile empty --conn "$CONN" --json 2>trace.log | jq .
```

---

## Códigos de salida

| Código | Significado |
|--------|-------------|
| **0** | Éxito. |
| **1** | Error (parseo, I/O, Postgres, SQL fallido, plan inválido, etc.). |

---

## Integración QGIS

El plugin construye `BuildParams` y ejecuta `SchemaBuilder` en `GwSchemaBuilderTask` con `QtDbAdapter` sobre `tools_db`. Desde código también puedes usar `Out`, `configure_stderr_logging` y `build_progress_cb` como en el CLI.

---

## Tests

```bash
# Rápidos, sin base de datos
python3 -m pytest test/engine -v

# Humo contra Postgres (se omiten sin PGSERVICE / PGDATABASE)
PGSERVICE=localhost_giswater python3 -m pytest test/engine/smoke -v
```

---

## Referencia rápida: todos los comandos y ejemplos

Sintaxis base:

```text
python3 -m giswater_admin <subcomando> [opciones del subcomando] [opciones globales]
```

---

### `init-db`

Crea extensiones por defecto: `postgis` → `postgis_raster` → `tablefunc` → `pgrouting` → `unaccent` (+ opcional `postgres_fdw`).

| Argumento | Descripción |
|-----------|-------------|
| `--with-fdw` | También `CREATE EXTENSION postgres_fdw`. |
| `--continue-on-error` | Sigue tras el primer fallo (por defecto se detiene). |
| `--check` | Lista el SQL; sin ejecutar; no requiere `--conn`. |
| `--conn` / `--config` | Conexión (omitible solo con `--check`). |

```bash
python3 -m giswater_admin init-db --conn "$CONN"
python3 -m giswater_admin init-db --conn "$CONN" --with-fdw
python3 -m giswater_admin init-db --check --json
```

---

### `create`

Crea un esquema según manifiesto `dbmodel/manifests/<kind>.yaml`.

| Argumento | Descripción |
|-----------|-------------|
| `--kind` | `ws` \| `ud` \| `utils` \| `am` \| `cm` (obligatorio). |
| `--schema` | Nombre del esquema (obligatorio). |
| `--srid` | EPSG (defecto `25831`). |
| `--profile` | Perfil del manifiesto (defecto `empty`). |
| `--locale` | Defecto `en_US`. |
| `--plugin-version` | Tope de parches `updates/` (defecto `4.9.0`). |
| `--db-user` | Autor en `lastprocess` (defecto: usuario de conexión). |
| `--ws-schema` / `--ud-schema` | Obligatorios si `kind=utils`. |
| `--parent-schema` | Obligatorio si `kind=cm`. |
| `--parent-type` | `ws` \| `ud` (sobreescribe auto-detección). |
| `--main-version` | Para `utils` (`utils_version` en config). |
| `--am-target` | **Deprecado** (alias oculto). AM ahora usa semver vía `--plugin-version`. |
| `--check` | Solo plan + recuentos; sin escritura en BD. |
| `--conn` / `--config` | Conexión. |

```bash
python3 -m giswater_admin create --kind ws --schema ws1 --srid 25831 --profile sample_full --conn "$CONN"
python3 -m giswater_admin create --kind ud --schema ud1 --profile empty --conn "$CONN"
python3 -m giswater_admin create --kind utils --schema utils --ws-schema ws1 --ud-schema ud1 --conn "$CONN"
python3 -m giswater_admin create --kind am --schema am --conn "$CONN"
python3 -m giswater_admin create --kind am --schema am --plugin-version 4.9.0 --conn "$CONN"
python3 -m giswater_admin create --kind cm --schema cm1 --parent-schema ws1 --conn "$CONN"
python3 -m giswater_admin create --kind cm --schema cm1 --parent-schema ws1 --parent-type ws --conn "$CONN"
python3 -m giswater_admin create --kind ws --schema x --profile empty --check --json
```

---

### `update`

Aplica perfil `update` del manifiesto al esquema indicado (parches entre `project_version` y `plugin_version`).

| Argumento | Descripción |
|-----------|-------------|
| `--schema` | Esquema existente (obligatorio). |
| `--kind` | `ws` \| `ud` \| `utils` \| `am` (opcional: se infiere de `sys_version.project_type`). |
| `--to-version` | Versión objetivo (defecto: `--plugin-version`). |
| `--plugin-version` | Defecto `4.9.0`. |
| `--locale` | Defecto `en_US`. |
| `--check` | Solo plan. |
| `--conn` / `--config` | Conexión. |

```bash
python3 -m giswater_admin update --schema ws_legacy --conn "$CONN"
python3 -m giswater_admin update --schema ws_legacy --to-version 4.9.0 --conn "$CONN"
python3 -m giswater_admin update --schema ws_legacy --kind ws --check --json
```

---

### `status`

Lista esquemas que tienen tabla `sys_version` o detalle de uno.

| Argumento | Descripción |
|-----------|-------------|
| `--schema` | Si se omite, lista todos los candidatos. |
| `--conn` / `--config` | Conexión. |

```bash
python3 -m giswater_admin status --conn "$CONN"
python3 -m giswater_admin status --schema ws_demo --conn "$CONN" --json
```

---

### `drop`

Elimina un esquema.

| Argumento | Descripción |
|-----------|-------------|
| `--schema` | Nombre (obligatorio). |
| `--yes` | Obligatorio para ejecutar (confirmación). |
| `--cascade` | `DROP SCHEMA … CASCADE`. |
| `--check` | Muestra el SQL sin ejecutar. |
| `--conn` / `--config` | Conexión. |

```bash
python3 -m giswater_admin drop --schema old_ws --yes --conn "$CONN"
python3 -m giswater_admin drop --schema old_ws --yes --cascade --conn "$CONN"
python3 -m giswater_admin drop --schema old_ws --yes --check
```

---

### `audit`

Subcomandos obligatorios: `structure` | `activate` | `drop`.

#### `audit structure`

| Argumento | Descripción |
|-----------|-------------|
| `--with-checkproject` | Incluye carga `audit_checkproject`. |
| `--locale`, `--plugin-version` | Passthrough al motor. |
| `--check` | Solo plan. |
| `--conn` / `--config` | Conexión. |

```bash
python3 -m giswater_admin audit structure --conn "$CONN"
python3 -m giswater_admin audit structure --with-checkproject --conn "$CONN"
```

#### `audit activate`

| Argumento | Descripción |
|-----------|-------------|
| `--schema` | Esquema ws/ud donde cablear triggers (obligatorio). |
| `--locale`, `--plugin-version` | Opcionales. |
| `--check` | Solo plan. |
| `--conn` / `--config` | Conexión. |

```bash
python3 -m giswater_admin audit activate --schema ws_demo --conn "$CONN"
```

#### `audit drop`

| Argumento | Descripción |
|-----------|-------------|
| `--yes` | Confirmación. |
| `--check` | Solo SQL. |
| `--conn` / `--config` | Conexión. |

```bash
python3 -m giswater_admin audit drop --yes --conn "$CONN"
```

---

### `manifest`

#### `manifest list`

Enumera YAML en `--dbmodel-path/manifests/` con `kind` y perfiles.

```bash
python3 -m giswater_admin manifest list
python3 -m giswater_admin manifest list --dbmodel-path ./dbmodel --json
```

#### `manifest validate`

Valida un fichero YAML.

```bash
python3 -m giswater_admin manifest validate dbmodel/manifests/ws.yaml
python3 -m giswater_admin manifest validate dbmodel/manifests/ws.yaml --json
```

---

### Ejemplos globales (cualquier subcomando que soporte el parser padre)

```bash
# Trazas por archivo (como log QGIS en terminal)
python3 -m giswater_admin create --kind ws --schema x --profile empty --conn "$CONN" -v

# Depuración con preview de SQL
python3 -m giswater_admin create --kind ws --schema x --profile empty --conn "$CONN" -d

# Salida JSON + silenciar progreso en stderr
python3 -m giswater_admin create --kind ws --schema x --profile empty --conn "$CONN" --json --quiet
```

---

### Caso completo: ws + ud + utils + comprobación (Linux / macOS)

```bash
set -e
export CONN='postgresql://gisadmin:secret@127.0.0.1:5432/giswater_cli'

python3 -m giswater_admin init-db --conn "$CONN"
python3 -m giswater_admin create --kind ws --schema ws_test --srid 25831 --profile sample_full --conn "$CONN"
python3 -m giswater_admin create --kind ud --schema ud_test --srid 25831 --profile sample_full --conn "$CONN"
python3 -m giswater_admin create --kind utils --schema utils --ws-schema ws_test --ud-schema ud_test --conn "$CONN"
python3 -m giswater_admin status --conn "$CONN" --json | python3 -m json.tool
```

### Mismo flujo en Windows (PowerShell)

```powershell
$CONN = "postgresql://gisadmin:secret@127.0.0.1:5432/giswater_cli"
py -3 -m giswater_admin init-db --conn $CONN
py -3 -m giswater_admin create --kind ws --schema ws_test --srid 25831 --profile sample_full --conn $CONN
py -3 -m giswater_admin create --kind ud --schema ud_test --srid 25831 --profile sample_full --conn $CONN
py -3 -m giswater_admin create --kind utils --schema utils --ws-schema ws_test --ud-schema ud_test --conn $CONN
py -3 -m giswater_admin status --conn $CONN --json
```

---

### Ampliar el modelo

1. Añadir o editar `dbmodel/manifests/<kind>.yaml`.
2. Si hace falta un `kind` nuevo, registrarlo en `giswater_admin/cli.py` (`--kind` y lógica del comando si aplica).
3. Validar: `python3 -m giswater_admin manifest validate dbmodel/manifests/<kind>.yaml`.

Los tipos de fase soportados en YAML incluyen: `sql_dir`, `version_walk` (con `root:` o `roots: [...]` multi-raíz para ws/ud), `dir_walk` (deprecado), `sql_file`, `sql_function`, `sql_inline`.
