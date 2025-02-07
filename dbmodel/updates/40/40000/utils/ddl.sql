/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 08/10/2024
ALTER TABLE sys_foreignkey DROP CONSTRAINT sys_foreingkey_pkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_foreignkey", "column":"id", "newName":"_id"}}$$);
ALTER TABLE sys_foreignkey DROP CONSTRAINT sys_foreignkey_unique;
ALTER TABLE sys_foreignkey ADD CONSTRAINT sys_foreingkey_pkey PRIMARY KEY (typevalue_table, typevalue_name, target_table, target_field);

ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
CREATE INDEX idx_plan_psector_expl_id ON plan_psector USING btree (expl_id);
CREATE INDEX idx_plan_psector_workcat_id ON plan_psector USING btree (workcat_id);
CREATE INDEX ifx_plan_psector_parent_id ON plan_psector USING btree (parent_id);
CREATE INDEX idx_plan_psector_name ON plan_psector USING btree (name);
CREATE INDEX idx_plan_psector_status ON plan_psector USING btree (status);
CREATE INDEX ifx_plan_psector_the_geom ON plan_psector USING gist (the_geom);

-- 11/10/2024
ALTER TABLE sys_feature_cat RENAME TO sys_feature_class;

ALTER TABLE cat_feature DROP CONSTRAINT IF EXISTS cat_feature_system_fkey;
ALTER TABLE cat_feature RENAME COLUMN system_id TO feature_class;
ALTER TABLE cat_feature ADD CONSTRAINT cat_feature_feature_class_fkey FOREIGN KEY (feature_class, feature_type) REFERENCES sys_feature_class(id, type) ON UPDATE CASCADE ON DELETE CASCADE;

DROP VIEW IF EXISTS v_value_cat_node;
DROP VIEW IF EXISTS v_value_cat_connec;
ALTER TABLE cat_feature_arc DROP CONSTRAINT cat_feature_arc_type_fkey;
ALTER TABLE cat_feature_node DROP CONSTRAINT cat_feature_node_type_fkey;
ALTER TABLE cat_feature_connec DROP CONSTRAINT cat_feature_connec_type_fkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_feature_arc", "column":"type", "newName":"_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_feature_node", "column":"type", "newName":"_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_feature_connec", "column":"type", "newName":"_type"}}$$);

-- 17/10/2024
CREATE TABLE config_form_help (
    formtype VARCHAR(50) NOT NULL DEFAULT 'generic'::character varying,
    formname VARCHAR(50) NOT NULL,
    tabname VARCHAR(30) NOT NULL DEFAULT 'tab_none'::character varying,
    path TEXT,
    CONSTRAINT config_form_help_pkey PRIMARY KEY (formtype, formname, tabname)
);

-- 18/10/2024
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_category;
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_fluid;
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_function;
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_location;
DROP TRIGGER IF EXISTS gw_trg_config_control ON cat_brand;
DROP TRIGGER IF EXISTS gw_trg_config_control ON cat_brand_model;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_type_category", "column":"featurecat_id", "dataType":"text[]"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_type_fluid", "column":"featurecat_id", "dataType":"text[]"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_type_function", "column":"featurecat_id", "dataType":"text[]"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_type_location", "column":"featurecat_id", "dataType":"text[]"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"cat_brand", "column":"featurecat_id", "dataType":"text[]"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"cat_brand_model", "column":"featurecat_id", "dataType":"text[]"}}$$);


-- 12/11/2024
DROP VIEW IF EXISTS ve_config_addfields;
DROP VIEW IF EXISTS ve_config_sysfields;

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk_update ON config_form_fields;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"config_form_fields", "column":"layoutname", "dataType":"text"}}$$);


-- 19/11/2024
ALTER TABLE arc DROP CONSTRAINT arc_category_type_feature_type_fkey;
ALTER TABLE arc DROP CONSTRAINT arc_fluid_type_feature_type_fkey;
ALTER TABLE arc DROP CONSTRAINT arc_function_type_feature_type_fkey;
ALTER TABLE arc DROP CONSTRAINT arc_location_type_feature_type_fkey;

ALTER TABLE node DROP CONSTRAINT node_category_type_feature_type_fkey;
ALTER TABLE node DROP CONSTRAINT node_fluid_type_feature_type_fkey;
ALTER TABLE node DROP CONSTRAINT node_function_type_feature_type_fkey;
ALTER TABLE node DROP CONSTRAINT node_location_type_feature_type_fkey;

ALTER TABLE connec DROP CONSTRAINT connec_category_type_feature_type_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_fluid_type_feature_type_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_function_type_feature_type_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_location_type_feature_type_fkey;

-- 28/11/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_element", "column":"elementtype_id", "newName":"element_type"}}$$);

-- 04/12/2024
ALTER TABLE doc_x_psector DROP CONSTRAINT doc_x_psector_doc_id_fkey;
ALTER TABLE doc_x_workcat DROP CONSTRAINT doc_x_workcat_doc_id_fkey;
ALTER TABLE doc_x_visit DROP CONSTRAINT doc_x_visit_doc_id_fkey;
ALTER TABLE doc_x_node DROP CONSTRAINT doc_x_node_doc_id_fkey;
ALTER TABLE doc_x_arc DROP CONSTRAINT doc_x_arc_doc_id_fkey;
ALTER TABLE doc_x_connec DROP CONSTRAINT doc_x_connec_doc_id_fkey;

ALTER TABLE doc RENAME TO _doc;
ALTER TABLE _doc RENAME CONSTRAINT doc_pkey TO _doc_pkey;
ALTER TABLE _doc DROP CONSTRAINT name_chk;
ALTER TABLE _doc DROP CONSTRAINT doc_doc_type_fkey;

CREATE TABLE doc (
    id varchar(30) DEFAULT nextval('doc_seq'::regclass) NOT NULL,
    "name" varchar(30) NOT NULL,
    doc_type varchar(30) NOT NULL,
    "path" varchar(512) NOT NULL,
    observ varchar(512) NULL,
    "date" timestamp(6) DEFAULT now() NULL,
    user_name varchar(50) DEFAULT USER NULL,
    tstamp timestamp DEFAULT now() NULL,
    the_geom public.geometry(point, 25831) NULL,
    CONSTRAINT doc_pkey PRIMARY KEY (id),
    CONSTRAINT name_chk UNIQUE ("name"),
    CONSTRAINT doc_doc_type_fkey FOREIGN KEY (doc_type) REFERENCES doc_type(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 05/12/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_address", "column":"postcomplement", "dataType":"text", "isUtils":"True"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_district", "column":"ext_code", "dataType":"text", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_address", "column":"ext_code", "dataType":"text", "isUtils":"True"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_streetaxis", "column":"source", "dataType":"text", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_address", "column":"source", "dataType":"text", "isUtils":"True"}}$$);

DROP VIEW IF EXISTS v_edit_plan_psector;
DROP VIEW IF EXISTS v_ui_plan_psector;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE", "table":"plan_psector", "column":"ext_code", "dataType":"text"}}$$);

DO $$
DECLARE
    v_utils BOOLEAN;
BEGIN
    SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

    IF v_utils THEN

        -- create indexes
        CREATE INDEX idx_address_streetaxis_id ON utils.address USING btree (streetaxis_id);
        CREATE INDEX idx_address_plot_id ON utils.address USING btree (plot_id);
        CREATE INDEX idx_address_postcode ON utils.address USING btree (postcode);
        CREATE INDEX idx_address_the_geom ON utils.address USING gist (the_geom);

        CREATE INDEX idx_streetaxis_name ON utils.streetaxis USING btree (name);
        CREATE INDEX idx_streetaxis_the_geom ON utils.streetaxis USING gist (the_geom);
        CREATE INDEX idx_streetaxis_muni_id ON utils.streetaxis USING btree (muni_id);
        CREATE INDEX idx_streetaxis_code ON utils.streetaxis USING btree (code);

        CREATE INDEX idx_municipality_name ON utils.municipality USING btree (name);
        CREATE INDEX idx_municipality_the_geom ON utils.municipality USING gist (the_geom);

        CREATE INDEX idx_plot_plot_code ON utils.plot USING btree (plot_code);
        CREATE INDEX idx_plot_muni_id ON utils.plot USING btree (muni_id);
        CREATE INDEX idx_plot_streetaxis_id ON utils.plot USING btree (streetaxis_id);
        CREATE INDEX idx_plot_the_geom ON utils.plot USING gist (the_geom);
        CREATE INDEX idx_plot_postcode ON utils.plot USING btree (postcode);

    ELSE

        -- create indexes
        CREATE INDEX idx_ext_address_streetaxis_id ON SCHEMA_NAME.ext_address USING btree (streetaxis_id);
        CREATE INDEX idx_ext_address_plot_id ON SCHEMA_NAME.ext_address USING btree (plot_id);
        CREATE INDEX idx_ext_address_postcode ON SCHEMA_NAME.ext_address USING btree (postcode);
        CREATE INDEX idx_ext_address_the_geom ON SCHEMA_NAME.ext_address USING gist (the_geom);

        CREATE INDEX idx_ext_streetaxis_name ON SCHEMA_NAME.ext_streetaxis USING btree (name);
        CREATE INDEX idx_ext_streetaxis_the_geom ON SCHEMA_NAME.ext_streetaxis USING gist (the_geom);
        CREATE INDEX idx_ext_streetaxis_muni_id ON SCHEMA_NAME.ext_streetaxis USING btree (muni_id);
        CREATE INDEX idx_ext_streetaxis_code ON SCHEMA_NAME.ext_streetaxis USING btree (code);

        CREATE INDEX idx_ext_municipality_name ON SCHEMA_NAME.ext_municipality USING btree (name);
        CREATE INDEX idx_ext_municipality_the_geom ON SCHEMA_NAME.ext_municipality USING gist (the_geom);

        CREATE INDEX idx_ext_plot_plot_code ON SCHEMA_NAME.ext_plot USING btree (plot_code);
        CREATE INDEX idx_ext_plot_muni_id ON SCHEMA_NAME.ext_plot USING btree (muni_id);
        CREATE INDEX idx_ext_plot_streetaxis_id ON SCHEMA_NAME.ext_plot USING btree (streetaxis_id);
        CREATE INDEX idx_ext_plot_the_geom ON SCHEMA_NAME.ext_plot USING gist (the_geom);
        CREATE INDEX idx_ext_plot_postcode ON SCHEMA_NAME.ext_plot USING btree (postcode);

	END IF;
END; $$;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"except_level", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"except_msg", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"except_table", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"except_table_msg", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"query_text", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"info_msg", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"function_name", "dataType":"text"}}$$);

-- 09/12/2024
ALTER SEQUENCE audit_psector_arc_traceability_id_seq RENAME TO archived_psector_arc_traceability_id_seq;
ALTER SEQUENCE audit_psector_connec_traceability_id_seq RENAME TO archived_psector_connec_traceability_id_seq;
ALTER SEQUENCE audit_psector_node_traceability_id_seq RENAME TO archived_psector_node_traceability_id_seq;
ALTER TABLE audit_psector_arc_traceability RENAME TO archived_psector_arc_traceability;
ALTER TABLE audit_psector_connec_traceability RENAME TO archived_psector_connec_traceability;
ALTER TABLE audit_psector_node_traceability RENAME TO archived_psector_node_traceability;

DROP VIEW IF EXISTS vi_backdrop;
ALTER TABLE inp_backdrop RENAME to _inp_backdrop;

-- 11/12/2024
ALTER TABLE element ADD COLUMN asset_id varchar(50);

-- 12/12/2024
CREATE TABLE cat_material (
    id varchar(30) NOT NULL,
    descript varchar(512) NOT NULL,
    feature_type _text NULL,
    featurecat_id _text NULL,
    n numeric(12, 4) NULL,
    link varchar(512) NULL,
    active bool DEFAULT true NULL,
    CONSTRAINT cat_mat_pkey PRIMARY KEY (id)
);

SELECT * FROM gw_fct_admin_transfer_cat_material();

ALTER TABLE cat_arc DROP CONSTRAINT IF EXISTS cat_arc_matcat_id_fkey;
ALTER TABLE cat_node DROP CONSTRAINT IF EXISTS cat_node_matcat_id_fkey;
ALTER TABLE cat_connec DROP CONSTRAINT IF EXISTS cat_connec_matcat_id_fkey;
ALTER TABLE cat_element DROP CONSTRAINT IF EXISTS cat_element_matcat_id_fkey;

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_matcat_id_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_matcat_id_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_matcat_id_fkey;

ALTER TABLE cat_mat_arc RENAME TO _cat_mat_arc;
ALTER TABLE cat_mat_node RENAME TO _cat_mat_node;
ALTER TABLE cat_mat_element RENAME TO _cat_mat_element;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"element", "column":"verified", "dataType":"int2", "isUtils":"False"}}$$);

DROP INDEX if exists plan_psector_psector_id;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"link", "column":"verified", "dataType":"int2", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"sys_fprocess", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);

update sys_fprocess set active = true;

-- 07/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"rpt_cat_result", "column":"inp_file", "dataType":"bytea", "isUtils":"False"}}$$);
