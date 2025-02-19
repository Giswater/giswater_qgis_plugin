/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 11/10/2024
ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

ALTER TABLE cat_feature_gully DROP CONSTRAINT IF EXISTS cat_feature_gully_type_fkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_feature_gully", "column":"type", "newName":"_type"}}$$);


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

ALTER TABLE _cat_grate DROP CONSTRAINT IF EXISTS cat_grate_pkey;
ALTER TABLE _cat_grate DROP CONSTRAINT IF EXISTS cat_grate_brand_fkey;
ALTER TABLE _cat_grate DROP CONSTRAINT IF EXISTS cat_grate_gully_type_fkey;
ALTER TABLE _cat_grate DROP CONSTRAINT IF EXISTS cat_grate_matcat_id_fkey;
ALTER TABLE _cat_grate DROP CONSTRAINT IF EXISTS cat_grate_model_fkey;

CREATE TABLE cat_gully (
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
	brand_id varchar(30) NULL,
	model_id varchar(30) NULL,
	svg varchar(50) NULL,
	active bool DEFAULT true NULL,
	"label" varchar(255) NULL,
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

-- 29/11/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"macrominsector_id", "dataType":"integer"}}$$);
ALTER TABLE node ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE arc ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE connec ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE link ALTER COLUMN macrominsector_id SET DEFAULT 0;
ALTER TABLE gully ALTER COLUMN macrominsector_id SET DEFAULT 0;
-- 02/12/2024
DROP VIEW IF EXISTS ve_epa_orifice;
DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_flwreg_orifice;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_orifice", "column":"close_time"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_flwreg_orifice", "column":"close_time"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"inp_dscenario_flwreg_orifice", "column":"close_time"}}$$);

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

--10/01/2025
--28/01/2025 [Modified]
-- Add flwreg as system type
ALTER TABLE sys_feature_type DROP CONSTRAINT sys_feature_type_check;
INSERT INTO sys_feature_type VALUES ('FLWREG', 5);
ALTER TABLE sys_feature_type ADD CONSTRAINT sys_feature_type_check CHECK (((id)::text =ANY (ARRAY['ARC'::text, 'CONNEC'::text, 'ELEMENT'::text,
'GULLY'::text, 'LINK'::text, 'NODE'::text, 'VNODE'::text, 'FLWREG'::text])));

-- Add flwregulators childs as feature_class
ALTER TABLE sys_feature_class DROP CONSTRAINT sys_feature_cat_check;

INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('ORIFICE', 'FLWREG', 'ORIFICE', 'man_orifice') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('VFLWREG', 'FLWREG', 'OUTLET', 'man_vflwreg') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('WEIR', 'FLWREG', 'WEIR', 'man_weir') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('PUMP', 'FLWREG', 'PUMP', 'man_pump') ON CONFLICT (id) DO NOTHING;

ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK (((id)::text = ANY (ARRAY['CHAMBER'::text, 'CONDUIT'::text, 'CONNEC'::text, 'GULLY'::text,
'JUNCTION'::text, 'MANHOLE'::text, 'NETELEMENT'::text, 'NETGULLY'::text, 'NETINIT'::text, 'OUTFALL'::text, 'SIPHON'::text, 'STORAGE'::text, 'VALVE'::text,
'VARC'::text, 'WACCEL'::text, 'WJUMP'::text, 'WWTP'::text, 'ELEMENT'::text, 'LINK'::text, 'ORIFICE'::text, 'VFLWREG'::text, 'WEIR'::text, 'PUMP'::text])));

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
	node_id varchar(16) NOT NULL,
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
	dma_id int4 NULL,
	y0 numeric(12, 4) NULL,
	ysur numeric(12, 4) NULL,
	apond numeric(12, 4) NULL,
	the_geom public.geometry(point, SRID_VALUE) NULL,
	expl_id int4 NULL,
	addparam text NULL,
	parent varchar(16) NULL,
	arcposition int2 NULL,
	fusioned_node text NULL,
	age int4 NULL,
	CONSTRAINT temp_node_node_id_unique UNIQUE (node_id),
	CONSTRAINT temp_node_pkey PRIMARY KEY (id)
);
CREATE INDEX temp_node_epa_type ON temp_node USING btree (epa_type);
CREATE INDEX temp_node_index ON temp_node USING gist (the_geom);
CREATE INDEX temp_node_node_id ON temp_node USING btree (node_id);
CREATE INDEX temp_node_node_type ON temp_node USING btree (node_type);
CREATE INDEX temp_node_nodeparent ON temp_node USING btree (parent);
CREATE INDEX temp_node_result_id ON temp_node USING btree (result_id);
CREATE INDEX temp_node_dma_id ON temp_node USING btree (dma_id);

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
	arc_id varchar(16) NOT NULL,
	node_1 varchar(16) NULL,
	node_2 varchar(16) NULL,
	elevmax1 numeric(12, 3) NULL,
	elevmax2 numeric(12, 3) NULL,
	arc_type varchar(30) NULL,
	arccat_id varchar(30) NULL,
	epa_type varchar(16) NULL,
	sector_id int4 NULL,
	state int2 NULL,
	state_type int2 NULL,
	annotation varchar(254) NULL,
	dma_id int4 NULL,
	length numeric(12, 3) NULL,
	n numeric(12, 3) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
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
	CONSTRAINT temp_arc_pkey PRIMARY KEY (id)
);
CREATE INDEX temp_arc_arc_id ON temp_arc USING btree (arc_id);
CREATE INDEX temp_arc_arc_type ON temp_arc USING btree (arc_type);
CREATE INDEX temp_arc_epa_type ON temp_arc USING btree (epa_type);
CREATE INDEX temp_arc_index ON temp_arc USING gist (the_geom);
CREATE INDEX temp_arc_node_1_type ON temp_arc USING btree (node_1);
CREATE INDEX temp_arc_node_2_type ON temp_arc USING btree (node_2);
CREATE INDEX temp_arc_dma_id ON temp_arc USING btree (dma_id);
CREATE INDEX temp_arc_result_id ON temp_arc USING btree (result_id);

-- 29/01/2025
-- Add table for cat_feature_flwreg
CREATE TABLE cat_feature_flwreg (
	id varchar(30) NOT NULL,
	epa_default varchar(30) NOT NULL,
	CONSTRAINT cat_feature_flwreg_pkey PRIMARY KEY (id),
	CONSTRAINT cat_feature_flwreg_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_feature_flwreg_inp_check CHECK (((epa_default)::text = ANY (ARRAY['WEIR'::text, 'ORIFICE'::text, 'PUMP'::text, 'OUTLET'::text, 'UNDEFINED'::text])))
);

CREATE TABLE cat_flwreg (
	id varchar(30) NOT NULL,
	flwreg_type text NULL,
	matcat_id varchar(16) NULL,
	descript varchar(255) NULL,
	link varchar(512) NULL,
	brand_id varchar(30) NULL,
	model_id varchar(30) NULL,
	cost_unit varchar(3) DEFAULT 'u'::character varying NULL,
	"cost" varchar(16) NULL,
	active bool DEFAULT true NULL,
	CONSTRAINT cat_flwreg_pkey PRIMARY KEY (id),
	CONSTRAINT cat_flwreg_brand_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_flwreg_cost_fkey FOREIGN KEY ("cost") REFERENCES plan_price(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_flwreg_model_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_flwreg_flwreg_type_fkey FOREIGN KEY (flwreg_type) REFERENCES cat_feature_flwreg(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT cat_flwreg_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_material(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--create parent table for flow regulators
CREATE TABLE flwreg (
	flwreg_id varchar(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	node_id varchar(16) NOT NULL,
	order_id int2 NOT NULL,
	to_arc varchar(16) NOT NULL,
	nodarc_id character varying(20),
	flwregcat_id varchar(18) NOT NULL,
	flwreg_length float8 NOT NULL,
	epa_type varchar(16) NOT NULL,  --(ORIFICE / WEIR / OUTLET / PUMP)
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	annotation text NULL,
	observ text NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NOT NULL,
	CONSTRAINT flwreg_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['WEIR'::text, 'ORIFICE'::text, 'PUMP'::text, 'OUTLET'::text, 'UNDEFINED'::text]))),
	CONSTRAINT flwreg_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT flwregcat_id_fkey FOREIGN KEY (flwregcat_id) REFERENCES cat_flwreg(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT flwreg_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT flwreg_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT flwreg_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT flwreg_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON DELETE RESTRICT ON UPDATE CASCADE

);

CREATE INDEX flwreg_node_id ON flwreg USING btree (node_id);
CREATE INDEX flwreg_flwregcat_id ON flwreg USING btree (flwregcat_id);


CREATE TABLE _inp_flwreg_pump AS SELECT * FROM inp_flwreg_pump;
CREATE TABLE _inp_flwreg_outlet AS SELECT * FROM inp_flwreg_outlet;
CREATE TABLE _inp_flwreg_orifice AS SELECT * FROM inp_flwreg_orifice;
CREATE TABLE _inp_flwreg_weir AS SELECT * FROM inp_flwreg_weir;

DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_outlet;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_weir;

DROP VIEW IF EXISTS v_edit_inp_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_flwreg_outlet;
DROP VIEW IF EXISTS v_edit_inp_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_flwreg_weir;

ALTER TABLE inp_dscenario_flwreg_pump DROP CONSTRAINT inp_dscenario_flwreg_pump_nodarc_id_fkey;
ALTER TABLE inp_dscenario_flwreg_outlet DROP CONSTRAINT inp_dscenario_flwreg_outlet_nodarc_id_fkey;
ALTER TABLE inp_dscenario_flwreg_orifice DROP CONSTRAINT inp_dscenario_flwreg_orifice_nodarc_id_fkey;
ALTER TABLE inp_dscenario_flwreg_weir DROP CONSTRAINT inp_dscenario_flwreg_weir_nodarc_id_fkey;

DROP TABLE IF EXISTS inp_flwreg_pump;
DROP TABLE IF EXISTS inp_flwreg_outlet;
DROP TABLE IF EXISTS inp_flwreg_orifice;
DROP TABLE IF EXISTS inp_flwreg_weir;

CREATE TABLE inp_flwreg_outlet (
	flwreg_id varchar(16) NOT NULL,
    outlet_type character varying(16) NOT NULL,
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
	CONSTRAINT inp_flwreg_outlet_pkey PRIMARY KEY (flwreg_id),
    CONSTRAINT inp_flwreg_outlet_check_outlet_type CHECK (((outlet_type)::text = ANY ((ARRAY['FUNCTIONAL/DEPTH'::character varying, 'FUNCTIONAL/HEAD'::character varying, 'TABULAR/DEPTH'::character varying, 'TABULAR/HEAD'::character varying])::text[])))
);

CREATE TABLE inp_flwreg_orifice (
	flwreg_id varchar(16) NOT NULL,
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
	CONSTRAINT inp_flwreg_orifice_check_ory_type CHECK (((orifice_type)::text = ANY (ARRAY[('SIDE'::character varying)::text, ('BOTTOM'::character varying)::text]))),
	CONSTRAINT inp_flwreg_orifice_check_shape CHECK (((shape)::text = ANY (ARRAY[('CIRCULAR'::character varying)::text, ('RECT_CLOSED'::character varying)::text]))),
	CONSTRAINT inp_flwreg_orifice_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT inp_flwreg_orifice_flwreg_id_fkey FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_flwreg_pump (
	flwreg_id varchar(16) NOT NULL,
	pump_type varchar(18) NOT NULL,
	curve_id varchar(16) NOT NULL,
	status varchar(3) NULL,
	startup numeric(12, 4) NULL,
	shutoff numeric(12, 4) NULL,
	CONSTRAINT inp_flwreg_pump_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT inp_flwreg_pump_check_status CHECK (((status)::text = ANY (ARRAY[('ON'::character varying)::text, ('OFF'::character varying)::text]))),
	CONSTRAINT inp_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_flwreg_pump_flwreg_id_fkey FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_flwreg_weir (
	flwreg_id varchar(16) NOT NULL,
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
	CONSTRAINT inp_flwreg_weir_check_type CHECK (((weir_type)::text = ANY (ARRAY['ROADWAY'::text, 'SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL_WEIR'::text]))),
	CONSTRAINT inp_flwreg_weir_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT inp_flwreg_weir_flwreg_id_fkey FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS _inp_flwreg_pump;
DROP TABLE IF EXISTS _inp_flwreg_outlet;
DROP TABLE IF EXISTS _inp_flwreg_orifice;
DROP TABLE IF EXISTS _inp_flwreg_weir;


-- Create man table for flow regulators
CREATE TABLE man_pump (
	flwreg_id varchar(16) NOT NULL,
	pump_class varchar(16) NOT NULL,
	CONSTRAINT man_frpump_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT man_frpump_flwreg_id_fk FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE
);

CREATE TABLE man_weir(
	flwreg_id varchar(16) NOT NULL,
	weir_class varchar(16) NOT NULL,
	CONSTRAINT man_frweir_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT man_frweir_flwreg_id_fk FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE
);

CREATE TABLE man_vflwreg (
	flwreg_id varchar(16) NOT NULL,
	outlet_class varchar(16) NOT NULL,
	CONSTRAINT outlet_type_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT outlet_type_flwreg_id_fk FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE
);

CREATE TABLE man_orifice (
	flwreg_id varchar(16) NOT NULL,
	orifice_class varchar(16) NOT NULL,
	CONSTRAINT man_frorifice_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT man_frorifice_flwreg_id_fk FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE
);

-- 30/01/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"gully", "column":"verified", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"samplepoint", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"element", "column":"verified", "dataType":"integer"}}$$);

ALTER TABLE man_manhole RENAME TO _man_manhole;
ALTER TABLE _man_manhole DROP CONSTRAINT IF EXISTS man_manhole_pkey;
ALTER TABLE _man_manhole DROP CONSTRAINT IF EXISTS man_manhole_node_id_fkey;

CREATE TABLE man_manhole (
	node_id varchar(16) NOT NULL,
	length numeric(12, 3) DEFAULT 0 NULL,
	width numeric(12, 3) DEFAULT 0 NULL,
	sander_depth numeric(12, 3) NULL,
	prot_surface bool NULL,
	inlet bool NULL,
	bottom_channel bool NULL,
	accessibility varchar(16) NULL,
	bottom_mat text NULL,
	height numeric(12,4),
	CONSTRAINT man_manhole_pkey PRIMARY KEY (node_id),
	CONSTRAINT man_manhole_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE
);


ALTER TABLE review_node RENAME TO _review_node;
ALTER TABLE _review_node DROP CONSTRAINT IF EXISTS review_node_pkey;

CREATE TABLE review_node (
	node_id varchar(16) NOT NULL,
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
	node_id varchar(16) NOT NULL,
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

CREATE SEQUENCE IF NOT EXISTS dwfzone_dwfzone_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE dwfzone (
	dwfzone_id serial4 NOT NULL,
	"name" varchar(30) NULL,
	expl_id int4 NULL,
	descript text NULL,
	undelete bool NULL,
	the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	link text NULL,
	graphconfig json DEFAULT '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json NULL,
	stylesheet json NULL,
	active bool DEFAULT true NULL,
	tstamp timestamp DEFAULT now() NULL,
	insert_user varchar(50) DEFAULT CURRENT_USER NULL,
	lastupdate timestamp NULL,
	lastupdate_user varchar(50) NULL,
	dwfzone_type varchar(16) NULL,
	CONSTRAINT dwfzone_pkey PRIMARY KEY (dwfzone_id)
);

-- 31/01/2025

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"sector", "column":"sector_type", "dataType":"varchar(50)"}}$$);

-- 04/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE arc ADD CONSTRAINT arc_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE node ADD CONSTRAINT node_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE connec ADD CONSTRAINT connec_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE gully ADD CONSTRAINT gully_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE link ADD CONSTRAINT link_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- 06/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"datasource", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"datasource", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"datasource", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"datasource", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"datasource", "dataType":"integer"}}$$);

-- 10/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"initoverflowpath", "dataType":"boolean"}}$$);

-- TODO: add logic to calculate this field
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"omunit_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"omunit_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"omunit_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"omunit_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"omunit_id", "dataType":"int4"}}$$);

CREATE TABLE arc_add (
	arc_id varchar(16) NOT NULL,
	result_id text NULL,
	max_flow numeric(12, 2) NULL,
	max_veloc numeric(12, 2) NULL,
	mfull_flow numeric(12, 2) NULL,
	mfull_depth numeric(12, 2) NULL,
	CONSTRAINT arc_add_pkey PRIMARY KEY (arc_id)
);

CREATE TABLE node_add (
	node_id varchar(16) NOT NULL,
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

-- 17/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
