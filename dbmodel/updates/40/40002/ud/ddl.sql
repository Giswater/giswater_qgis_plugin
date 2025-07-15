/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE man_wwtp ALTER COLUMN wwtp_type SET DEFAULT 0;
ALTER TABLE man_wwtp ALTER COLUMN treatment_type SET DEFAULT 0;


-- 07/07/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dwfzone", "column":"drainzone_id", "dataType":"int4"}}$$);

DROP VIEW IF EXISTS v_ui_plan_arc_cost;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_psector_all;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget_detail;
DROP VIEW IF EXISTS v_edit_inp_dscenario_conduit;
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;
DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_plan_aux_arc_pavement;
DROP VIEW IF EXISTS v_edit_inp_conduit;
DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_outlet;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_virtual;
DROP VIEW IF EXISTS v_edit_inp_weir;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS ve_pol_storage;
DROP VIEW IF EXISTS ve_pol_wwtp;
DROP VIEW IF EXISTS ve_pol_chamber;
DROP VIEW IF EXISTS ve_pol_netgully;
DROP VIEW IF EXISTS v_ui_plan_node_cost;
DROP VIEW IF EXISTS v_plan_result_node;
DROP VIEW IF EXISTS v_plan_psector_budget_node;
DROP VIEW IF EXISTS v_plan_node;
DROP VIEW IF EXISTS v_edit_inp_dscenario_outfall;
DROP VIEW IF EXISTS v_edit_inp_outfall;
DROP VIEW IF EXISTS v_edit_inp_dscenario_storage;
DROP VIEW IF EXISTS v_edit_inp_storage;
DROP VIEW IF EXISTS v_edit_inp_netgully;
DROP VIEW IF EXISTS v_edit_inp_divider;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
DROP VIEW IF EXISTS v_edit_inp_dscenario_treatment;
DROP VIEW IF EXISTS v_edit_inp_dwf;
DROP VIEW IF EXISTS v_edit_inp_inflows;
DROP VIEW IF EXISTS v_edit_inp_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_treatment;
DROP VIEW IF EXISTS v_edit_inp_junction;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS v_ui_arc_x_relations;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;
DROP VIEW IF EXISTS ve_connec_cjoin;
DROP VIEW IF EXISTS ve_connec_vconnec;
DROP VIEW IF EXISTS v_edit_connec;
DROP VIEW IF EXISTS v_edit_inp_gully;
DROP VIEW IF EXISTS ve_gully_ginlet;
DROP VIEW IF EXISTS ve_gully_pgully;
DROP VIEW IF EXISTS ve_gully_vgully;
DROP VIEW IF EXISTS v_edit_gully;
DROP VIEW IF EXISTS v_edit_link_connec;
DROP VIEW IF EXISTS v_edit_link_gully;
DROP VIEW IF EXISTS ve_link_link;
DROP VIEW IF EXISTS v_edit_link;

-- TODO: Check if this is needed
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc", "column":"drainzone_id", "newName":"dma_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"node", "column":"drainzone_id", "newName":"dma_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"drainzone_id", "newName":"dma_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"gully", "column":"drainzone_id", "newName":"dma_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"drainzone_id", "newName":"dma_id"}}$$);

CREATE TABLE IF NOT EXISTS dma (
    dma_id SERIAL,
    name TEXT,
    descript TEXT,
    muni_id INT4[],
    expl_id INT4[],
    sector_id INT4[],
    graphconfig JSON,
    active BOOLEAN DEFAULT TRUE,
    the_geom GEOMETRY(POLYGON, SRID_VALUE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by TEXT DEFAULT current_user,
    updated_at TIMESTAMP,
    updated_by TEXT,
    CONSTRAINT dma_pk PRIMARY KEY (dma_id)
);

ALTER TABLE dwfzone ADD CONSTRAINT dwfzone_drainzone_fk FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id);

-- 14/07/2025
DELETE FROM sys_foreignkey WHERE target_table = 'dma';

