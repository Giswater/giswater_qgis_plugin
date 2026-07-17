/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


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


ALTER TABLE inp_dscenario_lid_usage RENAME TO inp_dscenario_lids;



ALTER TABLE gully DROP CONSTRAINT gully_category_type_feature_type_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_fluid_type_feature_type_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_function_type_feature_type_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_location_type_feature_type_fkey;


DROP VIEW IF EXISTS ve_epa_orifice;
DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_frorifice;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_orifice", "column":"close_time"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_frorifice", "column":"close_time"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_dscenario_frorifice", "column":"close_time"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_outfall", "column":"route_to", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_outfall", "column":"route_to", "dataType":"varchar(16)"}}$$);


DROP VIEW IF EXISTS v_edit_cat_dwf_scenario;
ALTER TABLE cat_dwf_scenario RENAME TO cat_dwf;
ALTER SEQUENCE cat_dwf_scenario_id_seq RENAME TO cat_dwf_id_seq;

ALTER TABLE doc_x_gully DROP CONSTRAINT doc_x_gully_doc_id_fkey;


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


ALTER TABLE gully DROP CONSTRAINT gully_matcat_id_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_connec_matcat_id_fkey;

ALTER TABLE cat_mat_grate RENAME TO _cat_mat_grate;
ALTER TABLE cat_mat_gully RENAME TO _cat_mat_gully;


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
	node_id text NOT NULL,
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
	arc_id text NOT NULL,
	node_1 text NULL,
	node_2 text NULL,
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




CREATE TABLE dwfzone (
	dwfzone_id serial4 NOT NULL,
	code text NULL,
	"name" varchar(30) NULL,
	dwfzone_type varchar(16) NULL,
	expl_id int4[] NULL,
	sector_id int4[] NULL,
	muni_id int4[] NULL,
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



SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"sector", "column":"sector_type", "dataType":"varchar(50)"}}$$);


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



DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS vu_sector;
DROP RULE IF EXISTS undelete_sector ON sector;
DROP RULE IF EXISTS undelete_dma ON dma;
DROP RULE IF EXISTS undelete_macrodma ON macrodma;



SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"link", "column":"fluid_type", "dataType":"varchar(50)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"negativeoffset", "dataType":"boolean", "isUtils":"False"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"bulk", "newName":"thickness"}}$$);



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
ALTER TABLE _node DROP CONSTRAINT node_pkey CASCADE;


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
	omstate int4 DEFAULT 0 NULL,
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
	treatment_type int4 NULL,
	has_treatment bool NULL,
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
	conserv_state text NULL,
	om_state int4 NULL,
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
	-- CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_node_type_fkey FOREIGN KEY (node_type) REFERENCES cat_feature_node(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT node_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
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


ALTER TABLE IF EXISTS _arc_border_expl_ DROP CONSTRAINT IF EXISTS arc_border_expl_arc_id_fkey;

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
ALTER TABLE _arc DROP CONSTRAINT arc_pkey CASCADE;


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
	treatment_type int4 NULL,
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
	-- CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_pavcat_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT arc_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT arc_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
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
	treatment_type int4 NULL,
	has_treatment bool NULL,
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
	om_state int4 NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
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
	-- CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_pjoint_type_fkey FOREIGN KEY (pjoint_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT connec_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
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
	treatment_type int4 NULL,
	has_treatment bool NULL,
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
	om_state int4 NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
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
	-- CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_gullytype_id_fkey FOREIGN KEY (gully_type) REFERENCES cat_feature_gully(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_pjoint_type_fkey FOREIGN KEY (pjoint_type) REFERENCES sys_feature_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_pol_id_fkey FOREIGN KEY ("_pol_id_") REFERENCES polygon(pol_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT gully_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_state_id_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT gully_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE,
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
	-- CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
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
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
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
	-- CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE,
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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_connec", "column":"estimated_depth", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);


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
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_node_traceability", "column":"conserv_state", "dataType":"text", "isUtils":"False"}}$$);

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
DO $$
DECLARE
	v_utils boolean;
BEGIN
	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS NOT TRUE THEN
		ALTER TABLE ext_streetaxis DROP CONSTRAINT ext_streetaxis_exploitation_id_fkey;
		ALTER TABLE ext_address DROP CONSTRAINT ext_address_exploitation_id_fkey;
		ALTER TABLE ext_plot DROP CONSTRAINT ext_plot_exploitation_id_fkey;
	END IF;
END $$;
ALTER TABLE IF EXISTS _arc_border_expl_ DROP CONSTRAINT IF EXISTS arc_border_expl_expl_id_fkey;

ALTER TABLE _exploitation DROP CONSTRAINT exploitation_pkey;

DROP INDEX IF EXISTS exploitation_index;

CREATE TABLE exploitation (
	expl_id int4 NOT NULL,
	code text NULL,
	"name" varchar(50) NOT NULL,
	descript text NULL,
	sector_id int4[] NULL,
	muni_id int4[] NULL,
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
	expl_id int4[] NULL,
	descript text NULL,
	lock_level int4 NULL,
	active bool DEFAULT true NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	created_at timestamp with time zone DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamp with time zone NULL,
	updated_by varchar(50) NULL,
	CONSTRAINT macroomzone_pkey PRIMARY KEY (macroomzone_id)
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
	expl_id int4[] NULL,
	sector_id int4[] NULL,
	muni_id int4[] NULL,
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
	expl_id int4[] NULL,
	muni_id int4[] NULL,
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

ALTER TABLE selector_municipality DROP CONSTRAINT selector_municipality_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_muni_id_fkey;
ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_muni_id;
ALTER TABLE om_visit DROP CONSTRAINT om_visit_muni_id_fkey;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id_fkey;
ALTER TABLE dimensions DROP CONSTRAINT dimensions_muni_id;
ALTER TABLE raingage DROP CONSTRAINT raingage_muni_id;

DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

		DROP INDEX IF EXISTS idx_municipality_name;
		DROP INDEX IF EXISTS idx_municipality_the_geom;

		DROP VIEW ext_municipality;

		ALTER TABLE utils.municipality RENAME CONSTRAINT municipality_pkey TO _municipality_pkey;
		ALTER TABLE utils.municipality RENAME CONSTRAINT municipality_region_id_fkey TO _municipality_region_id_fkey;
		ALTER TABLE utils.municipality RENAME CONSTRAINT municipality_province_region_fk TO _municipality_province_region_fk;
		ALTER TABLE utils.municipality RENAME CONSTRAINT municipality_province_id_fkey TO _municipality_province_id_fkey;
		ALTER TABLE utils.municipality RENAME TO _municipality;

		CREATE TABLE utils.municipality (
			muni_id integer NOT NULL,
			name text NOT NULL,
			expl_id INT4[] NULL,
			sector_id INT4[] NULL,
			observ text,
			the_geom public.geometry(MultiPolygon,SRID_VALUE),
			active boolean DEFAULT true,
			region_id int4 NULL,
			province_id int4 NULL,
			ext_code text NULL,
			CONSTRAINT municipality_pkey PRIMARY KEY (muni_id),
			CONSTRAINT municipality_region_id_fkey FOREIGN KEY (region_id) REFERENCES ext_region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
			CONSTRAINT municipality_province_id_fkey FOREIGN KEY (province_id) REFERENCES ext_province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE
		);

    ELSE

		DROP INDEX IF EXISTS idx_ext_municipality_name;
		DROP INDEX IF EXISTS idx_ext_municipality_the_geom;

		ALTER TABLE ext_address DROP CONSTRAINT ext_address_muni_id_fkey;
		ALTER TABLE ext_district DROP CONSTRAINT ext_district_muni_id_fkey;
		ALTER TABLE ext_plot DROP CONSTRAINT ext_plot_muni_id_fkey;
		ALTER TABLE ext_streetaxis DROP CONSTRAINT ext_streetaxis_muni_id_fkey;
		ALTER TABLE samplepoint DROP CONSTRAINT samplepoint_streetaxis_muni_id_fkey;

		DROP VIEW v_ext_municipality;

		-- DROP TABLE ext_municipality;
		ALTER TABLE ext_municipality RENAME CONSTRAINT ext_municipality_pkey TO _ext_municipality_pkey;
		ALTER TABLE ext_municipality RENAME CONSTRAINT ext_municipality_region_id_fkey TO _ext_municipality_region_id_fkey;
		ALTER TABLE ext_municipality RENAME CONSTRAINT ext_municipality_province_region_fk TO _ext_municipality_province_region_fk;
		ALTER TABLE ext_municipality RENAME CONSTRAINT ext_municipality_province_id_fkey TO _ext_municipality_province_id_fkey;
		ALTER TABLE ext_municipality RENAME TO _ext_municipality;

		CREATE TABLE ext_municipality (
			muni_id integer NOT NULL,
			name text NOT NULL,
			expl_id INT4[] NULL,
			sector_id INT4[] NULL,
			observ text,
			the_geom public.geometry(MultiPolygon,SRID_VALUE),
			active boolean DEFAULT true,
			region_id int4 NULL,
			province_id int4 NULL,
			ext_code varchar(50) NULL,
			CONSTRAINT ext_municipality_pkey PRIMARY KEY (muni_id),
			CONSTRAINT ext_municipality_region_id_fkey FOREIGN KEY (region_id) REFERENCES ext_region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
			CONSTRAINT ext_municipality_province_id_fkey FOREIGN KEY (province_id) REFERENCES ext_province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE
		);

    END IF;
END; $$;

-- delete all views to avoid conflicts, then recreate them
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        CREATE OR REPLACE VIEW ext_municipality AS SELECT * FROM utils.municipality;

    ELSE
    
        CREATE OR REPLACE VIEW v_ext_municipality
        AS SELECT DISTINCT s.muni_id,
            m.name,
            m.expl_id,
            m.sector_id,
            m.active,
            m.the_geom
            FROM ext_municipality m, selector_municipality s
            WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

    END IF;
END; $$;

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

INSERT INTO dwfzone (dwfzone_id, code, name) VALUES(0, '0', 'Undefined') ON CONFLICT DO NOTHING;


INSERT INTO cat_arc (id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, thickness, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef)
SELECT id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef
FROM _cat_arc;

INSERT INTO cat_node (id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", acoeff)
SELECT id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", acoeff
FROM _cat_node;

INSERT INTO cat_connec (id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand_id, model_id, svg, active, "label")
SELECT id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand_id, model_id, svg, active, "label"
FROM _cat_connec;

INSERT INTO cat_gully (id, gully_type, matcat_id, length, width, efficiency, descript, link, brand_id, model_id, svg, label, active)
SELECT id, gully_type, matcat_id, length, width,
CASE
  WHEN effective_area IS NOT NULL AND total_area > 0 THEN
    effective_area/total_area
  ELSE
    0.8
END AS efficiency, descript, link, brand_id, model_id, svg, label, active
FROM _cat_grate;

UPDATE sys_param_user SET dv_querytext='SELECT id AS id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE id='edit_gratecat_vdefault';


DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_snow' AND target_table='inp_snowpack' AND target_field='snow_type ';



ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='PLOWABLE';
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='IMPERVIOUS';
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='PERVIOUS';
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='REMOVAL';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

DELETE FROM config_form_fields
	WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='geom1' AND tabname='tab_none';
DELETE FROM config_form_fields
	WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='shape' AND tabname='tab_none';


UPDATE config_form_fields set dv_querytext = replace(dv_querytext, 'cat_grate', 'cat_gully');
UPDATE config_form_fields set dv_querytext_filterc = replace(dv_querytext_filterc, 'cat_grate', 'cat_gully');



UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_data';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_epa';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_event';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_node' AND tabname='tab_data';


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_time_2', 'lyt_time_2', 'layoutTime2', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('epa_selector', 'tab_time', 'Date time', 'Date time', 'role_basic', NULL, NULL, 1, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'tab_main', 'lyt_epa_select_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"tabs":["tab_result", "tab_time"]}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'compare_date', 'lyt_time_2', 0, 'string', 'combo', 'Compare date', 'Compare date', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "compare_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_compare', 'lyt_result_1', 1, 'string', 'combo', 'Result name (to compare):', 'Result name (to compare)', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "compare_date",
      "compare_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'selector_time', 'lyt_time_1', 1, 'string', 'combo', 'Selector time', 'Selector time', NULL, false, false, true, false, false, NULL, NULL, true, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'compare_time', 'lyt_time_2', 1, 'string', 'combo', 'Compare time', 'Compare time', NULL, false, false, true, false, false, NULL, NULL, true, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'selector_date', 'lyt_time_1', 0, 'string', 'combo', 'Selector date', 'Selector date', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "selector_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_show', 'lyt_result_1', 0, 'string', 'combo', 'Result name (to show):', 'Result name', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "selector_date",
      "selector_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('epa_selector_tab_time', '{"layouts":["lyt_time_1","lyt_time_2"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('epa_results', 'SELECT result_id as id, expl_id::text, sector_id::text, network_type, status, iscorporate::text, descript, cur_user, exec_date, rpt_stats::text, addparam, export_options, network_stats, inp_options FROM v_ui_rpt_cat_result', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name":"btn_edit",
      "widgetfunction": {
        "functionName": "edit",
        "params": {}
      },
      "color": "default",
      "text": "Edit",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name":"btn_show_inp_data",
      "widgetfunction": {
        "functionName": "showInpData",
        "params": {}
      },
      "color": "default",
      "text": "Show inp data",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    },
    {
      "name":"btn_toggle_archive",
      "widgetfunction": {
        "functionName": "toggleArchive",
        "params": {}
      },
      "color": "default",
      "text": "Toggle archive",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_froutlet', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_frorifice', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_frpump', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_frweir', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dwf', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');


UPDATE config_form_list
	SET query_text='SELECT nodarc_id, to_arc, order_id, flwreg_length, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4 FROM inp_frorifice WHERE id IS NOT NULL'
	WHERE listname='inp_frorifice' AND device=4;
UPDATE config_form_list
	SET query_text='SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.ori_type, d.offsetval, d.cd, d.orate, d.flap, d.shape, d.geom1, d.geom2, d.geom3, d.geom4
FROM inp_dscenario_frorifice d
JOIN inp_frorifice f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL'
	WHERE listname='inp_dscenario_frorifice' AND device=4;


DELETE FROM config_form_tableview
	WHERE objectname='inp_dscenario_frorifice' AND columnname='close_time';
DELETE FROM config_form_tableview
	WHERE objectname='inp_frorifice' AND columnname='close_time';
UPDATE config_form_tableview
	SET columnindex=16
	WHERE objectname='inp_frorifice' AND columnname='nodarc_id';

-- cat_dwf_scenario rename to cat_dwf
UPDATE sys_table SET id = 'cat_dwf' WHERE id = 'cat_dwf_scenario';

UPDATE config_toolbox SET inputparams='[
  {"widgetname":"target", "label":"Target Scenario:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDwf"},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["INSERT-ONLY", "DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["INSERT ONLY", "DELETE & COPY", "KEEP & COPY", "DELETE ONLY"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"INSERT-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":4, "selectedId":""}
  ]'::json WHERE id=3102;

UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='id' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='idval' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='startdate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='log' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='observ' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='idval' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='id' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='startdate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='observ' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE active IS true', widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "cat_dwf", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": ""}}'::json WHERE formname='inp_dwf' AND formtype='form_feature' AND columnname='dwfscenario_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE active IS true', widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "cat_dwf", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": ""}}'::json WHERE formname='inp_dwf_pol_x_node' AND formtype='form_feature' AND columnname='dwfscenario_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE active IS true', widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "cat_dwf", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": ""}}'::json WHERE formname='v_edit_inp_dwf' AND formtype='form_feature' AND columnname='dwfscenario_id' AND tabname='tab_none';

UPDATE sys_param_user SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE id IS not null' WHERE id='inp_options_dwfscenario';

UPDATE config_toolbox SET inputparams = replace(inputparams::text, 'cat_dwf_scenario', 'cat_dwf')::json;


INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_frorifice', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_froutlet', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_frpump', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_frweir', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_inflows', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_1', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_2', 'lyt_nvo_mng_2', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_3', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_curves_1', 'lyt_curves_1', 'layoutCurves1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_patterns_1', 'lyt_patterns_1', 'layoutPatterns1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_timeseries_1', 'lyt_timeseries_1', 'layoutTimeseries1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_controls_1', 'lyt_controls_1', 'layoutControls1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_lids_1', 'lyt_lids_1', 'layoutLids1', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_curves', 'tab_curves', 'tabCurves', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_patterns', 'tab_patterns', 'tabPatterns', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_timeseries', 'tab_timeseries', 'tabTimeseries', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_controls', 'tab_controls', 'tabControls', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_lids', 'tab_lids', 'tabLids', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_manager', 'nvo_manager', 'nonVisualObjectsManager', NULL);
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_curves', 'Curves', 'Curves', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_patterns', 'Patterns', 'Patterns', 'role_basic', NULL, NULL, 1, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_timeseries', 'Timeseries', 'Timeseries', 'role_basic', NULL, NULL, 2, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_controls', 'Controls', 'Controls', 'role_basic', NULL, NULL, 3, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_lids', 'Lids', 'Lids', 'role_basic', NULL, NULL, 4, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_patterns', 'tab_patterns', 'lyt_patterns_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_patterns', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_controls', 'tab_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_controls', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_lids', 'tab_lids', 'lyt_lids_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_lids', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_timeseries', 'tab_timeseries', 'lyt_timeseries_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_timeseries', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'tab_main', 'lyt_nvo_mng_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_curves",
    "tab_patterns",
    "tab_timeseries",
    "tab_controls",
    "tab_lids"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "closeDlg"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_curves', 'tab_curves', 'lyt_curves_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_curves', false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_curves', 'SELECT * FROM v_edit_inp_curve WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openCurves","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"Curve"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openCurves","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_patterns', 'SELECT * FROM v_edit_inp_pattern WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"pattern_id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openPatterns","params":{"initialHeight":580,"initialWidth":720,"minHeight":579,"minWidth":719,"title":"Pattern"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openPatterns","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_controls', 'SELECT * FROM v_edit_inp_controls WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openControls","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Control"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openControls","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_timeseries', 'SELECT * FROM v_edit_inp_timeseries WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openTimeseries","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"Timeseries"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openTimeseries","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_lids', 'SELECT * FROM inp_lid WHERE lidco_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"lidco_id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openLids","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"LIDS"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openLids","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'sector_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'text', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'active', 3, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'lidco_id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "lidco_id",
  "header": "lidco_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'lidco_type', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'observ', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'log', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'active', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'descript', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'expl_id', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'curve_type', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "curve_type",
  "filterVariant": "select",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'log', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'pattern_id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "pattern_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'observ', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'tscode', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'tsparameters', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'expl_id', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'log', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'timser_type', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "timser_type",
  "filterVariant": "select",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'times_type', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'idval', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'descript', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'fname', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'expl_id', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'active', 7, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_timeseries', '{"layouts":["lyt_timeseries_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_curves', '{"layouts":["lyt_curves_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_patterns', '{"layouts":["lyt_patterns_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_controls', '{"layouts":["lyt_controls_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_lids', '{"layouts":["lyt_lids_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_1', 'lyt_nvo_curves_1', 'layoutNonVisualObjectsCurves1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_2', 'lyt_nvo_curves_2', 'layoutNonVisualObjectsCurves2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_3', 'lyt_nvo_curves_3', 'layoutNonVisualObjectsCurves3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_curves', 'nvo_curves', 'nonVisualObjectsCurves', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'tbl_curves', 'lyt_nvo_curves_3', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_curves', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'img_plot', 'lyt_nvo_curves_3', 1, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'descript', 'lyt_nvo_curves_2', 0, NULL, 'text', 'Description', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'id', 'lyt_nvo_curves_1', 0, NULL, 'text', 'Curve ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'curve_type', 'lyt_nvo_curves_1', 1, NULL, 'combo', 'Curve Type', NULL, NULL, false, false, false, false, false, 'SELECT DISTINCT curve_type AS id, curve_type AS idval FROM v_edit_inp_curve', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'expl_id', 'lyt_nvo_curves_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_curves', 'SELECT x_value, y_value FROM v_edit_inp_curve_value WHERE curve_id IS NOT NULL ', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_1', 'lyt_nvo_patterns_1', 'layoutNonVisualObjectsPatterns1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_2', 'lyt_nvo_patterns_2', 'layoutNonVisualObjectsPatterns2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_3', 'lyt_nvo_patterns_3', 'layoutNonVisualObjectsPatterns3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_patterns', 'nvo_patterns', 'nonVisualObjectsPatterns', NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'pattern_id', 'lyt_nvo_patterns_1', 0, NULL, 'text', 'Pattern ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'observ', 'lyt_nvo_patterns_1', 1, NULL, 'text', 'Observation', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'expl_id', 'lyt_nvo_patterns_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'img_plot', 'lyt_nvo_patterns_3', 0, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_hourly', 'lyt_nvo_patterns_2', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"}'::json, NULL, 'tbl_nvo_patterns_hourly', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_daily', 'lyt_nvo_patterns_2', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns_daily', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_weekend', 'lyt_nvo_patterns_2', 2, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns_weekend', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_monthly', 'lyt_nvo_patterns_2', 3, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns_monthly', false, 3);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_hourly', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_daily', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_weekend', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_monthly', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);

-- 1- Insert layouts  and form in config_typevalue
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_1', 'lyt_nvo_timeseries_1', 'layoutNonVisualObjectsTimeseries1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_2', 'lyt_nvo_timeseries_2', 'layoutNonVisualObjectsTimeseries2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_3', 'lyt_nvo_timeseries_3', 'layoutNonVisualObjectsTimeseries3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_4', 'lyt_nvo_timeseries_4', 'layoutNonVisualObjectsTimeseries4', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_timeseries', 'nvo_timeseries', 'nonVisualObjectstimeseries', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'id', 'lyt_nvo_timeseries_1', 0, NULL, 'text', 'Time Series ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'idval', 'lyt_nvo_timeseries_1', 1, NULL, 'text', 'idval', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'timser_type', 'lyt_nvo_timeseries_2', 0, NULL, 'combo', 'Time Series Type', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_timserid''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'times_type', 'lyt_nvo_timeseries_2', 1, NULL, 'combo', 'Times Type', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_timeseries''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'expl_id', 'lyt_nvo_timeseries_3', 0, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'fname', 'lyt_nvo_timeseries_3', 1, NULL, 'text', 'File name', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'descript', 'lyt_nvo_timeseries_4', 0, NULL, 'text', 'Description', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'tbl_timeseries', 'lyt_nvo_timeseries_4', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_timeseries', false, 1);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_timeseries', 'SELECT time, value FROM v_edit_inp_timeseries_value WHERE timser_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_controls_1', 'lyt_nvo_controls_1', 'layoutNonVisualObjectsControls1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_controls', 'nvo_controls', 'nonVisualObjectsControls', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'sector_id', 'lyt_nvo_controls_1', 0, NULL, 'combo', 'Sector ID', NULL, NULL, false, false, false, false, false, 'SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'active', 'lyt_nvo_controls_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'text', 'lyt_nvo_controls_1', 2, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_lids', 'nvo_lids', 'nonVisualObjectsLids', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_lids_1', 'lyt_nvo_lids_1', 'layoutNonVisualObjectsLids1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_lids_2', 'lyt_nvo_lids_2', 'layoutNonVisualObjectsLids2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_surface_1', 'lyt_surface_1', 'layoutLidSurface', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_soil_1', 'lyt_soil_1', 'layoutLidSoil', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_storage_1', 'lyt_storage_1', 'layoutLidStorage', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_drain_1', 'lyt_drain_1', 'layoutLidDrain', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pavement_1', 'lyt_pavement_1', 'layoutLidPavement', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_roof_1', 'lyt_roof_1', 'layoutLidRoof', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_drainmat_1', 'lyt_drainmat_1', 'layoutLidDrainamat', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_surface', 'tab_surface', 'tabSurface', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_soil', 'tab_soil', 'tabSoil', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_storage', 'tab_storage', 'tabStorage', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_drain', 'tab_drain', 'tabDrain', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pavement', 'tab_pavement', 'tabPavement', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_roof', 'tab_roof', 'tabRoof', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_drainmat', 'tab_drainmat', 'tabDrainmat', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_surface', 'Surface', 'Surface', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_soil', 'Soil', 'Soil', 'role_basic', NULL, NULL, 1, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_drainmat', 'Drainage Mat', 'Drainage Mat', 'role_basic', NULL, NULL, 2, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_pavement', 'Pavement', 'Pavement', 'role_basic', NULL, NULL, 3, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_storage', 'Storage', 'Storage', 'role_basic', NULL, NULL, 4, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_drain', 'Drain', 'Drain', 'role_basic', NULL, NULL, 5, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'lidco_id', 'lyt_nvo_lids_1', 0, NULL, 'text', 'Control Name', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'lidco_type', 'lyt_nvo_lids_1', 1, NULL, 'combo', 'Control Name', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_lidtype''', NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'img_lids', 'lyt_nvo_lids_1', 2, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'lbl_lids', 'lyt_nvo_lids_1', 3, NULL, 'label', 'Source: SWMM 5.1', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('GR', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_soil",
    "tab_drainmat"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_2', 'lyt_soil_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_3', 'lyt_soil_1', 1, NULL, 'text', 'Porosity    (volume fraction)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_4', 'lyt_soil_1', 2, NULL, 'text', 'Field Capacity (volume fraction)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_3', 'lyt_surface_1', 1, NULL, 'text', 'Vegetation Volume Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_4', 'lyt_surface_1', 2, NULL, 'text', 'Surface Roughness (Mannings n)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_5', 'lyt_surface_1', 3, NULL, 'text', 'Surface Slope (percent)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_6', 'lyt_surface_1', 4, NULL, 'text', 'Swale Side Slope (run / rise)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_2', 'lyt_surface_1', 0, NULL, 'text', 'Berm Height (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_6', 'lyt_soil_1', 4, NULL, 'text', 'Conductivity    (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_2', 'lyt_drain_1', 0, NULL, 'text', 'Flow Coefficient*', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_3', 'lyt_drain_1', 1, NULL, 'text', 'Flow Exponent', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_4', 'lyt_drain_1', 2, NULL, 'text', 'Offset (in or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_5', 'lyt_drain_1', 3, NULL, 'text', 'Drain Delay (hrs)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_6', 'lyt_drain_1', 4, NULL, 'text', 'Open Level (in or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_7', 'lyt_drain_1', 5, NULL, 'text', 'Closed Level (in or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_7', 'lyt_soil_1', 5, NULL, 'text', 'Conductivity Slope', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_8', 'lyt_soil_1', 6, NULL, 'text', 'Suction Head (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drainmat', 'value_2', 'lyt_drainmat_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drainmat', 'value_3', 'lyt_drainmat_1', 1, NULL, 'text', 'Void Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drainmat', 'value_4', 'lyt_drainmat_1', 2, NULL, 'text', 'Roughness (Mannings n)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_2', 'lyt_pavement_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_3', 'lyt_pavement_1', 1, NULL, 'text', 'Void Ratio (Void / Solids)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_4', 'lyt_pavement_1', 2, NULL, 'text', 'Imprevious Surface Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_5', 'lyt_pavement_1', 3, NULL, 'text', 'Permeability    (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_6', 'lyt_pavement_1', 4, NULL, 'text', 'Clogging Factor', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_7', 'lyt_pavement_1', 5, NULL, 'text', 'Regeneration Interval (days)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_8', 'lyt_pavement_1', 6, NULL, 'text', 'Regeneration Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_roof', 'value_2', 'lyt_roof_1', 0, NULL, 'text', 'Flow Capacity (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_2', 'lyt_storage_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_3', 'lyt_storage_1', 1, NULL, 'text', 'Void Ratio (Voids / Solids)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_4', 'lyt_storage_1', 2, NULL, 'text', 'Seepage Rate (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_5', 'lyt_storage_1', 3, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('VS', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_5', 'lyt_soil_1', 3, NULL, 'text', 'Wilting Point (volume fraction)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('BC', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_soil",
    "tab_storage"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('PP', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_pavement",
    "tab_storage"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('IT', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_storage"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('RB', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_storage",
    "tab_drain"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('RG', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_soil"
  ]
}'::json, NULL, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_surface', '{"layouts":["lyt_surface_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_soil', '{"layouts":["lyt_soil_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_storage', '{"layouts":["lyt_storage_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_drainmat', '{"layouts":["lyt_drainmat_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_drain', '{"layouts":["lyt_drain_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_pavement', '{"layouts":["lyt_pavement_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_roof', '{"layouts":["lyt_roof_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


UPDATE sys_style SET stylevalue = replace(stylevalue,'tot_flood','tot_flood_compare') WHERE layername IN ('v_rpt_comp_nodeflooding_sum');
UPDATE sys_style SET stylevalue = replace(stylevalue,'mfull_depth','mfull_depth_compare') WHERE layername IN ('v_rpt_comp_arcflow_sum');

DELETE FROM sys_table WHERE id='cat_mat_grate';
DELETE FROM sys_table WHERE id='cat_mat_gully';


UPDATE sys_style SET stylevalue = replace(stylevalue,'vhmax','vhmax_compare') WHERE layername IN ('v_rpt_comp_subcatchrunoff_sum');



update sys_message
set error_message = 'Feature is out of sector, feature_id: %feature_id%'
where id = 1010;

update sys_message
set error_message = 'Feature is out of dma, feature_id: %feature_id%'
where id = 1014;

update sys_message
set error_message = 'One or more arcs has the same node as Node1 and Node2. Node_id: %node_id%'
where id = 1040;

update sys_message
set error_message = 'One or more arcs was not inserted/updated because it has not start/end node. Arc_id: %arc_id%'
where id = 1042;

update sys_message
set error_message = 'Exists one o more connecs closer than configured minimum distance, connec_id: %connec_id%'
where id = 1044;

update sys_message
set error_message = 'Exists one o more nodes closer than configured minimum distance, node_id: %node_id%'
where id = 1046;

update sys_message
set error_message = 'There is at least one arc attached to the deleted feature. (num. arc,feature_id) = %num_arc%, %feature_id%'
where id = 1056;

update sys_message
set error_message = 'There is at least one element attached to the deleted feature. (num. element,feature_id) = %num_element%, %feature_id%'
where id = 1058;

update sys_message
set error_message = 'There is at least one document attached to the deleted feature. (num. document,feature_id) = %num_document%, %feature_id%'
where id = 1060;

update sys_message
set error_message = 'There is at least one visit attached to the deleted feature. (num. visit,feature_id) = %num_visit%, %feature_id%'
where id = 1062;

update sys_message
set error_message = 'There is at least one link attached to the deleted feature. (num. link,feature_id) = %num_link%, %feature_id%'
where id = 1064;

update sys_message
set error_message = 'There is at least one connec attached to the deleted feature. (num. connec,feature_id) = %num_connec%, %feature_id%'
where id = 1066;

update sys_message
set error_message = 'There is at least one gully attached to the deleted feature. (num. gully,feature_id)= %num_gully%, %feature_id%'
where id = 1068;

update sys_message
set error_message = 'The feature can''t be replaced, because it''s state is different than 1. State = %state_id%'
where id = 1070;

update sys_message
set error_message = 'Before downgrading the node to state 0, disconnect the associated features, node_id: %node_id%'
where id = 1072;

update sys_message
set error_message = 'Before downgrading the arc to state 0, disconnect the associated features, arc_id: %arc_id%'
where id = 1074;

update sys_message
set error_message = 'Before downgrading the connec to state 0, disconnect the associated features, connec_id: %connec_id%'
where id = 1076;

update sys_message
set error_message = 'Before downgrading the gully to state 0, disconnect the associated features, gully_id: %gully_id%'
where id = 1078;

update sys_message
set error_message = 'Nonexistent arc_id: %arc_id%'
where id = 1082;

update sys_message
set error_message = 'Nonexistent node_id: %node_id%'
where id = 1084;

update sys_message
set error_message = 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is: %node_id%'
where id = 1096;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state(1) over another one with state (1) also. The node is: %node_id%'
where id = 1097;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state (2) over another one with state (2). The node is: %node_id%'
where id = 1100;

update sys_message
set error_message = 'Feature is out of exploitation, feature_id: %feature_id%'
where id = 2012;

update sys_message
set error_message = '(arc_id, geom type) = %arc_id%, %geom_type%'
where id = 2022;

update sys_message
set error_message = 'The feature does not have state(1) value to be replaced, state = %state_id%'
where id = 2028;

update sys_message
set error_message = 'The feature not have state(2) value to be replaced, state = %state_id%'
where id = 2030;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id, arc_id: %arc_id%'
where id = 2036;

update sys_message
set error_message = 'The exit arc must be reversed. Arc = %arc_id%'
where id = 2038;

update sys_message
set error_message = 'Reduced geometry is not a Linestring, (arc_id,geom type)= %arc_id%, %geom_type%'
where id = 2040;

update sys_message
set error_message = 'Query text = %query_text%'
where id = 2078;

update sys_message
set error_message = 'The x value is too large. The total length of the line is %line_length%'
where id = 2080;

update sys_message
set error_message = 'The extension does not exists. Extension = %extension%'
where id = 2082;

update sys_message
set error_message = 'The module does not exists. Module = %module%'
where id = 2084;

update sys_message
set error_message = 'There are [units] values nulls or not defined on price_value_unit table  = %units%'
where id = 2088;

update sys_message
set error_message = 'There is at least one node attached to the deleted feature. (num. node,feature_id)= %num_node%, %feature_id%'
where id = 2108;

update sys_message
set error_message = 'The selected arc has state=0 (num. node,feature_id)= %element_id%'
where id = 3002;

update sys_message
set error_message = 'The minimum arc length of this exportation is: %min_arc_length%'
where id = 3010;

update sys_message
set error_message = 'Can''t modify typevalue: %typevalue%'
where id = 3028;

update sys_message
set error_message = 'Can''t delete typevalue: %typevalue%'
where id = 3030;

update sys_message
set error_message = 'Can''t apply the foreign key %typevalue_name%'
where id = 3032;

update sys_message
set error_message = 'Selected state type doesn''t correspond with state %state_id%'
where id = 3036;

update sys_message
set error_message = 'Inserted value has unaccepted characters: %characters%'
where id = 3038;

update sys_message
set error_message = 'Selected node type doesn''t divide arc. Node type: %node_type%'
where id = 3046;

update sys_message
set error_message = 'Connect2network tool is not enabled for connec''s with state=2. Connec_id: %connec_id%'
where id = 3052;

update sys_message
set error_message = 'Connect2network tool is not enabled for gullies with state=2. Gully_id: %gully_id%'
where id = 3054;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id. Arc_id: %arc_id%'
where id = 3056;

update sys_message
set error_message = 'It is impossible to validate the connec without assigning value of connecat_id. Connec_id: %connec_id%'
where id = 3058;

update sys_message
set error_message = 'It is impossible to validate the node without assigning value of nodecat_id. Node_id: %node_id%'
where id = 3060;

update sys_message
set error_message = 'Selected gratecat_id has NULL width or length. Gratecat_id: %gratecat_id%'
where id = 3062;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each connec. Connec_id: %connec_id%'
where id = 3076;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each gully. Gully_id: %gully_id%'
where id = 3078;

update sys_message
set error_message = 'It is not possible to relate connect with state=1 over network feature with state=2, connect: %connec_id%'
where id = 3080;

update sys_message
set error_message = 'Feature is out of any presszone, feature_id: %feature_id%'
where id = 3108;

update sys_message
set error_message = '%id% does not exists, impossible to delete it'
where id = 3116;

update sys_message
set error_message = 'Node is connected to arc which is involved in psector %psector_list%'
where id = 3140;

update sys_message
set error_message = 'Node is involved in psector %psector_list%'
where id = 3142;

update sys_message
set error_message = 'Exploitation of the feature is different than the one of the related arc. Arc_id: %arc_id%'
where id = 3144;

update sys_message
set error_message = 'Backup name already exists %backup_name%'
where id = 3148;

update sys_message
set error_message = 'Backup has no data related to table %table_name%'
where id = 3150;

update sys_message
set error_message = 'Null values on geom1 or geom2 fields on element catalog %elementcat_id%'
where id = 3152;

update sys_message
set error_message = 'Input parameter has null value %table_name%'
where id = 3156;

update sys_message
set error_message = 'This feature with state = 2 is only attached to one psector %psector_id%'
where id = 3160;

update sys_message
set error_message = 'Id value for this catalog already exists %value%'
where id = 3166;

update sys_message
set error_message = 'It is no possible to relate planned connec/gully over planned connec/gully wich not are on same psector. %debugmsg%'
where id = 3178;

update sys_message
set error_message = 'You are trying to modify some network element with related connects (connec / gully) on psector not selected. %psector_id%'
where id = 3180;

update sys_message
set error_message = 'It is not possible to downgrade connec because has operative hydrometer associated %feature_id%'
where id = 3194;

update sys_message
set error_message = 'Shortcut key is already defined for another feature %shortcut%'
where id = 3196;

update sys_message
set error_message = 'It''s not possible to break planned arcs by using operative nodes %arc_id%'
where id = 3202;

update sys_message
set error_message = 'The inserted value is not present in a catalog. %catalog%'
where id = 3022;

update sys_message
set error_message = 'Inserted feature_id does not exist on node/connec table %feature_id%'
where id = 3230;

update sys_message
set error_message = 'It''s not possible to connect to this arc because it exceed the maximum diameter configured: %diameter%'
where id = 3232;

update sys_message
set error_message = 'It''s not possible to configure this node as mapzone header, because it''s not an operative nor planified node %zone%'
where id = 3242;

update sys_message
set error_message = 'It''s not possible to use selected arcs. They are not connected to node parent %nodeparent%'
where id = 3244;

update sys_message
set error_message = 'There is no subcatchment or outlet_id nearby'
where id = 3252;

update sys_message
set error_message = 'No arc exists with a smaller diameter than the maximum configuered on edit_link_check_arcdnom: %edit_link_check_arcdnom%'
where id = 3260;

update sys_message
set error_message = 'Wrong configuration. Check config_form_fields on column widgetcontrol key ''reloadfields'' for columnname: %parentname%'
where id = 3264;

update sys_message
set error_message = left(error_message, length(error_message)-1)
where error_message ilike '%.';

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3360, 'Create Thyssen subcatchments', '{"featureType":[]}'::json, '[
{"widgetname":"clipLayer", "label":"Clip Layer:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["sector","expl", "muni"],
"comboNames":["SECTOR","EXPL", "MUNICIPALITY"]},
{"widgetname":"deletePrevious", "label":"Delete previous subcatchments:", "widgettype":"check", "datatype":"boolean", "layoutname":"grl_option_parameters","layoutorder":2, "value":"true"}
]'::json, NULL, true, '{4}');


INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_results', 'SELECT dscenario_id as id, name, descript, dscenario_type, parent_id, expl_id, active::TEXT, log FROM v_edit_cat_dscenario WHERE dscenario_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_toggle_active",
      "widgetfunction": {
        "functionName": "toggle_active",
        "params": {}
      },
      "color": "default",
      "text": "Toggle active",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pump_1', 'lyt_pump_1', 'lytPump1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_junction_1', 'lyt_junction_1', 'lytJunction1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_conduit_1', 'lyt_conduit_1', 'lytConduit1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_raingage_1', 'lyt_raingage_1', 'lytRaingage1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_weir_1', 'lyt_weir_1', 'lytWeir1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_outfall_1', 'lyt_outfall_1', 'lytOutfall1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_inflows_1', 'lyt_inflows_1', 'lytInflows1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_treatment_1', 'lyt_treatment_1', 'lytTreatment1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_poll_1', 'lyt_poll_1', 'lytPoll1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_orifice_1', 'lyt_orifice_1', 'lytOrifice1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_outlet_1', 'lyt_outlet_1', 'lytOutlet1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_outlet', 'tab_outlet', 'tabOutlet', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_conduit', 'tab_conduit', 'tabConduit', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_raingage', 'tab_raingage', 'tabRaingage', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_junction', 'tab_junction', 'tabJunction', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_weir', 'tab_weir', 'tabWeir', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_outfall', 'tab_outfall', 'tabOutfall', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_inflows', 'tab_inflows', 'tabInflows', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_treatment', 'tab_treatment', 'tabTreatment', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_poll', 'tab_poll', 'tabPoll', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pump', 'tab_pump', 'tabPump', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_orifice', 'tab_orifice', 'tabOrifice', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_conduit', 'Conduit', 'Conduit', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_controls', 'Controls', 'Controls', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_inflows', 'Inflows', 'Inflows', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_junction', 'Junction', 'Junction', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_lids', 'Lids', 'Lids', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_orifice', 'Orifice', 'Orifice', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_outfall', 'Outfall', 'Outfall', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_outlet', 'Outlet', 'Outlet', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_poll', 'Poll', 'Poll', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_pump', 'Pump', 'Pump', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_raingage', 'Raingage', 'Raingage', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_storage', 'Storage', 'Storage', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_treatment', 'Treatment', 'Treatment', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_weir', 'Weir', 'Weir', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_controls', '{"layouts":["lyt_controls_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_conduit', '{"layouts":["lyt_conduit_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_raingage', '{"layouts":["lyt_raingage_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_junction', '{"layouts":["lyt_junction_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_weir', '{"layouts":["lyt_weir_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_outfall', '{"layouts":["lyt_outfall_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_storage', '{"layouts":["lyt_storage_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_inflows', '{"layouts":["lyt_inflows_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_treatment', '{"layouts":["lyt_treatment_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_poll', '{"layouts":["lyt_poll_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_pump', '{"layouts":["lyt_pump_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_orifice', '{"layouts":["lyt_orifice_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_lids', '{"layouts":["lyt_lids_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_outlet', '{"layouts":["lyt_outlet_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_controls', 'tbl_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_controls', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_conduit', 'tbl_conduit', 'lyt_conduit_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_conduit', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_raingage', 'tbl_raingage', 'lyt_raingage_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_raingage', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_weir', 'tbl_weir', 'lyt_weir_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_weir', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_outfall', 'tbl_outfall', 'lyt_outfall_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_outfall', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_storage', 'tbl_storage', 'lyt_storage_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_storage', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_inflows', 'tbl_inflows', 'lyt_inflows_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_inflows', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_treatment', 'tbl_treatment', 'lyt_treatment_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_treatment', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_orifice', 'tbl_orifice', 'lyt_orifice_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_orifice', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_lids', 'tbl_lids', 'lyt_lids_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_lids', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_outlet', 'tbl_outlet', 'lyt_outlet_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_outlet', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_poll', 'tbl_poll', 'lyt_poll_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_poll', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_pump', 'tbl_pump', 'lyt_pump_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_pump', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_junction', 'tbl_junction', 'lyt_junction_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_junction', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'tab_main', 'lyt_dscenario_1', 1, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_pump",
    "tab_junction",
    "tab_conduit",
    "tab_raingage",
    "tab_weir",
    "tab_outfall",
    "tab_storage",
    "tab_inflows",
    "tab_treatment",
    "tab_poll",
    "tab_orifice",
    "tab_lids",
    "tab_outlet",
    "tab_controls"
  ]
}'::json, NULL, NULL, false, 1);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_controls', 'SELECT dscenario_id AS id, sector_id, "text", active FROM inp_dscenario_controls where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "sector_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "sector_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_conduit', 'SELECT dscenario_id AS id, arc_id, arccat_id, matcat_id, custom_n, barrels, culvert, kentry, kexit, kavg, flap, q0, qmax, seepage, elev1, elev2 FROM inp_dscenario_conduit where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_raingage', 'SELECT dscenario_id AS id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname,sta, units FROM inp_dscenario_raingage where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "rg_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "rg_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_junction', 'SELECT dscenario_id AS id, node_id, y0, ysur, apond, outfallparam, elev, ymax FROM inp_dscenario_junction where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_outfall', 'SELECT dscenario_id AS id, node_id, elev, ymax, outfall_type, stage, curve_id, timser_id, gate, route_to FROM inp_dscenario_outfall  where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_storage', 'SELECT dscenario_id AS id, node_id, elev, ymax, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur FROM inp_dscenario_storage where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_inflows', 'SELECT dscenario_id AS id, node_id, order_id, timser_id, sfactor, base, pattern_id FROM inp_dscenario_inflows where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_treatment', 'SELECT dscenario_id AS id, node_id, poll_id, "function" FROM inp_dscenario_treatment where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_orifice', 'SELECT dscenario_id AS id, nodarc_id, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4 FROM inp_dscenario_frorifice where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_lids', 'SELECT dscenario_id AS id, subc_id, lidco_id, numelem, area, width, initsat, fromimp, toperv, rptfile, descript FROM inp_dscenario_lids  where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "subc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "subc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_outlet', 'SELECT dscenario_id AS id, nodarc_id, outlet_type, offsetval, curve_id, cd1, flap, cd2 FROM inp_dscenario_froutlet where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_pump', 'SELECT dscenario_id AS id, nodarc_id, curve_id, status, shutoff, startup FROM inp_dscenario_frpump where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_weir', 'SELECT dscenario_id AS id, nodarc_id, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, coef_curve, road_surf FROM inp_dscenario_frweir where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_poll', 'SELECT dscenario_id AS id, node_id, poll_id, timser_id, form_type, mfactor, sfactor, base, pattern_id FROM inp_dscenario_inflows_poll  where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_controls', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_conduit', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_raingage', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_junction', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_weir', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_outfall', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_storage', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_inflows', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_treatment', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_poll', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_pump', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_orifice', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_lids', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_outlet', 'id', NULL, false, NULL, NULL, NULL, NULL);


UPDATE config_form_fields
SET iseditable = false
WHERE formtype = 'form_feature'
  AND columnname = 'to_arc'
  AND tabname = 'tab_none'
  AND formname IN (
    'v_edit_inp_frorifice',
    'v_edit_inp_froutlet',
    'v_edit_inp_frpump',
    'v_edit_inp_frweir'
  );

DROP FUNCTION IF EXISTS gw_fct_import_swmm_inp(p_data json);

DELETE FROM config_toolbox
	WHERE id=2524; --gw_fct_import_swmm_inp

DELETE FROM sys_function
	WHERE id=2524; --gw_fct_import_swmm_inp

update config_form_fields set dv_querytext_filterc = null
where formname in ('v_edit_inp_frpump','v_edit_inp_frorifice','v_edit_inp_frweir','v_edit_inp_froutlet');


--edited 28/01/2025

-- Insert on config_form_fields for parent view
-- copying columns from some random child (all childs has same columns that parent)
INSERT INTO config_form_fields
SELECT 'v_edit_flwreg', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrpump' AND columnname IN ('nodarc_id','order_id','to_arc','flwreg_length');

-- Insert on config_form_fields for child views
INSERT INTO config_form_fields
SELECT 've_flwreg_frorifice', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrorifice' AND columnname != 'close_time';

INSERT INTO config_form_fields
SELECT 've_flwreg_frweir', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrweir';

INSERT INTO config_form_fields
SELECT 've_flwreg_froutlet', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfroutlet';

INSERT INTO config_form_fields
SELECT 've_flwreg_frpump', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrpump';

--Adding flwregtype on forms for flowregulators
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_flwreg_frorifice', 'form_feature', 'tab_none', 'flwreg_type', NULL, 16, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname,layoutorder,   "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_flwreg_frweir', 'form_feature', 'tab_none', 'flwreg_type', NULL,20, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname,layoutorder,   "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_flwreg_froutlet', 'form_feature', 'tab_none', 'flwreg_type', NULL,12, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname,layoutorder,   "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_flwreg_frpump', 'form_feature', 'tab_none', 'flwreg_type', NULL,10, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

--Default parameters uneditable for flow regulators

UPDATE config_form_fields  set iseditable = FALSE where columnname IN ('nodarc_id', 'node_id', 'order_id', 'to_arc' )
AND formname IN ('ve_flwreg_frorifice','v_edit_flwreg_frweir', 'v_edit_flwreg_froutlet' ,'v_edit_flwreg_frpump');

--Trigger function for editing flowregulators.
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3372, 'gw_trg_edit_flwreg', 'ud', 'function', 'json', 'json', 'Trigger to insert the flowregulators.', 'role_epa', NULL, 'core');

--Add flowregulators in inventory
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}',
NULL, NULL, '{"orderBy":9}'::json);

--Adding flowregulators ibnto network group
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('v_edit_flwreg', 'View to edit flowregulators.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 1, 'Flow regulator (parent)', NULL, NULL, NULL, 'core', '{
  "pkey": "nodarc_id"
}'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('ve_flwreg_frweir', 'View to edit flowregulators for weir.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 5, 'Weir', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('v_edit_flwreg_froutlet', 'View to edit flowregulators for outlet.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 3, 'Outlet', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('ve_flwreg_frpump', 'View to edit flowregulators for pumps.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 4, 'Pump', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('ve_flwreg_frorifice', 'View to edit flowregulators for orifice.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 2, 'Orifice', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);

--Edit button for flwreg
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_flwreg', 'tab_none', NULL, NULL, 'role_epa', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  }
]'::json, 0, '{4,5}');

INSERT INTO temp_node (id, result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, omzone_id, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node, age)
SELECT id, result_id, node_id::integer, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, NULL, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node, age
FROM _temp_node;

INSERT INTO temp_arc (id, result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, omzone_id, length, n, the_geom, expl_id,
addparam, arcparent, q0, qmax, barrels, slope, flag, culvert, kentry, kexit, kavg, flap, seepage, age)
SELECT id, result_id, arc_id::integer, node_1::integer, node_2::integer, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, NULL, length, n, the_geom, expl_id,
addparam, arcparent, q0, qmax, barrels, slope, flag, culvert, kentry, kexit, kavg, flap, seepage, age
FROM _temp_arc;

INSERT INTO temp_gully (gully_id, gully_type, gullycat_id, arc_id, node_id, sector_id, state, state_type, top_elev, units, units_placement, outlet_type, width, length, "depth", "method", weir_cd, orifice_cd, a_param, b_param, efficiency, the_geom)
SELECT gully_id::integer, gully_type, gratecat_id, arc_id::integer, node_id::integer, sector_id, state, state_type, top_elev, units, units_placement, outlet_type, width, length, "depth", "method", weir_cd, orifice_cd, a_param, b_param, efficiency, the_geom
FROM _temp_gully;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_none', 'verified', 'lyt_data_1', 29, 'integer', 'combo', 'Verified', 'Verified', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);

UPDATE config_form_fields SET datatype = 'integer', widgettype = 'combo', label = 'Verified', tooltip = 'verified', iseditable = true,
dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''',
dv_orderby_id = true, dv_isnullvalue = true, widgetcontrols = '{"setMultiline": false, "labelPosition": "top"}'::json WHERE columnname = 'verified';


INSERT INTO man_manhole (node_id, length, width, sander_depth, prot_surface, inlet, bottom_channel, accessibility, bottom_mat)
SELECT node_id::integer, length, width, sander_depth, prot_surface, inlet, bottom_channel, accessibility, bottom_mat
FROM _man_manhole;

INSERT INTO review_node (node_id, top_elev, ymax, node_type, matcat_id, nodecat_id, annotation, observ, review_obs, expl_id, the_geom,
field_checked, is_validated, field_date)
SELECT node_id::integer, top_elev, ymax, node_type, matcat_id, nodecat_id, annotation, observ, review_obs, expl_id, the_geom,
field_checked, is_validated, field_date
FROM _review_node;

INSERT INTO review_audit_node (id, node_id, old_top_elev, new_top_elev, old_ymax, new_ymax, old_node_type, new_node_type, old_matcat_id, new_matcat_id, old_nodecat_id, new_nodecat_id,
old_annotation, new_annotation, old_observ, new_observ, review_obs, expl_id, the_geom, review_status_id, field_date, field_user, is_validated)
SELECT id, node_id::integer, old_top_elev, new_top_elev, old_ymax, new_ymax, old_node_type, new_node_type, old_matcat_id, new_matcat_id, old_nodecat_id, new_nodecat_id,
old_annotation, new_annotation, old_observ, new_observ, review_obs, expl_id, the_geom, review_status_id, field_date, field_user, is_validated
FROM _review_audit_node;

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FRORIFICE'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_frorifice' AND columnname='nodarc_id';

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FROUTLET'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_froutlet' AND columnname='nodarc_id';

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FRPUMP'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_frpump' AND columnname='nodarc_id';

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FRWEIR'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_frweir' AND columnname='nodarc_id';


-- Insert supplyzone types
INSERT INTO edit_typevalue VALUES('dwfzone_type', 'UNDEFINED', 'UNDEFINED', NULL, NULL);

-- Insert widgets drainzone
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1, "datatype"='integer', widgettype='text', "label"='drainzone_id', tooltip='drainzone_id', placeholder=NULL, ismandatory=true, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='drainzone_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2, "datatype"='string', widgettype='text', "label"='name', tooltip='name', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='drainzone_type', tooltip='drainzone_type', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue=''drainzone_type''', dv_orderby_id=true, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='drainzone_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4, "datatype"='string', widgettype='text', "label"='descript', tooltip='descript', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5, "datatype"='boolean', widgettype='check', "label"='active', tooltip='active', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6, "datatype"='integer', widgettype='combo', "label"='lock_level', tooltip='lock_level', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext='SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7, "datatype"='string', widgettype='text', "label"='graphconfig', tooltip='graphconfig', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8, "datatype"='string', widgettype='text', "label"='stylesheet', tooltip='stylesheet', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9, "datatype"='string', widgettype='text', "label"='link', tooltip='link', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10, "datatype"='text', widgettype='text', "label"='expl_id', tooltip='expl_id', placeholder='Ex: 1,2', ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

-- Insert widgets macrosector
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'macrosector_id', 'lyt_data_1', 1, 'integer', 'text', 'macrosector_id', 'macrosector_id', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'text', 'text', 'name', 'name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 5, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, false, 'SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


-- Insert widgets sector
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'sector_id', 'lyt_data_1', 1, 'integer', 'text', 'sector_id', 'sector_id', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'sector_type', 'lyt_data_1', 3, 'string', 'combo', 'sector_type', 'sector_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'macrosector', 'lyt_data_1', 4, 'string', 'combo', 'macrosector_id', 'macrosector_id', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 5, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, false, 'SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 8, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 9, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'parent_id', 'lyt_data_1', 10, 'string', 'combo', 'parent_id', 'parent_id', NULL, false, false, true, false, false, 'SELECT sector_id as id,name as idval FROM v_ui_sector WHERE sector_id > -1 AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'link', 'lyt_data_1', 11, 'string', 'text', 'link', 'link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- Insert widgets dwfzone
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'dwfzone_id', 'lyt_data_1', 1, 'integer', 'text', 'dwfzone_id', 'dwfzone_id', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'dwfzone_type', 'lyt_data_1', 3, 'string', 'combo', 'dwfzone_type', 'dwfzone_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dwfzone_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'string', 'text', 'descript', 'descript', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 5, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 6, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, false, 'SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 7, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 8, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'link', 'lyt_data_1', 9, 'string', 'text', 'link', 'link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 10, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


-- sys_foreignkey
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'node', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'arc', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'connec', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'element', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'gully', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;


INSERT INTO arc_add (arc_id, result_id, max_flow, max_veloc, mfull_flow, mfull_depth)
SELECT arc_id::integer, result_id, max_flow, max_veloc, mfull_flow, mfull_depth
FROM rpt_arcflow_sum;

INSERT INTO node_add (node_id, result_id, max_depth, max_height, flooding_rate, flooding_vol)
SELECT d.node_id::integer, result_id, max_depth, max_height, f.max_rate, f.tot_flood
FROM rpt_nodedepth_sum d
JOIN rpt_nodesurcharge_sum c USING (result_id)
JOIN rpt_nodeflooding_sum f USING (result_id);

UPDATE config_form_fields SET columnname = 'mfull_depth', label = 'mfull_depth', tooltip = 'mfull_depth' WHERE columnname = 'mfull_dept';


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_log_1', 'lyt_log_1', 'lytLog1', NULL) ON CONFLICT DO NOTHING;

DELETE FROM config_form_fields WHERE formname = 've_epa_valve' AND columnname = 'to_arc';


INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'node', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'arc', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'connec', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'element', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'gully', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL
WHERE (formname='v_edit_arc' OR formname ILIKE 've_arc_%' OR formname='v_edit_connec' OR formname ILIKE 've_connec_%' OR formname='v_edit_node' OR formname ILIKE 've_node_%' OR formname='v_edit_element' OR formname ILIKE 've_element_%' OR formname='v_edit_gully' OR formname ILIKE 've_gully_%')
AND formtype='form_feature' AND columnname='lock_level' AND tabname='tab_data';


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_gully', 'tab_relations_gully', 'tabRelationsGully', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_gully_1', 'lyt_relations_gully_1', 'layoutRelationsGully1', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_gully', 'Gully', 'Gully', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_gully', 'table_view_gully', 'lyt_relations_gully_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_gully_results', false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations', 'tab_relations_arc', 'lyt_relations_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_relations_arc",
    "tab_relations_node",
    "tab_relations_connec",
    "tab_relations_gully"
  ]
}'::json, NULL, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_gully', '{"layouts":["lyt_relations_gully_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_gully_results', 'SELECT id, gully_id, arc_id, state, doable::TEXT FROM plan_psector_x_gully WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);


-- man_wwtp
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_wwtp_wwtptype', '0', 'UNDEFINED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_wwtp_wwtptype', 'man_wwtp', 'wwtp_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_wwtp_wwtptype''', dv_isnullvalue=False
WHERE formname ILIKE 've_node%_wwtp' AND formtype='form_feature' AND columnname='wwtp_type' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_wwtp_treatmenttype', '0', 'UNDEFINED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_wwtp_treatmenttype', 'man_wwtp', 'treatment_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_wwtp_treatmenttype''', dv_isnullvalue=False
WHERE formname ILIKE 've_node%_wwtp' AND formtype='form_feature' AND columnname='treatment_type' AND tabname='tab_data';

-- node
UPDATE config_form_fields SET widgettype='typeahead', dv_querytext='SELECT id, id AS idval FROM cat_pavement WHERE id IS NOT NULL', dv_isnullvalue=True WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='pavcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET widgettype='typeahead', dv_querytext='SELECT id, id AS idval FROM cat_pavement WHERE id IS NOT NULL', dv_isnullvalue=True WHERE formname ILIKE 've_node_%' AND formtype='form_feature' AND columnname='pavcat_id' AND tabname='tab_data';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_arc', 'form_feature', 'tab_data', 'cat_dr', 'lyt_data_1', 55, 'integer', 'text', 'cat_dr', 'cat_dr', NULL, false, NULL, false, NULL, NULL, NULL, true, true, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

-- arc
UPDATE config_form_fields SET columnname='registration_date', widgettype='datetime' WHERE (formname ILIKE 've_arc%' OR formname='v_edit_arc') AND formtype='form_feature' AND columnname='registre_date' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('discharge_medium_typevalue', '0', 'Undefined', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'discharge_medium_typevalue', 'man_outfall', 'discharge_medium', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields SET layoutname='lyt_data_1', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''discharge_medium_typevalue''', dv_isnullvalue=TRUE WHERE columnname='discharge_medium' AND formname ILIKE '%outfall%';

DELETE FROM config_form_fields WHERE columnname='buildercat_id';

INSERT INTO macroexploitation (macroexpl_id, code, "name", descript, lock_level, active, updated_at)
SELECT macroexpl_id, macroexpl_id::text, "name", descript, NULL, active, now()
FROM _macroexploitation;

INSERT INTO exploitation (expl_id, code, "name", descript, macroexpl_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT expl_id, expl_id::text, "name", descript, macroexpl_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _exploitation;

INSERT INTO macrosector (macrosector_id, code, "name", descript, lock_level, active, the_geom, updated_at)
SELECT macrosector_id, macrosector_id::text, "name", descript, NULL, active, the_geom, now()
FROM _macrosector;

INSERT INTO macroomzone (macroomzone_id, code, "name", descript, expl_id, lock_level, active, the_geom, updated_at)
SELECT macrodma_id, macrodma_id::text, "name", descript, ARRAY[expl_id], NULL, active, the_geom, now()
FROM _macrodma;

INSERT INTO omzone (omzone_id, code, "name", descript, omzone_type, expl_id, macroomzone_id, minc, maxc, effc, link,
graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT dma_id, dma_id::text, "name", descript, dma_type, expl_id, macrodma_id, minc, maxc, effc, link,
graphconfig, stylesheet, lock_level, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dma;

INSERT INTO drainzone (drainzone_id, code, "name", drainzone_type, descript, expl_id, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT drainzone_id, drainzone_id::text, "name", drainzone_type, descript, ARRAY[expl_id], link, graphconfig, stylesheet, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _drainzone;

INSERT INTO sector (sector_id, code, "name", descript, macrosector_id, parent_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT sector_id, sector_id::text, "name", descript, macrosector_id, parent_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _sector;


-- todo: disable triggers

INSERT INTO node (node_id, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type,
annotation, observ, "comment", omzone_id, soilcat_id, function_type, category_type, _fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified, the_geom,
label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected, expl_id, num_value, feature_type, created_at, arc_id, updated_at,
updated_by, created_by, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, parent_id, expl_visibility, adate, adescript, hemisphere, placement_type,
access_type, label_quadrant, minsector_id, brand_id, model_id, serial_number)
SELECT node_id::integer, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type,
annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified::integer, the_geom,
label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected, expl_id, num_value, feature_type, tstamp, arc_id::integer, lastupdate,
lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, parent_id::integer, ARRAY[expl_id2], adate, adescript, hemisphere, placement_type,
access_type, label_quadrant, minsector_id, brand_id, model_id, serial_number
FROM _node;


INSERT INTO arc (arc_id, code, sys_code, node_1, node_2, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, sys_elev1, sys_elev2, arc_type, arccat_id,
matcat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", sys_slope, inverted_slope, custom_length, omzone_id, soilcat_id, function_type,
category_type, _fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement,
streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id,
num_value, feature_type, created_at, updated_at, created_by, updated_by, district_id, workcat_id_plan, asset_id, pavcat_id, drainzone_id, nodetype_1,
node_sys_top_elev_1, node_sys_elev_1, nodetype_2, node_sys_top_elev_2, node_sys_elev_2, parent_id, expl_visibility, adate, adescript, visitability, label_quadrant,
minsector_id, brand_id, model_id, serial_number)
SELECT arc_id::integer, code, code, node_1::integer, node_2::integer, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, sys_elev1, sys_elev2, arc_type, arccat_id,
matcat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", sys_slope, inverted_slope, custom_length, dma_id, soilcat_id, function_type,
category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement,
streetaxis2_id, postnumber2, postcomplement2, descript, link, verified::integer, the_geom, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id,
num_value, feature_type, tstamp, lastupdate, lastupdate_user, insert_user, district_id, workcat_id_plan, asset_id, pavcat_id, drainzone_id, nodetype_1,
node_sys_top_elev_1, node_sys_elev_1, nodetype_2, node_sys_top_elev_2, node_sys_elev_2, parent_id::integer, ARRAY[expl_id2], adate, adescript, visitability, label_quadrant,
minsector_id, brand_id, model_id, serial_number
FROM _arc;


INSERT INTO connec (connec_id, code, top_elev, y1, y2, connec_type, conneccat_id, sector_id, customer_code,
demand, state, state_type, connec_depth, connec_length, arc_id, annotation, observ, "comment",
omzone_id, soilcat_id, function_type, category_type, _fluid_type, location_type, workcat_id, workcat_id_end, builtdate,
enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2,
postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation, accessibility,
diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at,
created_by, updated_by, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, expl_visibility, adate, adescript,
plot_code, placement_type, access_type, label_quadrant, n_hydrometer, minsector_id)
SELECT connec_id::integer, code, top_elev, y1, y2, connec_type, conneccat_id, sector_id, customer_code,
demand, state, state_type, connec_depth, connec_length, arc_id::integer, annotation, observ, "comment",
dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate,
enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2,
postcomplement2, descript, link, verified::integer, rotation, the_geom, label_x, label_y, label_rotation, accessibility,
diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id::integer, lastupdate,
lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, ARRAY[expl_id2], adate, adescript,
plot_code, placement_type, access_type, label_quadrant, n_hydrometer, minsector_id
FROM _connec;


INSERT INTO gully (gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, gullycat_id, units, groove, siphon,
_connec_arccat_id, arc_id, "_pol_id_", sector_id, state, state_type, annotation, observ,
"comment", omzone_id, soilcat_id, function_type, category_type, _fluid_type, location_type, workcat_id, workcat_id_end,
builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation,
publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at,
created_by, updated_by, district_id, workcat_id_plan, asset_id, _connec_matcat_id, connec_y2, _gratecat2_id,
epa_type, groove_height, groove_length, units_placement, drainzone_id, expl_visibility, adate, adescript, siphon_type,
odorflap, placement_type, access_type, label_quadrant, minsector_id)
SELECT gully_id::integer, code, top_elev, ymax, sandbox, matcat_id, gully_type, gullycat_id, units, groove, siphon,
connec_arccat_id, arc_id::integer, "_pol_id_", sector_id, state, state_type, annotation, observ,
"comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
postnumber2, postcomplement2, descript, link, verified::integer, rotation, the_geom, label_x, label_y, label_rotation,
publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id::integer, lastupdate,
lastupdate_user, insert_user, district_id, workcat_id_plan, asset_id, connec_matcat_id, connec_y2, gullycat2_id,
epa_type, groove_height, groove_length, units_placement, drainzone_id, ARRAY[expl_id2], adate, adescript, siphon_type,
odorflap, placement_type, access_type, label_quadrant, minsector_id
NULL
FROM _gully;


INSERT INTO element (element_id, code, sys_code, elementcat_id, serial_number, num_elements, state, state_type, observ,
"comment", function_type, category_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory,
expl_id, feature_type, created_at, updated_at, created_by, updated_by, top_elev, expl_visibility, trace_featuregeom,
muni_id, sector_id, brand_id, model_id, asset_id)
SELECT element_id::integer, code, code, elementcat_id, serial_number, num_elements, state, state_type, observ,
"comment", function_type, category_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, rotation, link, verified::integer, the_geom, label_x, label_y, label_rotation, publish, inventory,
expl_id, feature_type, tstamp, lastupdate, lastupdate_user, insert_user, top_elev, ARRAY[expl_id2], trace_featuregeom,
muni_id, sector_id, brand_id, model_id, asset_id
FROM _element;


INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('v_edit_link','form_feature','tab_none','datasource','lyt_data_1',36,'integer','combo','Datasource','Datasource',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_link','form_feature','tab_none','custom_length','lyt_data_1',37,'double','text','Custom length','Custom length',false,false,true,false,'{"setMultiline":false}'::json,false);

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('cat_connec','form_feature','tab_none','estimated_depth','double','text','Estimated depth:','Estimated depth',false,false,true,false,'{"setMultiline":false}'::json,false);




UPDATE sys_fprocess
SET query_text='select link_id as arc_id, linkcat_id as arccat_id, a.expl_id, l.the_geom FROM t_link l, temp_t_arc a WHERE st_dwithin(st_endpoint(l.the_geom), a.the_geom, 0.001) AND a.epa_type NOT IN (''CONDUIT'', ''PIPE'', ''VIRTUALVALVE'', ''VIRTUALPUMP'')'
WHERE fid=404;


DO $func$
DECLARE
  gullyr record;
  connecr record;
BEGIN
  FOR gullyr IN (SELECT gully_id, _connec_arccat_id FROM gully)
  LOOP
    IF NOT EXISTS(SELECT 1 FROM link WHERE feature_id = gullyr.gully_id) THEN
      EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || gullyr.gully_id || ']"},
     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "GULLY", "linkcatId":"UPDATE_LINK_40"}}$$);';
      UPDATE link SET uncertain=true WHERE feature_id = gullyr.gully_id;
    END IF;
  END LOOP;

  FOR connecr IN (SELECT connec_id, conneccat_id  FROM connec)
  LOOP
    IF NOT EXISTS(SELECT 1 FROM link WHERE feature_id = connecr.connec_id) THEN
      EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
      UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
    END IF;
  END LOOP;
END $func$;


UPDATE edit_typevalue SET typevalue='omzone_type' WHERE typevalue='dma_type' AND id='UNDEFINED';


UPDATE config_form_fields SET label = replace(label, 'dma', 'omzone'), tooltip = replace(tooltip, 'dma', 'omzone'), dv_querytext = replace(dv_querytext, 'dma', 'omzone'), dv_querytext_filterc = replace(dv_querytext_filterc, 'dma', 'omzone');
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'link_to_gully', 'link_to_gully', 'linkToGully', NULL);

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', '', 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{
  "functionName": "accept",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_add', 'lyt_connect_link_2', 1, NULL, 'button', NULL, 'Add', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, NULL, '{
  "functionName": "add",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', '', 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_remove', 'lyt_connect_link_2', 2, NULL, 'button', NULL, 'Remove', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, NULL, '{
  "functionName": "remove",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_snapping', 'lyt_connect_link_2', 3, NULL, 'button', NULL, 'Select on canvas', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, NULL, '{
  "functionName": "snapping",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_filter_expression', 'lyt_connect_link_2', 4, NULL, 'button', NULL, 'Filter by expression', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, NULL, '{
  "functionName": "filter_expression",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'linkcat', 'lyt_connect_link_1', 2, 'text', 'combo', 'Link catalog:', 'Link catalog', NULL, true, NULL, true, NULL, NULL, 'SELECT id, id AS idval FROM cat_link WHERE id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'max_distance', 'lyt_connect_link_1', 1, 'text', 'text', 'Maximum distance:', 'Maximum distance', '300', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'pipe_diameter', 'lyt_connect_link_1', 0, 'text', 'text', 'Pipe diameter:', 'Pipe diameter', '150', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'tbl_ids', 'lyt_connect_link_3', 0, NULL, 'tableview', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'id', 'lyt_connect_link_2', 0, 'text', 'combo', 'Gully Id:', 'Gully Id', NULL, NULL, NULL, true, NULL, NULL, 'SELECT gully_id AS id, gully_id AS idval FROM gully WHERE gully_id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);


INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '0', 'NOT INFORMED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '1', 'RAINWATER', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '2', 'DILUTED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '3', 'FECAL', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '4', 'UNITARY', NULL, NULL);

UPDATE config_form_fields
SET	dv_querytext = 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''',
widgettype = 'combo'
WHERE columnname = 'fluid_type';

UPDATE sys_param_user
SET	dv_querytext = 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type'''
WHERE dv_querytext ILIKE '%man_type_fluid%';

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_gully_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_link_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_arc_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_connec_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_node_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'gully', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'link', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'arc', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'connec', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'node', 'fluid_type', NULL, true);


DROP TRIGGER gw_trg_typevalue_fk ON sys_table;
DELETE FROM sys_foreignkey WHERE typevalue_table = 'config_typevalue' AND typevalue_name = 'sys_table_context' AND target_table = 'sys_table' AND target_field = 'context';


INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '0', 'NOT INFORMED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '1', 'TREATED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '2', 'NOT TREATED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '3', 'PRETRESTED', NULL, NULL);

UPDATE config_form_fields
SET	dv_querytext = 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''treatment_type''',
widgettype = 'combo'
WHERE columnname = 'treatment_type';

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'gully', 'treatment_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'node', 'treatment_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'arc', 'treatment_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'connec', 'treatment_type', NULL, true);

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

    INSERT INTO utils.municipality (muni_id, name, observ, the_geom, active, region_id, province_id, ext_code)
    SELECT muni_id, name, observ, the_geom, active, region_id, province_id, ext_code FROM utils.municipality;

  ELSE

    INSERT INTO ext_municipality (muni_id, name, observ, the_geom, active, region_id, province_id, ext_code)
    SELECT muni_id, name, observ, the_geom, active, region_id, province_id, ext_code FROM _ext_municipality;

  END IF;
END; $$;

--sys_styles qml file for v_rpt_arcflow_sum

UPDATE sys_style SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.11-Prizren" styleCategories="Symbology|Symbology3D|Labeling|Legend" labelsEnabled="1">
  <renderer-v2 forceraster="0" symbollevels="0" graduatedMethod="GraduatedColor" referencescale="-1" enableorderby="0" attr="mfull_dept" type="graduatedSymbol">
    <ranges>
      <range label="&lt; 50%" upper="0.490000000000000" render="true" uuid="0" symbol="0" lower="0.000000000000000"/>
      <range label="50% - 70%" upper="0.690000000000000" render="true" uuid="1" symbol="1" lower="0.490000000000000"/>
      <range label="70% - 85%" upper="0.840000000000000" render="true" uuid="2" symbol="2" lower="0.690000000000000"/>
      <range label="85% - 100%" upper="1.000000000000000" render="true" uuid="3" symbol="3" lower="0.840000000000000"/>
    </ranges>
    <symbols>
      <symbol name="0" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleLine" id="{12dbbec5-66e6-41a6-ba96-6f9f07d628ad}" pass="0">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="53,165,45,255" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.65" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleLine" id="{b7a2be15-2ccb-4905-ab21-52177fe67849}" pass="0">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="66,181,236,255" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.65" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="2" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleLine" id="{52ee2378-098c-46a7-a535-97d0fb0beea5}" pass="0">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="250,126,39,255" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.65" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="3" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleLine" id="{4bc79f1b-1065-41a4-9946-a872d4885cae}" pass="0">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="212,26,28,255" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.65" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleLine" id="{841033f8-c4e2-4b2b-a492-768d7f280bce}" pass="0">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="238,116,122,255" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <colorramp name="[source]" type="gradient">
      <Option type="Map">
        <Option name="color1" value="247,251,255,255" type="QString"/>
        <Option name="color2" value="8,48,107,255" type="QString"/>
        <Option name="direction" value="ccw" type="QString"/>
        <Option name="discrete" value="0" type="QString"/>
        <Option name="rampType" value="gradient" type="QString"/>
        <Option name="spec" value="rgb" type="QString"/>
        <Option name="stops" value="0.13;222,235,247,255;rgb;ccw:0.26;198,219,239,255;rgb;ccw:0.39;158,202,225,255;rgb;ccw:0.52;107,174,214,255;rgb;ccw:0.65;66,146,198,255;rgb;ccw:0.78;33,113,181,255;rgb;ccw:0.9;8,81,156,255;rgb;ccw" type="QString"/>
      </Option>
    </colorramp>
    <classificationMethod id="EqualInterval">
      <symmetricMode astride="0" enabled="0" symmetrypoint="0"/>
      <labelFormat format="%1 - %2" trimtrailingzeroes="0" labelprecision="4"/>
      <parameters>
        <Option/>
      </parameters>
      <extraInformation/>
    </classificationMethod>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol name="" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="line" frame_rate="10">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleLine" id="{7b5ef12c-e372-44b6-808e-6c386ded9ce8}" pass="0">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="35,35,35,255" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style useSubstitutions="0" fontWeight="50" textColor="0,0,0,255" forcedBold="0" forcedItalic="0" textOrientation="horizontal" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontUnderline="0" fontSize="8" allowHtml="0" capitalization="0" blendMode="0" isExpression="0" fontItalic="0" fontLetterSpacing="0" multilineHeight="1" fontStrikeout="0" fontWordSpacing="0" legendString="Aa" fieldName="arccat_id" fontFamily="Arial" namedStyle="Normal" fontSizeUnit="Point" textOpacity="1" previewBkgrdColor="255,255,255,255" multilineHeightUnit="Percentage" fontKerning="1">
        <families/>
        <text-buffer bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSizeUnits="MM" bufferColor="255,255,255,255" bufferSize="1" bufferNoFill="0" bufferDraw="0" bufferBlendMode="0" bufferJoinStyle="64" bufferOpacity="1"/>
        <text-mask maskedSymbolLayers="" maskSizeUnits="MM" maskSize="1.5" maskJoinStyle="128" maskEnabled="0" maskType="0" maskSize2="1.5" maskOpacity="1" maskSizeMapUnitScale="3x:0,0,0,0,0,0"/>
        <background shapeSizeUnit="MM" shapeBorderWidthUnit="MM" shapeJoinStyle="64" shapeBlendMode="0" shapeRotation="0" shapeType="0" shapeRotationType="0" shapeBorderColor="128,128,128,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetUnit="MM" shapeOffsetY="0" shapeSizeY="0" shapeSVGFile="" shapeFillColor="255,255,255,255" shapeRadiiY="0" shapeSizeType="0" shapeRadiiUnit="MM" shapeDraw="0" shapeOffsetX="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeSizeX="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOpacity="1" shapeBorderWidth="0">
          <symbol name="markerSymbol" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="marker" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" class="SimpleMarker" id="" pass="0">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="196,60,57,255" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="2" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol name="fillSymbol" is_animated="0" clip_to_extent="1" alpha="1" force_rhr="0" type="fill" frame_rate="10">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" class="SimpleFill" id="" pass="0">
              <Option type="Map">
                <Option name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="color" value="255,255,255,255" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="128,128,128,255" type="QString"/>
                <Option name="outline_style" value="no" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="style" value="solid" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowOpacity="0.69999999999999996" shadowRadiusAlphaOnly="0" shadowBlendMode="6" shadowOffsetAngle="135" shadowOffsetGlobal="1" shadowColor="0,0,0,255" shadowUnder="0" shadowRadius="1.5" shadowDraw="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetDist="1" shadowScale="100" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusUnit="MM"/>
        <dd_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format leftDirectionSymbol="&lt;" multilineAlign="0" autoWrapLength="0" useMaxLineLengthForAutoWrap="1" plussign="0" decimals="3" rightDirectionSymbol=">" placeDirectionSymbol="0" addDirectionSymbol="0" wrapChar="" formatNumbers="0" reverseDirectionSymbol="0"/>
      <placement overrunDistance="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" layerType="LineGeometry" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" fitInPolygonOnly="0" maxCurvedCharAngleIn="20" yOffset="0" geometryGenerator="" polygonPlacementFlags="2" quadOffset="4" centroidWhole="0" placementFlags="10" maxCurvedCharAngleOut="-20" distUnits="MM" lineAnchorPercent="0.5" overrunDistanceUnit="MM" lineAnchorClipping="0" geometryGeneratorType="PointGeometry" lineAnchorTextPoint="CenterOfText" lineAnchorType="0" centroidInside="0" offsetType="0" priority="5" preserveRotation="1" allowDegraded="0" repeatDistance="0" dist="0" rotationAngle="0" placement="2" rotationUnit="AngleDegrees" xOffset="0" geometryGeneratorEnabled="0" distMapUnitScale="3x:0,0,0,0,0,0" overlapHandling="PreventOverlap" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" offsetUnits="MapUnit" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" repeatDistanceUnits="MM"/>
      <rendering fontLimitPixelSize="0" mergeLines="0" upsidedownLabels="0" obstacle="1" zIndex="0" obstacleType="0" scaleMax="3000" fontMaxPixelSize="10000" obstacleFactor="1" unplacedVisibility="0" maxNumLabels="2000" labelPerPart="0" scaleMin="1" limitNumLabels="0" scaleVisibility="1" fontMinPixelSize="3" drawLabels="1" minFeatureSize="0"/>
      <dd_properties>
        <Option type="Map">
          <Option name="name" value="" type="QString"/>
          <Option name="properties"/>
          <Option name="type" value="collection" type="QString"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option name="anchorPoint" value="pole_of_inaccessibility" type="QString"/>
          <Option name="blendMode" value="0" type="int"/>
          <Option name="ddProperties" type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
          <Option name="drawToAllParts" value="false" type="bool"/>
          <Option name="enabled" value="0" type="QString"/>
          <Option name="labelAnchorPoint" value="point_on_exterior" type="QString"/>
          <Option name="lineSymbol" value="&lt;symbol name=&quot;symbol&quot; is_animated=&quot;0&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; force_rhr=&quot;0&quot; type=&quot;line&quot; frame_rate=&quot;10&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;name&quot; value=&quot;&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option name=&quot;type&quot; value=&quot;collection&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; id=&quot;{e2e73dbb-bfcf-457b-8501-e974a735ee6d}&quot; pass=&quot;0&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;align_dash_pattern&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;capstyle&quot; value=&quot;square&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;customdash&quot; value=&quot;5;2&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;customdash_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;customdash_unit&quot; value=&quot;MM&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;dash_pattern_offset&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;dash_pattern_offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;dash_pattern_offset_unit&quot; value=&quot;MM&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;draw_inside_polygon&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;joinstyle&quot; value=&quot;bevel&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;line_color&quot; value=&quot;60,60,60,255&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;line_style&quot; value=&quot;solid&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;line_width&quot; value=&quot;0.3&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;line_width_unit&quot; value=&quot;MM&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;offset&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;offset_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;offset_unit&quot; value=&quot;MM&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;ring_filter&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;trim_distance_end&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;trim_distance_end_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;trim_distance_end_unit&quot; value=&quot;MM&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;trim_distance_start&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;trim_distance_start_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;trim_distance_start_unit&quot; value=&quot;MM&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;tweak_dash_pattern_on_corners&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;use_custom_dash&quot; value=&quot;0&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;width_map_unit_scale&quot; value=&quot;3x:0,0,0,0,0,0&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;name&quot; value=&quot;&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option name=&quot;type&quot; value=&quot;collection&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" type="QString"/>
          <Option name="minLength" value="0" type="double"/>
          <Option name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
          <Option name="minLengthUnit" value="MM" type="QString"/>
          <Option name="offsetFromAnchor" value="0" type="double"/>
          <Option name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
          <Option name="offsetFromAnchorUnit" value="MM" type="QString"/>
          <Option name="offsetFromLabel" value="0" type="double"/>
          <Option name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
          <Option name="offsetFromLabelUnit" value="MM" type="QString"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <legend showLabelLegend="0" type="default-vector"/>
  <layerGeometryType>1</layerGeometryType>
</qgis>
', active=true WHERE layername='v_rpt_arcflow_sum' AND styleconfig_id=101;

-- Recreate the constraints that were previously deleted
ALTER TABLE arc ADD CONSTRAINT arc_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node ADD CONSTRAINT node_nodecat_id_fkey FOREIGN KEY (nodecat_id) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT connec_conneccat_id_fkey FOREIGN KEY (conneccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_connec_arccat_id_fkey FOREIGN KEY (_connec_arccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT gully_gratecat2_id_fkey FOREIGN KEY (_gratecat2_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_gullycat_id_fkey FOREIGN KEY (gullycat_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gullycat2_id_fkey FOREIGN KEY (gullycat2_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gullycat_id_fkey FOREIGN KEY (gullycat_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE doc_x_gully ADD CONSTRAINT doc_x_gully_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;




SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"node", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"connec", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"gully", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"element", "column":"buildercat_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"buildercat_id"}}$$);

DROP TABLE cat_builder;



ALTER TABLE inp_dwf_pol_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_manhole ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_manhole ADD CONSTRAINT man_manhole_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_wwtp ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_wwtp ADD CONSTRAINT man_wwtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_visit_event_update_xy ON om_visit_event;
ALTER TABLE om_visit_event ALTER COLUMN position_id TYPE integer USING position_id::integer;
ALTER TABLE om_visit_event ADD CONSTRAINT om_visit_event_position_id_fkey FOREIGN KEY (position_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_inflows_poll ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_inflows_poll ADD CONSTRAINT inp_inflows_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netgully ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_netgully ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_netgully ADD CONSTRAINT inp_netgully_gully_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_outfall DROP CONSTRAINT inp_dscenario_outfall_node_id_fkey;
ALTER TABLE inp_outfall ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_outfall ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_outfall ADD CONSTRAINT inp_dscenario_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_outfall(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_chamber ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_chamber ADD CONSTRAINT man_chamber_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE node_border_sector ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE node_border_sector ADD CONSTRAINT arc_border_expl_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_divider ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netelement ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_netelement ADD CONSTRAINT man_netelement_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_groundwater ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_groundwater ADD CONSTRAINT inp_groundwater_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_wjump ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_wjump ADD CONSTRAINT man_wjump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_inflows_poll ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_inflows_poll ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_storage ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_storage ADD CONSTRAINT man_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netinit ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_netinit ADD CONSTRAINT man_netinit_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE om_visit_x_node ADD CONSTRAINT om_visit_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_valve ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_valve ADD CONSTRAINT man_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_junction ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_junction ADD CONSTRAINT man_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_inflows ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_inflows ADD CONSTRAINT inp_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_storage DROP CONSTRAINT inp_dscenario_storage_node_id_fkey;
ALTER TABLE inp_storage ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_storage ADD CONSTRAINT inp_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_storage ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_storage ADD CONSTRAINT inp_dscenario_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_storage(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_rdii ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_rdii ADD CONSTRAINT inp_rdii_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dwf ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_outfall ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_outfall ADD CONSTRAINT man_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_junction DROP CONSTRAINT inp_dscenario_junction_node_id_fkey;
ALTER TABLE inp_junction ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_junction ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_junction(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_inflows ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_inflows ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_node ON plan_psector_x_node;
ALTER TABLE plan_psector_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE plan_psector_x_node ADD CONSTRAINT plan_psector_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_treatment DROP CONSTRAINT inp_treatment_node_id_fkey;
ALTER TABLE inp_treatment ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_treatment ADD CONSTRAINT inp_treatment_node_x_pol_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_treatment ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_treatment ADD CONSTRAINT inp_dscenario_treatment_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_treatment(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE connec ADD CONSTRAINT connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT inp_dscenario_conduit_arc_id_fkey;
ALTER TABLE inp_conduit ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_conduit ADD CONSTRAINT inp_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_conduit ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_conduit(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_divider ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_orifice ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_orifice ADD CONSTRAINT inp_orifice_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_outlet ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_outlet ADD CONSTRAINT inp_outlet_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_pump ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_weir ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_weir ADD CONSTRAINT inp_weir_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_conduit ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_conduit ADD CONSTRAINT man_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_siphon ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_siphon ADD CONSTRAINT man_siphon_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_varc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_varc ADD CONSTRAINT man_varc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_waccel ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_waccel ADD CONSTRAINT man_waccel_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE om_visit_x_arc ADD CONSTRAINT om_visit_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_arc_x_pavement ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_arc_x_pavement ADD CONSTRAINT plan_arc_x_pavement_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_arc ON plan_psector_x_arc;
ALTER TABLE plan_psector_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_psector_x_arc ADD CONSTRAINT plan_psector_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_link ON plan_psector_x_connec;
ALTER TABLE plan_psector_x_connec ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_link ON plan_psector_x_gully;
ALTER TABLE plan_psector_x_gully ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE om_visit_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE om_visit_x_connec ADD CONSTRAINT om_visit_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_connec ON plan_psector_x_connec;
ALTER TABLE plan_psector_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE element_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE inp_gully ADD CONSTRAINT inp_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_gully ON plan_psector_x_gully;
ALTER TABLE plan_psector_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE om_visit_x_gully ADD CONSTRAINT om_visit_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE doc_x_gully ADD CONSTRAINT doc_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE element_x_gully ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element_x_connec ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_node ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_link ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit_x_link ADD CONSTRAINT om_visit_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_link ADD CONSTRAINT doc_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE RULE omzone_conflict AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = '-1'::integer) OR (old.omzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE omzone_del_conflict AS
    ON DELETE TO omzone
   WHERE (old.omzone_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE omzone_del_undefined AS
    ON DELETE TO omzone
   WHERE (old.omzone_id = 0) DO INSTEAD NOTHING;

CREATE RULE omzone_undefined AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = 0) OR (old.omzone_id = 0)) DO INSTEAD NOTHING;

CREATE RULE sector_conflict AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = '-1'::integer) OR (old.sector_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE sector_del_conflict AS
    ON DELETE TO sector
   WHERE (old.sector_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE sector_del_undefined AS
    ON DELETE TO sector
   WHERE (old.sector_id = 0) DO INSTEAD NOTHING;

CREATE RULE sector_undefined AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = 0) OR (old.sector_id = 0)) DO INSTEAD NOTHING;

CREATE RULE macroomzone_del_undefined AS
    ON DELETE TO macroomzone
   WHERE (old.macroomzone_id = 0) DO INSTEAD NOTHING;

CREATE RULE macroomzone_undefined AS
    ON UPDATE TO macroomzone
   WHERE ((new.macroomzone_id = 0) OR (old.macroomzone_id = 0)) DO INSTEAD NOTHING;

CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;

CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;


CREATE RULE macrosector_del_undefined AS
    ON DELETE TO macrosector
   WHERE (old.macrosector_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrosector_undefined AS
    ON UPDATE TO macrosector
   WHERE ((new.macrosector_id = 0) OR (old.macrosector_id = 0)) DO INSTEAD NOTHING;

CREATE RULE exploitation_del_undefined AS
    ON DELETE TO exploitation
   WHERE (old.expl_id = 0) DO INSTEAD NOTHING;

CREATE RULE exploitation_undefined AS
    ON UPDATE TO exploitation
   WHERE ((new.expl_id = 0) OR (old.expl_id = 0)) DO INSTEAD NOTHING;


ALTER TABLE cat_dscenario ADD CONSTRAINT cat_dscenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE cat_dwf ADD CONSTRAINT cat_dwf_scenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE cat_hydrology ADD CONSTRAINT cat_hydrology_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE dimensions ADD CONSTRAINT dimensions_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_curve ADD CONSTRAINT inp_curve_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_pattern ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_timeseries ADD CONSTRAINT inp_timeseries_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE raingage ADD CONSTRAINT raingage_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE selector_expl ADD CONSTRAINT selector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE link ADD CONSTRAINT link_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_verified_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE node ADD CONSTRAINT node_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE inp_controls ADD CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_controls ADD CONSTRAINT inp_dscenario_controls_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE selector_sector ADD CONSTRAINT inp_selector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE node_border_sector ADD CONSTRAINT node_border_expl_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_subcatchment ADD CONSTRAINT subcatchment_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE dimensions ADD CONSTRAINT dimensions_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE node ADD CONSTRAINT node_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE link ADD CONSTRAINT link_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;


CREATE RULE insert_plan_psector_x_arc AS
    ON INSERT TO arc
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable)
  VALUES (new.arc_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_current'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);

CREATE RULE insert_plan_psector_x_node AS
    ON INSERT TO node
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
  VALUES (new.node_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_current'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);

ALTER TABLE polygon ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE plan_rec_result_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE plan_rec_result_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_rec_result_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE plan_rec_result_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;

ALTER TABLE anl_arc_x_node ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE archived_psector_arc_traceability ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE archived_psector_connec_traceability ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE archived_psector_gully_traceability ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE archived_psector_node_traceability ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE archived_rpt_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE archived_rpt_inp_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN arc_id1 TYPE integer USING arc_id1::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN arc_id2 TYPE integer USING arc_id2::integer;
ALTER TABLE ext_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_virtual ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_reh_result_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE review_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE review_audit_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE temp_anlgraph ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE temp_arc_flowregulator ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE temp_go2epa ALTER COLUMN arc_id TYPE integer USING arc_id::integer;



ALTER TABLE archived_psector_node_traceability ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE archived_rpt_inp_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE archived_rpt_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE ext_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE ext_rtc_scada_x_data ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE plan_reh_result_node ALTER COLUMN node_id TYPE integer USING node_id::integer;

ALTER TABLE archived_psector_connec_traceability ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE review_audit_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE review_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE rtc_hydrometer_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;

ALTER TABLE archived_psector_gully_traceability ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE review_audit_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE review_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;

ALTER TABLE archived_psector_link_traceability ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE audit_log_data ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE dimensions ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE samplepoint ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE temp_data ALTER COLUMN feature_id TYPE integer USING feature_id::integer;

ALTER TABLE archived_psector_connec_traceability ALTER COLUMN pjoint_id TYPE integer USING pjoint_id::integer;
ALTER TABLE archived_psector_gully_traceability ALTER COLUMN pjoint_id TYPE integer USING pjoint_id::integer;
ALTER TABLE archived_psector_link_traceability ALTER COLUMN exit_id TYPE integer USING exit_id::integer;



ALTER TABLE archived_psector_arc_traceability ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE archived_psector_arc_traceability ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE archived_rpt_inp_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE archived_rpt_inp_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE plan_reh_result_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE plan_reh_result_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE rpt_summary_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE rpt_summary_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE temp_anlgraph ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE temp_anlgraph ALTER COLUMN node_2 TYPE integer USING node_2::integer;

ALTER TABLE inp_virtual ALTER COLUMN fusion_node TYPE integer USING fusion_node::integer;

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

     IF v_utils THEN
        ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE node ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;

    ELSE
        ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE node ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE ext_streetaxis ADD CONSTRAINT ext_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE ext_address ADD CONSTRAINT ext_address_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE ext_plot ADD CONSTRAINT ext_plot_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    END IF;
END $$;

DO $$
DECLARE
    v_rec RECORD;
    v_table_name text;
    v_feature_name text;
BEGIN
    FOR v_rec IN
        SELECT DISTINCT cf.id, cf.feature_type
        FROM sys_addfields sa
        JOIN cat_feature cf ON cf.id = sa.cat_feature_id
    LOOP
        v_feature_name := lower(v_rec.feature_type) || '_id';
        v_table_name := 'man_' || lower(v_rec.feature_type) || '_' || lower(v_rec.id);

        EXECUTE 'ALTER TABLE ' || v_table_name || ' ALTER COLUMN ' || v_feature_name || ' TYPE int4 USING ' || v_feature_name || '::int4';
        EXECUTE 'ALTER TABLE ' || v_table_name || ' ADD CONSTRAINT ' || v_table_name || '_' || v_feature_name || '_fkey FOREIGN KEY (' || v_feature_name || ') REFERENCES ' || v_rec.feature_type || '(' || v_feature_name || ') ON DELETE CASCADE';
    END LOOP;
END $$;

-- Recreate foreign keys for muni_id
DO $$
DECLARE
    v_utils boolean;
BEGIN
    SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

    IF v_utils THEN

        -- Index
        CREATE INDEX idx_municipality_name ON utils.municipality USING btree (name);
        CREATE INDEX idx_municipality_the_geom ON utils.municipality USING gist(the_geom);
        
        -- utils.municipality
        ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id);

        ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id)
        REFERENCES utils.municipality(muni_id);

        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id FOREIGN KEY (muni_id)
        REFERENCES utils.municipality(muni_id);

        -- No utils.municipality BEFORE
        ALTER TABLE ONLY ext_address ADD CONSTRAINT ext_address_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_district ADD CONSTRAINT ext_district_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_plot ADD CONSTRAINT ext_plot_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_streetaxis ADD CONSTRAINT ext_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY samplepoint ADD CONSTRAINT samplepoint_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    ELSE 

        -- Index
        CREATE INDEX idx_ext_municipality_name ON ext_municipality USING btree (name);
        CREATE INDEX idx_ext_municipality_the_geom ON ext_municipality USING gist(the_geom);

        -- ext_municipality
        ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id);

        ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id)
        REFERENCES ext_municipality(muni_id);

        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id FOREIGN KEY (muni_id)
        REFERENCES ext_municipality(muni_id);

        -- No utils.municipality
        ALTER TABLE ONLY ext_address ADD CONSTRAINT ext_address_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_district ADD CONSTRAINT ext_district_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_plot ADD CONSTRAINT ext_plot_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_streetaxis ADD CONSTRAINT ext_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY samplepoint ADD CONSTRAINT samplepoint_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    END IF;
END $$;

-- MAPZONES
CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('omzone_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF omzone_type ON omzone
FOR EACH ROW WHEN (((old.omzone_type)::TEXT IS DISTINCT FROM (new.omzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('drainzone_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('drainzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF drainzone_type ON drainzone
FOR EACH ROW WHEN (((old.drainzone_type)::TEXT IS DISTINCT FROM (new.drainzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('drainzone');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('sector_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('sector');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF sector_type ON sector
FOR EACH ROW WHEN (((old.sector_type)::TEXT IS DISTINCT FROM (new.sector_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('sector');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macroomzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macroomzone_id');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrosector_id');

DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_frweir;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_frorifice;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_froutlet;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON inp_frpump;

CREATE TRIGGER gw_trg_visit_event_update_xy AFTER INSERT OR UPDATE OF position_id, position_value ON om_visit_event
FOR EACH ROW EXECUTE FUNCTION gw_trg_visit_event_update_xy();

CREATE TRIGGER gw_trg_plan_psector_x_node BEFORE
INSERT
    OR
UPDATE
    OF node_id,
    state ON
    plan_psector_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_node();


-- Create fk for arrays thorught triggers:
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "utils.municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'utils.municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "utils.municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "utils.municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON utils.municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    ELSE

        -- Expl_id 
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"macroomzone":"expl_id", "dwfzone":"expl_id", "drainzone":"expl_id", "sector":"expl_id", "ext_municipality":"expl_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON macroomzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

        -- Muni_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dwfzone":"muni_id", "drainzone":"muni_id", "exploitation":"muni_id", "sector":"muni_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_muni AFTER INSERT OR UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

        -- Sector_id
        CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "ext_municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dwfzone":"sector_id", "drainzone":"sector_id", "exploitation":"sector_id", "ext_municipality":"sector_id"}');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON dwfzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON drainzone
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON exploitation
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

        CREATE TRIGGER gw_trg_fk_array_array_table_sector AFTER INSERT OR UPDATE ON ext_municipality
        FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');

    END IF;
END; $$;
