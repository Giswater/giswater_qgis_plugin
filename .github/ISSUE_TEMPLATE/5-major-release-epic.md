---
name: Major release epic
about: Coordinate a Giswater DB major bump (e.g. 4.x -> 5.0) and the lockstep release of every tier-1 client
title: "[EPIC] Giswater major release X.0"
labels: "epic"
assignees: ""
---

> One epic per DB major. Tier-1 clients (QGIS plugin, giswater-api, qwc2) bump major in the **same release train** — not before, not after.
> Full rules: [dbmodel/MAINTENANCE.md](../../dbmodel/MAINTENANCE.md).

## Target

- **DB major:** <!-- e.g. 5.0.0 -->
- **Tier-1 client majors:** plugin `X.0`, giswater-api `<n>.0`, qwc2 `<n>.0`
- **RC window:** <!-- date range -->

## Contract issues to resolve (the deprecation backlog)

> Every `[CONTRACT]` issue with a `DEPRECATED #<n>` token that lands in this major.
> Run `rg "DEPRECATED #"` in `dbmodel/` to find all pending removals.

- [ ] #<!-- contract issue --> — <!-- surface -->
- [ ] #<!-- contract issue --> — <!-- surface -->

## DB contract work (`5/0/x` at RC only)

- [ ] Create `schemas/main/{common,ws,ud}/updates/5/0/0/patch.sql` (do NOT create during 4.x)
- [ ] Remove all `DEPRECATED` surfaces linked above
- [ ] Remove the matching downgrade transforms from `gw_fct_json_create_return`
- [ ] `rg "DEPRECATED #"` returns nothing left for this major
- [ ] changelog.txt per scope

## Tier-1 client child issues (separate repos, same RC window)

- [ ] QGIS plugin: bump to `X.0`, drop old-shape reads, update `_check_version_compatibility()`
- [ ] giswater-api: bump major, `GISWATER_DB_SUPPORTED_MAJOR` -> new major, re-export JSON Schema
- [ ] qwc2: bump major, drop old-shape reads

## Tier-2+ platform child issues (follow when their direct upstream bumps major)

- [ ] giswater-plus-api (depends on giswater-api major)
- [ ] gw_plus_plugin (depends on giswater-plus-api major + base plugin)
- [ ] hengine-api / artifacts-api / storage-api (each follows its direct upstream)

## Release gate

- [ ] No tier-1 client released against the new DB major before its own major shipped
- [ ] No tier-1 client left on the old major after the new DB major is GA
- [ ] Compatibility/epoch tables updated in every repo README + MAINTENANCE.md
