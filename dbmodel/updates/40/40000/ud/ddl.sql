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
ALTER TABLE sys_feature_type ADD CONSTRAINT sys_feature_type_check CHECK (((id)::text =
ANY (ARRAY[('ARC'::character varying)::text, ('CONNEC'::character varying)::text, ('ELEMENT'::character varying)::text,
('GULLY'::character varying)::text, ('LINK'::character varying)::text, ('NODE'::character varying)::text, ('VNODE'::character varying)::text,
('FLWREG'::character varying)::text])));

-- Add flwregulators childs as feature_class
ALTER TABLE sys_feature_class DROP CONSTRAINT sys_feature_cat_check;
INSERT INTO sys_feature_class VALUES ('VFLWREG', 'FLWREG', 'ORIFICE', 'man_vflwreg');
INSERT INTO sys_feature_class VALUES ('WEIR', 'FLWREG', 'WEIR', 'man_weir');
INSERT INTO sys_feature_class VALUES ('PUMP', 'FLWREG', 'PUMP', 'man_pump');
ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK (((id)::text = ANY (ARRAY[('CHAMBER'::character varying)::text,
('CONDUIT'::character varying)::text, ('CONNEC'::character varying)::text, ('GULLY'::character varying)::text,
('JUNCTION'::character varying)::text, ('MANHOLE'::character varying)::text, ('NETELEMENT'::character varying)::text,
('NETGULLY'::character varying)::text, ('NETINIT'::character varying)::text, ('OUTFALL'::character varying)::text,
('SIPHON'::character varying)::text, ('STORAGE'::character varying)::text, ('VALVE'::character varying)::text,
('VARC'::character varying)::text, ('WACCEL'::character varying)::text, ('WJUMP'::character varying)::text,
('WWTP'::character varying)::text, ('ELEMENT'::character varying)::text, ('LINK'::character varying)::text,
('VFLWREG'::character varying)::text, ('WEIR'::character varying)::text, ('PUMP'::character varying)::text])));

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
	the_geom public.geometry(point, 25831) NULL,
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
	the_geom public.geometry(linestring, 25831) NULL,
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
--create parent table for flow regulators
CREATE TABLE flwreg (
	flwreg_id varchar(16) DEFAULT nextval('urn_id_seq'::regclass) NOT NULL,
	node_id varchar(16) NOT NULL,
	order_id int2 NOT NULL,
	to_arc varchar(16) NOT NULL,
	flwreg_type varchar(18) NOT NULL,
	flwreg_length float8 NOT NULL,
	epa_type varchar(16) NOT NULL,  --(ORIFICE / WEIR / OUTLET / PUMP)
	state int2 NOT NULL,
	state_type int2 NOT NULL,
	annotation text NULL,
	observ text NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NOT NULL,
	CONSTRAINT flwreg_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['WEIR'::text, 'ORIFICE'::text, 'PUMP'::text, 'OUTLET'::text, 'UNDEFINED'::text]))),
	CONSTRAINT flwreg_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT flwreg_type_fkey FOREIGN KEY (flwreg_type) REFERENCES cat_feature(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT flwreg_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX flwreg_node_id ON flwreg USING btree (node_id);
CREATE INDEX flwreg_flwreg_type ON flwreg USING btree (flwreg_type);

--Altering the inp tables for the flowregulators.
--ORIFICE
ALTER TABLE inp_flwreg_orifice DROP COLUMN id;
ALTER TABLE inp_flwreg_orifice ADD COLUMN flwreg_id varchar(16) NOT NULL;

--- OUTLET
ALTER TABLE inp_flwreg_outlet DROP COLUMN id;
ALTER TABLE inp_flwreg_outlet ADD COLUMN flwreg_id varchar(16) NOT NULL;

--WEIR
ALTER TABLE inp_flwreg_weir DROP COLUMN id;
ALTER TABLE inp_flwreg_weir ADD COLUMN flwreg_id varchar(16) NOT NULL;

--PUMP
ALTER TABLE inp_flwreg_pump DROP COLUMN id;
ALTER TABLE inp_flwreg_pump ADD COLUMN flwreg_id varchar(16) NOT NULL;

-- Add table for cat_feature_flwreg
CREATE TABLE cat_feature_flwreg (
	id varchar(30) NOT NULL,
	epa_default varchar(30) NOT NULL,
	CONSTRAINT cat_feature_flwreg_pkey PRIMARY KEY (id),
	CONSTRAINT cat_feature_flwreg_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cat_feature_flwreg_inp_check CHECK (((epa_default)::text = ANY (ARRAY['WEIR'::text, 'ORIFICE'::text, 'PUMP'::text, 'OUTLET'::text, 'UNDEFINED'::text])))
);

-- Create man table for flow regulators
CREATE TABLE man_pump (
	flwreg_id varchar(16) NOT NULL,
	pump_type varchar(16) NOT NULL,
	CONSTRAINT man_pump_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT man_pump_flwreg_id_fk FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE
);

CREATE TABLE man_weir(
	flwreg_id varchar(16) NOT NULL,
	weir_type varchar(16) NOT NULL,
	CONSTRAINT man_weir_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT man_weir_flwreg_id_fk FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE
);

CREATE TABLE man_vflwreg (
	flwreg_id varchar(16) NOT NULL,
	CONSTRAINT man_vflwreg_pkey PRIMARY KEY (flwreg_id),
	CONSTRAINT man_vflwreg_flwreg_id_fk FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE
);

-- 30/01/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"node", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"gully", "column":"verified", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"samplepoint", "column":"verified", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"element", "column":"verified", "dataType":"integer"}}$$);