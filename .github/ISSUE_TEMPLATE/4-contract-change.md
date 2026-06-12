---
name: Contract change
about: Rename / retype / move / remove a client-facing DB surface (gw_fct_* JSON, v_*/ve_* views, columns read by clients)
title: "[CONTRACT] "
labels: "contract-change"
assignees: ""
---

> Use this template **only** for changes that break the shape of something a client (QGIS plugin, giswater-api, qwc2) reads.
> Purely additive changes within the current DB major do **not** need this template — use a normal feature/bug issue.
> Full rules: [dbmodel/MAINTENANCE.md](../../dbmodel/MAINTENANCE.md).

## What surface changes

- **Function / view / column:** <!-- e.g. gw_fct_getselectors response, v_edit_node.foo -->
- **Current shape:** <!-- e.g. body.form.formTabs[].fields -->
- **Target shape:** <!-- e.g. body.data.fields (flat) -->
- **Why:** <!-- one line -->

## Affected clients

- [ ] QGIS plugin (this repo)
- [ ] giswater-api
- [ ] qwc2
- [ ] Other (tier-2+, name it): <!-- hengine-api, gw_plus_plugin, … -->

## Expand (DB, 4.x patch on `main`)

- [ ] Add the **new** surface alongside the old one (additive only)
- [ ] Tag every old/removable piece with `-- DEPRECATED #<this issue number>`
- [ ] `UPDATE audit_cat_table / audit_cat_function / audit_cat_sequence SET isdeprecated = TRUE` if a relation/function is deprecated
- [ ] Add a **downgrade transform** in `gw_fct_json_create_return` if older `client.version` must keep the old shape
- [ ] Update `changelog.txt` in the correct `updates/M/m/p/` scope (issue number mandatory)

## Migrate (clients — separate PRs, this same issue)

- [ ] QGIS plugin reads the new shape
- [ ] giswater-api model updated + JSON Schema re-exported + synced to `dbmodel/contracts/schemas/`
- [ ] qwc2 reads the new shape
- [ ] No version-ifs added in any tier-1 client (dialects live in the DB)

## Contract (next DB major — do NOT do during 4.x)

- [ ] Linked from the major-release epic (see template 5)
- [ ] `rg "DEPRECATED #<this issue number>"` returns only the lines to delete
- [ ] Old surface removed in `5/0/x/patch.sql`
- [ ] Downgrade transform for this surface removed
- [ ] This issue closed

## Test plan

- [ ] pgTAP for the function/view
- [ ] `run_contract_tests.py` passes against the giswater-api JSON Schema
- [ ] Golden snapshot updated (re-record + review diff)
