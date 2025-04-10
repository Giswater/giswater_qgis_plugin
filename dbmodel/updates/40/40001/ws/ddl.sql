/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK 
(((id)::text = ANY (ARRAY['ELEMENT'::text, 'EXPANSIONTANK'::text, 'FILTER'::text, 'FLEXUNION'::text, 'FOUNTAIN'::text, 'GREENTAP'::text, 'HYDRANT'::text, 'JUNCTION'::text, 'MANHOLE'::text, 
'METER'::text, 'NETELEMENT'::text, 'NETSAMPLEPOINT'::text, 'NETWJOIN'::text, 'PIPE'::text, 'PUMP'::text, 'REDUCTION'::text, 'REGISTER'::text, 'SOURCE'::text, 'TANK'::text, 'TAP'::text, 
'VALVE'::text, 'VARC'::text, 'WATERWELL'::text, 'WJOIN'::text, 'WTP'::text, 'SERVCONNECTION'::text, 'GENELEMENT'::text, 'FLWREG'::text])));

CREATE TABLE inp_flwreg_valve (
	element_id varchar(16) NOT NULL,
	valve_type varchar(18) NULL,
	custom_dint numeric(12, 4) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) DEFAULT 0 NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
	CONSTRAINT inp_flwreg_valve_pkey PRIMARY KEY (element_id),
	CONSTRAINT inp_flwreg_valve_valve_type_check CHECK (((valve_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text, ('PSRV'::character varying)::text]))),
	CONSTRAINT inp_flwreg_valve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_flwreg_valve_node_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_dscenario_flwreg_valve (
    dscenario_id int4 NOT NULL,
	element_id varchar(16) NOT NULL,
	valve_type varchar(18) NULL,
	custom_dint numeric(12, 4) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) DEFAULT 0 NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
    CONSTRAINT inp_dscenario_flwreg_valve_pkey PRIMARY KEY (element_id, dscenario_id),
	CONSTRAINT inp_dscenario_flwreg_valve_check_valve_type_ CHECK (((valve_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text, ('PSRV'::character varying)::text]))),
	CONSTRAINT inp_dscenario_flwreg_valve_fkey_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_flwreg_valve_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP FUNCTION IF EXISTS gw_trg_vi();
