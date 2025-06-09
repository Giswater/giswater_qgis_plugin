/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;

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
	CONSTRAINT cso_inp_system_subc_pkey PRIMARY KEY (node_id),
	CONSTRAINT unique_node_id_drainzone_id UNIQUE (node_id, drainzone_id)
);

CREATE TABLE cso_out_vol (
	rowid serial4 NOT NULL PRIMARY KEY,
	node_id text NOT NULL,
	drainzone_id text NULL,
	rf_name text NULL,
	rf_tstep text NULL,
	rf_volume numeric(10,3) NULL,
	vol_residual numeric(10,3) NULL,
	vol_max_epi numeric(10,3) NULL,
	vol_res_epi numeric(10,3) NULL,
	vol_rainfall numeric(10,3) NULL,
	vol_total numeric(10,3) NULL,
	vol_runoff numeric(10,3) NULL,
	vol_infiltr numeric(10,3) NULL,
	vol_circ numeric(10,3) NULL,
	vol_circ_dep numeric(10,3) NULL,
	vol_circ_red numeric(10,3) NULL,
	vol_non_leaked numeric(10,3) NULL,
	vol_leaked numeric(10,3) NULL,
	vol_wwtp numeric(10,3) NULL,
	vol_treated numeric(10,3) NULL,
	efficiency numeric(10,3) NULL,
	rf_intensity numeric(10,3) NULL
);

CREATE TABLE cso_subc_wwf (
	node_id text NULL,
	node_type text NULL,
	drainzone_id int4 NULL,
	lito_reclass text NULL,
	usos_reclass text NULL,
	slope_reclass text NULL,
	cn_code text NULL,
	cn_value int4 NULL,
	po numeric(10,3) NULL,
	c_value numeric(10,3) NULL,
	ci_value numeric(10,3) NULL,
	the_geom public.geometry(MULTIPOLYGON, SRID_VALUE) NULL
	CONSTRAINT cso_subc_wwf_pkey PRIMARY KEY (node_id)
);

CREATE TABLE cso_subc_dwf (
	node_id text NOT NULL,
	node_type text NULL,
	drainzone_id int4 NULL,
	consumption numeric(10,3) NULL,
	the_geom public.geometry(MULTIPOLYGON, SRID_VALUE) NULL
	CONSTRAINT cso_subc_dwf_pkey PRIMARY KEY (node_id)
);




CREATE INDEX cso_out_vol_node_id ON cso_out_vol (node_id);
CREATE INDEX cso_out_vol_rf_name ON cso_out_vol (rf_name);
CREATE INDEX cso_out_vol_rf_tstep ON cso_out_vol (rf_tstep);
