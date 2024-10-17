/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 11/10/2024
ALTER TABLE cat_feature_gully DROP CONSTRAINT cat_feature_gully_type_fkey;
ALTER TABLE cat_feature_gully DROP COLUMN type;

-- 15/10/2024
ALTER TABLE cat_arc RENAME TO _cat_arc;

ALTER TABLE arc DROP CONSTRAINT arc_arccat_id_fkey;
ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT inp_dscenario_conduit_arccat_id_fkey;

ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_pkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_arc_type_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_cost_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_curve_id_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_m2bottom_cost_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_m3protec_cost_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_matcat_id_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_shape_id_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT cat_arc_tsect_id_fkey;

DROP INDEX IF EXISTS cat_arc_cost_pkey;
DROP INDEX IF EXISTS cat_arc_m2bottom_cost_pkey;
DROP INDEX IF EXISTS cat_arc_m3protec_cost_pkey;

CREATE TABLE cat_arc (
	id varchar(30) NOT NULL,
    arc_type text NULL,
	matcat_id varchar(16) NULL,
	shape varchar(16) NOT NULL,
	geom1 numeric(12, 4) NULL,
	geom2 numeric(12, 4) DEFAULT 0.00 NULL,
	geom3 numeric(12, 4) DEFAULT 0.00 NULL,
	geom4 numeric(12, 4) DEFAULT 0.00 NULL,
	geom5 numeric(12, 4) NULL,
	geom6 numeric(12, 4) NULL,
	geom7 numeric(12, 4) NULL,
	geom8 numeric(12, 4) NULL,
	geom_r varchar(20) NULL,
	descript varchar(255) NULL,
	link varchar(512) NULL,
	brand varchar(30) NULL,
	model varchar(30) NULL,
	svg varchar(50) NULL,
	z1 numeric(12, 2) NULL,
	z2 numeric(12, 2) NULL,
	width numeric(12, 2) NULL,
	area numeric(12, 4) NULL,
	estimated_depth numeric(12, 2) NULL,
	bulk numeric(12, 2) NULL,
	cost_unit varchar(3) DEFAULT 'm'::character varying NULL,
	"cost" varchar(16) NULL,
	m2bottom_cost varchar(16) NULL,
	m3protec_cost varchar(16) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	tsect_id varchar(16) NULL,
	curve_id varchar(16) NULL,
	acoeff float8 NULL,
	connect_cost text NULL,
	visitability_vdef int4 NULL,
	CONSTRAINT cat_arc_pkey PRIMARY KEY (id),
	CONSTRAINT cat_arc_arc_type_fkey FOREIGN KEY (arc_type) REFERENCES cat_feature_arc(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_arc_cost_fkey FOREIGN KEY ("cost") REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_arc_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_arc_m2bottom_cost_fkey FOREIGN KEY (m2bottom_cost) REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_arc_m3protec_cost_fkey FOREIGN KEY (m3protec_cost) REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_arc_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_arc_shape_id_fkey FOREIGN KEY (shape) REFERENCES cat_arc_shape(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_arc_tsect_id_fkey FOREIGN KEY (tsect_id) REFERENCES inp_transects(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX cat_arc_cost_idx ON cat_arc USING btree (cost);
CREATE INDEX cat_arc_m2bottom_cost_idx ON cat_arc USING btree (m2bottom_cost);
CREATE INDEX cat_arc_m3protec_cost_idx ON cat_arc USING btree (m3protec_cost);


ALTER TABLE cat_node RENAME TO _cat_node;

ALTER TABLE node DROP CONSTRAINT node_nodecat_id_fkey;

ALTER TABLE _cat_node DROP CONSTRAINT cat_node_pkey;
ALTER TABLE _cat_node DROP CONSTRAINT cat_node_brand_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT cat_node_cost_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT cat_node_matcat_id_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT cat_node_model_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT cat_node_node_type_fkey;

CREATE TABLE cat_node (
	id varchar(30) NOT NULL,
	node_type text NULL,
	matcat_id varchar(16) NULL,
	shape varchar(50) NULL,
	geom1 numeric(12, 2) DEFAULT 0 NULL,
	geom2 numeric(12, 2) DEFAULT 0 NULL,
	geom3 numeric(12, 2) DEFAULT 0 NULL,
	descript varchar(255) NULL,
	link varchar(512) NULL,
	brand varchar(30) NULL,
	model varchar(30) NULL,
	svg varchar(50) NULL,
	estimated_y numeric(12, 2) NULL,
	cost_unit varchar(3) DEFAULT 'u'::character varying NULL,
	"cost" varchar(16) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	acoeff float8 NULL,
	CONSTRAINT cat_node_pkey PRIMARY KEY (id),
	CONSTRAINT cat_node_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_node_cost_fkey FOREIGN KEY ("cost") REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_node_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_node(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_node_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_node_node_type_fkey FOREIGN KEY (node_type) REFERENCES cat_feature_node(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_node_shape_fkey FOREIGN KEY (shape) REFERENCES cat_node_shape(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX cat_node_cost_idx ON cat_node USING btree (cost);


ALTER TABLE cat_connec RENAME TO _cat_connec;

ALTER TABLE connec DROP CONSTRAINT connec_connecat_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_private_connecat_id_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_connec_arccat_id_fkey;
ALTER TABLE link DROP CONSTRAINT link_connecat_id_fkey;

ALTER TABLE _cat_connec DROP CONSTRAINT cat_connec_pkey;
ALTER TABLE _cat_connec DROP CONSTRAINT cat_connec_brand_fkey;
ALTER TABLE _cat_connec DROP CONSTRAINT cat_connec_connec_type_fkey;
ALTER TABLE _cat_connec DROP CONSTRAINT cat_connec_matcat_id_fkey;
ALTER TABLE _cat_connec DROP CONSTRAINT cat_connec_model_fkey;

CREATE TABLE cat_connec (
	id varchar(30) NOT NULL,
	connec_type text NULL,
	matcat_id varchar(16) NULL,
	shape varchar(16) NULL,
	geom1 numeric(12, 4) DEFAULT 0 NULL,
	geom2 numeric(12, 4) DEFAULT 0.00 NULL,
	geom3 numeric(12, 4) DEFAULT 0.00 NULL,
	geom4 numeric(12, 4) DEFAULT 0.00 NULL,
	geom_r varchar(20) NULL,
	descript varchar(255) NULL,
	link varchar(512) NULL,
	brand varchar(30) NULL,
	model varchar(30) NULL,
	svg varchar(50) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	CONSTRAINT cat_connec_pkey PRIMARY KEY (id),
	CONSTRAINT cat_connec_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_connec_connec_type_fkey FOREIGN KEY (connec_type) REFERENCES cat_feature_connec(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_connec_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_connec_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE
);


ALTER TABLE cat_grate RENAME TO _cat_grate;

ALTER TABLE gully DROP CONSTRAINT gully_gratecat2_id_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_gratecat_id_fkey;
ALTER TABLE man_netgully DROP CONSTRAINT man_netgully_gratecat2_id_fkey;
ALTER TABLE man_netgully DROP CONSTRAINT man_netgully_gratecat_id_fkey;

ALTER TABLE _cat_grate DROP CONSTRAINT cat_grate_pkey;
ALTER TABLE _cat_grate DROP CONSTRAINT cat_grate_brand_fkey;
ALTER TABLE _cat_grate DROP CONSTRAINT cat_grate_gully_type_fkey;
ALTER TABLE _cat_grate DROP CONSTRAINT cat_grate_matcat_id_fkey;
ALTER TABLE _cat_grate DROP CONSTRAINT cat_grate_model_fkey;

CREATE TABLE cat_grate (
	id varchar(30) NOT NULL,
	gully_type text NULL,
	matcat_id varchar(16) NULL,
	length numeric(12, 4) DEFAULT 0 NULL,
	width numeric(12, 4) DEFAULT 0.00 NULL,
	total_area numeric(12, 4) DEFAULT 0.00 NULL,
	effective_area numeric(12, 4) DEFAULT 0.00 NULL,
	n_barr_l numeric(12, 4) DEFAULT 0.00 NULL,
	n_barr_w numeric(12, 4) DEFAULT 0.00 NULL,
	n_barr_diag numeric(12, 4) DEFAULT 0.00 NULL,
	a_param numeric(12, 4) DEFAULT 0.00 NULL,
	b_param numeric(12, 4) DEFAULT 0.00 NULL,
	descript varchar(255) NULL,
	link varchar(512) NULL,
	brand varchar(30) NULL,
	model varchar(30) NULL,
	svg varchar(50) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	CONSTRAINT cat_grate_pkey PRIMARY KEY (id),
	CONSTRAINT cat_grate_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_grate_gully_type_fkey FOREIGN KEY (gully_type) REFERENCES cat_feature_gully(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_grate_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_grate(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_grate_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE
);
