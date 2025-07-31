/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/07/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_valve", "column":"pression_exit", "newName":"pressure_exit"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_valve", "column":"pression_entry", "newName":"pressure_entry"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_pump", "column":"pressure", "newName":"pressure_exit"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc", "column":"staticpress1", "newName":"staticpressure1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc", "column":"staticpress2", "newName":"staticpressure2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"staticpressure", "newName":"staticpressure1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"staticpressure2", "dataType":"numeric(12,3)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_arc_traceability", "column":"staticpress1", "newName":"staticpressure1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_arc_traceability", "column":"staticpress2", "newName":"staticpressure2"}}$$);

-- 15/07/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc_add", "column":"mincut_impact", "newName":"mincut_impact_topo"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc_add", "column":"mincut_affectation", "newName":"mincut_impact_hydro"}}$$);

-- 15/07/2025
/*
-- Change expl_id type to INT4[] in macrodma
DROP VIEW IF EXISTS v_edit_macrodma;
DROP VIEW IF EXISTS v_ui_macrodma;
ALTER TABLE macrodma DROP CONSTRAINT IF EXISTS macrodma_expl_id_fkey;
ALTER TABLE macrodma ALTER COLUMN expl_id TYPE INT4[] USING ARRAY[expl_id];

-- Change expl_id type to INT4[] in macrodqa
DROP VIEW IF EXISTS v_edit_macrodqa;
DROP VIEW IF EXISTS v_ui_macrodqa;
ALTER TABLE macrodqa DROP CONSTRAINT IF EXISTS macrodqa_expl_id_fkey;
ALTER TABLE macrodqa ALTER COLUMN expl_id TYPE INT4[] USING ARRAY[expl_id];

-- Change expl_id type to INT4[] in macroomzone
DROP VIEW IF EXISTS v_edit_macroomzone;
DROP VIEW IF EXISTS v_ui_macroomzone;
ALTER TABLE macroomzone DROP CONSTRAINT IF EXISTS macroomzone_expl_id_fkey;
ALTER TABLE macroomzone ALTER COLUMN expl_id TYPE INT4[] USING ARRAY[expl_id];
*/

-- 24/07/2025
ALTER TABLE om_waterbalance_dma_graph ALTER COLUMN node_id TYPE int4 USING node_id::int4;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"meter_type", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"name", "dataType":"text"}}$$);

-- 31/07/2025
CREATE TABLE IF NOT EXISTS minsector_mincut_valve (
    minsector_id INT4,
    node_id INT4,
    proposed BOOLEAN,
    CONSTRAINT minsector_mincut_valve_pkey PRIMARY KEY (minsector_id, node_id),
    CONSTRAINT minsector_mincut_valve_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT minsector_mincut_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_minsector_mincut_valve_minsector_id ON minsector_mincut_valve (minsector_id);
CREATE INDEX IF NOT EXISTS idx_minsector_mincut_valve_node_id ON minsector_mincut_valve (node_id);

