/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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
    the_geom public.geometry(point, SRID_VALUE) NULL,
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
        CREATE INDEX IF NOT EXISTS idx_address_streetaxis_id ON utils.address USING btree (streetaxis_id);
        CREATE INDEX IF NOT EXISTS idx_address_plot_id ON utils.address USING btree (plot_id);
        CREATE INDEX IF NOT EXISTS idx_address_postcode ON utils.address USING btree (postcode);
        CREATE INDEX IF NOT EXISTS idx_address_the_geom ON utils.address USING gist (the_geom);

        CREATE INDEX IF NOT EXISTS idx_streetaxis_name ON utils.streetaxis USING btree (name);
        CREATE INDEX IF NOT EXISTS idx_streetaxis_the_geom ON utils.streetaxis USING gist (the_geom);
        CREATE INDEX IF NOT EXISTS idx_streetaxis_muni_id ON utils.streetaxis USING btree (muni_id);
        CREATE INDEX IF NOT EXISTS idx_streetaxis_code ON utils.streetaxis USING btree (code);

        CREATE INDEX IF NOT EXISTS idx_municipality_name ON utils.municipality USING btree (name);
        CREATE INDEX IF NOT EXISTS idx_municipality_the_geom ON utils.municipality USING gist (the_geom);

        CREATE INDEX IF NOT EXISTS idx_plot_plot_code ON utils.plot USING btree (plot_code);
        CREATE INDEX IF NOT EXISTS idx_plot_muni_id ON utils.plot USING btree (muni_id);
        CREATE INDEX IF NOT EXISTS idx_plot_streetaxis_id ON utils.plot USING btree (streetaxis_id);
        CREATE INDEX IF NOT EXISTS idx_plot_the_geom ON utils.plot USING gist (the_geom);
        CREATE INDEX IF NOT EXISTS idx_plot_postcode ON utils.plot USING btree (postcode);

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

-- 10/02/2025
DROP VIEW IF EXISTS v_ui_workspace;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"cat_workspace", "column":"cur_user"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"cat_workspace", "column":"insert_user", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"cat_workspace", "column":"insert_timestamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"cat_workspace", "column":"lastupdate_user", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"cat_workspace", "column":"lastupdate_timestamp", "dataType":"timestamp", "isUtils":"False"}}$$);

ALTER TABLE cat_workspace ALTER COLUMN insert_user SET DEFAULT current_user;
ALTER TABLE cat_workspace ALTER COLUMN insert_timestamp SET DEFAULT now();
ALTER TABLE cat_workspace ALTER COLUMN lastupdate_user SET DEFAULT current_user;
ALTER TABLE cat_workspace ALTER COLUMN lastupdate_timestamp SET DEFAULT now();

--20/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_user_x_expl", "column":"active"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_user_x_expl", "column":"manager_id"}}$$);

-- 04/03/2025
DROP VIEW IF EXISTS v_edit_macrosector;
DROP RULE IF EXISTS undelete_macrosector ON macrosector;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"macrosector", "column":"undelete"}}$$);


-- 05/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);

-- 06/03/2025
DROP VIEW IF EXISTS v_ui_rpt_cat_result;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"rpt_cat_result", "column":"result_id", "dataType":"varchar(50)", "isUtils":"False"}}$$);

-- 07/03/2025
DROP TABLE config_file;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'doc', 'Document', 'doc', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'pdf', 'Pdf', 'pdf', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'jpg', 'Image', 'jpg', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'png', 'Image', 'png', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'mp4', 'Video', 'mp4', NULL);


-- 10/03/2025
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget_node;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_edit_plan_psector_x_other;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_psector", "column":"atlas_id", "dataType":"int4"}}$$);

-- 11/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_rtc_scada_x_data", "column":"value_date", "dataType":"date"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_manager", "column":"sector_id"}}$$);

ALTER TABLE config_user_x_sector RENAME TO _config_user_x_sector;

CREATE TABLE om_visit_x_link (
	id bigserial NOT NULL,
	visit_id int8 NOT NULL,
	link_id int4 NOT NULL,
	is_last bool DEFAULT true NULL,
	CONSTRAINT om_visit_x_link_pkey PRIMARY KEY (id),
	CONSTRAINT om_visit_x_link_unique UNIQUE (link_id, visit_id),
	CONSTRAINT om_visit_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT om_visit_x_link_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE config_visit_parameter DROP CONSTRAINT config_visit_parameter_feature_type_check;
ALTER TABLE config_visit_parameter ADD CONSTRAINT config_visit_parameter_feature_type_check CHECK (feature_type::text = ANY (ARRAY['ARC'::text, 'NODE'::text, 'CONNEC'::text, 'GULLY'::text, 'LINK'::text, 'ALL'::text]));

CREATE TABLE doc_x_link (
	doc_id varchar(30) NOT NULL,
	link_id int4 NOT NULL,
	CONSTRAINT doc_x_link_pkey PRIMARY KEY (doc_id, link_id),
	CONSTRAINT doc_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT doc_x_link_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE element_x_link (
	element_id varchar(16) NOT NULL,
	link_id int4 NOT NULL,
	CONSTRAINT element_x_link_pkey PRIMARY KEY (element_id, link_id),
	CONSTRAINT element_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT element_x_link_element_id_fkey FOREIGN KEY (element_id) REFERENCES "element"(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 02/04/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector", "column":"archived", "dataType":"boolean", "isUtils":"False"}}$$);

CREATE TABLE archived_psector_link_traceability (
    id serial4 NOT NULL,
    psector_id int4 NOT NULL,
    psector_state int2 NOT NULL,
    doable bool NOT NULL,
    audit_tstamp timestamp DEFAULT now() NULL,
    audit_user text DEFAULT CURRENT_USER NULL,
    "action" varchar(16) NOT NULL,
    link_id int4 NOT NULL,
    code text NULL,
    feature_id varchar(16) NULL,
    feature_type varchar(16) NULL,
    exit_id varchar(16) NULL,
    exit_type varchar(16) NULL,
    userdefined_geom bool NULL,
    state int2 NOT NULL,
    expl_id int4 NOT NULL,
    the_geom public.geometry(linestring, SRID_VALUE) NULL,
    exit_topelev float8 NULL,
    exit_elev numeric(12, 3) NULL,
    sector_id int4 NULL,
    dma_id int4 NULL,
    fluid_type varchar(50) NULL,
    presszone_id int4 NULL,
    dqa_id int4 NULL,
    minsector_id int4 NULL,
    expl_visibility int2[] NULL,
    epa_type varchar(16) NULL,
    is_operative bool NULL,
    insert_user varchar(50) NULL,
    lastupdate timestamp NULL,
    lastupdate_user varchar(50) NULL,
    staticpressure numeric(12, 3) NULL,
    conneccat_id varchar(30) NULL,
    workcat_id varchar(255) NULL,
    workcat_id_end varchar(255) NULL,
    builtdate date NULL,
    enddate date NULL,
    uncertain bool NULL,
    muni_id int4 NULL,
    verified int2 NULL,
    supplyzone_id int4 NULL,
    n_hydrometer int4 NULL,
    custom_length numeric(12, 2) NULL,
    datasource int4 NULL,

    CONSTRAINT archived_psector_link_traceability_pkey PRIMARY KEY (id)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"polygon", "column":"undelete"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"polygon", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);

-- 25/04/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_message", "column":"message_type", "dataType":"varchar(50)", "isUtils":"False"}}$$);
