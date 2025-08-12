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
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_arc", "column":"staticpress1", "newName":"staticpressure1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_arc", "column":"staticpress2", "newName":"staticpressure2"}}$$);

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

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_cat_hydrometer", "column":"voltman_flow", "newName":"type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_cat_hydrometer", "column":"multi_jet_flow", "newName":"flownom"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"dma_id", "dataType":"integer[]"}}$$);


-- 06/08/2025
DROP VIEW IF EXISTS v_edit_inp_dscenario_frpump;
DROP VIEW IF EXISTS ve_epa_frpump;
DROP VIEW IF EXISTS v_edit_inp_frpump;
DROP TABLE IF EXISTS inp_frpump;
CREATE TABLE inp_frpump (
    element_id int4 NOT NULL,
	power varchar NULL,
	curve_id varchar NULL,
	speed numeric(12, 6) NULL,
	pattern_id varchar NULL,
	status varchar(12) NULL,
	energyparam varchar(30) NULL,
	energyvalue varchar(30) NULL,
	pump_type varchar(16) DEFAULT 'POWERPUMP'::character varying NULL,
	effic_curve_id varchar(18) NULL,
	energy_price float8 NULL,
	energy_pattern_id varchar(18) NULL,
	CONSTRAINT inp_frpump_pk PRIMARY KEY (element_id),
	CONSTRAINT inp_frpump_status_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('OPEN'::character varying)::text]))),
	CONSTRAINT inp_frpump_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_frpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_frpump_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_frpump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS inp_dscenario_frpump;
CREATE TABLE inp_dscenario_frpump (
	dscenario_id int4 NOT NULL,
	element_id int4 NOT NULL,
	power varchar NULL,
	curve_id varchar NULL,
	speed numeric(12, 6) NULL,
	pattern_id varchar NULL,
	status varchar(12) NULL,
	effic_curve_id varchar(18) NULL,
	energy_price float8 NULL,
	energy_pattern_id varchar(18) NULL,
    CONSTRAINT inp_dscenario_frpump_pk PRIMARY KEY (element_id, dscenario_id),
	CONSTRAINT inp_dscenario_frpump_status_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('OPEN'::character varying)::text]))),
	CONSTRAINT inp_dscenario_frpump_fk_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_frpump_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_frpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_frpump_element_id_fkey FOREIGN KEY (element_id) REFERENCES inp_frpump(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_frpump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"flow_units", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"quality_units", "dataType":"text"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"flow_max", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"flow_min", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"flow_avg", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"vel_max", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"vel_min", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"vel_avg", "dataType":"numeric(12,2)"}}$$);


CREATE TABLE element_add(
	element_id int4 NOT NULL,
	result_id text NULL,
	flow_max numeric(12, 2) NULL,
	flow_min numeric(12, 2) NULL,
	flow_avg numeric(12, 2) NULL,
	vel_max numeric(12, 2) NULL,
	vel_min numeric(12, 2) NULL,
	vel_avg numeric(12, 2) NULL,
	tot_headloss_max numeric(12, 2) NULL,
	tot_headloss_min numeric(12, 2) NULL,
	mincut_connecs int4 NULL,
	mincut_hydrometers int4 NULL,
	mincut_length numeric(12, 3) NULL,
	mincut_watervol numeric(12, 3) NULL,
	mincut_criticality numeric(12, 3) NULL,
	hydraulic_criticality numeric(12, 3) NULL,
	pipe_capacity float8 NULL,
	mincut_impact_topo json NULL,
	mincut_impact_hydro json NULL,
	CONSTRAINT element_add_pkey PRIMARY KEY(element_id),
	CONSTRAINT element_add_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS inp_frshortpipe;
CREATE TABLE inp_frshortpipe (
    element_id int4 NOT NULL,
	minorloss numeric(12, 6) DEFAULT 0 NULL,
	status varchar(12) NULL,
	bulk_coeff float8 NULL,
	wall_coeff float8 NULL,
	custom_dint int4 NULL,
	CONSTRAINT inp_frshortpipe_pk PRIMARY KEY (element_id),
	CONSTRAINT inp_frshortpipe_status_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('CV'::character varying)::text, ('OPEN'::character varying)::text]))),
	CONSTRAINT inp_frshortpipe_fk_element_id FOREIGN KEY (element_id) REFERENCES element(element_id)
);

DROP TABLE IF EXISTS inp_dscenario_frshortpipe;
CREATE TABLE inp_dscenario_frshortpipe (
	dscenario_id int4 NOT NULL,
	element_id int4 NOT NULL,
	minorloss numeric(12, 6) NULL,
	status varchar(12) NULL,
	custom_dint int4 NULL,
	bulk_coeff float8 NULL,
	wall_coeff float8 NULL,
    CONSTRAINT inp_dscenario_frshortpipe_pk PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_frshortpipe_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_frshortpipe_status_check CHECK (((status)::text = ANY (ARRAY[('CLOSED'::character varying)::text, ('CV'::character varying)::text, ('OPEN'::character varying)::text]))),
	CONSTRAINT inp_dscenario_frshortpipe_element_id_fkey FOREIGN KEY (element_id) REFERENCES inp_frshortpipe(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 06/08/2025
DO $function$
DECLARE
    v_crm boolean;
BEGIN

	SELECT value::boolean INTO v_crm FROM config_param_system WHERE parameter='admin_crm_schema';

	PERFORM gw_fct_admin_manage_fields(format($${"data":{"action":"RENAME", "table":"ext_cat_hydrometer", "column":"voltman_flow", "newName":"type", "isCrm":%s}}$$, v_crm::text)::json);
	PERFORM gw_fct_admin_manage_fields(format($${"data":{"action":"RENAME", "table":"ext_cat_hydrometer", "column":"multi_jet_flow", "newName":"flownom", "isCrm":%s}}$$, v_crm::text)::json);

END $function$;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_pump", "column":"pump_type", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_pump", "column":"engine_type", "dataType":"int4"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"flowsetting", "dataType":"numeric(12,3)"}}$$);
