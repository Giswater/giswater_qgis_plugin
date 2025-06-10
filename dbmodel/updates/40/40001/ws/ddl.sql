/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE inp_frvalve (
	element_id int4 NOT NULL,
	valve_type varchar(18) NULL,
	custom_dint numeric(12, 4) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) DEFAULT 0 NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
	CONSTRAINT inp_frvalve_pkey PRIMARY KEY (element_id),
	CONSTRAINT inp_frvalve_valve_type_check CHECK (((valve_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text, ('PSRV'::character varying)::text]))),
	CONSTRAINT inp_frvalve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_frvalve_node_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_dscenario_frvalve (
    dscenario_id int4 NOT NULL,
	element_id int4 NOT NULL,
	valve_type varchar(18) NULL,
	custom_dint numeric(12, 4) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) DEFAULT 0 NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
    CONSTRAINT inp_dscenario_frvalve_pkey PRIMARY KEY (element_id, dscenario_id),
	CONSTRAINT inp_dscenario_frvalve_check_valve_type_ CHECK (((valve_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text, ('PSRV'::character varying)::text]))),
	CONSTRAINT inp_dscenario_frvalve_fkey_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_frvalve_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_frpump (
    element_id int4 NOT NULL,
    curve_id varchar(16) NOT NULL,
    status varchar(3) NULL,
    startup numeric(12, 4) NULL,
    shutoff numeric(12, 4) NULL,
    CONSTRAINT inp_frpump_pk PRIMARY KEY (element_id),
	CONSTRAINT inp_frpump_fk_element_id FOREIGN KEY (element_id) REFERENCES element(element_id),
    CONSTRAINT inp_frpump_chk_status CHECK (status::text = ANY (ARRAY['ON'::text, 'OFF'::text])),
    CONSTRAINT inp_frpump_fk_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE inp_dscenario_frpump (
    dscenario_id int4 NOT NULL,
    element_id int4 NOT NULL,
    pump_type varchar(18) NOT NULL,
    curve_id varchar(16) NOT NULL,
    status varchar(3) NULL,
    startup numeric(12, 4) NULL,
    shutoff numeric(12, 4) NULL,
    CONSTRAINT inp_dscenario_frpump_pk PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_frpump_chk_status CHECK (status::text = ANY (ARRAY['ON'::text, 'OFF'::text])),
    CONSTRAINT inp_dscenario_frpump_fk_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


DROP FUNCTION IF EXISTS gw_trg_vi();

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_dscenario_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_dscenario_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_dscenario_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_dscenario_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ve_epa_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ve_epa_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"vi_valves", "column":"valv_type", "newName":"valve_type"}}$$);


-- 12/05/2025
ALTER TABLE man_valve DROP CONSTRAINT IF EXISTS man_valve_to_arc_fky;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_valve", "column":"to_arc", "dataType":"int4"}}$$);
ALTER TABLE man_pump DROP CONSTRAINT IF EXISTS man_pump_to_arc_fkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_pump", "column":"to_arc", "dataType":"int4"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"inlet_arc", "dataType":"integer[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"inlet_arc", "dataType":"integer[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"inlet_arc", "dataType":"integer[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"to_arc", "dataType":"int4", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"length", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"width", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"height", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"max_volume", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"util_volume", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

ALTER TABLE inp_pump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';
ALTER TABLE inp_virtualpump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';
ALTER TABLE inp_dscenario_virtualpump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';

--15/05/2025
ALTER TABLE connec_add ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE connec_add ADD CONSTRAINT connec_add_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON DELETE CASCADE ON UPDATE CASCADE;

-- 19/05/2025
ALTER TABLE cat_feature_node ALTER COLUMN graph_delimiter DROP DEFAULT;
DROP VIEW IF EXISTS v_edit_cat_feature_node;
ALTER TABLE cat_feature_node DROP CONSTRAINT node_type_graph_delimiter_check;
ALTER TABLE cat_feature_node ALTER COLUMN graph_delimiter TYPE _text USING ARRAY[graph_delimiter];


-- 20/05/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"pipe_capacity", "dataType":"float", "isUtils":"False"}}$$);


-- 27/05/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"mincut_impact", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"mincut_affectation", "dataType":"json", "isUtils":"False"}}$$);

-- 09/06/2025
-- Convert dma_id, dqa_id, presszone_id, expl_id, sector_id, muni_id to arrays in minsector
ALTER TABLE minsector DROP CONSTRAINT minsector_dma_id_fkey;
ALTER TABLE minsector ALTER COLUMN dma_id TYPE _int4 USING ARRAY[dma_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsector_dqa_id_fkey;
ALTER TABLE minsector ALTER COLUMN dqa_id TYPE _int4 USING ARRAY[dqa_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsector_presszonecat_id_fkey;
ALTER TABLE minsector ALTER COLUMN presszone_id TYPE _int4 USING ARRAY[presszone_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsector_expl_id_fkey;
ALTER TABLE minsector ALTER COLUMN expl_id TYPE _int4 USING ARRAY[expl_id::int4];
ALTER TABLE minsector ALTER COLUMN sector_id TYPE _int4 USING ARRAY[sector_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsectormuni_id_fkey;
ALTER TABLE minsector ALTER COLUMN muni_id TYPE _int4 USING ARRAY[muni_id::int4];

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"supplyzone_id", "dataType":"integer[]", "isUtils":"False"}}$$);

-- 10/06/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"minsector_graph", "column":"macrominsector_id"}}$$);
ALTER TABLE minsector_graph ADD CONSTRAINT minsector_graph_minsector_1_fk FOREIGN KEY (minsector_1) REFERENCES minsector(minsector_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE minsector_graph ADD CONSTRAINT minsector_graph_minsector_2_fk FOREIGN KEY (minsector_2) REFERENCES minsector(minsector_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE man_pipelink (
	link_id int4 NOT NULL,
	CONSTRAINT man_pipelink_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_pipelink_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_vconnec (
	connec_id int4 NOT NULL,
	CONSTRAINT man_vconnec_pkey PRIMARY KEY (connec_id),
	CONSTRAINT man_vconnec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_vlink (
	link_id int4 NOT NULL,
	CONSTRAINT man_vlink_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_vlink_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);
