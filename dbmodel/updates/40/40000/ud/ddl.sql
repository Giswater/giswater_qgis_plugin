/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 11/10/2024
ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

ALTER TABLE cat_feature_gully DROP CONSTRAINT IF EXISTS cat_feature_gully_type_fkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_feature_gully", "column":"type", "newName":"_type"}}$$);

ALTER TABLE inp_flwreg_orifice RENAME TO inp_frorifice;
ALTER TABLE inp_flwreg_weir RENAME TO inp_frweir;
ALTER TABLE inp_flwreg_outlet RENAME TO inp_froutlet;
ALTER TABLE inp_flwreg_pump RENAME TO inp_frpump;

ALTER TABLE inp_dscenario_flwreg_orifice RENAME TO inp_dscenario_frorifice;
ALTER TABLE inp_dscenario_flwreg_weir RENAME TO inp_dscenario_frweir;
ALTER TABLE inp_dscenario_flwreg_outlet RENAME TO inp_dscenario_froutlet;
ALTER TABLE inp_dscenario_flwreg_pump RENAME TO inp_dscenario_frpump;


-- 15/10/2024
ALTER TABLE cat_arc RENAME TO _cat_arc;

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_arccat_id_fkey;
ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT IF EXISTS inp_dscenario_conduit_arccat_id_fkey;

ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_pkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_arc_type_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_cost_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_curve_id_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_m2bottom_cost_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_m3protec_cost_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_matcat_id_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_shape_id_fkey;
ALTER TABLE _cat_arc DROP CONSTRAINT IF EXISTS cat_arc_tsect_id_fkey;

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
	brand_id varchar(30) NULL,
	model_id varchar(30) NULL,
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
	CONSTRAINT cat_arc_shape_id_fkey FOREIGN KEY (shape) REFERENCES cat_arc_shape(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_arc_tsect_id_fkey FOREIGN KEY (tsect_id) REFERENCES inp_transects(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT cat_arc_brand_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT cat_arc_model_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX cat_arc_cost_idx ON cat_arc USING btree (cost);
CREATE INDEX cat_arc_m2bottom_cost_idx ON cat_arc USING btree (m2bottom_cost);
CREATE INDEX cat_arc_m3protec_cost_idx ON cat_arc USING btree (m3protec_cost);


ALTER TABLE cat_node RENAME TO _cat_node;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_nodecat_id_fkey;

ALTER TABLE _cat_node DROP CONSTRAINT IF EXISTS cat_node_pkey;
ALTER TABLE _cat_node DROP CONSTRAINT IF EXISTS cat_node_brand_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT IF EXISTS cat_node_cost_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT IF EXISTS cat_node_matcat_id_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT IF EXISTS cat_node_model_fkey;
ALTER TABLE _cat_node DROP CONSTRAINT IF EXISTS cat_node_node_type_fkey;

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
	brand_id varchar(30) NULL,
	model_id varchar(30) NULL,
	svg varchar(50) NULL,
	estimated_y numeric(12, 2) NULL,
	cost_unit varchar(3) DEFAULT 'u'::character varying NULL,
	"cost" varchar(16) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	acoeff float8 NULL,
	CONSTRAINT cat_node_pkey PRIMARY KEY (id),
	CONSTRAINT cat_node_brand_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_node_cost_fkey FOREIGN KEY ("cost") REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_node_model_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_node_node_type_fkey FOREIGN KEY (node_type) REFERENCES cat_feature_node(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_node_shape_fkey FOREIGN KEY (shape) REFERENCES cat_node_shape(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX cat_node_cost_idx ON cat_node USING btree (cost);


ALTER TABLE cat_connec RENAME TO _cat_connec;

ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_connecat_id_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_private_connecat_id_fkey;
ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_connec_arccat_id_fkey;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_connecat_id_fkey;

ALTER TABLE _cat_connec DROP CONSTRAINT IF EXISTS cat_connec_pkey;
ALTER TABLE _cat_connec DROP CONSTRAINT IF EXISTS cat_connec_brand_fkey;
ALTER TABLE _cat_connec DROP CONSTRAINT IF EXISTS cat_connec_connec_type_fkey;
ALTER TABLE _cat_connec DROP CONSTRAINT IF EXISTS cat_connec_matcat_id_fkey;
ALTER TABLE _cat_connec DROP CONSTRAINT IF EXISTS cat_connec_model_fkey;

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
	brand_id varchar(30) NULL,
	model_id varchar(30) NULL,
	svg varchar(50) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
	CONSTRAINT cat_connec_pkey PRIMARY KEY (id),
	CONSTRAINT cat_connec_brand_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_connec_connec_type_fkey FOREIGN KEY (connec_type) REFERENCES cat_feature_connec(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_connec_model_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE
);


ALTER TABLE cat_grate RENAME TO _cat_grate;

ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_gratecat2_id_fkey;
ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_gratecat_id_fkey;
ALTER TABLE man_netgully DROP CONSTRAINT IF EXISTS man_netgully_gratecat2_id_fkey;
ALTER TABLE man_netgully DROP CONSTRAINT IF EXISTS man_netgully_gratecat_id_fkey;

CREATE TABLE cat_gully (
	id varchar(30) NOT NULL,
    gully_type text NULL,
    matcat_id varchar(16) NULL,
    length numeric(12, 4) DEFAULT 0 NULL,
    width numeric(12, 4) DEFAULT 0.00 NULL,
    ymax numeric(12, 4) DEFAULT 0.00 NULL,
    efficiency numeric(12, 4) DEFAULT 0.00 NULL,
    descript varchar(255) NULL,
    link varchar(512) NULL,
    brand_id varchar(30) NULL,
    model_id varchar(30) NULL,
    svg varchar(50) NULL,
    label varchar(255) NULL,
    active bool DEFAULT true NULL,
	CONSTRAINT cat_gully_pkey PRIMARY KEY (id),
	CONSTRAINT cat_gully_brand_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_gully_gully_type_fkey FOREIGN KEY (gully_type) REFERENCES cat_feature_gully(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_gully_model_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 22/10/2024
-- update dv_querytext before rename column to prevent error on config_control()
-- fix config_form_fields
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='v_edit_gully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='v_edit_inp_gully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='v_edit_gully' AND formtype='form_feature' AND columnname='gratecat2_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='v_edit_inp_netgully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='gratecat2_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully_gully' AND formtype='form_feature' AND columnname='gratecat2_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully_pgully' AND formtype='form_feature' AND columnname='gratecat2_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully_vgully' AND formtype='form_feature' AND columnname='gratecat2_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully_gully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully_pgully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE formname='ve_gully_vgully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT NULL AS id, NULL AS idval FROM cat_gully WHERE id IS NOT NULL' WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='geom1' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT NULL AS id, NULL AS idval FROM cat_gully WHERE id IS NOT NULL' WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='shape' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL' WHERE formname='v_edit_review_audit_gully' AND formtype='form_feature' AND columnname='old_gratecat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL' WHERE formname='v_edit_review_audit_gully' AND formtype='form_feature' AND columnname='new_gratecat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT(id) AS id, id AS idval FROM cat_gully WHERE id IS NOT NULL' WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT(matcat_id) AS id, matcat_id AS idval FROM cat_gully WHERE id IS NOT NULL' WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_gully WHERE id IS NOT NULL' WHERE formname='v_edit_review_gully' AND formtype='form_feature' AND columnname='gratecat_id' AND tabname='tab_none';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"private_connecat_id", "newName":"private_conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_connec", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"review_connec", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"gully", "column":"gratecat_id", "newName":"gullycat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_gully", "column":"gratecat_id", "newName":"gullycat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"gully", "column":"gratecat2_id", "newName":"gullycat2_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_netgully", "column":"gratecat_id", "newName":"gullycat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_netgully", "column":"gratecat2_id", "newName":"gullycat2_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"review_gully", "column":"gratecat_id", "newName":"gullycat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"connecat_id", "newName":"conneccat_id"}}$$);

-- 14/11/2024
ALTER TABLE inp_dscenario_lid_usage RENAME TO inp_dscenario_lids;


-- 19/11/2024
ALTER TABLE gully DROP CONSTRAINT gully_category_type_feature_type_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_fluid_type_feature_type_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_function_type_feature_type_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_location_type_feature_type_fkey;

-- 02/12/2024
DROP VIEW IF EXISTS ve_epa_orifice;
DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_frorifice;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_orifice", "column":"close_time"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_frorifice", "column":"close_time"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_dscenario_frorifice", "column":"close_time"}}$$);

-- 03/12/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_outfall", "column":"route_to", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_outfall", "column":"route_to", "dataType":"varchar(16)"}}$$);

-- 04/12/2024
DROP VIEW IF EXISTS v_edit_cat_dwf_scenario;
ALTER TABLE cat_dwf_scenario RENAME TO cat_dwf;
ALTER SEQUENCE cat_dwf_scenario_id_seq RENAME TO cat_dwf_id_seq;

ALTER TABLE doc_x_gully DROP CONSTRAINT doc_x_gully_doc_id_fkey;

-- 09/12/2024
ALTER SEQUENCE audit_psector_gully_traceability_id_seq RENAME TO archived_psector_gully_traceability_id_seq;
ALTER TABLE audit_psector_gully_traceability RENAME TO archived_psector_gully_traceability;

DROP VIEW IF EXISTS ve_epa_storage;
DROP VIEW IF EXISTS v_edit_inp_dscenario_storage;
DROP VIEW IF EXISTS v_edit_inp_storage;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_storage", "column":"apond"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dscenario_storage", "column":"apond"}}$$);

ALTER TABLE rtc_scada_x_dma RENAME to _rtc_scada_x_dma;
ALTER TABLE rtc_scada_x_sector RENAME to _rtc_scada_x_sector;

ALTER TABLE om_reh_cat_works RENAME TO _om_reh_cat_works;
ALTER TABLE om_reh_parameter_x_works RENAME TO _om_reh_parameter_x_works;
ALTER TABLE om_reh_value_loc_condition RENAME TO _om_reh_value_loc_condition;
ALTER TABLE om_reh_works_x_pcompost RENAME TO _om_reh_works_x_pcompost;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_conduit", "column":"inlet_offset", "newName":"_inlet_offset"}}$$);

-- 12/12/2024
ALTER TABLE gully DROP CONSTRAINT gully_matcat_id_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_connec_matcat_id_fkey;

ALTER TABLE cat_mat_grate RENAME TO _cat_mat_grate;
ALTER TABLE cat_mat_gully RENAME TO _cat_mat_gully;

-- 13/12/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_arc", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_arc_x_node", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_connec", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_gully", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_node", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"anl_polygon", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"config_param_user", "column":"cur_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dimensions", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dimensions", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dma", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"dma", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);

DROP VIEW IF EXISTS v_edit_drainzone;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"drainzone", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"drainzone", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"exploitation", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"exploitation", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_psector", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_psector", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"sector", "column":"insert_user", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"sector", "column":"lastupdate_user", "dataType":"varchar(50)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_timeseries", "column":"idval"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE", "table":"inp_timeseries", "column":"addparam", "dataType":"jsonb"}}$$);

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;


-- 21/01/2025
ALTER TABLE temp_node RENAME TO _temp_node;
ALTER TABLE _temp_node RENAME CONSTRAINT temp_node_pkey TO _temp_node_pkey;
ALTER TABLE _temp_node RENAME CONSTRAINT temp_node_node_id_unique TO _temp_node_node_id_unique;

DROP INDEX IF EXISTS temp_node_epa_type;
DROP INDEX IF EXISTS temp_node_index;
DROP INDEX IF EXISTS temp_node_node_id;
DROP INDEX IF EXISTS temp_node_node_type;
DROP INDEX IF EXISTS temp_node_nodeparent;
DROP INDEX IF EXISTS temp_node_result_id;

CREATE TABLE temp_node (
	id serial4 NOT NULL,
	result_id varchar(30) NULL,
	node_id int4 NOT NULL,
	top_elev numeric(12, 3) NULL,
	ymax numeric(12, 3) NULL,
	elev numeric(12, 3) NULL,
	node_type varchar(30) NULL,
	nodecat_id varchar(30) NULL,
	epa_type varchar(16) NULL,
	sector_id int4 NULL,
	state int2 NULL,
	state_type int2 NULL,
	annotation varchar(254) NULL,
	omzone_id int4 NULL,
	y0 numeric(12, 4) NULL,
	ysur numeric(12, 4) NULL,
	apond numeric(12, 4) NULL,
	expl_id int4 NULL,
	addparam text NULL,
	parent varchar(16) NULL,
	arcposition int2 NULL,
	fusioned_node text NULL,
	age int4 NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT temp_node_node_id_unique UNIQUE (node_id),
	CONSTRAINT temp_node_pkey PRIMARY KEY (id)
);
CREATE INDEX temp_node_epa_type ON temp_node USING btree (epa_type);
CREATE INDEX temp_node_index ON temp_node USING gist (the_geom);
CREATE INDEX temp_node_node_id ON temp_node USING btree (node_id);
CREATE INDEX temp_node_node_type ON temp_node USING btree (node_type);
CREATE INDEX temp_node_nodeparent ON temp_node USING btree (parent);
CREATE INDEX temp_node_result_id ON temp_node USING btree (result_id);
CREATE INDEX temp_node_omzone_id ON temp_node USING btree (omzone_id);

ALTER TABLE temp_arc RENAME TO _temp_arc;
ALTER TABLE _temp_arc RENAME CONSTRAINT temp_arc_pkey TO _temp_arc_pkey;

DROP INDEX IF EXISTS temp_arc_arc_id;
DROP INDEX IF EXISTS temp_arc_arc_type;
DROP INDEX IF EXISTS temp_arc_epa_type;
DROP INDEX IF EXISTS temp_arc_index;
DROP INDEX IF EXISTS temp_arc_node_1_type;
DROP INDEX IF EXISTS temp_arc_node_2_type;
DROP INDEX IF EXISTS temp_arc_result_id;


CREATE TABLE temp_arc (
	id serial4 NOT NULL,
	result_id varchar(30) NULL,
	arc_id int4 NOT NULL,
	node_1 int4 NULL,
	node_2 int4 NULL,
	elevmax1 numeric(12, 3) NULL,
	elevmax2 numeric(12, 3) NULL,
	arc_type varchar(30) NULL,
	arccat_id varchar(30) NULL,
	epa_type varchar(16) NULL,
	sector_id int4 NULL,
	state int2 NULL,
	state_type int2 NULL,
	annotation varchar(254) NULL,
	omzone_id int4 NULL,
	length numeric(12, 3) NULL,
	n numeric(12, 3) NULL,
	expl_id int4 NULL,
	addparam text NULL,
	arcparent varchar(16) NULL,
	q0 float8 NULL,
	qmax float8 NULL,
	barrels int4 NULL,
	slope float8 NULL,
	flag bool NULL,
	culvert varchar(10) NULL,
	kentry numeric(12, 4) NULL,
	kexit numeric(12, 4) NULL,
	kavg numeric(12, 4) NULL,
	flap varchar(3) NULL,
	seepage numeric(12, 4) NULL,
	age int4 NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT temp_arc_pkey PRIMARY KEY (id)
);
CREATE INDEX temp_arc_arc_id ON temp_arc USING btree (arc_id);
CREATE INDEX temp_arc_arc_type ON temp_arc USING btree (arc_type);
CREATE INDEX temp_arc_epa_type ON temp_arc USING btree (epa_type);
CREATE INDEX temp_arc_index ON temp_arc USING gist (the_geom);
CREATE INDEX temp_arc_node_1_type ON temp_arc USING btree (node_1);
CREATE INDEX temp_arc_node_2_type ON temp_arc USING btree (node_2);
CREATE INDEX temp_arc_omzone_id ON temp_arc USING btree (omzone_id);
CREATE INDEX temp_arc_result_id ON temp_arc USING btree (result_id);

ALTER TABLE temp_gully RENAME TO _temp_gully;
ALTER TABLE _temp_gully RENAME CONSTRAINT temp_gully_pkey TO _temp_gully_pkey;

CREATE TABLE temp_gully (
	gully_id int4 NOT NULL,
	gully_type varchar(30) NULL,
	gullycat_id varchar(30) NULL,
	arc_id int4 NULL,
	node_id int4 NULL,
	sector_id int4 NULL,
	state int2 NULL,
	state_type int2 NULL,
	top_elev float8 NULL,
	units int4 NULL,
	units_placement varchar(16) NULL,
	outlet_type varchar(30) NULL,
	width float8 NULL,
	length float8 NULL,
	"depth" float8 NULL,
	"method" varchar(30) NULL,
	weir_cd float8 NULL,
	orifice_cd float8 NULL,
	a_param float8 NULL,
	b_param float8 NULL,
	efficiency int4 NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	CONSTRAINT temp_gully_pkey PRIMARY KEY (gully_id)
);

DROP VIEW IF EXISTS v_edit_inp_dscenario_frpump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_froutlet;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frorifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frweir;

DROP VIEW IF EXISTS v_edit_inp_frpump;
DROP VIEW IF EXISTS v_edit_inp_froutlet;
DROP VIEW IF EXISTS v_edit_inp_frorifice;
DROP VIEW IF EXISTS v_edit_inp_frweir;


ALTER TABLE man_manhole RENAME TO _man_manhole;
ALTER TABLE _man_manhole DROP CONSTRAINT IF EXISTS man_manhole_pkey;
ALTER TABLE _man_manhole DROP CONSTRAINT IF EXISTS man_manhole_node_id_fkey;

CREATE TABLE man_manhole (
	node_id int4 NOT NULL,
	length numeric(12, 3) DEFAULT 0 NULL,
	width numeric(12, 3) DEFAULT 0 NULL,
	sander_depth numeric(12, 3) NULL,
	prot_surface bool NULL,
	inlet bool NULL,
	bottom_channel bool NULL,
	accessibility varchar(16) NULL,
	bottom_mat text NULL,
	height numeric(12,4),
	CONSTRAINT man_manhole_pkey PRIMARY KEY (node_id)
);


ALTER TABLE review_node RENAME TO _review_node;
ALTER TABLE _review_node DROP CONSTRAINT IF EXISTS review_node_pkey;

CREATE TABLE review_node (
	node_id int4 NOT NULL,
	top_elev numeric(12, 3) NULL,
	ymax numeric(12, 3) NULL,
	node_type varchar(18) NULL,
	matcat_id varchar(30) NULL,
	nodecat_id varchar(30) NULL,
	annotation text NULL,
	observ text NULL,
	review_obs text NULL,
	expl_id int4 NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	field_checked bool NULL,
	is_validated int4 NULL,
	field_date timestamp(6) NULL,
	CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
);

ALTER TABLE review_audit_node RENAME TO _review_audit_node;
ALTER TABLE _review_audit_node DROP CONSTRAINT IF EXISTS review_audit_node_pkey;

CREATE TABLE review_audit_node (
	id serial4 NOT NULL,
	node_id int4 NOT NULL,
	old_top_elev numeric(12, 3) NULL,
	new_top_elev numeric(12, 3) NULL,
	old_ymax numeric(12, 3) NULL,
	new_ymax numeric(12, 3) NULL,
	old_node_type varchar(18) NULL,
	new_node_type varchar(18) NULL,
	old_matcat_id varchar(30) NULL,
	new_matcat_id varchar(30) NULL,
	old_nodecat_id varchar(30) NULL,
	new_nodecat_id varchar(30) NULL,
	old_annotation text NULL,
	new_annotation text NULL,
	old_observ text NULL,
	new_observ text NULL,
	review_obs text NULL,
	expl_id int4 NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	review_status_id int2 NULL,
	field_date timestamp(6) NULL,
	field_user text NULL,
	is_validated int4 NULL,
	CONSTRAINT review_audit_node_pkey PRIMARY KEY (id)
);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_chamber", "column":"height", "dataType":"numeric(12,4)"}}$$);



-- 30/01/2025
CREATE TABLE dwfzone (
	dwfzone_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(30) NULL,
	dwfzone_type varchar(16) NULL,
	expl_id int4 NULL,
	descript text NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT dwfzone_pkey PRIMARY KEY (dwfzone_id)
);

-- 31/01/2025

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"sector", "column":"sector_type", "dataType":"varchar(50)"}}$$);

-- 10/02/2025
CREATE TABLE arc_add (
	arc_id int4 NOT NULL,
	result_id text NULL,
	max_flow numeric(12, 2) NULL,
	max_veloc numeric(12, 2) NULL,
	mfull_flow numeric(12, 2) NULL,
	mfull_depth numeric(12, 2) NULL,
	manning_veloc numeric(12,3) NULL,
	manning_flow numeric(12,3) NULL,
	dwf_minflow numeric(12,3) NULL,
	dwf_maxflow numeric(12,3) NULL,
	dwf_minvel numeric(12,3) NULL,
	dwf_maxvel numeric(12,3) NULL,
	CONSTRAINT arc_add_pkey PRIMARY KEY (arc_id)
);

CREATE TABLE node_add (
	node_id int4 NOT NULL,
	result_id text NULL,
	max_depth  numeric(12, 2) NULL,
	max_height  numeric(12, 2) NULL,
	flooding_rate  numeric(12, 2) NULL,
	flooding_vol  numeric(12, 2) null,
	CONSTRAINT node_add_pkey PRIMARY KEY (node_id)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_arcflow_sum", "column":"mfull_dept", "newName":"mfull_depth"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_rpt_inp_arc", "column":"mfull_dept", "newName":"mfull_depth"}}$$);

-- element_x_arc
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_pkey;
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_unique;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"element_x_arc", "column":"id"}}$$);
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_pkey PRIMARY KEY (element_id, arc_id);

-- element_x_connec
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_pkey;
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_unique;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"element_x_connec", "column":"id"}}$$);
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_pkey PRIMARY KEY (element_id, connec_id);

-- element_x_node
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_pkey;
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_unique;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"element_x_node", "column":"id"}}$$);
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_pkey PRIMARY KEY (element_id, node_id);

-- element_x_gully
ALTER TABLE element_x_gully DROP CONSTRAINT element_x_gully_pkey;
ALTER TABLE element_x_gully DROP CONSTRAINT element_x_gully_unique;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"element_x_gully", "column":"id"}}$$);
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_pkey PRIMARY KEY (element_id, gully_id);

-- doc_x_arc
ALTER TABLE doc_x_arc DROP CONSTRAINT doc_x_arc_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_arc", "column":"id"}}$$);
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_pkey PRIMARY KEY (doc_id, arc_id);

-- doc_x_connec
ALTER TABLE doc_x_connec DROP CONSTRAINT doc_x_connec_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_connec", "column":"id"}}$$);
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_pkey PRIMARY KEY (doc_id, connec_id);

-- doc_x_gully
ALTER TABLE doc_x_gully DROP CONSTRAINT doc_x_gully_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_gully", "column":"id"}}$$);
ALTER TABLE doc_x_gully ADD CONSTRAINT doc_x_gully_pkey PRIMARY KEY (doc_id, gully_id);

-- doc_x_node
ALTER TABLE doc_x_node DROP CONSTRAINT doc_x_node_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_node", "column":"id"}}$$);
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_pkey PRIMARY KEY (doc_id, node_id);

-- doc_x_psector
ALTER TABLE doc_x_psector DROP CONSTRAINT doc_x_psector_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_psector", "column":"id"}}$$);
ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_pkey PRIMARY KEY (doc_id, psector_id);

-- doc_x_visit
ALTER TABLE doc_x_visit DROP CONSTRAINT doc_x_visit_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_visit", "column":"id"}}$$);
ALTER TABLE doc_x_visit ADD CONSTRAINT doc_x_visit_pkey PRIMARY KEY (doc_id, visit_id);

-- doc_x_workcat
ALTER TABLE doc_x_workcat DROP CONSTRAINT doc_x_workcat_pkey;
ALTER TABLE doc_x_workcat DROP CONSTRAINT unique_doc_id_workcat_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"doc_x_workcat", "column":"id"}}$$);
ALTER TABLE doc_x_workcat ADD CONSTRAINT doc_x_workcat_pkey PRIMARY KEY (doc_id, workcat_id);

-- 27/02/2025
-- man_conduit
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_conduit", "column":"conduit_code", "dataType":"text", "isUtils":"False"}}$$);

-- man_wjump
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wjump", "column":"wjump_code", "dataType":"text", "isUtils":"False"}}$$);

-- man_waccel
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_waccel", "column":"waccel_code", "dataType":"text", "isUtils":"False"}}$$);

-- man_siphon
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_siphon", "column":"siphon_code", "dataType":"text", "isUtils":"False"}}$$);

-- man_wwtp
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"wwtp_code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"wwtp_type", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"treatment_type", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"maxflow", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"opsflow", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"wwtp_function", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"served_hydrometer", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"efficiency", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"sludge_disposition", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_wwtp", "column":"sludge_treatment", "dataType":"boolean", "isUtils":"False"}}$$);

UPDATE man_wwtp SET wwtp_type=0 WHERE wwtp_type IS NULL;
ALTER TABLE man_wwtp ALTER COLUMN wwtp_type SET NOT NULL;

UPDATE man_wwtp SET treatment_type=0 WHERE treatment_type IS NULL;
ALTER TABLE man_wwtp ALTER COLUMN treatment_type SET NOT NULL;

-- man_manhole
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_manhole", "column":"manhole_code", "dataType":"text", "isUtils":"False"}}$$);

-- 03/03/2025

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"flow_units"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"rain_runof"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"snowmelt"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"groundw"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"flow_rout"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"pond_all"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"water_q"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"infil_m"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"flowrout_m"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"start_date"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"end_date"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"dry_days"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"rep_tstep"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"wet_tstep"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"dry_tstep"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"rout_tstep"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"var_time_step"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"max_trials"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"head_tolerance"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"man_outfall", "column":"discharge_medium", "dataType":"int4", "isUtils":"False"}}$$);


-- 04/03/2025
DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS vu_sector;
DROP RULE IF EXISTS undelete_sector ON sector;
DROP RULE IF EXISTS undelete_dma ON dma;
DROP RULE IF EXISTS undelete_macrodma ON macrodma;


-- 05/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"fluid_type", "dataType":"varchar(50)"}}$$);

-- 06/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"negativeoffset", "dataType":"boolean", "isUtils":"False"}}$$);

--12/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"bulk", "newName":"thickness"}}$$);


-- 18/03/2025
-- node
ALTER TABLE node RENAME TO _node;


-- Drop foreign keys that reference node
ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT inp_dwf_pol_x_node_node_id_fkey;
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_node_id_fkey;
ALTER TABLE arc DROP CONSTRAINT arc_node_1_fkey;
ALTER TABLE arc DROP CONSTRAINT arc_node_2_fkey;
ALTER TABLE arc DROP CONSTRAINT arc_parent_id_fkey;
ALTER TABLE man_wwtp DROP CONSTRAINT man_wwtp_node_id_fkey;
ALTER TABLE om_visit_event DROP CONSTRAINT om_visit_event_position_id_fkey;
ALTER TABLE inp_inflows_poll DROP CONSTRAINT inp_inflows_pol_x_node_node_id_fkey;
ALTER TABLE man_netgully DROP CONSTRAINT man_netgully_node_id_fkey;
ALTER TABLE inp_netgully DROP CONSTRAINT inp_netgully_gully_id_fkey;
ALTER TABLE inp_outfall DROP CONSTRAINT inp_outfall_node_id_fkey;
ALTER TABLE man_chamber DROP CONSTRAINT man_chamber_node_id_fkey;
ALTER TABLE node_border_sector DROP CONSTRAINT arc_border_expl_node_id_fkey;
ALTER TABLE inp_divider DROP CONSTRAINT inp_divider_node_id_fkey;
ALTER TABLE man_netelement DROP CONSTRAINT man_netelement_node_id_fkey;
ALTER TABLE inp_groundwater DROP CONSTRAINT inp_groundwater_node_id_fkey;
ALTER TABLE doc_x_node DROP CONSTRAINT doc_x_node_node_id_fkey;
ALTER TABLE man_wjump DROP CONSTRAINT man_wjump_node_id_fkey;
ALTER TABLE inp_dscenario_inflows_poll DROP CONSTRAINT inp_dscenario_inflows_node_id_fkey;
ALTER TABLE man_storage DROP CONSTRAINT man_storage_node_id_fkey;
ALTER TABLE man_netinit DROP CONSTRAINT man_netinit_node_id_fkey;
ALTER TABLE om_visit_x_node DROP CONSTRAINT om_visit_x_node_node_id_fkey;
ALTER TABLE man_valve DROP CONSTRAINT man_valve_node_id_fkey;
ALTER TABLE man_junction DROP CONSTRAINT man_junction_node_id_fkey;
ALTER TABLE inp_inflows DROP CONSTRAINT inp_inflows_node_id_fkey;
ALTER TABLE inp_storage DROP CONSTRAINT inp_storage_node_id_fkey;
ALTER TABLE inp_rdii DROP CONSTRAINT inp_rdii_node_id_fkey;
ALTER TABLE inp_dwf DROP CONSTRAINT inp_dwf_node_id_fkey;
ALTER TABLE man_outfall DROP CONSTRAINT man_outfall_node_id_fkey;
ALTER TABLE inp_junction DROP CONSTRAINT inp_junction_node_id_fkey;
ALTER TABLE inp_dscenario_inflows DROP CONSTRAINT inp_dscenario_inflows_node_id_fkey;
ALTER TABLE plan_psector_x_node DROP CONSTRAINT plan_psector_x_node_node_id_fkey;
ALTER TABLE inp_treatment DROP CONSTRAINT inp_treatment_node_x_pol_node_id_fkey;


-- Drop foreign keys from table node

ALTER TABLE _node DROP CONSTRAINT node_district_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_buildercat_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_drainzone_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_dma_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_expl_fkey;
ALTER TABLE _node DROP CONSTRAINT node_expl_id2_fkey;
ALTER TABLE _node DROP CONSTRAINT node_feature_type_fkey;
ALTER TABLE _node DROP CONSTRAINT node_muni_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_node_type_fkey;
ALTER TABLE _node DROP CONSTRAINT node_ownercat_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_parent_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_sector_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_soilcat_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_state_fkey;
ALTER TABLE _node DROP CONSTRAINT node_state_type_fkey;
ALTER TABLE _node DROP CONSTRAINT node_streetaxis2_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_streetaxis_id_fkey;
ALTER TABLE _node DROP CONSTRAINT node_workcat_id_end_fkey;
ALTER TABLE _node DROP CONSTRAINT node_workcat_id_fkey;

ALTER TABLE inp_frorifice DROP CONSTRAINT inp_flwreg_orifice_node_id_fkey;
ALTER TABLE inp_froutlet DROP CONSTRAINT inp_flwreg_outlet_node_id_fkey;
ALTER TABLE inp_frpump DROP CONSTRAINT inp_flwreg_pump_node_id_fkey;
ALTER TABLE inp_frweir DROP CONSTRAINT inp_flwreg_weir_node_id_fkey;

ALTER TABLE inp_frorifice DROP CONSTRAINT inp_flwreg_orifice_to_arc_fkey;
ALTER TABLE inp_froutlet DROP CONSTRAINT inp_flwreg_outlet_to_arc_fkey;
ALTER TABLE inp_frpump DROP CONSTRAINT inp_flwreg_pump_to_arc_fkey;
ALTER TABLE inp_frweir DROP CONSTRAINT inp_flwreg_weir_to_arc_fkey;


-- Drop restrictions from table node
ALTER TABLE _node DROP CONSTRAINT node_epa_type_check;
ALTER TABLE _node DROP CONSTRAINT node_pkey;


-- Drop rules from table node

DROP RULE IF EXISTS insert_plan_psector_x_node ON _node;
DROP RULE IF EXISTS undelete_node ON _node;


-- Drop indexes from table node

DROP INDEX IF EXISTS node_arc_id;
DROP INDEX IF EXISTS node_dma;
DROP INDEX IF EXISTS node_exploitation;
DROP INDEX IF EXISTS node_exploitation2;
DROP INDEX IF EXISTS node_index;
DROP INDEX IF EXISTS node_muni;
DROP INDEX IF EXISTS node_nodecat;
DROP INDEX IF EXISTS node_nodetype_index;
DROP INDEX IF EXISTS node_pkey;
DROP INDEX IF EXISTS node_sector;
DROP INDEX IF EXISTS node_street1;
DROP INDEX IF EXISTS node_street2;
DROP INDEX IF EXISTS node_streetname;
DROP INDEX IF EXISTS node_streetname2;


-- New order to table node
CREATE TABLE node (
	node_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev numeric(12, 3) NULL,
	custom_top_elev numeric(12, 3) NULL,
	ymax numeric(12, 3) NULL,
	custom_ymax numeric(12, 3) NULL,
	elev numeric(12, 3) NULL,
	custom_elev numeric(12, 3) NULL,
	feature_type varchar(16) DEFAULT 'NODE'::character varying NULL,
	node_type varchar(30) NOT NULL,
	matcat_id varchar(16) NULL,
	nodecat_id varchar(30) NOT NULL,
	epa_type varchar(16) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	arc_id int4 NULL,
	parent_id int4 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	drainzone_id int4 DEFAULT 0 NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	omunit_id int4 DEFAULT 0 NULL,
	minsector_id int4 DEFAULT 0 NULL,
	dwfzone_outfall int4[] NULL,
	drainzone_outfall int4[] NULL,
	pavcat_id text NULL,
	soilcat_id varchar(16) NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	annotation text NULL,
	observ text NULL,
	comment text NULL,
	descript text NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	district_id int4 NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NULL,
	postnumber int4 NULL,
	postcomplement varchar(100) NULL,
	streetaxis2_id varchar(16) NULL,
	postnumber2 int4 NULL,
	postcomplement2 varchar(100) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	workcat_id_plan varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	access_type text NULL,
	placement_type varchar(50) NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	serial_number varchar(100) NULL,
	asset_id varchar(50) NULL,
	adate text NULL,
	adescript text NULL,
	verified int4 NULL,
	xyz_date date NULL,
	uncertain bool NULL,
	datasource int4 NULL,
	unconnected bool NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	rotation numeric(6, 3) NULL,
	label_quadrant varchar(12) NULL,
	hemisphere float8 NULL,
	inventory bool NULL,
	publish bool NULL,
	is_scadamap bool NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	CONSTRAINT node_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['JUNCTION'::text, 'STORAGE'::text, 'DIVIDER'::text, 'OUTFALL'::text, 'NETGULLY'::text, 'UNDEFINED'::text]))),
	CONSTRAINT node_pkey PRIMARY KEY (node_id),
	CONSTRAINT cat_pavement_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_node_type_fkey FOREIGN KEY (node_type) REFERENCES cat_feature_node(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX node_arc_id ON node USING btree (arc_id);
CREATE INDEX node_omzone ON node USING btree (omzone_id);
CREATE INDEX node_exploitation ON node USING btree (expl_id);
CREATE INDEX node_expl_visibility_idx ON node USING btree (expl_visibility);
CREATE INDEX node_index ON node USING gist (the_geom);
CREATE INDEX node_muni ON node USING btree (muni_id);
CREATE INDEX node_nodecat ON node USING btree (nodecat_id);
CREATE INDEX node_nodetype_index ON node USING btree (node_type);
CREATE INDEX node_sector ON node USING btree (sector_id);
CREATE INDEX node_street1 ON node USING btree (streetaxis_id);
CREATE INDEX node_street2 ON node USING btree (streetaxis2_id);
CREATE INDEX node_sys_code_idx ON node USING btree (sys_code);
CREATE INDEX node_asset_id_idx ON node USING btree (asset_id);

-- arc
ALTER TABLE arc RENAME TO _arc;


-- Drop foreign keys that reference arc
ALTER TABLE connec DROP CONSTRAINT connec_arc_id_fkey;
ALTER TABLE doc_x_arc DROP CONSTRAINT doc_x_arc_arc_id_fkey;
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_arc_id_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_arc_id_fkey;
ALTER TABLE inp_conduit DROP CONSTRAINT inp_conduit_arc_id_fkey;
ALTER TABLE inp_divider DROP CONSTRAINT inp_divider_arc_id_fkey;
ALTER TABLE inp_orifice DROP CONSTRAINT inp_orifice_arc_id_fkey;
ALTER TABLE inp_outlet DROP CONSTRAINT inp_outlet_arc_id_fkey;
ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_arc_id_fkey;
ALTER TABLE inp_weir DROP CONSTRAINT inp_weir_arc_id_fkey;
ALTER TABLE man_conduit DROP CONSTRAINT man_conduit_arc_id_fkey;
ALTER TABLE man_siphon DROP CONSTRAINT man_siphon_arc_id_fkey;
ALTER TABLE man_varc DROP CONSTRAINT man_varc_arc_id_fkey;
ALTER TABLE man_waccel DROP CONSTRAINT man_waccel_arc_id_fkey;
ALTER TABLE om_visit_x_arc DROP CONSTRAINT om_visit_x_arc_arc_id_fkey;
ALTER TABLE plan_arc_x_pavement DROP CONSTRAINT plan_arc_x_pavement_arc_id_fkey;
ALTER TABLE plan_psector_x_arc DROP CONSTRAINT plan_psector_x_arc_arc_id_fkey;
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT plan_psector_x_connec_arc_id_fkey;
ALTER TABLE plan_psector_x_gully DROP CONSTRAINT plan_psector_x_gully_arc_id_fkey;


ALTER TABLE _arc_border_expl_ DROP CONSTRAINT arc_border_expl_arc_id_fkey;

-- Drop foreign keys from table arc

ALTER TABLE _arc DROP CONSTRAINT arc_arc_type_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_buildercat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_district_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_dma_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_drainzone_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_expl_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_expl_id2_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_feature_type_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_muni_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_ownercat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_pavcat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_sector_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_soilcat_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_state_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_state_type_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_streetaxis_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_streetaxis2_id_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_workcat_id_end_fkey;
ALTER TABLE _arc DROP CONSTRAINT arc_workcat_id_fkey;

-- Drop restrictions from table arc
ALTER TABLE _arc DROP CONSTRAINT arc_epa_type_check;
ALTER TABLE _arc DROP CONSTRAINT arc_pkey;


-- Drop rules from table arc

DROP RULE IF EXISTS insert_plan_psector_x_arc ON _arc;
DROP RULE IF EXISTS undelete_arc ON _arc;


-- Drop indexes from table arc

DROP INDEX IF EXISTS arc_arccat;
DROP INDEX IF EXISTS arc_dma;
DROP INDEX IF EXISTS arc_exploitation;
DROP INDEX IF EXISTS arc_exploitation2;
DROP INDEX IF EXISTS arc_index;
DROP INDEX IF EXISTS arc_muni;
DROP INDEX IF EXISTS arc_node1;
DROP INDEX IF EXISTS arc_node2;
DROP INDEX IF EXISTS arc_pkey;
DROP INDEX IF EXISTS arc_sector;
DROP INDEX IF EXISTS arc_street1;
DROP INDEX IF EXISTS arc_street2;
DROP INDEX IF EXISTS arc_streetname;
DROP INDEX IF EXISTS arc_streetname2;
DROP INDEX IF EXISTS gully_streetname;
DROP INDEX IF EXISTS gully_streetname2;


-- New order to table arc
CREATE TABLE arc (
	arc_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	node_1 int4 NULL,
	nodetype_1 varchar(30) NULL,
	node_sys_top_elev_1 numeric(12, 3) NULL,
	node_sys_elev_1 numeric(12, 3) NULL,
	elev1 numeric(12, 3) NULL,
	custom_elev1 numeric(12, 3) NULL,
	sys_elev1 numeric(12, 3) NULL,
	y1 numeric(12, 3) NULL,
	custom_y1 numeric(12, 3) NULL,
	node_2 int4 NULL,
	nodetype_2 varchar(30) NULL,
	node_sys_top_elev_2 numeric(12, 3) NULL,
	node_sys_elev_2 numeric(12, 3) NULL,
	elev2 numeric(12, 3) NULL,
	custom_elev2 numeric(12, 3) NULL,
	sys_elev2 numeric(12, 3) NULL,
	y2 numeric(12, 3) NULL,
	custom_y2 numeric(12, 3) NULL,
	feature_type varchar(16) DEFAULT 'ARC'::character varying NULL,
	arc_type varchar(18) NOT NULL,
	matcat_id varchar(30) NULL,
	arccat_id varchar(30) NOT NULL,
	epa_type varchar(16) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	parent_id int4 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	drainzone_id int4 DEFAULT 0 NULL,
	drainzone_outfall int4[] NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	dwfzone_outfall int4[] NULL,
	omzone_id int4 DEFAULT 0 NULL,
	omunit_id int4 DEFAULT 0 NULL,
	minsector_id int4 DEFAULT 0 NULL,
	pavcat_id varchar(30) NULL,
	soilcat_id varchar(16) NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	custom_length numeric(12, 2) NULL,
	sys_slope numeric(12, 4) NULL,
	descript text NULL,
	annotation text NULL,
	observ text NULL,
	comment text NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	district_id int4 NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NULL,
	postnumber int4 NULL,
	postcomplement varchar(100) NULL,
	streetaxis2_id varchar(16) NULL,
	postnumber2 int4 NULL,
	postcomplement2 varchar(100) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	workcat_id_plan varchar(255) NULL,
	builtdate date NULL,
	registration_date date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	last_visitdate date NULL,
	visitability int4 NULL,
	om_state text NULL,
	conserv_state text NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	serial_number varchar(100) NULL,
	asset_id varchar(50) NULL,
	adate text NULL,
	adescript text NULL,
	verified int4 NULL,
	uncertain bool NULL,
	datasource int4 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	label_quadrant varchar(12) NULL,
	inventory bool NULL,
	publish bool NULL,
	is_scadamap bool NULL,
	lock_level int4 NULL,
	initoverflowpath bool DEFAULT false NULL,
	inverted_slope bool DEFAULT false NULL,
	negative_offset bool DEFAULT false NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	-- extra we don't know the order
	meandering integer NULL,
	CONSTRAINT arc_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['CONDUIT'::text, 'WEIR'::text, 'ORIFICE'::text, 'VIRTUAL'::text, 'PUMP'::text, 'OUTLET'::text, 'UNDEFINED'::text]))),
	CONSTRAINT arc_pkey PRIMARY KEY (arc_id),
	CONSTRAINT arc_arc_type_fkey FOREIGN KEY (arc_type) REFERENCES cat_feature_arc(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_pavcat_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT arc_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX arc_arccat ON arc USING btree (arccat_id);
CREATE INDEX arc_omzone ON arc USING btree (omzone_id);
CREATE INDEX arc_exploitation ON arc USING btree (expl_id);
CREATE INDEX arc_expl_visibility_idx ON arc USING btree (expl_visibility);
CREATE INDEX arc_index ON arc USING gist (the_geom);
CREATE INDEX arc_muni ON arc USING btree (muni_id);
CREATE INDEX arc_node1 ON arc USING btree (node_1);
CREATE INDEX arc_node2 ON arc USING btree (node_2);
CREATE INDEX arc_sector ON arc USING btree (sector_id);
CREATE INDEX arc_street1 ON arc USING btree (streetaxis_id);
CREATE INDEX arc_street2 ON arc USING btree (streetaxis2_id);
CREATE INDEX arc_sys_code_idx ON arc USING btree (sys_code);
CREATE INDEX arc_asset_id_idx ON arc USING btree (asset_id);






-- connec
ALTER TABLE connec RENAME TO _connec;


-- Drop foreign keys that reference connec

ALTER TABLE om_visit_x_connec DROP CONSTRAINT om_visit_x_connec_connec_id_fkey;
ALTER TABLE doc_x_connec DROP CONSTRAINT doc_x_connec_connec_id_fkey;
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_connec_id_fkey;
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT plan_psector_x_connec_connec_id_fkey;


-- Drop foreign keys from table connec

ALTER TABLE _connec DROP CONSTRAINT connec_connectype_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_buildercat_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_district_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_dma_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_drainzone_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_expl_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_expl_id2_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_feature_type_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_muni_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_ownercat_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_pjoint_type_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_sector_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_soilcat_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_state_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_state_type_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_streetaxis2_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_streetaxis_id_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_workcat_id_end_fkey;
ALTER TABLE _connec DROP CONSTRAINT connec_workcat_id_fkey;

-- Drop restrictions from table connec
ALTER TABLE _connec DROP CONSTRAINT connec_pjoint_type_check;
ALTER TABLE _connec DROP CONSTRAINT connec_pkey;


-- Drop rules from table connec

DROP RULE IF EXISTS undelete_connec ON _connec;


-- Drop indexes from table connec

DROP INDEX IF EXISTS connec_connecat;
DROP INDEX IF EXISTS connec_dma;
DROP INDEX IF EXISTS connec_exploitation;
DROP INDEX IF EXISTS connec_exploitation2;
DROP INDEX IF EXISTS connec_index;
DROP INDEX IF EXISTS connec_muni;
DROP INDEX IF EXISTS connec_pkey;
DROP INDEX IF EXISTS connec_sector;
DROP INDEX IF EXISTS connec_street1;
DROP INDEX IF EXISTS connec_street2;
DROP INDEX IF EXISTS connec_streetname;
DROP INDEX IF EXISTS connec_streetname2;


-- New order to table connec
CREATE TABLE connec (
	connec_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev numeric(12, 4) NULL,
	y1 numeric(12, 4) NULL,
	y2 numeric(12, 4) NULL,
	feature_type varchar(16) DEFAULT 'CONNEC'::character varying NULL,
	connec_type varchar(30) NOT NULL,
	matcat_id varchar(16) NULL,
	conneccat_id varchar(30) NOT NULL,
	customer_code varchar(30) NULL,
	connec_depth numeric(12, 3) NULL,
	connec_length numeric(12, 3) NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	arc_id int4 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	drainzone_id int4 DEFAULT 0 NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	omunit_id int4 DEFAULT 0 NULL,
	minsector_id int4 DEFAULT 0 NULL,
	drainzone_outfall int4[] NULL,
	dwfzone_outfall int4[] NULL,
	soilcat_id varchar(16) NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	n_hydrometer int4 NULL,
	n_inhabitants int4 NULL,
	demand numeric(12, 8) NULL,
	descript text NULL,
	annotation text NULL,
	observ text NULL,
	comment text NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	district_id int4 NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NULL,
	postnumber int4 NULL,
	postcomplement varchar(100) NULL,
	streetaxis2_id varchar(16) NULL,
	postnumber2 int4 NULL,
	postcomplement2 varchar(100) NULL,
	block_code text NULL,
	plot_code text NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	workcat_id_plan varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	pjoint_id integer NULL,
	pjoint_type varchar(16) NULL,
	access_type text NULL,
	placement_type varchar(50) NULL,
	accessibility bool NULL,
	asset_id varchar(50) NULL,
	adate text NULL,
	adescript text NULL,
	verified int4 NULL,
	uncertain bool NULL,
	datasource int4 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	rotation numeric(6, 3) NULL,
	label_quadrant varchar(12) NULL,
	inventory bool NULL,
	publish bool NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	-- extra we don't know the order
	diagonal varchar(50) NULL,
	CONSTRAINT connec_pjoint_type_check CHECK (((pjoint_type)::text = ANY (ARRAY['NODE'::text, 'ARC'::text, 'CONNEC'::text, 'GULLY'::text]))),
	CONSTRAINT connec_pkey PRIMARY KEY (connec_id),
	CONSTRAINT connec_connectype_id_fkey FOREIGN KEY (connec_type) REFERENCES cat_feature_connec(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_pjoint_type_fkey FOREIGN KEY (pjoint_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX connec_connecat ON connec USING btree (conneccat_id);
CREATE INDEX connec_omzone ON connec USING btree (omzone_id);
CREATE INDEX connec_exploitation ON connec USING btree (expl_id);
CREATE INDEX connec_expl_visibility_idx ON connec USING btree (expl_visibility);
CREATE INDEX connec_index ON connec USING gist (the_geom);
CREATE INDEX connec_muni ON connec USING btree (muni_id);
CREATE INDEX connec_sector ON connec USING btree (sector_id);
CREATE INDEX connec_street1 ON connec USING btree (streetaxis_id);
CREATE INDEX connec_street2 ON connec USING btree (streetaxis2_id);
CREATE INDEX connec_sys_code_idx ON connec USING btree (sys_code);
CREATE INDEX connec_asset_id_idx ON connec USING btree (asset_id);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"block_zone", "newName":"block_code"}}$$);



-- gully
ALTER TABLE gully RENAME TO _gully;


-- Drop foreign keys that reference gully
ALTER TABLE element_x_gully DROP CONSTRAINT element_x_gully_gully_id_fkey;
ALTER TABLE inp_gully DROP CONSTRAINT inp_gully_gully_id_fkey;
ALTER TABLE plan_psector_x_gully DROP CONSTRAINT plan_psector_x_gully_gully_id_fkey;
ALTER TABLE om_visit_x_gully DROP CONSTRAINT om_visit_x_gully_gully_id_fkey;
ALTER TABLE doc_x_gully DROP CONSTRAINT doc_x_gully_gully_id_fkey;


-- Drop foreign keys from table gully

ALTER TABLE _gully DROP CONSTRAINT gully_district_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_buildercat_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_dma_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_drainzone_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_expl_id2_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_feature_type_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_gullytype_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_muni_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_ownercat_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_pjoint_type_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_pol_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_sector_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_soilcat_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_state_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_state_type_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_streetaxis2_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_streetaxis_id_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_workcat_id_end_fkey;
ALTER TABLE _gully DROP CONSTRAINT gully_workcat_id_fkey;

-- Drop restrictions from table gully
ALTER TABLE _gully DROP CONSTRAINT gully_pjoint_type_check;
ALTER TABLE _gully DROP CONSTRAINT gully_pkey;


-- Drop rules from table gully

DROP RULE IF EXISTS undelete_gully ON _gully;


-- Drop indexes from table gully

DROP INDEX IF EXISTS gully_dma;
DROP INDEX IF EXISTS gully_exploitation;
DROP INDEX IF EXISTS gully_exploitation2;
DROP INDEX IF EXISTS gully_gratecat;
DROP INDEX IF EXISTS gully_index;
DROP INDEX IF EXISTS gully_muni;
DROP INDEX IF EXISTS gully_pkey;
DROP INDEX IF EXISTS gully_sector;
DROP INDEX IF EXISTS gully_street1;
DROP INDEX IF EXISTS gully_street2;


-- New order to table gully
CREATE TABLE gully (
	gully_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev numeric(12, 4) NULL,
	ymax numeric(12, 4) NULL,
	length numeric(12, 3) NULL,
	width numeric(12, 3) NULL,
	sandbox numeric(12, 4) NULL,
	matcat_id varchar(18) NULL,
	feature_type varchar(16) DEFAULT 'GULLY'::character varying NULL,
	gullycat_id varchar(30) NULL,
	_gratecat2_id text NULL,
	gully_type varchar(30) NOT NULL,
	units numeric(12, 2) NULL,
	units_placement varchar(16) NULL,
	groove bool NULL,
	groove_height float8 NULL,
	groove_length float8 NULL,
	siphon bool NULL,
	siphon_type text NULL,
	odorflap text NULL,
	connec_length numeric(12, 3) NULL,
	connec_depth numeric(12, 3) NULL,
	connec_y2 numeric(12, 3) NULL,
	arc_id int4 NULL,
	epa_type varchar(16) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	drainzone_id int4 DEFAULT 0 NULL,
	drainzone_outfall int4[] NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	dwfzone_outfall int4[] NULL,
	omzone_id int4 DEFAULT 0 NULL,
	omunit_id int4 DEFAULT 0 NULL,
	minsector_id int4 DEFAULT 0 NULL,
	soilcat_id varchar(16) NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	descript text NULL,
	annotation text NULL,
	observ text NULL,
	comment text NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	district_id int4 NULL,
	postcode varchar(16) NULL,
	streetaxis_id varchar(16) NULL,
	postnumber int4 NULL,
	postcomplement varchar(100) NULL,
	streetaxis2_id varchar(16) NULL,
	postnumber2 int4 NULL,
	postcomplement2 varchar(100) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	workcat_id_plan varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	pjoint_id integer NULL,
	pjoint_type varchar(16) NULL,
	placement_type varchar(50) NULL,
	access_type text NULL,
	asset_id varchar(50) NULL,
	adate text NULL,
	adescript text NULL,
	verified int4 NULL,
	uncertain bool NULL,
	datasource int4 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	rotation numeric(6, 3) NULL,
	label_quadrant varchar(12) NULL,
	inventory bool NULL,
	publish bool NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	_connec_arccat_id varchar(18) NULL,
	"_pol_id_" varchar(16) NULL,
	_connec_matcat_id text NULL,
	CONSTRAINT gully_pjoint_type_check CHECK (((pjoint_type)::text = ANY (ARRAY['NODE'::text, 'ARC'::text, 'CONNEC'::text, 'GULLY'::text]))),
	CONSTRAINT gully_pkey PRIMARY KEY (gully_id),
	CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_gullytype_id_fkey FOREIGN KEY (gully_type) REFERENCES cat_feature_gully(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_pjoint_type_fkey FOREIGN KEY (pjoint_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_pol_id_fkey FOREIGN KEY ("_pol_id_") REFERENCES polygon(pol_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT gully_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_state_id_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX gully_omzone ON gully USING btree (omzone_id);
CREATE INDEX gully_exploitation ON gully USING btree (expl_id);
CREATE INDEX gully_expl_visibility_idx ON gully USING btree (expl_visibility);
CREATE INDEX gully_gratecat ON gully USING btree (gullycat_id);
CREATE INDEX gully_index ON gully USING gist (the_geom);
CREATE INDEX gully_muni ON gully USING btree (muni_id);
CREATE INDEX gully_sector ON gully USING btree (sector_id);
CREATE INDEX gully_street1 ON gully USING btree (streetaxis_id);
CREATE INDEX gully_street2 ON gully USING btree (streetaxis2_id);
CREATE INDEX gully_sys_code_idx ON gully USING btree (sys_code);
CREATE INDEX gully_asset_id_idx ON gully USING btree (asset_id);





-- element
ALTER TABLE element RENAME TO _element;


-- Drop foreign keys that reference element

ALTER TABLE element_x_gully DROP CONSTRAINT element_x_gully_element_id_fkey;
ALTER TABLE element_x_connec DROP CONSTRAINT element_x_connec_element_id_fkey;
ALTER TABLE element_x_node DROP CONSTRAINT element_x_node_element_id_fkey;
ALTER TABLE element_x_arc DROP CONSTRAINT element_x_arc_element_id_fkey;
ALTER TABLE element_x_link DROP CONSTRAINT element_x_link_element_id_fkey;


-- Drop foreign keys from table element

ALTER TABLE _element DROP CONSTRAINT element_category_type_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_elementcat_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_buildercat_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_fluid_type_feature_type_fkey; -- Nico
ALTER TABLE _element DROP CONSTRAINT element_function_type_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_location_type_feature_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_muni_id;
ALTER TABLE _element DROP CONSTRAINT element_muni_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_ownercat_id_fkey;
ALTER TABLE _element DROP CONSTRAINT element_sector_id;
ALTER TABLE _element DROP CONSTRAINT element_state_fkey;
ALTER TABLE _element DROP CONSTRAINT element_state_type_fkey;
ALTER TABLE _element DROP CONSTRAINT element_workcat_id_end_fkey;
ALTER TABLE _element DROP CONSTRAINT element_workcat_id_fkey;

-- Drop restrictions from table element
ALTER TABLE _element DROP CONSTRAINT element_pkey;


-- Drop rules from table element

-- Drop indexes from table element

DROP INDEX IF EXISTS element_index;
DROP INDEX IF EXISTS element_muni;
DROP INDEX IF EXISTS element_pkey;
DROP INDEX IF EXISTS element_sector;


-- New order to table element
CREATE TABLE element (
	element_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev numeric(12, 3) NULL,
	feature_type varchar(16) DEFAULT 'ELEMENT'::character varying NULL,
	elementcat_id varchar(30) NOT NULL,
	epa_type varchar(16) NULL,
	num_elements int4 NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	omzone_id int4 DEFAULT 0 NULL,
	omunit_id int4 DEFAULT 0 NULL,
	function_type varchar(50) NULL,
	category_type varchar(50) NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	observ varchar(254) NULL,
	"comment" varchar(254) NULL,
	link varchar(512) NULL,
	workcat_id varchar(30) NULL,
	workcat_id_end varchar(30) NULL,
	builtdate date NULL,
	enddate date NULL,
	ownercat_id varchar(30) NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	serial_number varchar(30) NULL,
	asset_id varchar(50) NULL,
	verified int4 NULL,
	datasource int4 NULL,
	label_x varchar(30) NULL,
	label_y varchar(30) NULL,
	label_rotation numeric(6, 3) NULL,
	rotation numeric(6, 3) NULL,
	inventory bool NULL,
	publish bool NULL,
	trace_featuregeom bool DEFAULT true NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	CONSTRAINT element_pkey PRIMARY KEY (element_id),
	CONSTRAINT element_elementcat_id_fkey FOREIGN KEY (elementcat_id) REFERENCES cat_element(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id),
	CONSTRAINT element_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT element_epa_type_check CHECK ((epa_type = ANY (ARRAY['FRPUMP'::text, 'FRWEIR'::text, 'FRORIFICE'::text, 'FROUTLET'::text])))
);
CREATE INDEX element_index ON element USING gist (the_geom);
CREATE INDEX element_muni ON element USING btree (muni_id);
CREATE INDEX element_sys_code_idx ON element USING btree (sys_code);
CREATE INDEX element_sector ON element USING btree (sector_id);
CREATE INDEX element_asset_id_idx ON element USING btree (asset_id);

ALTER TABLE link RENAME TO _link;

-- Drop foreign keys that reference link
ALTER TABLE plan_psector_x_gully DROP CONSTRAINT plan_psector_x_gully_link_id_fkey;
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT plan_psector_x_connec_link_id_fkey;
ALTER TABLE om_visit_x_link DROP CONSTRAINT om_visit_x_link_link_id_fkey;
ALTER TABLE doc_x_link DROP CONSTRAINT doc_x_link_link_id_fkey;
ALTER TABLE element_x_link DROP CONSTRAINT element_x_link_link_id_fkey;


-- Drop foreign keys from table link
ALTER TABLE _link DROP CONSTRAINT link_exit_type_fkey;
ALTER TABLE _link DROP CONSTRAINT link_exploitation_id_fkey;
ALTER TABLE _link DROP CONSTRAINT link_feature_type_fkey;
ALTER TABLE _link DROP CONSTRAINT link_muni_id_fkey;
ALTER TABLE _link DROP CONSTRAINT link_sector_id_fkey;
ALTER TABLE _link DROP CONSTRAINT link_state_fkey;
ALTER TABLE _link DROP CONSTRAINT link_workcat_id_end_fkey;
ALTER TABLE _link DROP CONSTRAINT link_workcat_id_fkey;

-- Drop restrictions from table link
ALTER TABLE _link DROP CONSTRAINT link_pkey;

-- Drop indexes from table link
DROP INDEX IF EXISTS link_exit_id;
DROP INDEX IF EXISTS link_expl_id2;
DROP INDEX IF EXISTS link_exploitation2;
DROP INDEX IF EXISTS link_feature_id;
DROP INDEX IF EXISTS link_index;
DROP INDEX IF EXISTS link_muni;

CREATE TABLE link (
	link_id int4 DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	code text NULL,
	sys_code text NULL,
	top_elev1 float8 NULL,
	y1 numeric(12, 4) NULL,
	exit_id int4 NULL,
	exit_type varchar(16) NULL,
	top_elev2 float8 NULL,
	y2 numeric(12, 4) NULL,
	feature_type varchar(16) NULL,
	feature_id int4 NULL,
	link_type varchar(30) NOT NULL,
	linkcat_id varchar(30) NOT NULL,
	epa_type varchar(16) NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	expl_id2 int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	drainzone_id int4 DEFAULT 0 NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	drainzone_outfall int4[] NULL,
	dwfzone_outfall int4[] NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	custom_length numeric(12, 2) NULL,
	sys_slope numeric (12,3),
	annotation text NULL,
	observ text NULL,
	"comment" text NULL,
	descript varchar(254) NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	private_linkcat_id varchar(30) NULL,
	verified int2 NULL,
	uncertain bool NULL,
	userdefined_geom bool NULL,
	datasource int4 NULL,
	is_operative bool NULL,
	lock_level int4 NULL,
	expl_visibility int2[] NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT link_pkey PRIMARY KEY (link_id),
	CONSTRAINT link_linkcat_id_fkey FOREIGN KEY (linkcat_id) REFERENCES cat_arc(id) ON DELETE RESTRICT ON UPDATE CASCADE, -- UPDATED reference on 4.0.001
	CONSTRAINT link_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_exit_type_fkey FOREIGN KEY (exit_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT link_private_linkcat_id_fkey FOREIGN KEY (private_linkcat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE INDEX link_exit_id ON link USING btree (exit_id);
CREATE INDEX link_expl_visibility_idx ON link USING btree (expl_visibility);
CREATE INDEX link_feature_id ON link USING btree (feature_id);
CREATE INDEX link_index ON link USING gist (the_geom);
CREATE INDEX link_muni ON link USING btree (muni_id);

--26/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_connec", "column":"estimated_depth", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

-- 02/04/2025
-- fix archived_psector_*_traceability
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_connec_traceability", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_connec_traceability", "column":"connecat_id", "newName":"conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_connec_traceability", "column":"private_connecat_id", "newName":"private_conneccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"dwfzone_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"datasource", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"omunit_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_connec_traceability", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_arc_traceability", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"dwfzone_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"initoverflowpath", "dataType":"bool", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"omunit_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"registration_date", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"meandering", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"conserv_state", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"om_state", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"last_visitdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_arc_traceability", "column":"negative_offset", "dataType":"bool", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_node_traceability", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"dwfzone_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"datasource", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"omunit_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"pavcat_id", "dataType":"varchar(30)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"connec_arccat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"connec_matcat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_gully_traceability", "column":"gratecat_id", "newName":"gullycat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_gully_traceability", "column":"gratecat2_id", "newName":"gullycat2_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"archived_psector_gully_traceability", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_gully_traceability", "column":"dwfzone_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_gully_traceability", "column":"datasource", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_gully_traceability", "column":"omunit_id", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_gully_traceability", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_gully_traceability", "column":"length", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_gully_traceability", "column":"width", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);


-- MAPZONES
ALTER TABLE macroexploitation RENAME TO _macroexploitation;
ALTER TABLE exploitation DROP CONSTRAINT IF EXISTS macroexpl_id_fkey;
ALTER TABLE _macroexploitation DROP CONSTRAINT macroexploitation_pkey;

DROP INDEX IF EXISTS macroexploitation_index;

CREATE TABLE macroexploitation (
	macroexpl_id int4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript varchar(100) NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macroexploitation_pkey PRIMARY KEY (macroexpl_id)
);

ALTER TABLE exploitation RENAME TO _exploitation;

-- Drop foreign key constraints that reference exploitation_pkey
ALTER TABLE cat_dscenario DROP CONSTRAINT IF EXISTS cat_dscenario_expl_id_fkey;
ALTER TABLE cat_dwf DROP CONSTRAINT IF EXISTS cat_dwf_scenario_expl_id_fkey;
ALTER TABLE cat_hydrology DROP CONSTRAINT IF EXISTS cat_hydrology_expl_id_fkey;
ALTER TABLE dimensions DROP CONSTRAINT IF EXISTS dimensions_exploitation_id_fkey;
ALTER TABLE dma DROP CONSTRAINT IF EXISTS dma_expl_id_fkey;
ALTER TABLE macrodma DROP CONSTRAINT IF EXISTS macrodma_expl_id_fkey;
ALTER TABLE inp_curve DROP CONSTRAINT IF EXISTS inp_curve_expl_id_fkey;
ALTER TABLE inp_pattern DROP CONSTRAINT IF EXISTS inp_pattern_expl_id_fkey;
ALTER TABLE inp_timeseries DROP CONSTRAINT IF EXISTS inp_timeseries_expl_id_fkey;
ALTER TABLE om_visit DROP CONSTRAINT IF EXISTS om_visit_expl_id_fkey;
ALTER TABLE plan_psector DROP CONSTRAINT IF EXISTS plan_psector_expl_id_fkey;
ALTER TABLE raingage DROP CONSTRAINT IF EXISTS raingage_expl_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS samplepoint_exploitation_id_fkey;
ALTER TABLE selector_expl DROP CONSTRAINT IF EXISTS selector_expl_id_fkey;
ALTER TABLE config_user_x_expl DROP CONSTRAINT IF EXISTS config_user_x_expl_expl_id_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_expl_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_expl_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_expl_fkey;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_exploitation_id_fkey;
ALTER TABLE ext_streetaxis DROP CONSTRAINT IF EXISTS ext_streetaxis_exploitation_id_fkey;
ALTER TABLE ext_address DROP CONSTRAINT IF EXISTS ext_address_exploitation_id_fkey;
ALTER TABLE ext_plot DROP CONSTRAINT IF EXISTS ext_plot_exploitation_id_fkey;
ALTER TABLE _arc_border_expl_ DROP CONSTRAINT IF EXISTS arc_border_expl_expl_id_fkey;

ALTER TABLE _exploitation DROP CONSTRAINT exploitation_pkey;

DROP INDEX IF EXISTS exploitation_index;

CREATE TABLE exploitation (
	expl_id int4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	macroexpl_id int4 DEFAULT 0 NOT NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT exploitation_pkey PRIMARY KEY (expl_id),
	CONSTRAINT macroexpl_id_fkey FOREIGN KEY (macroexpl_id) REFERENCES macroexploitation(macroexpl_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX exploitation_index ON exploitation USING gist (the_geom);

ALTER TABLE macrodma RENAME TO _macrodma;
ALTER TABLE dma DROP CONSTRAINT IF EXISTS dma_macrodma_id_fkey;

ALTER TABLE _macrodma DROP CONSTRAINT macrodma_pkey;

CREATE TABLE macroomzone (
	macroomzone_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	expl_id int4 NOT NULL,
	descript text NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macroomzone_pkey PRIMARY KEY (macroomzone_id),
	CONSTRAINT macroomzone_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX macroomzone_index ON macroomzone USING gist (the_geom);

ALTER TABLE macrosector RENAME TO _macrosector;
ALTER TABLE sector DROP CONSTRAINT IF EXISTS sector_macrosector_id_fkey;
ALTER TABLE _macrosector DROP CONSTRAINT macrosector_pkey;

ALTER SEQUENCE macrosector_macrosector_id_seq RENAME TO macrosector_macrosector_id_seq1;

DROP INDEX IF EXISTS macrosector_index;

CREATE TABLE macrosector (
	macrosector_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macrosector_pkey PRIMARY KEY (macrosector_id)
);
CREATE INDEX macrosector_index ON macrosector USING gist (the_geom);



ALTER TABLE dma RENAME TO _dma;

ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS samplepoint_verified_fkey;

ALTER TABLE _dma DROP CONSTRAINT dma_pkey;

DROP INDEX IF EXISTS dma_index;

-- ! dma renamed to omzone
CREATE TABLE omzone (
	omzone_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(30) NULL,
	descript text NULL,
	omzone_type varchar(16) NULL,
	expl_id int4 NULL,
	macroomzone_id int4 DEFAULT 0 NULL,
	minc float8 NULL,
	maxc float8 NULL,
	effc float8 NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT omzone_pkey PRIMARY KEY (omzone_id),
	CONSTRAINT omzone_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT omzone_macroomzone_id_fkey FOREIGN KEY (macroomzone_id) REFERENCES macroomzone(macroomzone_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX omzone_index ON omzone USING gist (the_geom);


ALTER TABLE drainzone RENAME TO _drainzone;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_drainzone_id_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_drainzone_id_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_drainzone_id_fkey;
ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_drainzone_id_fkey;
ALTER TABLE _drainzone DROP CONSTRAINT drainzone_pkey;

ALTER SEQUENCE drainzone_drainzone_id_seq RENAME TO drainzone_drainzone_id_seq1;

DROP INDEX IF EXISTS drainzone_index;

CREATE TABLE drainzone (
	drainzone_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(30) NULL,
	drainzone_type varchar(16) NULL,
	descript text NULL,
	expl_id int4 NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT drainzone_pkey PRIMARY KEY (drainzone_id)
);
CREATE INDEX drainzone_index ON drainzone USING gist (the_geom);

ALTER TABLE sector RENAME TO _sector;

-- Drop foreign key constraints that reference sector_pkey
ALTER TABLE inp_controls DROP CONSTRAINT IF EXISTS inp_controls_x_sector_id_fkey;
ALTER TABLE inp_dscenario_controls DROP CONSTRAINT IF EXISTS inp_dscenario_controls_sector_id_fkey;
ALTER TABLE selector_sector DROP CONSTRAINT IF EXISTS inp_selector_sector_id_fkey;
ALTER TABLE node_border_sector DROP CONSTRAINT IF EXISTS node_border_expl_sector_id_fkey;
ALTER TABLE _sector DROP CONSTRAINT IF EXISTS sector_parent_id_fkey;
ALTER TABLE inp_subcatchment DROP CONSTRAINT IF EXISTS subcatchment_sector_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS samplepoint_sector_id;
ALTER TABLE dimensions DROP CONSTRAINT IF EXISTS dimensions_sector_id;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_sector_id_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_sector_id_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_sector_id_fkey;
ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_sector_id_fkey;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS element_sector_id;
ALTER TABLE link DROP CONSTRAINT IF EXISTS link_sector_id_fkey;
ALTER TABLE _config_user_x_sector DROP CONSTRAINT IF EXISTS config_user_x_sector_sector_id_fkey;

ALTER TABLE _sector DROP CONSTRAINT sector_pkey;

ALTER SEQUENCE sector_sector_id_seq RENAME TO sector_sector_id_seq1;

DROP INDEX IF EXISTS sector_index;

CREATE TABLE sector (
	sector_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	sector_type varchar(50) NULL,
	macrosector_id int4 DEFAULT 0 NULL,
	parent_id int4 NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":"", "toArc":[]}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	link text NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT sector_pkey PRIMARY KEY (sector_id),
	CONSTRAINT sector_macrosector_id_fkey FOREIGN KEY (macrosector_id) REFERENCES macrosector(macrosector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT sector_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX sector_index ON sector USING gist (the_geom);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"samplepoint", "column":"dma_id", "newName":"omzone_id"}}$$);

ALTER TABLE man_type_fluid RENAME TO _man_type_fluid;
