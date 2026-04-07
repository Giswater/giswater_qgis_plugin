# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.8.1] - 2026-04-07

### Added

- This changelog file
- New indexes on `anl_*` tables.

### Fixed

- `gw_trg_arc_node_values` trigger on ws schemas.
- `gw_fct_graphanalytics_macromapzones` streamline temporary table management.
- `gw_fct_pg2epa_export_inp` add alias for emitter_coeff.
- `gw_fct_graphanalytics_mapzones_v1` function.
- Performance of dscenario views for ws and ud 
- `gw_trg_gully_proximity`, `gw_trg_connec_proximity` triggers to use `ve_gully` and `ve_connec` tables instead of `gully` and `connec` tables.
- `gw_fct_getfeatureupsert` function to use `ve_node`, `ve_connec` and `ve_gully` tables instead of `node`, `connec` and `gully` tables.
- Recreated `ve_connec` and `ve_gully` views.
- Improved `inp_family` table and `result_families` function.
- `gw_fct_setfeaturereplaceplan` function.
- `ud_gw_trg_topocontrol_node` trigger.
- `ud_gw_trg_topocontrol_arc` trigger.
- `gw_fct_psector_merge` function.
- `ud_pg2epa` now export undefined nodes connected to not undefined arcs.

### Removed

- Losses dscenario.

## [4.8.0] - 2026-03-17

### Added

- Tab `supplyzone` on mapzone manager.

### Fixed

- Getting style for some layers.
- QGIS crash with toolbox processes.
- QGIS project creation.
- Various CM bug fixes.

### Changed

- Refactor `getlist` and tableviews header with alias management.
- QGIS maximum version to 4.0.

## [4.7.1] - 2026-02-24

### Fixed

- Make some user parameters mandatory (`sys_param_user`).
- Mapzone checks on mapzones.

## [4.7.0] - 2026-01-30

### Added

- New EPA export result families.
- Mapzones checks before execution.
- New checks on `pg2epa` export.
- Load temporal layers when getting profile values.

### Fixed

- Topology fields and various UD/WS analysis routines.
- Graph inundation and profile values retrieval.

### Changed

- Refactor UD topology fields and related views.
- Update psector/mincut logic to use `pgr_linegraph` and new algorithms.

## [4.6.0] - 2025-12-18

### Added

- Update submodules and database logic for new CI and tests.

## [4.5.4] - 2025-11-12

### Fixed

- Multiple triggers and functions related to config control, proximity, connectivity and plan psector logic.
- `config_form_fields` to use the correct `dv_query_text` on `man_type_*` columns.
- Deleting psectors with `to_arc` property.
- Various EPA export and topology control routines (`pg2epa`, `setfeaturereplace`, `setendfeature`, `topocontrol_arc`, etc.).

## [4.5.3] - 2025-10-28

### Fixed

- Translation of `cat_arc.area` for `es_CR`.
- `admin_currency` translation.
- `config_fprocess` to add `rpt_arc_stats` and `rpt_node_stats` entries.
- `pg2epa` network check to use `-2` as `dma_id` for undefined values.

## [4.5.2] - 2025-10-27

### Fixed

- Widget type compatibility and UI checks.
- Psector topology validation and error handling.
- Psector translations, initproject, `config_form_fields` for dma and canvas refresh.

## [4.5.1] - 2025-10-23

### Fixed

- GwPlan application when a psector is current.
- Psignals on psector manager and play/pause button.
- Psector merge, duplicate and topology when duplicated nodes are found.
- Adding connecs into a psector without `arc_id`.
- Several rows on `sys_message` and selector_psector clarity.
- Log order on `audit_check_data`.

### Removed

- Legacy `chk_enable_all` behavior.
- Deleting from `selector_psector` when psector is set to inactive.

## [4.5.0] - 2025-10-20

### Added

- New CM toolbar for campaigns, lots, organizations, teams and users with role-based permissions.
- New AM toolbar for priority calculation, breakage analysis and result management.
- New translation logic and i18n overhaul.
- Psector mode toggle in status bar with context menu.
- Go2IBER integration (DAT/RPT support).
- Import EPANET/SWMM with save-to-psector.
- New selection-by-expression tools and unified selection logic.
- New elements managers (`ve_genelem`, `ve_frelem`) and non-visual managers enhancements.
- Markdown generator for documentation.
- Hidden form logic for feature creation.
- PgRouting version compatibility check on project load.
- GitHub workflow templates and flake8 CI for Python compatibility checks.

### Fixed

- Project creation for `es_CR` and other locales with malformed JSON.
- Psector toggling and table relation refresh.
- Mincut conflicts deletion and result selector updates.
- EPANET import (time options, diameters, catalogs).
- SWMM import (flow regulators, trigger enabling).
- Selection tools snapping precision and map/table interaction.
- macOS dialogs that blocked the main QGIS window.
- Feature replace catalogs and arc snapping in psector mode.
- Info docker double-click and cross-section image display.
- Signal/thread handling for psector, CM and selection tools.

### Changed

- Massive refactor of `v_edit_*` views to `ve_*` prefix.
- Refactor of setfields logic to use database-side feature creation.
- Refactor of docker references and psector UI buttons.
- Consolidation of psector loading and signal management.
- Performance optimizations on selectors, table refresh and map rendering.
- SQL performance improvements for i18n, CM and EPA imports.
- Form change detection and caching improvements.
- Large-scale flake8 and typing standardization.

[unreleased]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.8.1...main
[4.8.1]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.8.0...v4.8.1
[4.8.0]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.7.1...v4.8.0
[4.7.1]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.7.0...v4.7.1
[4.7.0]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.6.0...v4.7.0
[4.6.0]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.5.4...v4.6.0
[4.5.4]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.5.3...v4.5.4
[4.5.3]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.5.2...v4.5.3
[4.5.2]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.5.1...v4.5.2
[4.5.1]: https://github.com/giswater/giswater_qgis_plugin/compare/v4.5.0...v4.5.1
[4.5.0]: https://github.com/giswater/giswater_qgis_plugin/releases/tag/v4.5.0
