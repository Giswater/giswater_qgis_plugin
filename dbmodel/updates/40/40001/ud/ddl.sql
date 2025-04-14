/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- DROP FUNCTION IF EXISTS gw_trg_vi(); -- TODO: refactor gw_fct_rpt2pg_import_rpt

DROP TABLE IF EXISTS inp_flwreg_outlet CASCADE;
DROP TABLE IF EXISTS inp_flwreg_orifice CASCADE;
DROP TABLE IF EXISTS inp_flwreg_weir CASCADE;

DROP TABLE IF EXISTS inp_dscenario_flwreg_outlet CASCADE;
DROP TABLE IF EXISTS inp_dscenario_flwreg_orifice CASCADE;
DROP TABLE IF EXISTS inp_dscenario_flwreg_weir CASCADE;


CREATE TABLE man_inletpipe (
	link_id int4 NOT NULL,
	CONSTRAINT man_inletpipe_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_inletpipe_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_flwreg_outlet (
    element_id varchar(16) NOT NULL,
    outlet_type character varying(16) NOT NULL,
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    CONSTRAINT inp_flwreg_outlet_pkey PRIMARY KEY (element_id),
    CONSTRAINT inp_flwreg_outlet_check_outlet_type CHECK (((outlet_type)::text = ANY ((ARRAY['FUNCTIONAL/DEPTH'::character varying, 'FUNCTIONAL/HEAD'::character varying, 'TABULAR/DEPTH'::character varying, 'TABULAR/HEAD'::character varying])::text[])))
);

CREATE TABLE inp_flwreg_orifice(
    element_id varchar(16) NOT NULL,
    orifice_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NOT NULL,
    orate numeric(12, 4) NULL,
    flap varchar(3) NOT NULL,
    shape varchar(18) NOT NULL,
    geom1 numeric(12, 4) NOT NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NOT NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    CONSTRAINT inp_flwreg_orifice_pkey PRIMARY KEY (element_id),
    CONSTRAINT inp_flwreg_orifice_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_flwreg_orifice_check_orifice_type CHECK (((orifice_type)::text = ANY (ARRAY[('SIDE'::character varying)::text, ('BOTTOM'::character varying)::text]))),
    CONSTRAINT inp_flwreg_orifice_check_shape CHECK (((shape)::text = ANY (ARRAY[('CIRCULAR'::character varying)::text, ('RECT_CLOSED'::character varying)::text])))
);

CREATE TABLE inp_flwreg_weir(
    element_id varchar(16) NOT NULL,
    weir_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NULL,
    ec numeric(12, 4) NULL,
    cd2 numeric(12, 4) NULL,
    flap varchar(3) NULL,
    geom1 numeric(12, 4) NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    surcharge varchar(3) NULL,
    road_width float8 NULL,
    road_surf varchar(16) NULL,
    coef_curve float8 NULL,
    CONSTRAINT inp_flwreg_weir_pkey PRIMARY KEY (element_id),
    CONSTRAINT inp_flwreg_weir_fkey_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_flwreg_weir_check_weir_type CHECK (((weir_type)::text = ANY (ARRAY['ROADWAY'::text, 'SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL_WEIR'::text])))
);

CREATE TABLE inp_dscenario_flwreg_outlet (
    dscenario_id int4 NOT NULL,
    element_id varchar(16) NOT NULL,
    outlet_type character varying(16) NOT NULL,
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    CONSTRAINT inp_dscenario_flwreg_outlet_pkey PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_flwreg_outlet_fkey_dscenario_id FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_flwreg_outlet_check_outlet_type CHECK (((outlet_type)::text = ANY ((ARRAY['FUNCTIONAL/DEPTH'::character varying, 'FUNCTIONAL/HEAD'::character varying, 'TABULAR/DEPTH'::character varying, 'TABULAR/HEAD'::character varying])::text[])))
);

CREATE TABLE inp_dscenario_flwreg_orifice (
    dscenario_id int4 NOT NULL,
    element_id varchar(16) NOT NULL,
    orifice_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NOT NULL,
    orate numeric(12, 4) NULL,
    flap varchar(3) NOT NULL,
    shape varchar(18) NOT NULL,
    geom1 numeric(12, 4) NOT NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NOT NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    CONSTRAINT inp_dscenario_flwreg_orifice_pkey PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_flwreg_orifice_fkey_dscenario_id FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_flwreg_orifice_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_flwreg_orifice_check_orifice_type CHECK (((orifice_type)::text = ANY (ARRAY[('SIDE'::character varying)::text, ('BOTTOM'::character varying)::text]))),
    CONSTRAINT inp_dscenario_flwreg_orifice_check_shape CHECK (((shape)::text = ANY (ARRAY[('CIRCULAR'::character varying)::text, ('RECT_CLOSED'::character varying)::text])))
);

CREATE TABLE inp_dscenario_flwreg_weir (
    dscenario_id int4 NOT NULL,
    element_id varchar(16) NOT NULL,
    weir_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NULL,
    ec numeric(12, 4) NULL,
    cd2 numeric(12, 4) NULL,
    flap varchar(3) NULL,
    geom1 numeric(12, 4) NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    surcharge varchar(3) NULL,
    road_width float8 NULL,
    road_surf varchar(16) NULL,
    coef_curve float8 NULL,
    CONSTRAINT inp_dscenario_flwreg_weir_pkey PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_flwreg_weir_fkey_dscenario_id FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_flwreg_weir_fkey_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_flwreg_weir_check_weir_type CHECK (((weir_type)::text = ANY (ARRAY['ROADWAY'::text, 'SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL_WEIR'::text])))
);

DROP TABLE IF EXISTS ext_rtc_dma_period CASCADE;
