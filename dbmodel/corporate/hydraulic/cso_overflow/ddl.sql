/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;


-- ANCHOR Tables

CREATE SEQUENCE IF NOT EXISTS cso_subc_id_seq;
CREATE SEQUENCE IF NOT EXISTS cso_area_type_id_seq;

CREATE TABLE cso_inp_system_subc (
	node_id varchar NOT NULL,
	drainzone_id integer NULL,
	thyssen_plv_area numeric NULL,
	imperv_area numeric NULL,
	mean_coef_runoff numeric NULL,
	demand numeric NULL,
	eq_inhab numeric NULL,
	q_max numeric NULL,
	vret numeric NULL,
	kb numeric NULL,
	active bool NULL,
	vret_imperv numeric NULL,
	muni_name text NULL,
	macroexpl_name text NULL,
	expl_name text NULL,
	calib_coeff_runoff numeric NULL,
	calib_imperv_area numeric NULL,
	weight_factor NUMERIC NULL,
	real_demand NUMERIC NULL,
	CONSTRAINT cso_inp_system_subc_pkey PRIMARY KEY (node_id),
	CONSTRAINT unique_node_id_drainzone_id UNIQUE (node_id, drainzone_id)
);

CREATE TABLE cso_subc_dwf_all (
	id int4 NOT NULL DEFAULT nextval('cso_subc_id_seq'::regclass),
	node_type text NULL,
	drainzone_id int4 NULL,
	consumption numeric(10, 3) NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	node_id text NULL,
	macroexpl_id int4 NULL,
	CONSTRAINT cso_subc_dwf_all_pkey PRIMARY KEY (id)
);

CREATE TABLE cso_subc_wwf_all (
	id int4 NOT NULL DEFAULT nextval('cso_subc_id_seq'::regclass),
	node_type text NULL,
	drainzone_id int4 NULL,
	lito_reclass text NULL,
	landuse_reclass text NULL,
	slope_reclass text NULL,
	cn_code text NULL,
	cn_value int4 NULL,
	po_value numeric(10,3) NULL,
	c_value numeric(10,3) NULL,
	ci_value numeric(10,3) NULL,
	the_geom public.geometry(MULTIPOLYGON, SRID_VALUE) NULL
	node_id text NULL,
	macroexpl_id int4 NULL,
	CONSTRAINT id_pkey PRIMARY KEY (id)
);

CREATE TABLE cso_zone_type_plv (
	id int4 NOT NULL DEFAULT nextval('cso_area_type_id_seq'::regclass),
	area_type text NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	expl_id int4 NOT NULL,
	thy_plv bool NULL,
	thy_res bool NULL,
	active bool NULL,
	CONSTRAINT cso_area_type_pkey PRIMARY KEY (id)
);

CREATE TABLE cso_zone_type_res (
	id int4 NOT NULL DEFAULT nextval('cso_area_type_id_seq'::regclass),
	area_type text NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	expl_id int4 NOT NULL,
	active bool NULL,
	CONSTRAINT cso_area_type_res_pkey PRIMARY KEY (id)
);

CREATE TABLE cso_calibration (
	drainzone_id int4 NOT NULL,
	calib_imperv_area numeric NULL,
	CONSTRAINT cso_calibration_pkey PRIMARY KEY (drainzone_id)
);

CREATE TABLE cso_out_vol (
	rowid int4 NULL,
	node_id text NULL,
	drainzone_id int4 NOT NULL,
	rf_name text NOT NULL,
	rf_tstep text NOT NULL,
	rf_volume float4 NULL,
	vol_residual float4 NULL,
	vol_max_epi float4 NULL,
	vol_rainfall float4 NULL,
	vol_total float4 NULL,
	vol_runoff float4 NULL,
	vol_infiltr float4 NULL,
	vol_circ float4 NULL,
	vol_circ_dep float4 NULL,
	vol_circ_red float4 NULL,
	vol_non_leaked float4 NULL,
	vol_leaked float4 NULL,
	vol_wwtp float4 NULL,
	vol_treated float4 NULL,
	efficiency float4 NULL,
	rf_intensity float4 NULL,
	lastupdate timestamp NULL,
	expl_id integer,
	CONSTRAINT pkey PRIMARY KEY (drainzone_id, rf_name, rf_tstep)
);

CREATE TABLE cso_inp_weir (
	node_id varchar(16) NOT NULL,
	qmax NUMERIC,
	vmax NUMERIC, 
	weight_factor NUMERIC, 
	custom_qmax NUMERIC, 
	custom_vmax NUMERIC,
	CONSTRAINT cso_inp_weir_node_id_pkey PRIMARY KEY (node_id),
	CONSTRAINT cso_inp_weir_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE cso_inp_wwtp (
	node_id varchar(16) NOT NULL,
	habitants integer,
	eq_habitants integer,
	qmed NUMERIC,
	qmax NUMERIC,
	qmin NUMERIC,
	unit_demand NUMERIC,
	CONSTRAINT cso_inp_wwtp_node_id_pkey PRIMARY KEY (node_id),
	CONSTRAINT cso_inp_wwtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- ANCHOR Foreign keys
ALTER TABLE cso_calibration ADD CONSTRAINT cso_calibration_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE cso_out_vol ADD CONSTRAINT drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id);
ALTER TABLE cso_out_vol ADD CONSTRAINT rf_name_fkey FOREIGN KEY (rf_name) REFERENCES inp_timeseries(id);


-- ANCHOR Index

CREATE INDEX cso_out_vol_node_id ON cso_out_vol USING btree (node_id);
CREATE INDEX cso_out_vol_rf_name ON cso_out_vol USING btree (rf_name);
CREATE INDEX cso_out_vol_rf_tstep ON cso_out_vol USING btree (rf_tstep);
