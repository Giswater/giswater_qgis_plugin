# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- stable `gw_id` custom map layer property when adding layers to the TOC so lookup and removal do not rely on the layer display name alone.
- `add_layer_provider` with URI builders (WMS, WFS, OAPIF, XYZ, GeoJSON) for loading non-PostGIS layers from `providerConfig`.
- `gw_fct_getaddlayervalues`: return `providerConfig` from `sys_table` for add-layer value lists.

### Changed

- child-layer menu, temporal and snapshot layers, mincut/psector overlap layers, EPA dscenario/netscenario removal, Go2Iber imports, ValueRelation layers in HIDDEN, and backend query layers updated for the new TOC APIs.

### Fixed

- Fix functions and triggers to use `v_raster_dem` instead of `ext_raster_dem`.
- Fix mincut offline result layer names and styles.

## [4.9.0] - 2026-05-14

### Added

- New dscenario pattern and pattern value tables (`inp_dscenario_pattern`, `inp_dscenario_pattern_value`).
- New typevalue for dscenario type: CALIBRATION.
- New visibility tables `node_x_sector_visibility`, `node_x_municipality_visibility`, `element_x_sector_visibility`, `element_x_municipality_visibility`.
- New trigger `gw_trg_update_element_mapzones` to update mapzone columns on `element`.
- `has_treatment` column on UD `node`, `connec`, and `gully` tables, related triggers, and `ve_node`, `ve_connec`, and `ve_gully` views.
- `drainzone_outfall` calculation and updates to `dwfzone_outfall` in graph analytics mapzones.
- `v_recalculate_macromapzones` parameter and related macro mapzone logic in `gw_fct_graphanalytics_mapzones`.
- Temporary table and view for element management inside graph analytics.
- Drainzone handling in graph analytics extended so `addfields` / `addparam.drainzone` receive aggregated results where applicable.
- `provider_config` column on `sys_table` plus related catalogue checks.
- View `v_type_street` and updated `config_form_fields` references for street types.
- CSO overflow mapping table for storm overflow workflows.

### Changed

- Config toolbox: SQL input parameters for graph class and exploitation options.
- `sys_style`: improved line symbology for fluid types.
- Municipality assignment for nodes when several municipalities lie nearby (selection logic refined).
- Upstream/downstream analysis: traverse network regardless of `is_operative` on elements.
- `fct_cm_check_progress`: exposes percentage of executed nodes per campaign.
- Network mincut: streamlined SQL queries and address autofill usable from web and desktop.
- Multiple SQL functions: `sector_id` conditions normalized for clearer integrity rules.
- i18n: labels, tooltips, and descriptions (graph tools, exploitation, and general wording).
- Optional dependencies resolved via `tools_os.get_dep` instead of bare imports.

### Fixed

- `inp_dscenario_demand`: move `id` column to first position for stable column ordering.
- Composer: logo image path resolution.
- `gw_fct_graphanalytics_mapzones_v1`: drainzone insert/update; correct `expl_id[]`, `muni_id[]`, `sector_id[]` arrays for mapzones; ignore `sector_id = 0` when aggregating sectors; create `temp_pgr_mapzone_graph` only when running graphanalytics mapzones.
- Graph analytics visibility: WS/UD compatibility for `node_x_sector_visibility`-related flows.
- `gw_fct_getfeatureupsert`: default value handling for filter combo widgets when updating features in Info.
- `gw_fct_cm_setcheckproject`: GeoJSON payload handling for check results.
- `gw_fct_cm_check_data_context`: expanded checks and clearer error texts; QC output limited to rows with `status = 1` and `action <> 3`.
- `gw_fct_pg2epa_check_network`: `sector_id` and `dma_id` behaviour on disconnected networks.
- `gw_fct_pg2epa_export` WS dscenario path: tank parameters updated correctly on inlet links.
- `gw_fct_getsearch`: optional JSON key to target a specific layer in the search call.
- `gw_fct_setelevfromdem`: propagate detailed errors back to the client on failure.
- `om_check_data`: use catalogued `t_tables` instead of ad hoc target tables.
- Asset Manager: insert into `sys_version` uses schema SRID (`SCHEMA_SRID`) for EPSG.
- `gw_fct_getprofilevalues`: cast JSON `descript` through text for stable typing.
- Lot/campaign selectors: `ON CONFLICT` handling for campaign/lot selectors to avoid duplicate key failures.
- `inp_subcatchment`: enforce foreign keys referencing municipality where defined in utils/tablect DDL.
- `temp_anl_arc` / `temp_anl_node`: drop redundant duplicate index DDL where the index already existed.

## [4.8.4] - 2026-05-07

### Fixed

- Improve composer warning handling and correct coverage.
- Fix ve_plan_psector and v_plan_psector references.
- Fix hardcoded logo.png path.
- Improve psector manager performance.
- Fix psector other_prices tab bug with ',' and '.' as decimal separator.
- Fix problem with psector pca calculation.
- Fix dscenario manager to check columns from views instead of tables.

### Changed

- Performance profiling in get_psector method when open existing one.
- References from `ve_plan_psector` to `v_plan_psector` in `sys_table` and `sys_style` tables.

### Removed

- Deprecated code on psector manager to improve performance.
- Hide pump additional tab in dscenario manager.

## [4.8.3] - 2026-05-05

### Fixed

- Fix `config_param_system` update epa_automatic_man2graph_values value

## [4.8.2] - 2026-04-20

### Changed

- Removed dependency on chardet.

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

[unreleased]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.9.0...main
[4.9.0]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.8.4...v4.9.0
[4.8.4]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.8.3...v4.8.4
[4.8.3]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.8.2...v4.8.3
[4.8.2]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.8.1...v4.8.2
[4.8.1]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.8.0...v4.8.1
[4.8.0]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.7.1...v4.8.0
[4.7.1]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.7.0...v4.7.1
[4.7.0]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.6.0...v4.7.0
[4.6.0]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.5.4...v4.6.0
[4.5.4]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.5.3...v4.5.4
[4.5.3]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.5.2...v4.5.3
[4.5.2]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.5.1...v4.5.2
[4.5.1]: https://github.com/Giswater/giswater_qgis_plugin/compare/v4.5.0...v4.5.1
[4.5.0]: https://github.com/Giswater/giswater_qgis_plugin/releases/tag/v4.5.0
