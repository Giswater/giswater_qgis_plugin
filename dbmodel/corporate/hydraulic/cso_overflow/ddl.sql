/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;

CREATE TABLE cso_inp_system_subc (
	node_id varchar NOT NULL,
	drainzone_id varchar NULL,
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
	rowid serial4 NOT NULL,
	node_id text NOT NULL,
	drainzone_id text NULL,
	rf_name text NULL,
	rf_tstep text NULL,
	rf_volume numeric NULL,
	vol_residual numeric NULL,
	vol_max_epi numeric NULL,
	vol_res_epi numeric NULL,
	vol_rainfall numeric NULL,
	vol_total numeric NULL,
	vol_runoff numeric NULL,
	vol_infiltr numeric NULL,
	vol_circ numeric NULL,
	vol_circ_dep numeric NULL,
	vol_circ_red numeric NULL,
	vol_non_leaked numeric NULL,
	vol_leaked numeric NULL,
	vol_wwtp numeric NULL,
	vol_treated numeric NULL,
	efficiency numeric NULL,
	rf_intensity numeric NULL
);


CREATE INDEX cso_out_vol_node_id ON cso_out_vol (node_id);
CREATE INDEX cso_out_vol_rf_name ON cso_out_vol (rf_name);
CREATE INDEX cso_out_vol_rf_tstep ON cso_out_vol (rf_tstep);





