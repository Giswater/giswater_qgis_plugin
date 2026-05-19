<div align="center">
	<h1>Giswater DB Model</h1>
	<a href="https://github.com/Giswater/giswater_dbmodel"><img alt="Giswater Dbmodel Badge" src="https://img.shields.io/badge/GISWATER-DBMODEL-blue?style=for-the-badge&logo=postgresql&logoColor=ffffff"></a>
	<a href="./LICENSE"><img alt="LICENSE" src="https://img.shields.io/github/license/giswater/giswater_dbmodel?style=for-the-badge"></a>
	<a href="https://github.com/Giswater/giswater_dbmodel/actions/workflows/ci_test_ud_db.yml"><img alt="CI Testing UD" src="https://img.shields.io/github/actions/workflow/status/giswater/giswater_dbmodel/ci_test_ud_db.yml?branch=dev-4.0&style=for-the-badge&label=TEST%20UD"></a>
	<a href="https://github.com/Giswater/giswater_dbmodel/actions/workflows/ci_test_ws_db.yml"><img alt="CI Testing WS" src="https://img.shields.io/github/actions/workflow/status/giswater/giswater_dbmodel/ci_test_ws_db.yml?branch=dev-4.0&style=for-the-badge&label=TEST%20WS"></a>
</div>

**Giswater** revolutionizes water management by simplifying the planning and control of water supply networks without costly investments. Since its launch in 2014, Giswater is the first open-source software designed for integrated water management, connecting IT solutions and databases for high-performance management systems. It integrates seamlessly with hydraulic modeling software like **EPANET** and **SWMM**, making it indispensable for professionals and organizations in water management.

### Features

- Open-source tool for complete water cycle management.
- Works with hydraulic tools (**EPANET**, **EPA SWMM**) and GIS systems.
- Integrates with business management tools (ERP, CRM, BI).
- Compatible with Windows, Mac, and Linux (for most features)

## Table of Contents

1. [Schemas and layout](#schemas-and-layout)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Testing](#testing)
5. [Deployment](#deployment)
6. [Wiki](#wiki)
7. [FAQ](#faqs)
8. [Repositories](#repositories)
9. [Versioning](#versioning)
10. [License](#license)
11. [Acknowledgements](#acknowledgements)

## Schemas and layout

Giswater creates six PostgreSQL schemas. Each one owns a dedicated
folder under [`schemas/`](./schemas/) that bundles its base SQL **and**
its semver-versioned `updates/` tree, so per-schema changelogs are
self-contained.

| Schema  | Type      | Base folder                                     | Updates root (semver `<M>/<m>/<p>/*.sql`)        |
|---------|-----------|-------------------------------------------------|--------------------------------------------------|
| `ws`    | project   | [`schemas/network/ws/`](./schemas/network/ws/)  | `schemas/network/common/updates/` + `schemas/network/ws/updates/` (per-version interleaved) |
| `ud`    | project   | [`schemas/network/ud/`](./schemas/network/ud/)  | `schemas/network/common/updates/` + `schemas/network/ud/updates/` (per-version interleaved) |
| `utils` | singleton | [`schemas/utils/`](./schemas/utils/)            | `schemas/utils/updates/` (flat)                  |
| `am`    | singleton | [`schemas/am/`](./schemas/am/)                  | `schemas/am/updates/` (flat)                     |
| `cm`    | singleton | [`schemas/cm/`](./schemas/cm/)                  | `schemas/cm/updates/` (flat)                     |
| `audit` | singleton | [`schemas/audit/`](./schemas/audit/)            | (no semver updates; uses `structure`/`activate`) |

[`schemas/network/common/`](./schemas/network/common/) holds the SQL
that **runs into both the ws and ud schemas** at create and upgrade
time (DDL/functions/triggers shared by both project schemas). It is
**not** a schema of its own.

[`schemas/network/sample/`](./schemas/network/sample/) (renamed from
the legacy `example/`) hosts the per-project-type seed datasets
(`user/`, `inv/`, `dev/`) referenced by the `load_sample`/`load_inv`/
`load_dev` phases of the ws/ud manifests.

### Updates tree convention

For singleton schemas (am, cm, utils, audit):

```
dbmodel/schemas/<kind>/updates/<major>/<minor>/<patch>/*.sql   # flat, no subdir
```

For the network schemas (ws, ud) the engine consumes **two parallel
roots** per build, interleaved per version (common first, then the
project-type):

```
dbmodel/schemas/network/common/updates/<M>/<m>/<p>/*.sql
dbmodel/schemas/network/ws/updates/<M>/<m>/<p>/*.sql
dbmodel/schemas/network/ud/updates/<M>/<m>/<p>/*.sql
```

The `version_walk` phase in [`manifests/`](./manifests/) declares this
with either `root:` (singletons) or `roots: [...]` (ws/ud, where the
list order defines the apply order for a given version). The engine
filters patches by the schema's `sys_version.giswater`
(`project_version`) and the CLI's `--plugin-version`:

- **new project**: walk every patch `v <= plugin_version`
- **upgrade**:     walk patches `project_version < v <= plugin_version`

Changelogs (`changelog.txt`) live next to each version folder:

```
schemas/network/common/updates/<v>/changelog.txt   # historical mixed changes
schemas/network/ws/updates/<v>/changelog.txt       # ws-only changes
schemas/network/ud/updates/<v>/changelog.txt       # ud-only changes
schemas/<kind>/updates/<v>/changelog.txt           # singleton changes
```

Historical changelogs from the old unified `dbmodel/updates/<v>/`
tree were consolidated under `schemas/network/common/updates/<v>/`.

### AM legacy patches

`am` used to live under `am/updates/<YYYY-MM>/` (calendar buckets). All
historical content was collapsed into
`dbmodel/schemas/am/updates/0/0/0/` with filenames prefixed by the
original date for chronological ordering. New am patches go under
regular semver folders alongside ws/ud/utils.

### CM layout (parallel to network ws/ud)

| Path | Role |
|------|------|
| `schemas/cm/common/` | Shared CM DDL/fct/ftrg (legacy folder name was `utils`; not the satellite `utils` schema) |
| `schemas/cm/base/` | Core `cm` tables (campaign, lot, arc/node/connec, …) |
| `schemas/cm/parent_schema/utils/` | Parent-link views/triggers (`PARENT_SCHEMA` override; ws+ud) |
| `schemas/cm/parent_schema/ws\|ud/` | Type-specific hooks (ws stubs; ud gully tables) |

Prerequisite: parent ws/ud project already created (`network/common` + kind).

`parent_type=ud`: adds gully SQL under `parent_schema/ud/`.

## Requirements

To use Giswater, you need:

- **PostgreSQL**: Ensure pgAdmin/dbeaver (DB manager) and PostGIS (spatial extension) are installed.
- **QGIS**: Geoprocessing software for frontend use.

## Installation

Giswater is a client-server system requiring installation on both the backend and frontend.

### Backend Environment:

- Compatible with Windows, Mac, and Linux.
- Install **PostgreSQL** (versions 9.5 to 14).
- Enable the following extensions:

```postgres
CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;
CREATE EXTENSION tablefunc;
CREATE EXTENSION unaccent;
```

### Frontend Environment:

- Compatible with Windows, Mac, and Linux. **EPA models** work best on Windows.
- Install **QGIS** (latest LTR version).
- Install **SWMM** (5.1) and **EPANET** (2.2). Note: EPA models may not work fully on Linux.

## Testing

Example projects with integrated datasets are available to test the system. Check out these tutorial videos to set up your environment:

1. [Install plugin](https://www.youtube.com/watch?v=EwDRoHY2qAk&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=4)
2. [Setup connection](https://www.youtube.com/watch?v=LJGCUrqa0es&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=3)
3. [Create DB schema example](https://www.youtube.com/watch?v=nR3PBtfGi9k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=2)
4. [Create QGIS project](https://www.youtube.com/watch?v=RwFumKKTB2k&list=PLQ-seRm9Djl4hxWuHidqYayHEk_wsKyko&index=1)

## Deployment

### Prerequisites:

- Ensure you have PostgreSQL access with DB superuser permissions for tasks like schema creation, roles, backups, and restoration.

### Mandatory Project Setup:

- Fill required catalogs: **materials**, **node**, and **arc**.
- Define **inventory layers** (network shapes) with required fields.
- Set up **mapzones**: e.g., macroexploitation, municipality, sector.

Start by creating two nodes; then, insert arcs. For configuration options, visit the [Giswater configuration guide](https://github.com/Giswater/giswater_dbmodel/wiki/Config).

### Getting Started:

- [Start from scratch](https://github.com/Giswater/giswater_dbmodel/wiki/Start-from-Scratch:-Installing-Giswater-and-steps-to-create-an-empty-project).
- Optionally, load INP files (in beta). See more about [Import INP debug mode](https://github.com/Giswater/giswater_dbmodel/wiki).

## Wiki

For comprehensive documentation, visit the [Giswater Wiki](https://github.com/Giswater/giswater_dbmodel/wiki).

## FAQs

Check out the [FAQs section](https://github.com/Giswater/giswater_dbmodel/wiki/FAQs) for common questions.

## Repositories

- **Docs**: [Giswater Docs](https://github.com/Giswater/docs)
- **QGIS Plugin**: [Giswater QGIS Plugin](https://github.com/Giswater/giswater_qgis_plugin)
- **Database Model**: [Giswater DB Model](https://github.com/Giswater/giswater_dbmodel)

Other repositories are either deprecated or not in use.

## Versioning

Giswater follows a three-tier release system: **Major**, **Minor**, and **Build** updates.

- **Major**: Architecture updates (not backward compatible).
- **Minor**: Bug fixes, new functionalities (backward compatible).
- **Build**: Small fixes, monthly releases.

## License

This software is licensed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for more details.

## Acknowledgements

Special thanks to the following partners for their contributions:

- GITS-BarcelonaTech University
- Aigües de Mataró
- Aigües de Girona
- Aigües de Blanes
- Aigües del Prat
- Aigües de Vic
- Aigües de Castellbisbal
- Aigües de Banyoles
- Figueres de Serveis, S.A
- Prodaisa
- Sabemsa
- Consorci Aigües de Tarragona
