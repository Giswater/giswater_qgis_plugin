/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE inp_frvalve (
	element_id varchar(16) NOT NULL,
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
	element_id varchar(16) NOT NULL,
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
    element_id varchar(16) NOT NULL,
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
    element_id varchar(16) NOT NULL,
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


ALTER TABLE inp_pump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';
ALTER TABLE inp_virtualpump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';
ALTER TABLE inp_dscenario_virtualpump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';
