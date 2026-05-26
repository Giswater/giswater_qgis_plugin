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

DROP TABLE IF EXISTS inp_inlet;
CREATE TABLE inp_inlet (
	node_id integer NOT NULL,
	y0 numeric(12, 4) NULL,
	ysur numeric(12, 4) NULL,
	apond numeric(12, 4) NULL,
	inlet_type varchar(30) NULL,
	outlet_type varchar(30) NULL,
	gully_method varchar(30) NULL,
	custom_top_elev float8 NULL,
	custom_depth float8 NULL,
	inlet_length float8 NULL,
	inlet_width float8 NULL,
	cd1 float8 NULL,
	cd2 float8 NULL,
	efficiency float8 NULL,
    CONSTRAINT inp_inlet_pkey PRIMARY KEY (node_id),
	CONSTRAINT inp_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_dscenario_inlet (
	dscenario_id int4 NOT NULL,
	node_id integer NOT NULL,
	elev float8 NULL,
	ymax float8 NULL,
	y0 numeric(12, 4) NULL,
	ysur numeric(12, 4) NULL,
	apond numeric(12, 4) NULL,
	inlet_type varchar(30) NULL,
	outlet_type varchar(30) NULL,
	gully_method varchar(30) NULL,
	custom_top_elev float8 NULL,
	custom_depth float8 NULL,
	inlet_length float8 NULL,
	inlet_width float8 NULL,
	cd1 float8 NULL,
	cd2 float8 NULL,
	efficiency float8 NULL,
	CONSTRAINT inp_dscenario_inlet_pkey PRIMARY KEY (dscenario_id, node_id),
	CONSTRAINT inp_dscenario_inlet_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_inlet(node_id) ON DELETE CASCADE ON UPDATE CASCADE
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"temp_gully", "column":"gully_id", "dataType":"varchar(30)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_gully", "column":"method", "newName":"gully_method"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_netgully", "column":"method", "newName":"gully_method"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ve_epa_netgully", "column":"method", "newName":"gully_method"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ve_epa_gully", "column":"method", "newName":"gully_method"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"temp_arc_flowregulator", "column":"arc_id", "dataType":"varchar(30)"}}$$);

-- 15/07/2025
DROP TABLE IF EXISTS macrominisector;

/*
-- Add expl_id and muni_id to sector
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"expl_id", "dataType":"INT4[]", "isUtils":"True"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"muni_id", "dataType":"INT4[]", "isUtils":"True"}}$$);

-- Add sector_id and muni_id to explotation
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation", "column":"sector_id", "dataType":"INT4[]", "isUtils":"True"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"exploitation", "column":"muni_id", "dataType":"INT4[]", "isUtils":"True"}}$$);

-- Add expl_id and sector_id to ext_municipality
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_municipality", "column":"expl_id", "dataType":"INT4[]", "isUtils":"True"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_municipality", "column":"sector_id", "dataType":"INT4[]", "isUtils":"True"}}$$);


-- Add muni_id and sector_id to drainzone
DROP VIEW IF EXISTS v_edit_drainzone;
DROP VIEW IF EXISTS v_ui_drainzone;
ALTER TABLE drainzone ALTER COLUMN expl_id TYPE INT4[] USING ARRAY[expl_id];
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"muni_id", "dataType":"INT4[]", "isUtils":"True"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"sector_id", "dataType":"INT4[]", "isUtils":"True"}}$$);

-- Add muni_id and sector_id to dwfzone
DROP VIEW IF EXISTS v_edit_dwfzone;
DROP VIEW IF EXISTS v_ui_dwfzone;
ALTER TABLE dwfzone ALTER COLUMN expl_id TYPE INT4[] USING ARRAY[expl_id];
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dwfzone", "column":"muni_id", "dataType":"INT4[]", "isUtils":"True"}}$$);
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dwfzone", "column":"sector_id", "dataType":"INT4[]", "isUtils":"True"}}$$);

-- Change expl_id type to INT4[] in Macroomzone
DROP VIEW IF EXISTS v_edit_macroomzone;
DROP VIEW IF EXISTS v_ui_macroomzone;
ALTER TABLE macroomzone DROP CONSTRAINT IF EXISTS macroomzone_expl_id_fkey;
ALTER TABLE macroomzone ALTER COLUMN expl_id TYPE INT4[] USING ARRAY[expl_id];

*/


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME", "table":"man_outfall", "column":"discharge_medium", "newName":"outfall_medium", "isUtils":"False"}}$$);
DELETE FROM sys_foreignkey WHERE typevalue_name='discharge_medium_typevalue';
UPDATE edit_typevalue SET typevalue='outfall_medium_typevalue' WHERE typevalue='discharge_medium_typevalue';
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'outfall_medium_typevalue', 'man_outfall', 'outfall_medium', NULL, true);
UPDATE config_form_fields SET "label"='outfall_medium', tooltip='outfall_medium', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''outfall_medium_typevalue''' WHERE formname='ve_node_outfall' AND formtype='form_feature' AND columnname='discharge_medium' AND tabname='tab_data';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_netinit", "column":"inlet_medium", "dataType":"int4", "isUtils":"False"}}$$);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('inlet_medium_typevalue', '0', 'Undefined', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'inlet_medium_typevalue', 'man_netinit', 'inlet_medium', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields SET layoutname='lyt_data_1', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''inlet_medium_typevalue''', dv_isnullvalue=TRUE WHERE columnname='inlet_medium' AND formname ILIKE '%netinit%';

-- 07/08/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_dscenario_frpump", "column":"pump_type", "isUtils":"False"}}$$);
ALTER TABLE inp_dscenario_froutlet ALTER COLUMN outlet_type DROP NOT NULL;
ALTER TABLE inp_dscenario_frorifice ALTER COLUMN orifice_type DROP NOT NULL;
ALTER TABLE inp_dscenario_frweir ALTER COLUMN weir_type DROP NOT NULL;
ALTER TABLE inp_froutlet ALTER COLUMN outlet_type DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN orifice_type DROP NOT NULL;
ALTER TABLE inp_frweir ALTER COLUMN weir_type DROP NOT NULL;

ALTER TABLE archived_psector_gully_traceability RENAME COLUMN tstamp TO created_at;
ALTER TABLE archived_psector_gully_traceability RENAME COLUMN insert_user TO created_by;
ALTER TABLE archived_psector_gully_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_gully_traceability RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE archived_psector_gully_traceability RENAME to archived_psector_gully;
ALTER SEQUENCE archived_psector_gully_traceability_id_seq RENAME TO archived_psector_gully_id_seq;
ALTER TABLE archived_psector_gully RENAME CONSTRAINT audit_psector_gully_traceability_pkey TO archived_psector_gully_pkey;

ALTER TABLE archived_psector_gully drop column streetname;
ALTER TABLE archived_psector_gully drop column streetname2;

UPDATE sys_foreignkey SET target_table='archived_psector_gully' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_gully_traceability' AND target_field='fluid_type';
UPDATE sys_table SET descript='archived_psector_gully', id='archived_psector_gully' WHERE id='archived_psector_gully_traceability';

-- 06/08/2025
DO $function$
DECLARE
    v_crm boolean;
BEGIN

    SELECT value::boolean INTO v_crm FROM config_param_system WHERE parameter='admin_crm_schema';

    PERFORM gw_fct_admin_manage_fields(format($${"data":{"action":"RENAME", "table":"ext_cat_hydrometer", "column":"voltman_flow", "newName":"type", "isCrm":%s}}$$, v_crm::text)::json);
    PERFORM gw_fct_admin_manage_fields(format($${"data":{"action":"RENAME", "table":"ext_cat_hydrometer", "column":"multi_jet_flow", "newName":"flownom", "isCrm":%s}}$$, v_crm::text)::json);

END $function$;


CREATE TABLE om_waterbalance_dma_graph (
    node_id int4 NOT NULL,
    dma_id int4 NOT NULL,
    flow_sign int2 NULL,
    CONSTRAINT om_waterbalance_dma_graph_unique UNIQUE (dma_id, node_id),
    CONSTRAINT om_waterbalance_dma_graph_pkey PRIMARY KEY (node_id, dma_id),
    CONSTRAINT om_waterbalance_dma_graph_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT om_waterbalance_dma_graph_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE man_cjoin (
	connec_id int4 NOT NULL,
	CONSTRAINT man_cjoin_pkey PRIMARY KEY (connec_id),
	CONSTRAINT man_cjoin_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_ginlet (
	gully_id int4 NOT NULL,
	CONSTRAINT man_ginlet_pkey PRIMARY KEY (gully_id),
	CONSTRAINT man_ginlet_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP VIEW IF EXISTS v_edit_inp_dscenario_frorifice;
DROP VIEW IF EXISTS v_edit_inp_frorifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frpump;
DROP VIEW IF EXISTS v_edit_inp_frpump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frweir;
DROP VIEW IF EXISTS v_edit_inp_frweir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_froutlet;
DROP VIEW IF EXISTS v_edit_inp_froutlet;
DROP VIEW IF EXISTS ve_epa_frorifice;
DROP VIEW IF EXISTS ve_epa_frweir;
DROP VIEW IF EXISTS ve_epa_froutlet;
DROP VIEW IF EXISTS ve_epa_frpump;
DROP VIEW IF EXISTS ve_element_eorifice;
DROP VIEW IF EXISTS ve_element_eweir;
DROP VIEW IF EXISTS ve_element_eoutlet;
DROP VIEW IF EXISTS ve_element_epump;
DROP VIEW IF EXISTS ve_man_frelem;
DROP VIEW IF EXISTS ve_frelem CASCADE;
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_frelem", "column":"order_id"}}$$);
