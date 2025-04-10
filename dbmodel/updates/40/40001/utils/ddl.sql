/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TABLE IF EXISTS flwreg CASCADE;
DROP TABLE IF EXISTS cat_flwreg CASCADE;
DROP TABLE IF EXISTS inp_flwreg_pump CASCADE;
DROP TABLE IF EXISTS inp_dscenario_flwreg_pump CASCADE;


CREATE TABLE man_servconnection (
	link_id int4 NOT NULL,
	CONSTRAINT man_servconnection_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_servconnection_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE sys_feature_class DROP CONSTRAINT sys_feature_cat_check;
DELETE FROM sys_feature_class WHERE id = 'LINK';
DELETE FROM sys_feature_class WHERE type = 'FLWREG';

CREATE TABLE cat_feature_link (
	id varchar(30) NOT NULL,
	CONSTRAINT cat_feature_link_pkey PRIMARY KEY (id),
	CONSTRAINT cat_feature_link_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cat_link (
	id varchar(30) NOT NULL,
	link_type varchar(30) NOT NULL,
	matcat_id varchar(30) NULL,
	pnom varchar(16) NULL,
	dnom varchar(16) NULL,
	dint numeric(12, 5) NULL,
	dext numeric(12, 5) NULL,
	descript varchar(512) NULL,
	link varchar(512) NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	svg varchar(50) NULL,
	z1 numeric(12, 2) NULL,
	z2 numeric(12, 2) NULL,
	width numeric(12, 2) NULL,
	area numeric(12, 4) NULL,
	estimated_depth numeric(12, 2) NULL,
	thickness numeric(12, 2) NULL,
	cost_unit varchar(3) DEFAULT 'm'::character varying NULL,
	"cost" varchar(16) NULL,
	m2bottom_cost varchar(16) NULL,
	m3protec_cost varchar(16) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	CONSTRAINT cat_link_pkey PRIMARY KEY (id),
	CONSTRAINT cat_link_linktype_id_fkey FOREIGN KEY (link_type) REFERENCES cat_feature_link(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_link_brand_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_cost_fkey FOREIGN KEY ("cost") REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_m2bottom_cost_fkey FOREIGN KEY (m2bottom_cost) REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_m3protec_cost_fkey FOREIGN KEY (m3protec_cost) REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_link_model_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX cat_link_cost_pkey ON cat_link USING btree (cost);
CREATE INDEX cat_link_m2bottom_cost_pkey ON cat_link USING btree (m2bottom_cost);
CREATE INDEX cat_link_m3protec_cost_pkey ON cat_link USING btree (m3protec_cost);

ALTER TABLE link DROP CONSTRAINT link_linkcat_id_fkey;
ALTER TABLE link ADD CONSTRAINT link_linkcat_id_fkey FOREIGN KEY (linkcat_id) REFERENCES cat_link(id) ON DELETE RESTRICT ON UPDATE CASCADE;



CREATE TABLE man_genelement (
    element_id varchar(16) NOT NULL,
    CONSTRAINT man_genelement_pkey PRIMARY KEY (element_id)
);

CREATE TABLE man_flwreg (
    element_id varchar(16) NOT NULL,
    flwreg_class varchar(16) NOT NULL,
	flwreg_type text NULL,
    nodarc_id varchar NULL,
    order_id numeric NULL,
    to_arc varchar NULL,
    flwreg_length numeric NULL,
    CONSTRAINT man_flwreg_pkey PRIMARY KEY (element_id)
);

CREATE TABLE cat_feature_element (
    id varchar(30) NOT NULL,
    epa_default varchar(30) NOT NULL,
    geometry_type varchar(30) NOT NULL DEFAULT 'POINT',
    CONSTRAINT cat_feature_element_pkey PRIMARY KEY (id),
    CONSTRAINT cat_feature_element_fkey_element_id FOREIGN KEY (id) REFERENCES cat_feature(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT cat_feature_element_check_geometry_type CHECK (geometry_type::text = ANY (ARRAY['POLYGON'::text, 'LINESTRING'::text, 'POINT'::text])),
    CONSTRAINT cat_feature_element_inp_check CHECK (epa_default::text = ANY (ARRAY['ORIFICE'::text, 'WEIR'::text, 'OUTLET'::text, 'PUMP'::text, 'UNDEFINED'::text]))
);

CREATE TABLE inp_flwreg_pump (
    element_id varchar(16) NOT NULL,
    pump_type varchar(18) NOT NULL,
    curve_id varchar(16) NOT NULL,
    status varchar(3) NULL,
    startup numeric(12, 4) NULL,
    shutoff numeric(12, 4) NULL,
    CONSTRAINT inp_flwreg_pump_pkey PRIMARY KEY (element_id),
    CONSTRAINT inp_flwreg_pump_check_status CHECK (status::text = ANY (ARRAY['ON'::text, 'OFF'::text])),
    CONSTRAINT inp_flwreg_pump_fkey_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE inp_dscenario_flwreg_pump (
    dscenario_id int4 NOT NULL,
    element_id varchar(16) NOT NULL,
    pump_type varchar(18) NOT NULL,
    curve_id varchar(16) NOT NULL,
    status varchar(3) NULL,
    startup numeric(12, 4) NULL,
    shutoff numeric(12, 4) NULL,
    CONSTRAINT inp_dscenario_flwreg_pump_pkey PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_flwreg_pump_check_status CHECK (status::text = ANY (ARRAY['ON'::text, 'OFF'::text])),
    CONSTRAINT inp_dscenario_flwreg_pump_fkey_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"geometry_type", "dataType":"text"}}$$);
