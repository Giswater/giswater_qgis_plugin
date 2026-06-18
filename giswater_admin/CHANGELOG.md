# Changelog

All notable changes to the giswater-cli package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-06-18

### Added

- PyPI package `giswater-cli` with `gw` console entrypoint (Python 3.9+).
- Headless schema engine shared with the QGIS plugin (`SchemaBuilder`, YAML manifests under `dbmodel/manifests/`).
- `gw db init` — install PostGIS, pgRouting and required PostgreSQL extensions per database.
- `gw schema main create|update|drop` — ws/ud project schemas with manifest profiles (`empty`, `test`, `demo`, …).
- `gw schema addon create|integrate|update|drop` — satellite schemas (utils, cibs, audit, …) and parent wiring.
- `gw schema list` — list schemas configured in the active dbmodel.
- `gw network show|update` — inspect linked topology and run lockstep network upgrades.
- `gw dbmodel install|list|use|status` — download, cache and switch Giswater SQL releases from plugin ZIPs.
- `gw config get|set` — persistent user settings (`~/.config/giswater/config.yaml` or `%APPDATA%/giswater/`).
- `gw manifest validate|list` — validate and enumerate manifest YAML files.
- `gw version` — report CLI package version and active dbmodel/schema version.
- Dbmodel resolution via `--dbmodel-path`, `GW_DBMODEL_PATH`, user config, or sibling checkout (`gw dbmodel use dev`).
- Offline `--check` mode to print the SQL execution plan without connecting to PostgreSQL.
- Timing reports and structured log output for automation and CI.
- Legacy command aliases (`create`, `update`, `drop`, `status`, `init-db`, `update-network`, `audit …`) with stderr deprecation warnings.

[unreleased]: https://github.com/Giswater/giswater_qgis_plugin/compare/cli-v0.1.0...main
[0.1.0]: https://github.com/Giswater/giswater_qgis_plugin/releases/tag/cli-v0.1.0
