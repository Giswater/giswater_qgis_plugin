/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


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


CREATE TABLE config_form_help (
    formtype VARCHAR(50) NOT NULL DEFAULT 'generic'::character varying,
    formname VARCHAR(50) NOT NULL,
    tabname VARCHAR(30) NOT NULL DEFAULT 'tab_none'::character varying,
    path TEXT,
    CONSTRAINT config_form_help_pkey PRIMARY KEY (formtype, formname, tabname)
);


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



DROP VIEW IF EXISTS ve_config_addfields;
DROP VIEW IF EXISTS ve_config_sysfields;

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk_update ON config_form_fields;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"config_form_fields", "column":"layoutname", "dataType":"text"}}$$);



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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_element", "column":"elementtype_id", "newName":"element_type"}}$$);


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


ALTER SEQUENCE audit_psector_arc_traceability_id_seq RENAME TO archived_psector_arc_traceability_id_seq;
ALTER SEQUENCE audit_psector_connec_traceability_id_seq RENAME TO archived_psector_connec_traceability_id_seq;
ALTER SEQUENCE audit_psector_node_traceability_id_seq RENAME TO archived_psector_node_traceability_id_seq;
ALTER TABLE audit_psector_arc_traceability RENAME TO archived_psector_arc_traceability;
ALTER TABLE audit_psector_connec_traceability RENAME TO archived_psector_connec_traceability;
ALTER TABLE audit_psector_node_traceability RENAME TO archived_psector_node_traceability;

DROP VIEW IF EXISTS vi_backdrop;
ALTER TABLE inp_backdrop RENAME to _inp_backdrop;


ALTER TABLE element ADD COLUMN asset_id varchar(50);


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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"rpt_cat_result", "column":"inp_file", "dataType":"bytea", "isUtils":"False"}}$$);


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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_user_x_expl", "column":"active"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_user_x_expl", "column":"manager_id"}}$$);


DROP VIEW IF EXISTS v_edit_macrosector;
DROP RULE IF EXISTS undelete_macrosector ON macrosector;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"macrosector", "column":"undelete"}}$$);



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"lock_level", "dataType":"int4", "isUtils":"False"}}$$);


DROP VIEW IF EXISTS v_ui_rpt_cat_result;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"rpt_cat_result", "column":"result_id", "dataType":"varchar(50)", "isUtils":"False"}}$$);


DROP TABLE config_file;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'doc', 'Document', 'doc', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'pdf', 'Pdf', 'pdf', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'jpg', 'Image', 'jpg', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'png', 'Image', 'png', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('filetype_typevalue', 'mp4', 'Video', 'mp4', NULL);



DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget_node;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_edit_plan_psector_x_other;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"plan_psector", "column":"atlas_id", "dataType":"int4"}}$$);


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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_message", "column":"message_type", "dataType":"varchar(50)", "isUtils":"False"}}$$);



-- delete all views to avoid conflicts, then recreate them
DROP VIEW IF EXISTS v_plan_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_all;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_psector_arc;
DROP VIEW IF EXISTS v_plan_psector_connec;
DROP VIEW IF EXISTS v_plan_psector_node;
DROP VIEW IF EXISTS v_plan_psector_link;
DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_plan_netscenario_arc;
DROP VIEW IF EXISTS v_plan_netscenario_node;
DROP VIEW IF EXISTS v_plan_netscenario_connec;
DROP VIEW IF EXISTS v_edit_plan_netscenario_valve;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;

DROP VIEW IF EXISTS v_ui_workcat_x_feature;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;

DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_outlet;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_virtual;
DROP VIEW IF EXISTS v_edit_inp_weir;

DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_outlet;
DROP VIEW IF EXISTS v_edit_inp_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_flwreg_outlet;


DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
DROP VIEW IF EXISTS v_edit_inp_dscenario_treatment;
DROP VIEW IF EXISTS v_edit_inp_dwf;
DROP VIEW IF EXISTS v_edit_inp_inflows;
DROP VIEW IF EXISTS v_edit_inp_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_treatment;
DROP VIEW IF EXISTS v_edit_inp_junction;

DROP VIEW IF EXISTS v_edit_inp_divider;
DROP VIEW IF EXISTS v_edit_inp_dscenario_outfall;
DROP VIEW IF EXISTS v_edit_inp_outfall;
DROP VIEW IF EXISTS v_edit_inp_dscenario_storage;
DROP VIEW IF EXISTS v_edit_inp_storage;
DROP VIEW IF EXISTS v_edit_inp_netgully;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_plan_psector_budget_node;
DROP VIEW IF EXISTS v_plan_result_node;
DROP VIEW IF EXISTS v_ui_plan_node_cost;
DROP VIEW IF EXISTS v_plan_node;
DROP VIEW IF EXISTS ve_pol_chamber;
DROP VIEW IF EXISTS ve_pol_netgully;
DROP VIEW IF EXISTS ve_pol_node;
DROP VIEW IF EXISTS ve_pol_storage;
DROP VIEW IF EXISTS ve_pol_wwtp;
DROP VIEW IF EXISTS vi_coverages;
DROP VIEW IF EXISTS vi_groundwater;

DROP VIEW IF EXISTS v_edit_inp_dscenario_conduit;
DROP VIEW IF EXISTS v_edit_inp_conduit;

DROP VIEW IF EXISTS v_rtc_period_dma;
DROP VIEW IF EXISTS v_rtc_period_node;
DROP VIEW IF EXISTS v_rtc_period_pjoint;
DROP VIEW IF EXISTS v_rtc_period_hydrometer;

DROP VIEW IF EXISTS ve_pol_connec;

DROP VIEW IF EXISTS v_ui_presszone;
DROP VIEW IF EXISTS v_ui_arc_x_relations;
DROP VIEW IF EXISTS v_ui_arc_x_node;
DROP VIEW IF EXISTS v_ui_node_x_relations;

DROP VIEW IF EXISTS vu_element_x_node;
DROP VIEW IF EXISTS vu_element_x_connec;
DROP VIEW IF EXISTS vu_element_x_arc;
DROP VIEW IF EXISTS vu_element_x_gully;

DROP VIEW IF EXISTS v_ui_element;
DROP VIEW IF EXISTS v_ui_element_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS ve_pol_element;

DROP VIEW IF EXISTS v_ui_doc_x_arc;
DROP VIEW IF EXISTS v_ui_doc_x_connec;
DROP VIEW IF EXISTS v_ui_doc_x_gully;
DROP VIEW IF EXISTS v_ui_doc_x_node;
DROP VIEW IF EXISTS v_ui_doc_x_psector;
DROP VIEW IF EXISTS v_ui_doc_x_visit;
DROP VIEW IF EXISTS v_ui_doc_x_workcat;
DROP VIEW IF EXISTS v_ui_om_visit_x_doc;

DROP VIEW IF EXISTS v_ext_raster_dem;

DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_price_x_catarc;
DROP VIEW IF EXISTS v_plan_aux_arc_pavement;

DROP VIEW IF EXISTS vi_parent_dma;
DROP VIEW IF EXISTS vi_parent_arc;
DROP VIEW IF EXISTS vi_parent_hydrometer;
DROP VIEW IF EXISTS vi_parent_connec;

DROP VIEW IF EXISTS v_edit_field_valve;
DROP VIEW IF EXISTS ve_pol_register;
DROP VIEW IF EXISTS ve_pol_tank;
DROP VIEW IF EXISTS ve_pol_fountain;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump;
DROP VIEW IF EXISTS v_edit_inp_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_connec;
DROP VIEW IF EXISTS v_edit_inp_connec;
DROP VIEW IF EXISTS v_edit_inp_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_tank;
DROP VIEW IF EXISTS v_edit_inp_tank;
DROP VIEW IF EXISTS v_edit_inp_dscenario_reservoir;
DROP VIEW IF EXISTS v_edit_inp_reservoir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
DROP VIEW IF EXISTS v_edit_inp_valve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inlet;
DROP VIEW IF EXISTS v_edit_inp_inlet;

DROP VIEW IF EXISTS v_edit_inp_dscenario_demand;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_pipe;

DROP VIEW IF EXISTS v_edit_review_audit_node;
DROP VIEW IF EXISTS v_edit_review_audit_arc;
DROP VIEW IF EXISTS v_edit_review_audit_connec;
DROP VIEW IF EXISTS v_edit_review_audit_gully;

DROP VIEW IF EXISTS v_edit_review_node;
DROP VIEW IF EXISTS v_edit_review_arc;
DROP VIEW IF EXISTS v_edit_review_connec;
DROP VIEW IF EXISTS v_edit_review_gully;

DROP VIEW IF EXISTS v_edit_link_connec;
DROP VIEW IF EXISTS v_edit_link_gully;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);

DROP VIEW IF EXISTS ve_epa_junction;
DROP VIEW IF EXISTS ve_epa_tank;
DROP VIEW IF EXISTS ve_epa_reservoir;
DROP VIEW IF EXISTS ve_epa_connec;
DROP VIEW IF EXISTS ve_epa_inlet;

DROP VIEW IF EXISTS v_rpt_node;
DROP VIEW IF EXISTS v_rpt_node_all;

DROP VIEW IF EXISTS ve_epa_pump;
DROP VIEW IF EXISTS ve_epa_pump_additional;
DROP VIEW IF EXISTS ve_epa_valve;
DROP VIEW IF EXISTS ve_epa_shortpipe;
DROP VIEW IF EXISTS ve_epa_pipe;
DROP VIEW IF EXISTS ve_epa_virtualvalve;
DROP VIEW IF EXISTS ve_epa_virtualpump;

DROP VIEW IF EXISTS v_rpt_arc;
DROP VIEW IF EXISTS v_rpt_arc_all;

DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS v_edit_connec;

DROP VIEW IF EXISTS ve_arc CASCADE;
DROP VIEW IF EXISTS vu_arc;

DROP VIEW IF EXISTS ve_node CASCADE;
DROP VIEW IF EXISTS vu_node;

DROP VIEW IF EXISTS ve_connec CASCADE;
DROP VIEW IF EXISTS vu_connec;

DROP VIEW IF EXISTS v_edit_link;

DROP VIEW IF EXISTS v_edit_minsector;
DROP VIEW IF EXISTS v_edit_samplepoint;

DROP VIEW IF EXISTS v_plan_psector_gully;
DROP VIEW IF EXISTS v_ui_element_x_gully;
DROP VIEW IF EXISTS vi_gully2node;
DROP VIEW IF EXISTS ve_pol_gully;
DROP VIEW IF EXISTS v_edit_inp_gully;

DROP VIEW IF EXISTS v_edit_gully;
DROP VIEW IF EXISTS v_edit_element;

DROP VIEW IF EXISTS ve_gully;
DROP VIEW IF EXISTS vu_gully;

DROP view IF EXISTS vu_link;
DROP view IF EXISTS vu_link_connec;
DROP view IF EXISTS vu_link_gully;

DROP VIEW IF EXISTS v_edit_presszone;
DROP VIEW IF EXISTS vu_presszone;

DROP VIEW IF EXISTS v_om_mincut_hydrometer;

DROP VIEW IF EXISTS v_edit_dma;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS v_ui_macrodma;
DROP VIEW IF EXISTS v_edit_macrodma;
DROP VIEW IF EXISTS vu_dma;
DROP VIEW IF EXISTS v_edit_plan_netscenario_presszone;
DROP VIEW IF EXISTS v_edit_plan_psector_x_other;
DROP VIEW IF EXISTS v_edit_dqa;
DROP VIEW IF EXISTS v_ui_dqa;
DROP VIEW IF EXISTS v_edit_macrodqa;
DROP VIEW IF EXISTS v_ui_macrodqa;
DROP VIEW IF EXISTS vu_dqa;

DROP VIEW IF EXISTS v_edit_macrosector;
DROP VIEW IF EXISTS v_ui_macrosector;

DROP VIEW IF EXISTS v_edit_macroexploitation;
DROP VIEW IF EXISTS v_edit_exploitation;

DROP VIEW IF EXISTS v_state_arc;
DROP VIEW IF EXISTS v_state_node;
DROP VIEW IF EXISTS v_state_link;
DROP VIEW IF EXISTS v_state_connec;

DROP VIEW IF EXISTS v_edit_pond;
DROP VIEW IF EXISTS v_edit_pool;
DROP VIEW IF EXISTS v_om_waterbalance_report;

DROP VIEW IF EXISTS v_om_waterbalance;


DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS vu_sector;

DROP VIEW IF EXISTS v_anl_arc;
DROP VIEW IF EXISTS v_anl_arc_point;
DROP VIEW IF EXISTS v_anl_arc_x_node;
DROP VIEW IF EXISTS v_anl_arc_x_node_point;
DROP VIEW IF EXISTS v_anl_node;
DROP VIEW IF EXISTS v_edit_anl_hydrant;
DROP VIEW IF EXISTS v_anl_connec;
DROP VIEW IF EXISTS vi_options;
DROP VIEW IF EXISTS vi_report;
DROP VIEW IF EXISTS vi_times;
DROP VIEW IF EXISTS vi_timeseries;
DROP VIEW IF EXISTS vi_reactions;
DROP VIEW IF EXISTS vi_energy;
DROP VIEW IF EXISTS vi_quality;
DROP VIEW IF EXISTS vi_controls;
DROP VIEW IF EXISTS vi_coordinates;
DROP VIEW IF EXISTS vi_curves;
DROP VIEW IF EXISTS vi_demands;
DROP VIEW IF EXISTS vi_emitters;
DROP VIEW IF EXISTS vi_junctions;
DROP VIEW IF EXISTS vi_labels;
DROP VIEW IF EXISTS vi_mixing;
DROP VIEW IF EXISTS vi_patterns;
DROP VIEW IF EXISTS vi_pipes;
DROP VIEW IF EXISTS vi_pumps;
DROP VIEW IF EXISTS vi_reservoirs;
DROP VIEW IF EXISTS vi_rules;
DROP VIEW IF EXISTS vi_sources;
DROP VIEW IF EXISTS vi_status;
DROP VIEW IF EXISTS vi_tags;
DROP VIEW IF EXISTS vi_tanks;
DROP VIEW IF EXISTS vi_title;
DROP VIEW IF EXISTS vi_valves;
DROP VIEW IF EXISTS vi_vertices;

DROP VIEW IF EXISTS vi_adjustments;
DROP VIEW IF EXISTS vi_aquifers;
DROP VIEW IF EXISTS vi_buildup;
DROP VIEW IF EXISTS vi_evaporation;
DROP VIEW IF EXISTS vi_files;
DROP VIEW IF EXISTS vi_gully;
DROP VIEW IF EXISTS vi_hydrographs;
DROP VIEW IF EXISTS vi_inflows;
DROP VIEW IF EXISTS vi_landuses;
DROP VIEW IF EXISTS vi_lid_controls;
DROP VIEW IF EXISTS vi_map;
-- DROP VIEW IF EXISTS vi_pollutants; -- TODO: refactor gw_fct_rpt2pg_import_rpt
DROP VIEW IF EXISTS vi_polygons;
DROP VIEW IF EXISTS vi_conduits;
DROP VIEW IF EXISTS vi_dividers;
DROP VIEW IF EXISTS vi_losses;
DROP VIEW IF EXISTS vi_orifices;
DROP VIEW IF EXISTS vi_outfalls;
DROP VIEW IF EXISTS vi_outlets;
DROP VIEW IF EXISTS vi_storage;
DROP VIEW IF EXISTS vi_weirs;
DROP VIEW IF EXISTS vi_xsections;
DROP VIEW IF EXISTS vi_quality;
DROP VIEW IF EXISTS vi_raingages;
DROP VIEW IF EXISTS vi_rdii;
DROP VIEW IF EXISTS vi_snowpacks;
DROP VIEW IF EXISTS vi_symbols;
DROP VIEW IF EXISTS vi_temperature;
DROP VIEW IF EXISTS vi_transects;
DROP VIEW IF EXISTS vi_treatment;
DROP VIEW IF EXISTS vi_washoff;
DROP VIEW IF EXISTS vcp_pipes;
DROP VIEW IF EXISTS vcp_demands;

DROP VIEW IF EXISTS v_edit_inp_coverage;
DROP VIEW IF EXISTS vi_dwf;
DROP VIEW IF EXISTS v_edit_inp_dscenario_lid_usage; -- renamed to v_edit_inp_dscenario_lids
DROP VIEW IF EXISTS vi_gwf;
DROP VIEW IF EXISTS vi_infiltration;
DROP VIEW IF EXISTS vi_lid_usage;
DROP VIEW IF EXISTS vi_subareas;
DROP VIEW IF EXISTS vi_subcatchcentroid;
DROP VIEW IF EXISTS vi_subcatchments;
DROP VIEW IF EXISTS v_edit_inp_subc2outlet;
DROP VIEW IF EXISTS vi_loadings;
DROP VIEW IF EXISTS v_edit_inp_subcatchment;
DROP VIEW IF EXISTS v_ui_drainzone;
DROP VIEW IF EXISTS vu_drainzone;

DROP VIEW IF EXISTS v_edit_inp_timeseries;
DROP VIEW IF EXISTS v_edit_inp_timeseries_value;

DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer;

DROP VIEW IF EXISTS v_ui_om_event;
DROP VIEW IF EXISTS v_ui_om_visitman_x_node;
DROP VIEW IF EXISTS v_ui_om_visit_x_node;
DROP VIEW IF EXISTS v_ui_om_visitman_x_arc;
DROP VIEW IF EXISTS v_ui_om_visit_x_arc;
DROP VIEW IF EXISTS v_ui_om_visitman_x_connec;
DROP VIEW IF EXISTS v_ui_om_visit_x_connec;
DROP VIEW IF EXISTS v_ui_om_visitman_x_gully;
DROP VIEW IF EXISTS v_ui_om_visit_x_gully;
DROP VIEW IF EXISTS ve_visit_node_singlevent;
DROP VIEW IF EXISTS ve_visit_arc_singlevent;
DROP VIEW IF EXISTS ve_visit_connec_singlevent;
DROP VIEW IF EXISTS ve_visit_gully_singlevent;
DROP VIEW IF EXISTS v_om_visit;
DROP VIEW IF EXISTS v_ui_event_x_node;
DROP VIEW IF EXISTS v_ui_event_x_arc;
DROP VIEW IF EXISTS v_ui_event_x_connec;
DROP VIEW IF EXISTS v_ui_event_x_gully;

DROP VIEW IF EXISTS v_ui_hydroval_x_connec;
DROP VIEW IF EXISTS v_ui_hydroval;

DROP VIEW IF EXISTS v_price_x_arc;

DROP VIEW IF EXISTS v_edit_plan_psector_x_connec;
DROP VIEW IF EXISTS v_edit_plan_psector_x_gully;

DROP VIEW IF EXISTS v_inp_pjointpattern;

DROP VIEW IF EXISTS v_edit_rtc_hydro_data_x_connec;

DROP VIEW IF EXISTS v_ui_mincut_hydrometer;
DROP VIEW IF EXISTS v_om_mincut_current_hydrometer;

DROP VIEW IF EXISTS v_om_mincut_planned_valve;
DROP VIEW IF EXISTS v_om_mincut_valve;
DROP VIEW IF EXISTS v_om_mincut_arc;
DROP VIEW IF EXISTS v_om_mincut_planned_arc;
DROP VIEW IF EXISTS v_om_mincut_current_arc;
DROP VIEW IF EXISTS v_om_mincut_connec;
DROP VIEW IF EXISTS v_om_mincut_current_connec;
DROP VIEW IF EXISTS v_ui_mincut_connec;
DROP VIEW IF EXISTS v_om_mincut_node;
DROP VIEW IF EXISTS v_om_mincut_current_node;

DROP VIEW IF EXISTS v_polygon;

DROP VIEW IF EXISTS v_rpt_compare_node;
DROP VIEW IF EXISTS v_rpt_arc_hourly;
DROP VIEW IF EXISTS v_rpt_comp_node_hourly;
DROP VIEW IF EXISTS v_rpt_comp_arc_hourly;
DROP VIEW IF EXISTS v_rpt_comp_arc;
DROP VIEW IF EXISTS v_rpt_comp_node;
DROP VIEW IF EXISTS v_rpt_node_hourly;

DROP VIEW IF EXISTS v_expl_connec;

DROP VIEW IF EXISTS ve_epa_netgully;
DROP VIEW IF EXISTS ve_epa_outfall;
DROP VIEW IF EXISTS ve_epa_conduit;
DROP VIEW IF EXISTS ve_epa_outlet;
DROP VIEW IF EXISTS ve_epa_weir;
DROP VIEW IF EXISTS ve_epa_gully;
DROP VIEW IF EXISTS ve_epa_virtual;
DROP VIEW IF EXISTS ve_epa_storage;

DROP VIEW IF EXISTS v_sector_node;

DROP VIEW IF EXISTS v_state_gully;
DROP VIEW IF EXISTS v_state_link_connec;
DROP VIEW IF EXISTS v_state_link_gully;

DROP VIEW IF EXISTS v_rpt_arc_compare_all;
DROP VIEW IF EXISTS v_rpt_arc_compare_timestep;
DROP VIEW IF EXISTS v_rpt_arc_timestep;
DROP VIEW IF EXISTS v_rpt_comp_arcflow_sum;
DROP VIEW IF EXISTS v_rpt_arcflow_sum;
DROP VIEW IF EXISTS v_rpt_arcpolload_sum;
DROP VIEW IF EXISTS v_rpt_comp_condsurcharge_sum;
DROP VIEW IF EXISTS v_rpt_condsurcharge_sum;
DROP VIEW IF EXISTS v_rpt_comp_flowclass_sum;
DROP VIEW IF EXISTS v_rpt_flowclass_sum;
DROP VIEW IF EXISTS v_rpt_comp_pumping_sum;
DROP VIEW IF EXISTS v_rpt_pumping_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodedepth_sum;
DROP VIEW IF EXISTS v_rpt_nodedepth_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeflooding_sum;
DROP VIEW IF EXISTS v_rpt_nodeflooding_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeinflow_sum;
DROP VIEW IF EXISTS v_rpt_nodeinflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodesurcharge_sum;
DROP VIEW IF EXISTS v_rpt_nodesurcharge_sum;
DROP VIEW IF EXISTS v_rpt_comp_outfallflow_sum;
DROP VIEW IF EXISTS v_rpt_outfallflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_outfallload_sum;
DROP VIEW IF EXISTS v_rpt_outfallload_sum;
DROP VIEW IF EXISTS v_rpt_node_compare_timestep;
DROP VIEW IF EXISTS v_rpt_node_timestep;
DROP VIEW IF EXISTS v_rpt_storagevol_sum;
DROP VIEW IF EXISTS v_rpt_node_compare_all;
DROP VIEW IF EXISTS v_rpt_comp_storagevol_sum;

DROP VIEW IF EXISTS v_edit_dimensions;

DROP VIEW IF EXISTS v_expl_gully;
DROP VIEW IF EXISTS v_man_gully;

DROP VIEW IF EXISTS ve_epa_virtual;
DROP VIEW IF EXISTS v_edit_inp_virtual;

DROP VIEW IF EXISTS v_edit_cat_feature_connec;



CREATE OR REPLACE VIEW vcv_times AS
 SELECT rpt.result_id,
    rpt.inp_options ->> 'inp_times_duration'::text AS duration
   FROM selector_inp_result r, rpt_cat_result rpt
   WHERE r.result_id = rpt.result_id AND r.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW vcv_dma AS
 SELECT ext_rtc_dma_period.id,
    ext_rtc_dma_period.dma_id,
    ext_rtc_dma_period.cat_period_id AS period_id,
    ext_rtc_dma_period.effc,
    ext_rtc_dma_period.pattern_id
   FROM ext_rtc_dma_period;



CREATE OR REPLACE VIEW ve_config_addfields
AS SELECT sys_addfields.param_name AS columnname,
    config_form_fields.datatype,
    config_form_fields.widgettype,
    config_form_fields.label,
    config_form_fields.hidden,
    config_form_fields.layoutname,
    config_form_fields.layoutorder AS layout_order,
    sys_addfields.orderby AS addfield_order,
    sys_addfields.active,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    config_form_fields.ismandatory,
    config_form_fields.isparent,
    config_form_fields.iseditable,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    config_form_fields.widgetfunction,
    config_form_fields.linkedobject,
    config_form_fields.stylesheet,
    config_form_fields.widgetcontrols,
        CASE
            WHEN sys_addfields.cat_feature_id IS NOT NULL THEN config_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    sys_addfields.id AS param_id,
    sys_addfields.cat_feature_id
   FROM sys_addfields
     LEFT JOIN cat_feature ON cat_feature.id::text = sys_addfields.cat_feature_id::text
     LEFT JOIN config_form_fields ON config_form_fields.columnname::text = sys_addfields.param_name::text;


CREATE OR REPLACE VIEW ve_config_sysfields
AS SELECT row_number() OVER () AS rid,
    config_form_fields.formname,
    config_form_fields.formtype,
    config_form_fields.columnname,
    config_form_fields.label,
    config_form_fields.hidden,
    config_form_fields.layoutname,
    config_form_fields.layoutorder,
    config_form_fields.iseditable,
    config_form_fields.ismandatory,
    config_form_fields.datatype,
    config_form_fields.widgettype,
    config_form_fields.tooltip,
    config_form_fields.placeholder,
    config_form_fields.stylesheet::text AS stylesheet,
    config_form_fields.isparent,
    config_form_fields.isautoupdate,
    config_form_fields.dv_querytext,
    config_form_fields.dv_orderby_id,
    config_form_fields.dv_isnullvalue,
    config_form_fields.dv_parent_id,
    config_form_fields.dv_querytext_filterc,
    config_form_fields.widgetcontrols::text AS widgetcontrols,
    config_form_fields.widgetfunction,
    config_form_fields.linkedobject,
    cat_feature.id AS cat_feature_id
   FROM config_form_fields
     LEFT JOIN cat_feature ON cat_feature.child_layer::text = config_form_fields.formname::text
  WHERE config_form_fields.formtype::text = 'form_feature'::text AND config_form_fields.formname::text <> 've_arc'::text AND config_form_fields.formname::text <> 've_node'::text AND config_form_fields.formname::text <> 've_connec'::text AND config_form_fields.formname::text <> 've_gully'::text;


DROP VIEW IF EXISTS v_minsector_graph;


CREATE OR REPLACE VIEW v_ui_doc
AS SELECT doc.id,
    doc.name,
    doc.observ,
    doc.doc_type,
    doc.path,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;


CREATE OR REPLACE VIEW v_edit_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.ext_code,
    plan_psector.status,
    plan_psector.text3,
    plan_psector.text4,
    plan_psector.text5,
    plan_psector.text6,
    plan_psector.num_value,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
     JOIN exploitation USING (expl_id)
     LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
     LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
     LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_ui_workspace
AS SELECT cat_workspace.id,
    cat_workspace.name,
    cat_workspace.private,
    cat_workspace.descript,
    cat_workspace.config,
    cat_workspace.insert_user,
    cat_workspace.insert_timestamp,
    cat_workspace.lastupdate_user,
    cat_workspace.lastupdate_timestamp
   FROM cat_workspace
  WHERE
  cat_workspace.private IS FALSE
  OR cat_workspace.private IS TRUE
  AND (cat_workspace.insert_user = CURRENT_USER::text OR cat_workspace.lastupdate_user = CURRENT_USER::text);



CREATE OR REPLACE VIEW v_ui_doc_x_link
AS SELECT doc_x_link.doc_id,
    doc_x_link.link_id,
    doc.name as doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
  FROM doc_x_link
     JOIN doc ON doc.id::text = doc_x_link.doc_id::text;


UPDATE sys_fprocess SET fprocess_name='Arc without start-end nodes', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='arcs with state=1 and without node_1 or node_2.', query_text='SELECT arc_id,arccat_id,the_geom, expl_id FROM v_prefix_arc WHERE state = 1 AND node_1 IS NULL UNION 
SELECT arc_id, arccat_id, the_geom, expl_id FROM v_prefix_arc WHERE state = 1 AND node_2 IS NULL', info_msg='No arc''''s with state=1 and without node_1 or node_2 nodes found.', function_name='[gw_fct_om_check_data]' WHERE fid=103;
UPDATE sys_fprocess SET fprocess_name='Node duplicated', "source"='core', fprocess_type='Check epa-topology', project_type='utils', except_level=3, except_msg='nodes duplicated with state 1.', query_text='SELECT * FROM 
(SELECT DISTINCT t1.node_id AS node_1, t1.nodecat_id AS nodecat_1, t1.state as state1, 
t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 106, t1.the_geom 
FROM v_prefix_node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 1 AND a.state2 = 1', info_msg='There are no nodes duplicated with state 1', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=106;
UPDATE sys_fprocess SET fprocess_name='Node orphan (EPA)', "source"='core', fprocess_type='Check epa-topology', project_type='utils', except_level=2, except_msg='nodes orphans ready-to-export (epa_type & state_type). If they are actually orphan, you could change the epa_type to fix it''', query_text='SELECT node_id, nodecat_id, the_geom, expl_id FROM 
(SELECT node_id FROM v_edit_node EXCEPT (SELECT node_1 as node_id FROM v_edit_arc UNION SELECT node_2 FROM v_edit_arc))a 
JOIN node USING (node_id)   JOIN selector_sector USING (sector_id) JOIN value_state_type v ON state_type = v.id 
WHERE epa_type != ''UNDEFINED'' and is_operative = true and cur_user = current_user and arc_id IS NULL', info_msg='No nodes orphan found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=107;
UPDATE sys_fprocess SET fprocess_name='Node exit upper intro', "source"='core', fprocess_type='Function process', project_type='ud', except_level=2, except_msg='junctions with exits upper intro', query_text='SELECT node_id, nodecat_id, expl_id, a.the_geom 
	FROM ( SELECT node_id, max(sys_elev1) AS max_exit, nodecat_id, node.expl_id, node.the_geom FROM v_edit_arc JOIN node ON node_1 = node_id JOIN cat_feature_node ON node_type = id
	WHERE isexitupperintro = 0 GROUP BY node_id, node.expl_id )a
	JOIN ( SELECT node_id, max(sys_elev2) AS max_entry FROM v_edit_arc JOIN node ON node_2 = node_id JOIN cat_feature_node ON node_type = id WHERE isexitupperintro = 0 GROUP BY node_id )b USING (node_id)
	JOIN selector_expl USING (expl_id) 
	WHERE max_entry < max_exit AND cur_user = current_user', info_msg='Any junction have been detected with exits upper intro.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=111;
UPDATE sys_fprocess SET fprocess_name='Node sink', "source"='core', fprocess_type='Function process', project_type='ud', except_level=2, except_msg='junctions type sink which means that junction only have entry arcs without any exit arc (FORCE_MAIN is not valid).', query_text='SELECT node_id, nodecat_id, expl_id, v_edit_node.the_geom, ''Node sink'' FROM v_edit_node WHERE epa_type !=''UNDEFINED'' AND node_id IN
	(SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope < 0 AND s.epa != ''FORCE_MAIN'')a
	EXCEPT 
	SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope > 0)a)', info_msg='Any junction have been swiched on the fly to OUTFALL.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=113;
UPDATE sys_fprocess SET fprocess_name='Check dint value for cat_node acting as [SHORTPIPE or VALVE or PUMP]', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=2, except_msg='registers on node''s catalog acting as [SHORTPIPE or VALVE] with dint not defined.''', query_text='SELECT * FROM cat_node WHERE dint IS NULL AND id IN 
(SELECT DISTINCT(nodecat_id) from v_edit_node WHERE epa_type IN (''SHORTPIPE'', ''VALVE''))', info_msg='Dint for node''''s catalog checked. No values missed for SHORTPIPES OR VALVES', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=142;
UPDATE sys_fprocess SET fprocess_name='Inlets with null mandatory values', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='inlets with null values at least on mandatory columns for inlets (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details.', query_text='SELECT * FROM temp_anl_node WHERE fid=153 AND cur_user=current_user', info_msg='Inlets checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=153;
UPDATE sys_fprocess SET fprocess_name='Nodes without top_elev', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='nodes without top_elev. Take a look on temporal table for details.', query_text='SELECT * FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE top_elev IS NULL AND cur_user = current_user', info_msg='No nodes with null values on field top_elev have been found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=164;
UPDATE sys_fprocess SET fprocess_name='Nodes with top_elev=0', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='nodes with top_elev=0.', query_text='SELECT * FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE top_elev = 0 AND cur_user = current_user', info_msg='No nodes with ''''0'''' on field top_elev have been found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=165;
UPDATE sys_fprocess SET fprocess_name='Node2arc with more than two arcs', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='node2arcs with more than two arcs. It''''s impossible to continue''', query_text='SELECT * FROM (
SELECT node_id, nodecat_id, node.the_geom, node.expl_id FROM node  JOIN selector_sector USING (sector_id) 
JOIN v_edit_arc a1 ON node_id=a1.node_1  AND node.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user 
UNION ALL SELECT node_id, nodecat_id, node.the_geom, node.expl_id FROM node  JOIN selector_sector USING (sector_id) 
JOIN v_edit_arc a1 ON node_id=a1.node_2  AND node.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user)a 
GROUP by node_id, nodecat_id, the_geom, expl_id HAVING count(*) > 2', info_msg='No results found looking for node2arcs with more than two arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=166;
UPDATE sys_fprocess SET fprocess_name='Node2arc with less than two arcs', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='mandatory node2arcs with less than two arcs.''', query_text='SELECT *FROM (
SELECT node_id, nodecat_id, v_edit_node.the_geom, v_edit_node.expl_id FROM v_edit_node 
JOIN selector_sector USING (sector_id)   JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user 
AND v_edit_node.epa_type IN (''VALVE'', ''PUMP'') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) UNION ALL
SELECT node_id, nodecat_id, v_edit_node.the_geom, v_edit_node.expl_id FROM v_edit_node  JOIN selector_sector USING (sector_id) 
JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user  AND v_edit_node.epa_type IN (''VALVE'', ''PUMP'') 
AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user))a 
GROUP by node_id, nodecat_id, the_geom, expl_id HAVING count(*) < 2', info_msg='No results found for mandatory node2arcs with less than two arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=167;
UPDATE sys_fprocess SET fprocess_name='Check pipes with status CV', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='CV pipes. Be carefull with the sense of pipe and check that node_1 and node_2 are on the right direction to prevent reverse flow.', query_text='SELECT * FROM temp_anl_arc WHERE fid = 169 AND cur_user=current_user', info_msg='No results found for CV pipes', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=169;
UPDATE sys_fprocess SET fprocess_name='Check concordance of to_arc valves', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='valves with wrong to_arc value according to the current closest arcs.', query_text='SELECT * FROM temp_anl_node WHERE fid = 170 AND cur_user=current_user', info_msg='Valve to_arc wrong values checked. No inconsistencies have been detected according to the current closest arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=170;
UPDATE sys_fprocess SET fprocess_name='Check concordance of to_arc pumps', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with wrong to_arc value according to the current closest arcs.', query_text='SELECT * FROM temp_anl_node WHERE fid = 171 AND cur_user=current_user', info_msg='Pump to_arc wrong values checked. No inconsistencies have been detected according with the current closest arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=171;
UPDATE sys_fprocess SET fprocess_name='Null values on state_type column', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='topologic features (arc, node) with state_type with NULL values. Please, check your data before continue', query_text='SELECT arc_id FROM v_prefix_arc WHERE state > 0 AND state_type IS NULL UNION SELECT node_id FROM v_prefix_node WHERE state > 0 AND state_type IS NULL', info_msg='No topologic features (arc, node) with state_type NULL values found.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=175;
UPDATE sys_fprocess SET fprocess_name='Null values on closed/broken values for valves', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=3, except_msg='valves (state=1) with broken or closed with NULL values.', query_text='SELECT n.node_id, n.nodecat_id, n.the_geom, expl_id FROM man_valve JOIN v_prefix_node n USING (node_id) 
WHERE n.state = 1 AND (broken IS NULL OR closed IS NULL)', info_msg='There are not operative valves with null values on closed/broken fields.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=176;
UPDATE sys_fprocess SET fprocess_name='inlet_x_exploitation with null/wrong values', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=3, except_msg='rows with exploitation bad configured on the config_graph_mincut table. Please check your data before continue.', query_text='SELECT * FROM config_graph_mincut cgi INNER JOIN node n ON cgi.node_id = n.node_id  WHERE n.expl_id NOT IN 
(SELECT expl_id FROM exploitation WHERE active IS TRUE)', info_msg='It seems config_graph_mincut table is well configured. At least, table is filled with nodes from all exploitations. All tanks are defined in config_graph_mincut.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=177;
UPDATE sys_fprocess SET fprocess_name='dma-nodeparent acording with graph_delimiter', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=2, except_msg='nodes with ''DMA'' on cat_feature_node.graph_delimiter array not configured on the dma table.', query_text='SELECT node_id, nodecat_id, the_geom, a.active, t_node.expl_id FROM t_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type
LEFT JOIN (SELECT node_id, a.active FROM t_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer AS node_id, 
active FROM dma WHERE graphconfig IS NOT NULL )a USING (node_id)) a USING (node_id) WHERE ''DMA'' = ANY(graph_delimiter) AND (a.node_id IS NULL
OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM dma WHERE active IS TRUE)) AND t_node.state > 0 and verified <> 2 and a.active is false', info_msg='All nodes with cat_feature_node.graph_delimiter=''DMA'' are defined as nodeParent on dma.graphconfig', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=180;
UPDATE sys_fprocess SET fprocess_name='dqa-nodeparent acording with graph_delimiter', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes with ''DQA'' on cat_feature_node.graph_delimiter array not configured on the dqa table. nodes with ''DQA'' on cat_feature_node.graph_delimiter array configured for unactive mapzone.', query_text='SELECT node_id, nodecat_id, the_geom,  v_prefix_node.expl_id FROM v_prefix_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type  LEFT JOIN (SELECT node_id FROM v_prefix_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer as node_id FROM v_prefix_dqa WHERE graphconfig IS NOT NULL ) a USING (node_id)) a USING (node_id) WHERE ''DQA'' = ANY(graph_delimiter) AND (a.node_id IS NULL  OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM v_prefix_dqa))  AND v_prefix_node.state > 0 and verified <> 2', info_msg='All nodes with cat_feature_node.graph_delimiter=''DMA'' are defined as nodeParent on dma.graphconfig', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=181;
UPDATE sys_fprocess SET fprocess_name='presszone-nodeparent acording with graph_delimiter', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes with ''PRESSZONE'' on cat_feature_node.graph_delimiter array not configured on the presszone table. ''PRESSZONE'' on cat_feature_node.graph_delimiter array configured for unactive mapzone.', query_text='SELECT node_id, nodecat_id, the_geom, v_prefix_node.expl_id FROM v_prefix_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type  LEFT JOIN (SELECT node_id FROM v_prefix_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer as node_id FROM v_prefix_presszone WHERE graphconfig IS NOT NULL )a USING (node_id)) a USING (node_id) WHERE''PRESSZONE'' = ANY(graph_delimiter) AND (a.node_id IS NULL  OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM v_prefix_presszone))  AND v_prefix_node.state > 0 and verified <> 2', info_msg='All nodes with cat_feature_node.graph_delimiter=''PRESSZONE'' are defined as nodeParent on presszone.graphconfig', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=182;
UPDATE sys_fprocess SET fprocess_name='Nodes with state_type is_operative false', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='nodes with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue', query_text='SELECT node_id, nodecat_id, the_geom, n.expl_id FROM node n JOIN value_state_type s ON id=state_type WHERE n.state > 0 AND s.is_operative IS FALSE AND verified <> 2', info_msg='No nodes with state > 0 AND state_type.is_operative on FALSE found.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=187;
UPDATE sys_fprocess SET fprocess_name='Arcs with state_type is_operative false', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='arcs with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue', query_text='SELECT arc_id, arccat_id, the_geom, a.expl_id FROM v_prefix_arc a JOIN value_state_type s ON id=state_type  
WHERE a.state > 0 AND s.is_operative IS FALSE AND verified <> 2', info_msg='No arcs with state > 0 AND state_type.is_operative on FALSE found.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=188;
UPDATE sys_fprocess SET fprocess_name='Arcs with state=1 using nodes on state=0', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='arcs with state=1 using extremals nodes with state = 0. Please, check your data before continue', query_text='SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a 
JOIN v_prefix_node n ON node_1=node_id WHERE a.state =1 AND n.state=0 UNION 
SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a 
JOIN v_prefix_node n ON node_2=node_id WHERE a.state =1 AND n.state=0', info_msg='No arcs with state=1 using nodes with state=0 found.', function_name='[gw_fct_om_check_data]' WHERE fid=196;
UPDATE sys_fprocess SET fprocess_name='Arcs with state=1 using nodes on state=2', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='arcs with state=1 using extremals nodes with state = 2. Please, check your data before continue', query_text='SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a JOIN v_prefix_node n ON node_1=node_id 
WHERE a.state =1 AND n.state=2 UNION   SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a 
JOIN v_prefix_node n ON node_2=node_id WHERE a.state =1 AND n.state=2', info_msg='No arcs with state=1 using nodes with state=0 found.', function_name='[gw_fct_om_check_data]' WHERE fid=197;
UPDATE sys_fprocess SET fprocess_name='Tanks with null mandatory values', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='tanks with null values at least on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details', query_text='SELECT * FROM temp_anl_node WHERE fid=198 AND cur_user=current_user', info_msg='Tanks checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=198;
UPDATE sys_fprocess SET fprocess_name='Connecs with duplicated customer_code', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='connecs customer code duplicated. Please, check your data before continue', query_text='SELECT customer_code FROM v_prefix_connec WHERE state=1 and customer_code IS NOT NULL group by customer_code, expl_id having count(*) > 1', info_msg='No connecs with customer code duplicated.', function_name='[gw_fct_om_check_data]' WHERE fid=201;
UPDATE sys_fprocess SET fprocess_name='Feature which id is not an integer', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='which id is not an integer. Please, check your data before continue', query_text='SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)  ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id as featurecat, expl_id FROM v_prefix_arc UNION 
SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER) ELSE 0 END as feature_id, ''NODE'' as type, nodecat_id as featurecat, expl_id FROM v_prefix_node UNION 
SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER) ELSE 0 END as feature_id, ''CONNEC'' as type, conneccat_id as featurecat, expl_id FROM v_prefix_connec', info_msg='All features with id integer.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=202;
UPDATE sys_fprocess SET fprocess_name='Connec without link', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='connecs without links or connecs over arc without arc_id.', query_text='SELECT connec_id, conneccat_id, c.the_geom, c.expl_id from v_prefix_connec c WHERE c.state= 1 
AND connec_id NOT IN (SELECT feature_id FROM link) EXCEPT  
SELECT connec_id, conneccat_id, c.the_geom, c.expl_id FROM v_prefix_connec c 
LEFT JOIN arc a USING (arc_id) WHERE c.state= 1 
AND arc_id IS NOT NULL AND st_dwithin(c.the_geom, a.the_geom, 0.1)', info_msg='All connecs have links or are over arc with arc_id.', function_name='[gw_fct_om_check_data]' WHERE fid=204;
UPDATE sys_fprocess SET fprocess_name='Connec or gully chain with different arc_id ', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='chained connecs or gullies with different arc_id. chained connecs with different arc_id.', query_text='with c as 
(select v_prefix_connec.connec_id as id, arc_id as arc, 
v_prefix_connec.conneccat_id as feature_catalog, the_geom, v_prefix_connec.expl_id from v_prefix_connec)     
select c1.id, c1.feature_catalog, c1.the_geom, c1.expl_id from link a 
left join c c1 on a.feature_id = c1.id 
left join c c2 on a.exit_id = c2.id 
where (a.exit_type =''CONNEC'') and c1.arc <> c2.arc ', info_msg='All chained connecs and gullies have the same arc_id All chained connecs have the same arc_id', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=205;
UPDATE sys_fprocess SET fprocess_name='Nodes ischange without change of dn/pn/material', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes with ischange on 1 (true) without any variation of arcs in terms of diameter, pn or material. Please, check your data before continue.', query_text='SELECT n.node_id, count(*), nodecat_id, the_geom, a.expl_id FROM (SELECT node_1 as node_id, arccat_id, v_edit_arc.expl_id FROM v_edit_arc WHERE node_1 IN (SELECT node_id FROM v_edit_node JOIN cat_node ON id=nodecat_id WHERE ischange=1) UNION SELECT node_2, arccat_id, v_edit_arc.expl_id FROM v_edit_arc WHERE node_2 IN (SELECT node_id FROM v_edit_node JOIN cat_node ON id=nodecat_id WHERE ischange=1) GROUP BY 1,2,3) a	JOIN node n USING (node_id) GROUP BY 1,3,4,5 HAVING count(*) <> 2', info_msg='No nodes ''ischange'' without real change have been found.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=208;
UPDATE sys_fprocess SET fprocess_name='Change of dn/pn/material without node ischange', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes where arc catalog changes without nodecat with ischange on 0 or 2 (false or maybe). Please, check your data before continue.', query_text='SELECT node_id, nodecat_id, array_agg(arccat_id) as arccat_id, the_geom, node.expl_id FROM ( SELECT count(*), node_id, arccat_id FROM   (SELECT node_1 as node_id, arccat_id FROM v_prefix_arc UNION ALL SELECT node_2, arccat_id FROM v_prefix_arc)a GROUP BY 2,3 HAVING count(*) <> 2 ORDER BY 2) b   JOIN node USING (node_id) JOIN cat_node ON id=nodecat_id WHERE ischange=0 GROUP By 1,2,4,5 HAVING count(*)=2', info_msg='No nodes without ''ischange'' where arc changes have been found', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=209;
UPDATE sys_fprocess SET fprocess_name='Connecs with customer code null', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='connecs with customer code null. Please, check your data before continue', query_text='SELECT connec_id FROM v_prefix_connec WHERE state=1 and customer_code IS NULL', info_msg='No connecs with null customer code.', function_name='[gw_fct_om_check_data]' WHERE fid=210;
UPDATE sys_fprocess SET fprocess_name='Check arc drawing direction', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='arcs with drawing direction different than definition of node_1, node_2', query_text='SELECT a.arc_id , arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a, v_prefix_node n WHERE st_dwithin(st_startpoint(a.the_geom), n.the_geom, 0.0001) and node_2 = node_id   UNION   SELECT a.arc_id , arccat_id, a.the_geom, a.expl_id  FROM v_prefix_arc a, v_prefix_node n WHERE st_dwithin(st_endpoint(a.the_geom), n.the_geom, 0.0001) and node_1 = node_id', info_msg='No arcs with drawing direction different than definition of node_1, node_2', function_name='[gw_fct_om_check_data]' WHERE fid=223;
UPDATE sys_fprocess SET fprocess_name='arcs less than 20 cm.', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='pipes with length less than node proximity distance configured.', query_text='SELECT * FROM v_edit_inp_pipe WHERE st_length(the_geom) < (SELECT value::json->>''value'' FROM config_param_system WHERE parameter = ''edit_node_proximity'')::float', info_msg='Standard minimun length checked. No values less than node proximity distance configured.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=229;
UPDATE sys_fprocess SET fprocess_name='arcs less than 5 cm.', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=3, except_msg='pipes with length less than configured minimum length.', query_text='SELECT the_geom, st_length(the_geom) AS length FROM v_edit_inp_pipe WHERE st_length(the_geom) < (SELECT value FROM config_param_system WHERE parameter = ''epa_arc_minlength'')::float', info_msg='Critical minimun length checked. No values less than configured minimum length found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=230;
UPDATE sys_fprocess SET fprocess_name='Conduits with negative slope and inverted slope', "source"='core', fprocess_type='Check om-topology', project_type='ud', except_level=3, except_msg='arcs with inverted slope false and slope negative values. Please, check your data before continue', query_text='SELECT a.arc_id, arccat_id, a.the_geom, expl_id FROM arc a WHERE sys_slope < 0 AND state > 0 AND inverted_slope IS FALSE', info_msg='No arcs with inverted slope checked found.', function_name='[gw_fct_om_check_data]' WHERE fid=251;
UPDATE sys_fprocess SET fprocess_name='Features state=2 are involved in psector', "source"='core', fprocess_type='Check plan-config', project_type='ws', except_level=3, except_msg='planified arcs without psector. planified nodes without psector. planified connecs without psector. planified gullys without psector. features with state=2 without psector assigned. Please, check your data before continue', query_text='SELECT a.feature_id, a.feature, a.catalog, a.the_geom, count(*) FROM (
SELECT node_id as feature_id, ''NODE'' as feature, nodecat_id as catalog, 
the_geom FROM v_edit_node WHERE state=2 AND node_id NOT IN 
(select node_id FROM plan_psector_x_node) UNION 
SELECT arc_id as feature_id, ''ARC'' as feature, arccat_id as catalog, the_geom  
FROM v_edit_arc WHERE state=2 AND arc_id NOT IN 
(select arc_id FROM plan_psector_x_arc) UNION 
SELECT connec_id as feature_id, ''CONNEC'' as feature, conneccat_id  as catalog, 
the_geom  FROM v_edit_connec WHERE state=2 AND connec_id NOT IN 
(select connec_id FROM plan_psector_x_connec)) a  
GROUP BY a.feature_id, a.feature , a.catalog, a.the_geom', info_msg='There are no features with state=2 without psector.', function_name='[gw_fct_plan_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=252;
UPDATE sys_fprocess SET fprocess_name='State not according with state_type', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with state without concordance with state_type. Please, check your data before continue features with state without concordance with state_type. Please, check your data before continue', query_text='SELECT arc_id as id, a.state, state_type FROM v_prefix_arc a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state UNION 
SELECT node_id as id, a.state, state_type FROM v_prefix_node a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state UNION 
SELECT connec_id as id, a.state, state_type FROM v_prefix_connec a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state UNION 
SELECT element_id as id, a.state, state_type FROM v_prefix_element a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state', info_msg='No features without concordance against state and state_type.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=253;
UPDATE sys_fprocess SET fprocess_name='Features with code null', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with code with NULL values. Please, check your data before continue with code with NULL values. Please, check your data before continue', query_text='SELECT arc_id, arccat_id FROM v_prefix_arc WHERE code IS NULL UNION 
SELECT node_id, nodecat_id FROM v_prefix_node WHERE code IS NULL UNION 
SELECT connec_id, conneccat_id FROM v_prefix_connec WHERE code IS NULL UNION 
SELECT element_id, elementcat_id FROM v_prefix_element WHERE code IS NULL', info_msg='No features (arc, node, connec, element) with NULL values on code found.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=254;
UPDATE sys_fprocess SET fprocess_name='Connec or gully without or with wrong arc_id', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs without or with incorrect arc_id. gullies without or with incorrect arc_id.', query_text='SELECT c.connec_id, c.conneccat_id, c.the_geom, c.expl_id, l.feature_type, link_id FROM arc a, link l 
JOIN connec c ON l.feature_id = c.connec_id WHERE st_dwithin(a.the_geom, st_endpoint(l.the_geom), 0.01) AND exit_type = ''ARC'' 
AND (a.arc_id <> c.arc_id or c.arc_id is null)   AND l.feature_type = ''CONNEC'' AND a.state=1 and c.state = 1 and l.state=1 EXCEPT 
SELECT c.connec_id, c.conneccat_id, c.the_geom, c.expl_id, l.feature_type, link_id  FROM node n, link l JOIN connec c ON l.feature_id = c.connec_id 
WHERE st_dwithin(n.the_geom, st_endpoint(l.the_geom), 0.01) AND exit_type IN (''NODE'', ''ARC'')  AND l.feature_type = ''CONNEC'' AND n.state=1 and c.state = 1 
and l.state=1 ORDER BY feature_type, link_id', info_msg='All connecs have correct arc_id. All gullies have correct arc_id.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=257;
UPDATE sys_fprocess SET fprocess_name='Link without feature_id', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='links with state > 0 without feature_id.', query_text='SELECT link_id, the_geom FROM v_prefix_link where feature_id is null and state > 0', info_msg='All links state > 0 have feature_id.', function_name='[gw_fct_om_check_data]' WHERE fid=260;
UPDATE sys_fprocess SET fprocess_name='Link without exit_id', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='links with state > 0 without exit_id.', query_text='SELECT link_id, the_geom FROM v_prefix_link where exit_id is null and state > 0', info_msg='All links state > 0 have exit_id.', function_name='[gw_fct_om_check_data]' WHERE fid=261;
UPDATE sys_fprocess SET fprocess_name='Features state=1 and end date', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features on service with value of end date.', query_text='SELECT arc_id as feature_id  from v_prefix_arc where state = 1 and enddate is not null UNION 
SELECT node_id from v_prefix_node where state = 1 and enddate is not null UNION 
SELECT connec_id from v_prefix_connec where state = 1 and enddate is not null', info_msg='No features on service have value of end date', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=262;
UPDATE sys_fprocess SET fprocess_name='Features state=0 without end date', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features with state 0 without value of end date.', query_text='SELECT arc_id as feature_id  from v_prefix_arc where state = 0 and enddate is null UNION 
SELECT node_id from v_prefix_node where state = 0 and enddate is null UNION 
SELECT connec_id from v_prefix_connec where state = 0 and enddate is null ', info_msg='No features with state 0 are missing the end date', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=263;
UPDATE sys_fprocess SET fprocess_name='Features state=1 and end date before start date', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features with end date earlier than built date.', query_text='SELECT arc_id as feature_id  from v_prefix_arc where enddate < builtdate and state = 1 UNION 
SELECT node_id from v_prefix_node where enddate < builtdate and state = 1 UNION 
SELECT connec_id from v_prefix_connec where enddate < builtdate and state = 1', info_msg='No features with end date earlier than built date', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=264;
UPDATE sys_fprocess SET fprocess_name='Automatic links with more than 100m', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='automatic links with longitude out-of-range found.', query_text='SELECT * FROM v_prefix_link where st_length(the_geom) > 100', info_msg='No automatic links with out-of-range Longitude found.', function_name='[gw_fct_om_check_data]' WHERE fid=265;
UPDATE sys_fprocess SET fprocess_name='Duplicated ID between arc, node, connec, gully', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with duplicated ID value between arc, node, connec, gully features with duplicated ID values between arc, node, connec, gully', query_text='SELECT node_id AS feature_id FROM v_prefix_node n JOIN v_prefix_arc a ON a.arc_id=n.node_id UNION
SELECT node_id FROM v_prefix_node n JOIN v_prefix_connec c ON c.connec_id=n.node_id UNION 
SELECT a.arc_id FROM v_prefix_arc a JOIN v_prefix_connec c ON c.connec_id=a.arc_id', info_msg='All features have a diferent ID to be correctly identified', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=266;
UPDATE sys_fprocess SET fprocess_name='Sectors without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='sectors on sector table with graphconfig not configured.', query_text='SELECT * FROM v_edit_sector WHERE graphconfig IS NULL and sector_id > 0', info_msg='All sectors has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=268;
UPDATE sys_fprocess SET fprocess_name='DMA without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='dmas on dma table with graphconfig not configured.', query_text='SELECT * FROM v_edit_dma WHERE graphconfig IS NULL and dma_id > 0', info_msg='All dma has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=269;
UPDATE sys_fprocess SET fprocess_name='DQA without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='dqas on dqa table with graphconfig not configured.', query_text='SELECT * FROM v_edit_dqa WHERE graphconfig IS NULL and dqa_id > 0', info_msg='All dqa has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=270;
UPDATE sys_fprocess SET fprocess_name='Presszone without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='presszones on presszone table with graphconfig not configured.', query_text='SELECT * FROM v_edit_presszone WHERE graphconfig IS NULL and presszone_id > 0', info_msg='All presszones has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=271;
UPDATE sys_fprocess SET fprocess_name='Missing data on inp tables', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='missed features on inp tables. Please, check your data before continue', query_text='SELECT arc_id, ''arc'' FROM v_edit_arc LEFT JOIN    
(SELECT arc_id from inp_pipe UNION SELECT arc_id FROM inp_virtualpump) b using (arc_id)   
WHERE b.arc_id IS NULL AND state > 0 AND epa_type !=''UNDEFINED'' 
UNION 
SELECT node_id, ''node'' FROM v_edit_node LEFT JOIN
(select node_id from inp_shortpipe UNION select node_id from inp_valve ç
UNION select node_id from inp_tank 
UNION select node_id FROM inp_reservoir 
UNION select node_id FROM inp_pump
UNION SELECT node_id from inp_inlet
UNION SELECT node_id from inp_junction) b USING (node_id)
WHERE b.node_id IS NULL AND state >0 AND epa_type !=''UNDEFINED''', info_msg='No features missed on inp_tables found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=272;
UPDATE sys_fprocess SET fprocess_name='Null values on valve_type table', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='valves with null values on valve_type column.', query_text='SELECT * FROM v_edit_inp_valve WHERE valve_type IS NULL', info_msg='Valve valve_type checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=273;
UPDATE sys_fprocess SET fprocess_name='Null values on valve status', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='valves with null values on mandatory column status.', query_text='SELECT * FROM v_edit_inp_valve WHERE status IS NULL AND state > 0', info_msg='Valve status checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=274;
UPDATE sys_fprocess SET fprocess_name='Null values on valve pressure', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='PBV-PRV-PSV valves with null values on the mandatory column for Pressure valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))', info_msg='PBC-PRV-PSV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=275;
UPDATE sys_fprocess SET fprocess_name='Null values on GPV valve config', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='GPV valves with null values on mandatory column for General purpose valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))', info_msg='GPV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=276;
UPDATE sys_fprocess SET fprocess_name='Null values on TCV valve config', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='TCV valves with null values on mandatory column for Losses Valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE valve_type=''TCV'' AND setting IS NULL', info_msg='TCV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=277;
UPDATE sys_fprocess SET fprocess_name='Null values on FCV valve config', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='FCV valves with null values on mandatory column for Flow Control Valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE ((valve_type=''FCV'') AND (setting IS NULL))', info_msg='FCV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=278;
UPDATE sys_fprocess SET fprocess_name='Null values on pump type', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with null values on pump_type column. virtualpump''''s with null values on pump_type column.', query_text='SELECT * FROM v_edit_inp_pump WHERE pump_type IS NULL', info_msg='Pumps checked. No mandatory values for pump_type missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=279;
UPDATE sys_fprocess SET fprocess_name='Null values on pump curve_id ', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with null values at least on mandatory column curve_id. virtualpumps with null values at least on mandatory column curve_id.', query_text='SELECT * FROM v_edit_inp_pump WHERE curve_id IS NULL', info_msg='Pumps checked. No mandatory values for curve_id missed. Virtualpumps checked. No mandatory values for curve_id missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=280;
UPDATE sys_fprocess SET fprocess_name='Null values on additional pump curve_id ', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='additional pumps with null values at least on mandatory column curve_id.', query_text='SELECT * FROM inp_pump_additional JOIN v_edit_inp_pump USING (node_id) WHERE inp_pump_additional.curve_id IS NULL', info_msg='Additional pumps checked. No mandatory values for curve_id missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=281;
UPDATE sys_fprocess SET fprocess_name='Null values on roughness catalog ', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='pipes with null values for roughness. Check roughness catalog columns (init_age,end_age,roughness) before continue.''', query_text='SELECT * FROM v_edit_inp_pipe JOIN cat_arc ON id = arccat_id JOIN cat_mat_roughness USING  (matcat_id) WHERE init_age IS NULL OR end_age IS NULL OR roughness IS NULL', info_msg='Roughness catalog checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=282;
UPDATE sys_fprocess SET fprocess_name='Null values on arc catalog - dint', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='registers on arc''''s catalog with null values on dint column.''', query_text='SELECT * FROM cat_arc WHERE dint IS NULL', info_msg='Dint for arc''''s catalog checked. No values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=283;
UPDATE sys_fprocess SET fprocess_name='Arcs without elevation', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='arcs without values on sys_elev1 or sys_elev2.', query_text='SELECT * FROM v_edit_arc JOIN selector_sector USING (sector_id) WHERE cur_user = current_user AND sys_elev1 = NULL OR sys_elev2 = NULL', info_msg='No arcs with null values on field elevation (sys_elev1 or sys_elev2) have been found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=284;
UPDATE sys_fprocess SET fprocess_name='Null values on raingage', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='raingages with null values at least on mandatory columns for rain type (form_type, intvl, rgage_type).', query_text='SELECT * FROM v_edit_raingage where (form_type is null) OR (intvl is null) OR (rgage_type is null)', info_msg='Mandatory colums for raingage (form_type, intvl, rgage_type) have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=285;
UPDATE sys_fprocess SET fprocess_name='Null values on raingage timeseries', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='raingages with null values on the mandatory column for ''TIMESERIES'' raingage type', query_text='SELECT * FROM v_edit_raingage where rgage_type=''TIMESERIES'' AND timser_id IS NULL', info_msg='Mandatory colums for ''TIMESERIES'' raingage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=286;
UPDATE sys_fprocess SET fprocess_name='Null values on raingage file', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='raingages with null values at least on mandatory columns for ''FILE'' raingage type (fname, sta, units).', query_text='SELECT * FROM v_edit_raingage where rgage_type=''FILE'' AND (fname IS NULL or sta IS NULL or units IS NULL)', info_msg='Mandatory colums (fname, sta, units) for ''FILE'' raingage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=287;
UPDATE sys_fprocess SET fprocess_name='Connec or gully with different expl_id than arc', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='connecs with exploitation different than the exploitation of the related arc', query_text='SELECT DISTINCT connec_id, conneccat_id, c.the_geom, c.expl_id 
FROM v_prefix_connec c JOIN v_prefix_arc b using (arc_id) WHERE b.expl_id::text != c.expl_id::text', info_msg='All connecs or gullys have the same exploitation as the related arc', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=291;
UPDATE sys_fprocess SET fprocess_name='Check for inp_node tables and epa_type consistency', "source"='core', fprocess_type='Check epa-data', project_type='utils', except_level=3, except_msg='node features with epa_type not according with epa table. Check your data before continue', query_text='SELECT * FROM t_anl_node WHERE fid=294 AND cur_user=current_user', info_msg='Epa type for node features checked. No inconsistencies aganints epa table found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=294;
UPDATE sys_fprocess SET fprocess_name='Check for inp_arc tables and epa_type consistency', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='arcs features with epa_type not according with epa table. Check your data before continue.', query_text='SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_pump table'') AS epa_table, a.the_geom FROM v_edit_inp_pump JOIN arc a USING (arc_id) WHERE epa_type !=''PUMP''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_conduit table'') AS epa_table, a.the_geom FROM v_edit_inp_conduit JOIN arc a USING (arc_id) WHERE epa_type !=''CONDUIT''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_outlet table'') AS epa_table, a.the_geom FROM v_edit_inp_outlet JOIN arc a USING (arc_id) WHERE epa_type !=''OUTLET''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_orifice table'') AS epa_table, a.the_geom FROM v_edit_inp_orifice JOIN arc a USING (arc_id) WHERE epa_type !=''ORIFICE''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_weir table'') AS epa_table, a.the_geom FROM v_edit_inp_weir JOIN arc a USING (arc_id) WHERE epa_type !=''WEIR''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_virtual table'') AS epa_table, a.the_geom FROM v_edit_inp_virtual JOIN arc a USING (arc_id) WHERE epa_type !=''VIRTUAL''', info_msg='Epa type for arcs features checked. No inconsistencies aganints epa table found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=295;
UPDATE sys_fprocess SET fprocess_name='Check values of system variables', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='system variables with out-of-standard values.', query_text='SELECT parameter FROM config_param_system WHERE lower(value) != lower(standardvalue) AND standardvalue IS NOT NULL  AND  standardvalue NOT ILIKE ''{%}'' UNION 
SELECT parameter FROM config_param_system  WHERE lower(json_extract_path_text(value::json,''activated'')) != lower(json_extract_path_text(standardvalue::json,''activated'')) AND standardvalue IS NOT NULL AND standardvalue ILIKE ''{%}''', info_msg='No system variables with values out-of-standars found.', function_name='[gw_fct_om_check_data]' WHERE fid=302;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature field active', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features without value on field "active" from cat_feature.', query_text='SELECT * FROM cat_feature WHERE active IS NULL', info_msg='All features have value on field "active"', function_name='[gw_fct_admin_check_data]' WHERE fid=303;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature field code_autofill', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features without value on field "code_autofill" from cat_feature.', query_text='SELECT * FROM cat_feature WHERE code_autofill IS NULL', info_msg='All features have value on field "code_autofill"', function_name='[gw_fct_admin_check_data]' WHERE fid=304;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field num_arcs', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "num_arcs" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE num_arcs IS NULL', info_msg='All nodes have value on field "num_arcs"', function_name='[gw_fct_admin_check_data]' WHERE fid=305;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field isarcdivide', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "isarcdivide" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE isarcdivide IS NULL', info_msg='All nodes have value on field "isarcdivide"', function_name='[gw_fct_admin_check_data]' WHERE fid=306;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field graph_delimiter', "source"='core', fprocess_type='Check admin', project_type='ws', except_level=3, except_msg='nodes without value on field "graph_delimiter" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE graph_delimiter IS NULL', info_msg='All nodes have value on field "graph_delimiter"', function_name='[gw_fct_admin_check_data]' WHERE fid=307;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field isexitupperintro', "source"='core', fprocess_type='Check admin', project_type='ud', except_level=3, except_msg='nodes without value on field "isexitupperintro" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE isexitupperintro IS NULL', info_msg='All nodes have value on field "isexitupperintro"', function_name='[gw_fct_admin_check_data]' WHERE fid=308;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field choose_hemisphere', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "choose_hemisphere" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE choose_hemisphere IS NULL', info_msg='All nodes have value on field "choose_hemisphere"', function_name='[gw_fct_admin_check_data]' WHERE fid=309;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field isprofilesurface', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "isprofilesurface" from cat_feature_node. Features - '',v_feature_list::text,''.''', query_text='SELECT * FROM cat_feature_node WHERE isprofilesurface IS NULL', info_msg='All nodes have value on field "isprofilesurface"', function_name='[gw_fct_admin_check_data]' WHERE fid=310;
UPDATE sys_fprocess SET fprocess_name='Check child view man table definition', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='view wrongly defined man_table', query_text='WITH subq_1 as (
SELECT id, feature_class, feature_type, child_layer from cat_feature
), subq_2 as (
select*from information_schema.views a join subq_1 m on m.child_layer = a.table_name
where a.table_schema = current_schema
), subq_3 as (
select position(concat(''man_'',lower(feature_type)) in view_definition) from subq_2
)
select*from subq_3 where position = 0', info_msg='All views are well defined in man_table', function_name='[gw_fct_admin_check_data]' WHERE fid=311;
UPDATE sys_fprocess SET fprocess_name='Check child view addfields', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=2, except_msg='active addfields that may not be present on its corresponding child view:', query_text='WITH subq AS (
    SELECT s.param_name, s.cat_feature_id FROM sys_addfields s
    LEFT JOIN cat_feature f ON s.cat_feature_id = f.id
    WHERE s.feature_type = ''CHILD'' AND s.active IS TRUE AND s.cat_feature_id IS NULL
)
SELECT string_agg(concat(key, '': '', value), ''; '') AS "string_agg"
FROM (SELECT key, value 
        FROM subq, json_each_text(json_build_object(''addfield'', COALESCE(param_name, ''null''), ''cat_feature'', COALESCE(cat_feature_id::text, ''null'')
             )
         )
) AS pairs', info_msg='All active addfields exist on its corresponing view.', function_name='[gw_fct_admin_check_data]' WHERE fid=312;
UPDATE sys_fprocess SET fprocess_name='Find not existing child views', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='views defined in cat_feature table but is not created in a DB.', query_text='SELECT c.child_layer FROM cat_feature c
left join information_schema.views a on a.table_name= c.child_layer
where a.table_schema = current_schema and a.view_definition is null', info_msg='All child views are created and defined in cat_feature and', function_name='[gw_fct_admin_check_data]' WHERE fid=313;
UPDATE sys_fprocess SET fprocess_name='Find active features without child views', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='active features which views names are not present in cat_feature table.', query_text='SELECT string_agg(id,'','') FROM cat_feature WHERE active IS TRUE AND child_layer IS NULL', info_msg='All active features have child view name in cat_feature table', function_name='[gw_fct_admin_check_data]' WHERE fid=314;
UPDATE sys_fprocess SET fprocess_name='Check definition on config_info_layer_x_type', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='active features which views are not defined in config_info_layer_x_type.', query_text='SELECT string_agg(id, ''; '') FROM cat_feature WHERE active IS TRUE AND child_layer not in (select tableinfo_id FROM config_info_layer_x_type)', info_msg='All active features have child view defined in config_info_layer_x_type', function_name='[gw_fct_admin_check_data]' WHERE fid=315;
UPDATE sys_fprocess SET fprocess_name='Check definition on config_form_fields', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='active features which views are not defined in config_form_fields.', query_text='SELECT string_agg(concat(cat_feature_id, '': '', param_name), ''; '') FROM sys_addfields 
JOIN cat_feature ON cat_feature.id=sys_addfields.cat_feature_id WHERE sys_addfields.active IS TRUE AND param_name not IN 
(SELECT columnname FROM config_form_fields JOIN cat_feature ON cat_feature.child_layer=formname)', info_msg='All active features have child view defined in config_form_fields', function_name='[gw_fct_admin_check_data]' WHERE fid=316;
UPDATE sys_fprocess SET fprocess_name='Find ve_* views not defined in cat_feature', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=2, except_msg='views defined in a DB but is not related to any feature in cat_feature.', query_text='select string_agg(child_layer,'','') FROM cat_feature where child_layer IS NOT NULL', info_msg='All views in DB are related to features in cat_feature', function_name='[gw_fct_admin_check_data]' WHERE fid=317;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields field datatype', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features form fields in config_form_fields that don''''t have data type.', query_text='SELECT string_agg(concat(formname, '': '', columnname), ''; '') FROM config_form_fields WHERE datatype IS NULL AND formtype=''form_feature''', info_msg='All feature form fields have defined data type.', function_name='[gw_fct_admin_check_data]' WHERE fid=318;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields field widgettype', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features form fields in config_form_fields that don''''t have widget type.', query_text='SELECT string_agg(concat(formname, '': '', columnname), ''; '') FROM config_form_fields WHERE widgettype IS NULL AND formtype=''form_feature''', info_msg='All feature form fields have defined widget type.', function_name='[gw_fct_admin_check_data]' WHERE fid=319;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields field dv_querytext', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features form fields in config_form_fields that are combo or typeahead but don''''t have dv_querytext defined.', query_text='SELECT string_agg(concat(formname, '': '', columnname), ''; '') FROM config_form_fields WHERE (widgettype = ''combo'' or widgettype =''typeahead'') and dv_querytext is null and columnname !=''composer''
', info_msg='All feature form fields with widget type combo or typeahead have dv_querytext defined.', function_name='[gw_fct_admin_check_data]' WHERE fid=320;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields for addfields definition', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='addfields that are not defined in config_form_fields.', query_text='SELECT string_agg(param_name, ''; '') FROM sys_addfields 
JOIN cat_feature ON cat_feature.id=sys_addfields.cat_feature_id WHERE sys_addfields.active IS TRUE AND param_name not IN 
(SELECT columnname FROM config_form_fields JOIN cat_feature ON cat_feature.child_layer=formname)', info_msg='All addfields are defined in config_form_fields.', function_name='[gw_fct_admin_check_data]' WHERE fid=321;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields layoutorder duplicated', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='form names with duplicated layout order defined in config_form_fields: ''', query_text='SELECT array_agg(a.list::text) FROM (SELECT concat(''Formname: '',formname, '', layoutname: '',layoutname, '', layoutorder: '',layoutorder) as list FROM config_form_fields WHERE formtype = ''feature'' AND hidden is false 
group by layoutorder,formname,layoutname having count(*)>1)a', info_msg='All fields defined in config_form_fields have unduplicated order.', function_name='[gw_fct_admin_check_data]' WHERE fid=322;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field active', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=3, except_msg='rows without values on cat_arc.active column.', query_text='SELECT * FROM cat_arc WHERE active IS NULL', info_msg='There is/are no rows without values on cat_arc.active column.', function_name='[gw_fct_plan_check_data]' WHERE fid=323;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_arc.cost column.', query_text='SELECT * FROM cat_arc WHERE cost IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_arc.cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=324;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field m2bottom_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_arc.m2bottom_cost column.', query_text='SELECT * FROM cat_arc WHERE m2bottom_cost IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_arc.m2bottom_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=325;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field m3protec_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_arc.m3protec_cost column.', query_text='SELECT * FROM cat_arc WHERE m3protec_cost IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_arc.m3protec_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=326;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field active', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=3, except_msg='rows without values on cat_node.active column.', query_text='SELECT * FROM cat_node WHERE active IS NULL', info_msg='There is/are no rows without values on cat_node.active column.', function_name='[gw_fct_plan_check_data]' WHERE fid=327;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_node.cost column.', query_text='SELECT * FROM cat_node WHERE cost IS NULL and active=TRUE', info_msg='There is/are no rows rows without values on cat_node.cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=328;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field cost_column', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_node.cost_unit column.', query_text='SELECT * FROM cat_node WHERE cost_unit IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_node.cost_unit column.', function_name='[gw_fct_plan_check_data]' WHERE fid=329;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field estimated_depth', "source"='core', fprocess_type='Check plan-config', project_type='ws', except_level=2, except_msg='rows without values on cat_node.estimated_depth column.', query_text='SELECT * FROM cat_node WHERE estimated_depth IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_node.estimated_depth column.', function_name='[gw_fct_plan_check_data, gw_fct_admin_check_data]' WHERE fid=330;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field estimated_y', "source"='core', fprocess_type='Check plan-config', project_type='ud', except_level=2, except_msg='rows without values on cat_node.estimated_y column.', query_text='SELECT * FROM cat_node WHERE estimated_y IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_node.estimated_y column.', function_name='[gw_fct_plan_check_data]' WHERE fid=331;
UPDATE sys_fprocess SET fprocess_name='Check cat_connec field active', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=3, except_msg='rows without values on cat_connec.active column.', query_text='SELECT * FROM cat_connec WHERE active IS NULL', info_msg='There is/are no rows without values on cat_connec.active column column.', function_name='[gw_fct_plan_check_data]' WHERE fid=332;
UPDATE sys_fprocess SET fprocess_name='Check cat_pavement field thickness', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_pavement.thickness column.', query_text='SELECT * FROM cat_pavement WHERE thickness IS NULL', info_msg='There is/are no rows without values on cat_pavement.thickness column.', function_name='[gw_fct_plan_check_data]' WHERE fid=336;
UPDATE sys_fprocess SET fprocess_name='Check cat_pavement field m2cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_pavement.m2_cost column.', query_text='SELECT * FROM cat_pavement WHERE m2_cost IS NULL', info_msg='There is/are no rows without values on cat_pavement.m2_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=337;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field y_param', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.y_param column.', query_text='SELECT * FROM cat_soil WHERE y_param IS NULL', info_msg='There is/are no rows without values on cat_soil.y_param column.', function_name='[gw_fct_plan_check_data]' WHERE fid=338;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field b', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.b column.', query_text='SELECT * FROM cat_soil WHERE b IS NULL', info_msg='There is/are no rows without values on cat_soil.b column.', function_name='[gw_fct_plan_check_data]' WHERE fid=339;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m3exc_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m3exc_cost column.', query_text='SELECT * FROM cat_soil WHERE m3exc_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m3exc_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=340;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m3fill_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m3fill_cost column.', query_text='SELECT * FROM cat_soil WHERE m3fill_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m3fill_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=341;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m3excess_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m3excess_cost column.', query_text='SELECT * FROM cat_soil WHERE m3excess_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m3excess_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=342;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m2trenchl_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m2trenchl_cost column.', query_text='SELECT * FROM cat_soil WHERE m2trenchl_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m2trenchl_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=343;
UPDATE sys_fprocess SET fprocess_name='Check cat_grate field active', "source"='core', fprocess_type='Check plan-config', project_type='ud', except_level=3, except_msg='rows without values on cat_gully.active column.', query_text='SELECT * FROM cat_gully WHERE active IS NULL', info_msg='There is/are no rows without values on cat_gully.active column.', function_name='[gw_fct_plan_check_data]' WHERE fid=344;
UPDATE sys_fprocess SET fprocess_name='Check plan_arc_x_pavement rows number', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=1, except_msg='rows more in arc than in table plan_arc_x_pavement', query_text='with arcs as (SELECT count(*) as a FROM arc WHERE state>0),
pavs as (SELECT count(*) as b FROM plan_arc_x_pavement)
select case when b < a then a-b else 0 end from arcs, pavs', info_msg='The number of rows of the plan_arc_x_pavement table is same than the arc table.', function_name='[gw_fct_plan_check_data]' WHERE fid=346;
UPDATE sys_fprocess SET fprocess_name='Check plan_arc_x_pavement field pavcat_id', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on plan_arc_x_pavement.pavcat_id column.', query_text='SELECT * FROM plan_arc_x_pavement WHERE pavcat_id IS NOT NULL', info_msg='There is/are no rows without values on rows without values on plan_arc_x_pavement.pavcat_id column.', function_name='[gw_fct_plan_check_data]' WHERE fid=347;
UPDATE sys_fprocess SET fprocess_name='Check arc state=2 with final nodes in psector', "source"='core', fprocess_type='Check plan-data', project_type='utils', except_level=3, except_msg='operative arcs without final nodes in some psector.', query_text='SELECT DISTINCT ON (arc_id) * FROM (SELECT a.arc_id, a.arccat_id, pa.psector_id , node_1 as node, a.the_geom FROM v_edit_arc a  JOIN plan_psector_x_node pn1 ON pn1.node_id = a.node_1  left JOIN plan_psector_x_arc pa using (arc_id)  WHERE a.state = 1 AND pn1.state = 0 and pa.psector_id is null  UNION  SELECT a.arc_id, a.arccat_id, pa.psector_id, node_2, a.the_geom FROM v_edit_arc a  JOIN plan_psector_x_node pn2 ON pn2.node_id = a.node_2  left JOIN plan_psector_x_arc pa using (arc_id)  WHERE a.state = 1 AND pn2.state = 0 and pa.psector_id is null  ) b', info_msg='There are no arcs with state=1 with final nodes obsolete in psector.', function_name='[gw_fct_plan_check_data]' WHERE fid=354;
UPDATE sys_fprocess SET fprocess_name='Check arc state=2 with operative nodes in psector', "source"='core', fprocess_type='Check plan-data', project_type='utils', except_level=3, except_msg='planified arcs without final in some psector.', query_text='SELECT * FROM ( SELECT pa.arc_id, a.arccat_id, pa.psector_id , node_1 as node, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id) JOIN plan_psector_x_node pn1 ON pn1.node_id = a.node_1 WHERE pa.psector_id = pn1.psector_id AND pa.state = 1 AND pn1.state = 0 UNION SELECT pa.arc_id, a.arccat_id, pa.psector_id, node_2, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id) JOIN plan_psector_x_node pn2 ON pn2.node_id = a.node_2 WHERE pa.psector_id = pn2.psector_id AND pa.state = 1 AND pn2.state = 0) b', info_msg='There are no arcs with state=2 with final nodes obsolete in psector.', function_name='[gw_fct_plan_check_data]' WHERE fid=355;
UPDATE sys_fprocess SET fprocess_name='Planned connecs without reference link', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='planned connecs without reference link planned connecs or gullys without reference link', query_text='SELECT * FROM plan_psector_x_connec WHERE link_id IS NULL ', info_msg='All planned connecs or gullys have a reference link', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=356;
UPDATE sys_fprocess SET fprocess_name='Check if defined nodes and arcs exist in a database', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='arcs that are configured as toArc for v_prefix_v_graphClass but is not operative on arc table.', query_text='SELECT b.arc_id, b.v_graphClass_id as zone_id FROM ( SELECT v_graphClass_id, json_array_elements_text(((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''toArc'')::json)::integer as arc_id FROM v_prefix_v_graphClass)b 
WHERE arc_id not in (select arc_id FROM arc WHERE state=1)', info_msg='All arcs defined as toArc on v_prefix_v_graphClass exists on DB.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=367;
UPDATE sys_fprocess SET fprocess_name='Null values on to_arc valves', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='valves with missed values on mandatory column to_arc.', query_text='SELECT * FROM v_edit_inp_valve WHERE to_arc IS NULL', info_msg='Valve to_arc missed values checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=368;
UPDATE sys_fprocess SET fprocess_name='Check arc catalog with matcat_id null', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='rows with missed matcat_id on cat_arc table. Fix it before continue''', query_text='SELECT * FROM cat_arc WHERE matcat_id IS NULL', info_msg='No registers found without material on cat_arc table.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=371;
UPDATE sys_fprocess SET fprocess_name='Check operative arcs with wrong topology', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='operative arcs with wrong topology.', query_text='with mec as (SELECT arc_id, node_1, node_2, expl_id,state, the_geom
			 FROM arc WHERE state = 1),
	n1 as (SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_startpoint(arc.the_geom))) as d FROM node, arc 
	WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_startpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
	), n2 as (
	SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_endpoint(arc.the_geom))) as d FROM node, arc 
	WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_endpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
	)
	select*from mec m 
		left join n1 on m.arc_id = n1.arc_id
		left join n2 on m.arc_id = n2.arc_id 
		  where (m.node_1 != n1.node_id) or (m.node_1 != n1.node_id)', info_msg='All arcs has well-defined topology', function_name='[gw_fct_om_check_data]' WHERE fid=372;
UPDATE sys_fprocess SET fprocess_name='Check undefined nodes as topological nodes', "source"='core', fprocess_type='Check epa-topology', project_type='utils', except_level=2, except_msg='nodes with epa_type UNDEFINED acting as node_1 or node_2 of arcs. Please, check your data before continue.''', query_text='SELECT n.node_id, nodecat_id, the_geom, n.expl_id FROM 
(SELECT node_1 node_id, sector_id FROM v_edit_arc WHERE epa_type !=''UNDEFINED'' UNION 
SELECT node_2, sector_id FROM arc WHERE epa_type !=''UNDEFINED'' )a JOIN  
(SELECT node_id, nodecat_id, the_geom, expl_id FROM v_edit_node WHERE epa_type = ''UNDEFINED'') n USING (node_id) 
JOIN selector_sector USING (sector_id) WHERE n.node_id IS NOT NULL AND cur_user = current_user', info_msg='No nodes with epa_type UNDEFINED acting as node_1 or node_2 of arcs found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=379;
UPDATE sys_fprocess SET fprocess_name='Check missed values for storage volume', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='storages with null values at least on mandatory columns to define volume parameters (a1,a2,a0 for FUNCTIONAL or curve_id for TABULAR).', query_text='SELECT * FROM v_edit_inp_storage where (a1 is null and a2 is null and a0 is null AND storage_type=''FUNCTIONAL'') OR (curve_id IS NULL AND storage_type=''TABULAR'')', info_msg='Mandatory colums for volume values used on storage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=382;
UPDATE sys_fprocess SET fprocess_name='Check missed values for cat_mat.arc n used on real arcs', "source"='core', fprocess_type='Check epa-config', project_type='ud', except_level=3, except_msg='materials with null values on manning coefficient column used on a real arc where manning is needed.', query_text='SELECT DISTINCT cat_material.* FROM cat_material JOIN v_edit_arc ON matcat_id = id where sys_type !=''VARC'' AND n is null', info_msg='Manning coefficient on cat_material is filled for those materials used on real arcs (not varcs).', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=383;
UPDATE sys_fprocess SET fprocess_name='Arcs shorter than value set as node proximity', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='arcs with length shorter than value set as node proximity. Please, check your data before continue', query_text='SELECT arc_id,arccat_id,st_length(the_geom), the_geom, expl_id, json_extract_path_text(value::json,''value'')::numeric as nprox 
FROM v_prefix_arc, config_param_system where parameter = ''edit_node_proximity'' 
and  st_length(the_geom) < json_extract_path_text(value::json,''value'')::numeric ', info_msg='No arcs shorter than value set as node proximity.', function_name='[gw_fct_om_check_data]' WHERE fid=391;
UPDATE sys_fprocess SET fprocess_name='Check to_arc missed VALUES for pumps', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with missed values on mandatory column to_arc.', query_text='SELECT * FROM v_edit_inp_pump WHERE to_arc IS NULL', info_msg='Pump to_arc missed values checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=395;
UPDATE sys_fprocess SET fprocess_name='Builddate before 1900', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features with built date before 1900.', query_text='SELECT arc_id, ''ARC''::text FROM v_prefix_arc WHERE builtdate < ''1900/01/01''::date UNION 
SELECT  node_id, ''NODE''::text FROM v_prefix_node WHERE builtdate < ''1900/01/01''::date UNION 
SELECT  connec_id, ''CONNEC''::text FROM v_prefix_connec WHERE builtdate < ''1900/01/01''::date', info_msg='No feature with builtdate before 1900.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=406;
UPDATE sys_fprocess SET fprocess_name='Links without connec on startpoint', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='links related to connecs with wrong topology, startpoint does not fit connec', query_text='	with mec as ( -- links cuyo startpoint estigui al tocar d''un connec
	SELECT l.link_id, c.connec_id, l.the_geom, l.expl_id FROM connec c, link l
	WHERE l.state = 1 and c.state = 1 and ST_DWithin(ST_startpoint(l.the_geom), c.the_geom, 0.01) group by 1,2 ORDER BY 1 DESC
	), moc as ( -- links connectats a un connec
		SELECT link_id, feature_id, ''417'', l.state, l.the_geom 
		FROM link l JOIN connec c ON feature_id = connec_id WHERE l.state = 1 and l.feature_type = ''CONNEC''
	) -- si el link cuyo startpoint està tocant un connec, no està informat com que està connectat a un connec, mal
	select * from mec where link_id not in (select link_id from moc)', info_msg='All connec links has connec on startpoint', function_name='[gw_fct_om_check_data]' WHERE fid=417;
UPDATE sys_fprocess SET fprocess_name='Links without gully on startpoint', "source"='core', fprocess_type='Check om-data', project_type='ud', except_level=3, except_msg='links with wrong topology. Startpoint does not fit with connec.', query_text='with subq1 as (SELECT l.link_id, c.connec_id, c.the_geom FROM connec c, link l
WHERE l.state = 1 and c.state = 1 and ST_DWithin(ST_startpoint(l.the_geom), c.the_geom, 0.01) group by 1,2 ORDER BY 1 DESC)
select connec_id, the_geom From subq1 where connec_id not in (select connec_id from connec)', info_msg='All connec links has connec on startpoint', function_name='[gw_fct_om_check_data]' WHERE fid=418;
UPDATE sys_fprocess SET fprocess_name='Duplicated hydrometer related to more than one connec', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='hydrometer related to more than one connec. HINT-419: Type ''''SELECT hydrometer_id, count(*) FROM v_rtc_hydrometer  group by hydrometer_id having count(*)> 1''''''', query_text='SELECT hydrometer_id, count(*) FROM v_rtc_hydrometer  group by hydrometer_id having count(*)> 1 ', info_msg='All hydrometeres are related to a unique connec', function_name='[gw_fct_om_check_data]' WHERE fid=419;
UPDATE sys_fprocess SET fprocess_name='Check category_type values exists on man_ table', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with category_type does not exists on man_type_category table.', query_text='SELECT ''ARC'', arc_id, category_type FROM v_prefix_arc WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, category_type FROM v_prefix_node WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, category_type FROM v_prefix_connec WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL', info_msg='All features has category_type informed on man_type_category table', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=421;
UPDATE sys_fprocess SET fprocess_name='Check function_type values exists on man_ table', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with function_type does not exists on man_type_function table.', query_text='SELECT ''ARC'', arc_id, function_type FROM v_prefix_arc WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, function_type FROM v_prefix_node WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, function_type FROM v_prefix_connec WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL', info_msg='All features has function_type informed on man_type_function table', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=422;
UPDATE sys_fprocess SET fprocess_name='Check fluid_type values exists on om_typevalue domain fluid_type values', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with fluid_type does not exists on om_typevalue domain.', query_text='SELECT ''ARC'', arc_id, fluid_type FROM v_prefix_arc WHERE fluid_type NOT IN (SELECT fluid_type FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, fluid_type FROM v_prefix_node WHERE fluid_type NOT IN (SELECT fluid_type FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, fluid_type FROM v_prefix_connec WHERE fluid_type NOT IN (SELECT fluid_type FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL', info_msg='All features has fluid_type informed', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=423;
UPDATE sys_fprocess SET fprocess_name='Check location_type values exists on man_ table', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with location_type does not exists on man_type_location table.', query_text='SELECT ''ARC'', arc_id, location_type FROM v_prefix_arc WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, location_type FROM v_prefix_node WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, location_type FROM v_prefix_connec WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL', info_msg='All features has location_type informed on man_type_location table', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=424;
UPDATE sys_fprocess SET fprocess_name='Check expl.geom is not null when raster DEM is enabled', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='exploitations without geometry. Capturing values from DEM is enabled, but it will fail on exploitation: '',string_agg(name,'', '')', query_text='SELECT * FROM exploitation WHERE the_geom IS NULL AND active IS TRUE and expl_id > 0 ', info_msg='Capturing values from DEM is enabled and will work correctly as all exploitations have geometry.', function_name='[gw_fct_om_check_data]' WHERE fid=428;
UPDATE sys_fprocess SET fprocess_name='Check that EPA OBJECTS (curves and others) name do not contain spaces', "source"='core', fprocess_type='Check epa-config', project_type='utils', except_level=3, except_msg='curves name with spaces. Please fix it!', query_text='SELECT * FROM inp_curve WHERE id like''% %''', info_msg='All curves checked have names without spaces.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=429;
UPDATE sys_fprocess SET fprocess_name='Check matcat null for arcs', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='arcs without matcat_id informed.''', query_text='SELECT * FROM selector_sector s, v_edit_arc a JOIN cat_arc c ON c.id = a.cat_matcat_id  
WHERE a.sector_id = s.sector_id and cur_user=current_user 
AND a.cat_matcat_id IS NULL AND sys_type !=''VARC''', info_msg='All arcs have matcat_id filled.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=430;
UPDATE sys_fprocess SET fprocess_name='Check node ''T candidate'' with wrong topology', "source"='core', fprocess_type='Function process', project_type='utils', except_level=3, except_msg='Nodes ''''T candidate'''' with wrong topology', query_text='with q_arc as (
select * from arc JOIN v_state_arc USING (arc_id))
SELECT b.* FROM (
	SELECT n1.node_id, n1.nodecat_id, n1.sector_id, n1.expl_id, n1.state, n1.the_geom  FROM q_arc, 
		(select * from node JOIN v_state_node USING (node_id)) n1 
	JOIN (SELECT node_1 node_id from q_arc UNION 
	select node_2 FROM q_arc) b USING (node_id) 
	WHERE st_dwithin(q_arc.the_geom, n1.the_geom,0.01) AND n1.node_id NOT IN 
	(node_1, node_2)
)b, selector_expl e 
where e.expl_id= b.expl_id AND cur_user=current_user', info_msg='All Nodes T has right topology.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=432;
UPDATE sys_fprocess SET fprocess_name='Arc materials not defined in cat_mat_roughness table', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='arc materials that are not defined in cat_mat_rougnhess table. Please, check your data before continue.''', query_text='SELECT id FROM cat_material WHERE id NOT IN (SELECT matcat_id FROM cat_mat_roughness)', info_msg='All arc materials are defined on cat_mat_rougnhess table.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=433;
UPDATE sys_fprocess SET fprocess_name='Check outlet_id assigned to subcatchments', "source"='core', fprocess_type='Check epa-config', project_type='ud', except_level=3, except_msg='outlets defined on subcatchments view, that are not present on junction, outfall, storage, divider or subcatchment view.', query_text='WITH query AS (SELECT * FROM 
(SELECT subc_id, outlet_id, st_centroid(the_geom) as the_geom from v_edit_inp_subcatchment where left(outlet_id::text, 1) != ''{''::text 
	UNION
	SELECT subc_id, unnest(outlet_id::text[]), st_centroid(the_geom) from v_edit_inp_subcatchment where left(outlet_id::text, 1) = ''{''::text
	)a WHERE outlet_id not in (
		select node_id::text FROM v_edit_inp_junction UNION 
		select node_id::text FROM v_edit_inp_outfall UNION
		select node_id::text FROM v_edit_inp_storage UNION 
		select node_id::text FROM v_edit_inp_divider UNION
		select subc_id FROM v_edit_inp_subcatchment
	))
	SELECT q1.*, u.expl_id FROM query q1 
		LEFT JOIN 
		(SELECT * FROM (
		SELECT 440, subc_id, outlet_id, the_geom from v_edit_inp_subcatchment where left(outlet_id::text, 1) != ''{''::text 
		UNION
		SELECT 440, subc_id, unnest(outlet_id::text[]), the_geom AS outlet_id from v_edit_inp_subcatchment 
		where left(outlet_id::text, 1) = ''{''::text)a)b
		USING (outlet_id) 
		left join node u on q1.outlet_id = u.node_id::text
		WHERE b.subc_id IS NULL', info_msg='All outlets set on subcatchments are correctly defined.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=440;
UPDATE sys_fprocess SET fprocess_name='Node orphan with isarcdivide=TRUE (OM)', "source"='core', fprocess_type='Check om-topology', project_type='ws', except_level=2, except_msg='orphan nodes with isarcdivide=TRUE.', query_text='SELECT * FROM v_prefix_node a JOIN cat_node nc ON nodecat_id=id JOIN cat_feature_node nt ON nt.id=nc.node_type WHERE a.state>0 AND isarcdivide = true
	AND (SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0', info_msg='There are no orphan nodes with isarcdivide=TRUE', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=442;
UPDATE sys_fprocess SET fprocess_name='Node orphan with isarcdivide=FALSE (OM)', "source"='core', fprocess_type='Check om-topology', project_type='ws', except_level=2, except_msg='orphan nodes with isarcdivide=FALSE.', query_text='SELECT  * FROM node a JOIN cat_node nc ON nodecat_id=id JOIN cat_feature_node nt ON nt.id=nc.node_type WHERE a.state>0 AND isarcdivide=false AND arc_id IS NULL', info_msg='There are no orphan nodes with isarcdivide=FALSE', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=443;
UPDATE sys_fprocess SET fprocess_name='Node planified duplicated', "source"='core', fprocess_type='Check plan-data', project_type='utils', except_level=3, except_msg='nodes duplicated with state 2.', query_text='SELECT * FROM (SELECT DISTINCT t1.node_id AS node_1, t1.nodecat_id AS nodecat_1, t1.state as state1, t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 453, t1.the_geom FROM v_prefix_node AS t1 JOIN v_prefix_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 2 AND a.state2 = 2', info_msg='There are no nodes duplicated with state 2', function_name='[gw_fct_plan_check_data, gw_fct_om_check_data]' WHERE fid=453;
UPDATE sys_fprocess SET fprocess_name='Check redundant values on y-top_elev-elev', "source"='core', fprocess_type='Check om-topology', project_type='ud', except_level=3, except_msg='nodes with redundancy on ymax, top_elev & elev values.', query_text='SELECT node_id, nodecat_id, the_geom, expl_id FROM v_prefix_node WHERE (ymax is not null or custom_ymax is not null) 
and (top_elev is not null or custom_top_elev is not null) and (elev is not null or custom_elev is not null)', info_msg='There are no nodes with redundancy on ymax, top_elev & elev values.', function_name='[gw_fct_om_check_data]' WHERE fid=461;
UPDATE sys_fprocess SET fprocess_name='Check number of rows in a plan_price table', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows on plan_price table. Revise the data and remove unnecessary rows.', query_text='with c as (SELECT row_number() over() as rowid, * FROM plan_price) select*from c where rowid > 300', info_msg='The number of rows on plan price is acceptable.', function_name='[gw_fct_plan_check_data]' WHERE fid=465;
UPDATE sys_fprocess SET fprocess_name='Planified EPANET pumps with more than two acs', "source"='core', fprocess_type='Check plan-data', project_type='ws', except_level=3, except_msg='pumpss with more than two arcs .Take a look on temporal table to details', query_text='SELECT * FROM t_anl_node WHERE fid=467 AND cur_user=current_user', info_msg='EPA pumps checked. No pumps with more than two arcs detected.', function_name='[gw_fct_plan_check_data, gw_fct_admin_check_data]' WHERE fid=467;
UPDATE sys_fprocess SET fprocess_name='Check consistency between cat_manager and config_user_x_expl', "source"='core', fprocess_type='Function process', project_type='utils', except_level=3, except_msg='inconsistent configurations on cat_manager and config_user_x_expl for user: '''',string_agg(DISTINCT usern,'''', '''')),''||v_count||'' FROM ''||v_querytext||'';''"', query_text='WITH exploit AS (
SELECT COALESCE(m.rolname, s.rolname) AS usern, id FROM (
SELECT id, unnest(rolename) AS role FROM cat_manager WHERE expl_id IS NOT NULL) q 
LEFT JOIN pg_roles r ON q.role = r.rolname LEFT JOIN pg_auth_members am ON r.oid = am.roleid 
LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE  LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE 
WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
) 
SELECT *, CONCAT(explots, ''-'', usern, ''-'', id) FROM (SELECT id, unnest(expl_id) explots, usern FROM cat_manager   JOIN exploit using(id)) a 
WHERE CONCAT(explots, ''-'', usern, ''-'', id) NOT IN (SELECT CONCAT(expl_id, ''-'', username, ''-'', manager_id) FROM config_user_x_expl cuxe) AND explots != 0', info_msg='Configuration of cat_manager and config_user_x_expl is consistent.', function_name='[gw_fct_admin_check_data]', active = false WHERE fid=472;
UPDATE sys_fprocess SET fprocess_name='Check features without defined sector_id', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs with sector_id 0 or -1.', query_text='SELECT connec_id, conneccat_id, the_geom, expl_id FROM connec WHERE state > 0 
AND (sector_id=0 OR sector_id=-1)', info_msg='No connecs with 0 or -1 value on sector_id.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=478;
UPDATE sys_fprocess SET fprocess_name='Check duplicated arcs', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='arcs with duplicated geometry.', query_text='SELECT arc_id, arccat_id, state1, arc_id_aux, node_1, node_2, expl_id, the_geom FROM        
 (WITH q_arc AS (SELECT * FROM arc JOIN v_state_arc using (arc_id)) 
 SELECT DISTINCT t1.arc_id, t1.arccat_id, t1.state as state1, t2.arc_id as arc_id_aux,
 t2.state as state2, t1.node_1, t1.node_2, t1.expl_id, t1.the_geom 
 FROM q_arc AS t1 JOIN q_arc AS t2 USING(the_geom) JOIN arc v ON t1.arc_id = v.arc_id
 WHERE t1.arc_id != t2.arc_id ORDER BY t1.arc_id )a
 where a.state1 > 0 AND a.state2 > 0', info_msg='No arcs with duplicated geometry.', function_name='[gw_fct_om_check_data]' WHERE fid=479;
UPDATE sys_fprocess SET fprocess_name='Check connects with more than 1 link on service', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs with more than 1 link on service', query_text='SELECT connec_id, conneccat_id, the_geom, expl_id FROM connec WHERE connec_id IN 
(SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)', info_msg='No connects with more than 1 link on service', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=480;
UPDATE sys_fprocess SET fprocess_name='Check arcs with value of custom length', "source"='core', fprocess_type='Check epa-data', project_type='utils', except_level=2, except_msg='percent of arcs have value on custom_length.', query_text='WITH cust_len AS (SELECT count(*) FROM v_edit_arc WHERE custom_length IS NOT NULL), 
		arcs AS (SELECT count(*) FROM v_edit_arc),
		thres as (SELECT json_extract_path_text(value::json,''customLength'',''maxPercent'')::NUMERIC as t FROM config_param_system WHERE parameter = ''epa_outlayer_values'')
		SELECT round(cust_len.count::numeric / arcs.count::numeric *100, 2) FROM arcs, cust_len, thres
		where round(cust_len.count::numeric / arcs.count::numeric *100, 2) > t', info_msg='No arcs have value on custom_length.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=482;
UPDATE sys_fprocess SET fprocess_name='Check orphan documents', "source"='core', fprocess_type='Function process', project_type='ws', except_level=2, except_msg='documents not related to any feature.', query_text='select id from doc where id not in 
(select distinct  doc_id from doc_x_arc UNION 
select distinct  doc_id from doc_x_connec UNION 
select distinct  doc_id from doc_x_node)', info_msg='All documents are related to the features.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=497;
UPDATE sys_fprocess SET fprocess_name='Check orphan visits', "source"='core', fprocess_type='Function process', project_type='ws', except_level=2, except_msg='visits not related to any feature and without geometry.', query_text='select id, the_geom from om_visit where the_geom is null and id not in (
with mec as (
select distinct visit_id from om_visit_x_arc UNION
select distinct visit_id from om_visit_x_connec UNION
select distinct visit_id from om_visit_x_node UNION
select distinct visit_id from om_visit_x_link)
select a.visit_id from mec a left join om_visit b on a.visit_id = id
)', info_msg='All visits are related to the features or have geometry.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=498;
UPDATE sys_fprocess SET fprocess_name='Check orphan elements', "source"='core', fprocess_type='Function process', project_type='ws', except_level=2, except_msg='elements not related to any feature and without geometry.', query_text='select element_id, the_geom from element where the_geom is null and element_id not in (
with mec as (select distinct element_id from element_x_arc UNION
select distinct element_id from element_x_connec UNION
select distinct element_id from element_x_node)
select a.element_id from mec a left join "element" b using (element_id))', info_msg='All elements are related to the features or have geometry.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=499;
UPDATE sys_fprocess SET fprocess_name='Check outfalls with more than 1 arc', "source"='core', fprocess_type='Function process', project_type='ud', except_level=3, except_msg='outfalls with more than 1 arc.', query_text='select node.node_id, node.the_geom, node.expl_id, node.nodecat_id 
from node, arc where node.epa_type=''OUTFALL'' and st_dwithin(node.the_geom, arc.the_geom, 0.01) 
group by node.node_id having count(node.node_id)>1', info_msg='All outfalls have a valid number of connected arcs.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=522;
UPDATE sys_fprocess SET fprocess_name='Check outlet_id existance in inp_subcatchment and inp_junction', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='non-existing outlet_id related to subcatchment.', query_text='select outlet_id from v_edit_inp_subc2outlet
LEFT JOIN (
select node_id from v_edit_inp_junction 
UNION select node_id from v_edit_inp_outfall
UNION select node_id from v_edit_inp_storage 
UNION select node_id from v_edit_inp_netgully
) a on outlet_id = node_id
where outlet_type in (''JUNCTION'') and node_id is null
union
select a.outlet_id from v_edit_inp_subc2outlet a LEFT JOIN v_edit_inp_subcatchment s on a.outlet_id::text = s.subc_id
where outlet_type = ''SUBCATCHMENT'' and s.subc_id is null', info_msg='All subcatchments have an existing outlet_id', function_name='[gw_fct_pg2epa_check_data]', active = false WHERE fid=528; -- TODO: revise if this is needed
UPDATE sys_fprocess SET fprocess_name='Check missing data in Inp Weir', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='values missing on some data of Inp Weir (weir_type, cd, geom1, geom2, offsetval)', query_text='SELECT  arc_id,  the_geom from v_edit_inp_weir 
		where weir_type is null or cd is null or geom1 is null or geom2 is null or offsetval is null', info_msg='No missing data on Inp Weir.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=529;
UPDATE sys_fprocess SET fprocess_name='Check missing data in Inp Orifice', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='values missing on some data of Inp Orifice (ori_type, geom1, offsetval)', query_text='SELECT arc_id, the_geom from v_edit_inp_orifice
where ori_type is null or geom1 is null or offsetval is null', info_msg='No missing data on Inp Orifice.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=530;

UPDATE sys_fprocess SET fprocess_name='Mandatory nodarc over other EPA node', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=3, except_msg='mandatory nodarcs (VALVE & PUMP) over other EPA nodes.'' ', query_text='SELECT a.* FROM (SELECT DISTINCT t1.node_id as n1, t1.nodecat_id as n1cat, t1.state as state1, t2.node_id as n2, 
t2.nodecat_id as n2cat, t2.state as state2, t1.expl_id, 411, 
t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, t1.sector_id  
FROM node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id AND ((t1.epa_type IN (''PUMP'', ''VALVE'') AND t2.epa_type !=''UNDEFINED'') OR 
(t2.epa_type IN (''PUMP'', ''VALVE'') AND t1.epa_type !=''UNDEFINED''))  ORDER BY t1.node_id) a, selector_expl e, selector_sector s  
WHERE e.expl_id = a.expl_id AND e.cur_user = current_user   AND s.sector_id = a.sector_id 
AND s.cur_user = current_user  AND a.state1 > 0 AND a.state2 > 0 ORDER BY dist', info_msg=' All mandatory nodarc (PUMP & VALVE) are not on the same position than other EPA nodes.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=411;
UPDATE sys_fprocess SET fprocess_name='Shortpipe nodarc over other EPA node', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='shortpipe nodarcs over other EPA nodes.''', query_text='SELECT * FROM (  SELECT DISTINCT t1.node_id as n1, t1.nodecat_id as n1cat, t1.state as state1, t2.node_id as n2, t2.nodecat_id as n2cat, t2.state as state2, t1.expl_id, 412,   t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, ''Shortpipe nodarc over other EPA node'' as descript  FROM selector_expl e, selector_sector s, node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01)   WHERE t1.node_id != t2.node_id   AND s.sector_id = t1.sector_id AND s.cur_user = current_user  AND e.expl_id = t1.expl_id AND e.cur_user = current_user   AND ((t1.epa_type = ''SHORTPIPE'' AND t2.epa_type =''JUNCTION'') OR (t2.epa_type = ''SHORTPIPE'' AND t1.epa_type !=''JUNCTION''))  AND t1.node_id =''SHORTPIPE''  ORDER BY t1.node_id) a where a.state1 > 0 AND a.state2 > 0 ORDER BY dist', info_msg='All shortpipe nodarcs are not on the same position than other EPA nodes.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=412;
UPDATE sys_fprocess SET fprocess_name='Check minlength less than 0.01 or more than node proximity', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=3, except_msg='minlength value is bad configured (more than node proximity or less than 0.01).', query_text='WITH subq_1 AS (
SELECT value::numeric as v_minlength FROM config_param_system WHERE parameter = ''epa_arc_minlength''
), subq_2 as (
SELECT (value::json->>''value'')::numeric as v_nodeproximity FROM config_param_system WHERE parameter = ''edit_node_proximity''
), mec as (
select v_minlength < 0.01 or v_minlength >= v_nodeproximity as results from subq_1, subq_2
) select * from mec where results is true', info_msg='Minlength value ('',v_minlength,'') is well configured.''', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=425;
UPDATE sys_fprocess SET fprocess_name='Check zones without numeric id', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=3, except_msg='presszones with id that is not a numeric value.', query_text='SELECT presszone_id FROM presszone WHERE presszone_id=''-1'' AND (presszone_id::text ~''^\d+(\.\d+)?$'') is false', info_msg='All presszone_ids are numeric values.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=460;
UPDATE sys_fprocess SET fprocess_name='Check connecs related to arcs with diameter bigger than defined value', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs related to arcs with diameter bigger than defined value.', query_text='WITH subq_1 AS (
SELECT (value::json->>''status'')::boolean as status FROM config_param_system WHERE parameter = ''edit_link_check_arcdnom''
), subq_2 as (
select (value::json->>''diameter'')::numeric as v_check_arcdnom FROM config_param_system, subq_1 
WHERE parameter = ''edit_link_check_arcdnom'' and status is true)
SELECT connec_id, conneccat_id, the_geom, expl_id 
FROM v_prefix_connec, subq_2 WHERE state>0 AND arc_id IN 
(SELECT arc_id FROM v_prefix_arc JOIN cat_arc ON arccat_id=id WHERE dnom::integer>subq_2.v_check_arcdnom)', info_msg='No connecs related to arcs with diameter bigger than defined value', function_name='[gw_fct_om_check_data]' WHERE fid=488;


INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(533, 'Non-mandatory nodarc with less than two arcs', 'core', 'Check epa-topology', 'ws', 2, 'NON-mandatory node2arcs with less than two arcs. It will be transformed on the fly using only one arc''', 'SELECT * FROM t_anl_node WHERE fid = 292', 'No results found for NON-mandatory node2arcs with less than two arcs.', '[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(534, 'Check if defined nodes (nodeParent) exist in a database', 'core', 'Check graph-data', 'ws', 2, 'nodes that are configured as nodeParent for v_prefix_v_graphClass but is not operative on node table.', 'SELECT b.node_id, b.v_graphClass_id as zone_id FROM (
SELECT v_graphClass_id, graphconfig::json->''use''->0->>''nodeParent''::integer as node_id FROM v_prefix_v_graphClass)b 
WHERE node_id::text not in (select node_id FROM node WHERE state=1)', 'All nodes defined as nodeParent on v_prefix_v_graphClass exists on DB.', '[gw_fct_graphanalytics_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(541, 'Gully without link', 'core', 'Check om-data', 'ud', NULL, 'gullys without links or gullies over arc without arc_id.', 'SELECT gully_id, gullycat_id, c.the_geom, c.expl_id from v_prefix_gully c WHERE c.state= 1 
AND gully_id NOT IN (SELECT feature_id FROM link)
EXCEPT 
SELECT gully_id, gullycat_id, c.the_geom, c.expl_id FROM v_prefix_gully c
LEFT JOIN v_prefix_arc a USING (arc_id) WHERE c.state= 1 
AND arc_id IS NOT NULL AND st_dwithin(c.the_geom, a.the_geom, 0.1)', 'All gullies have links or are over arc with arc_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(542, 'feature which id is not an integer', 'core', 'Check om-data', 'ud', 3, 'which id is not an integer. Please, check your data before continue', 'SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)
ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id as featurecat,the_geom, expl_id  FROM arc
UNION SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER)
ELSE 0 END as feature_id, ''NODE'' as type, nodecat_id as featurecat,the_geom, expl_id FROM node
UNION SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER)
ELSE 0 END as feature_id, ''CONNEC'' as type, conneccat_id as featurecat,the_geom, expl_id FROM connec
UNION SELECT CASE WHEN gully_id~E''^\\d+$'' THEN CAST (gully_id AS INTEGER)
ELSE 0 END as feature_id, ''GULLY'' as type, gullycat_id as featurecat,the_geom, expl_id FROM gully', 'All features with id integer.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(543, 'Gully chain with different arc_id than the final connec/gully', 'core', 'Check om-data', 'ud', NULL, 'chained connecs/gullys without links or gullies over arc without arc_id.', 'with c as (
Select v_prefix_connec.connec_id as id, arc_id as arc, v_prefix_connec.conneccat_id as 
feature_catalog, the_geom, v_prefix_connec.expl_id from v_prefix_connec
UNION select v_prefix_gully.gully_id as id, arc_id as arc, v_prefix_gully.gullycat_id, 
the_geom, v_prefix_gully.expl_id  from v_prefix_gully
)
select c1.id, c1.feature_catalog, c1.the_geom,  c1.expl_id
from link a
left join c c1 on a.feature_id = c1.id
left join c c2 on a.exit_id = c2.id
where (a.exit_type =''CONNEC'' OR a.exit_type =''GULLY'')
and c1.arc <> c2.arc', 'All chained connecs and gullies have the same arc_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(545, 'State not according with state_type', 'core', 'Check om-data', 'ud', 3, 'features with state without concordance with state_type. Please, check your data before continue features with state without concordance with state_type. Please, check your data before continue', 'SELECT arc_id as id, a.state, state_type FROM v_prefix_arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT node_id as id, a.state, state_type FROM v_prefix_node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT connec_id as id, a.state, state_type FROM v_prefix_connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT gully_id as id, a.state, state_type FROM v_prefix_gully a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
UNION SELECT element_id as id, a.state, state_type FROM v_prefix_element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state', 'No features without concordance against state and state_type.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(547, 'Check fluid_type values exists on om_typevalue domain values', 'core', 'Check om-data', 'ud', 3, 'features with fluid_type does not exists on om_typevalue domain.', 'SELECT ''ARC'', arc_id, fluid_type FROM v_prefix_arc WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, fluid_type FROM v_prefix_node WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, fluid_type FROM v_prefix_connec WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, fluid_type FROM v_prefix_gully WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL', 'All features has fluid_type informed on om_typevalue domain', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(548, 'Check orphan elements', 'core', 'Function process', 'ud', 2, 'elements not related to any feature and without geometry.', 'select element_id, the_geom from element where the_geom is null and element_id not in (
with mec as (select distinct element_id from element_x_arc UNION
select distinct element_id from element_x_connec UNION
select distinct element_id from element_x_node UNION
select distinct element_id from element_x_gully)
select a.element_id from mec a left join "element" b using (element_id))', 'All elements are related to the features or have geometry.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(549, 'Node orphan with isarcdivide=TRUE (OM)', 'core', 'Check om-topology', 'ud', 2, 'orphan nodes with isarcdivide=TRUE.', 'SELECT * FROM v_prefix_node a JOIN cat_feature_node ON id = a.node_type WHERE a.state>0 AND isarcdivide= ''true'' 
AND (SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0', 'There are no orphan nodes with isarcdivide=TRUE', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(550, 'Check function_type values exists on man_ table', 'core', 'Check om-data', 'ud', 3, 'features with function_type does not exists on man_type_function table.', 'SELECT ''ARC'', arc_id, function_type FROM v_prefix_arc WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, function_type FROM v_prefix_node WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, function_type FROM v_prefix_connec WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, function_type FROM v_prefix_gully WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL', 'All features has function_type informed on man_type_function table', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(551, 'Features state=1 and end date', 'core', 'Check om-data', 'ud', 2, 'features on service with value of end date.', 'SELECT arc_id as feature_id from v_prefix_arc where state = 1 and enddate is not null
UNION SELECT node_id as feature_id from v_prefix_node where state = 1 and enddate is not null
UNION SELECT connec_id as feature_id from v_prefix_connec where state = 1 and enddate is not null
UNION SELECT gully_id as feature_id from v_prefix_gully where state = 1 and enddate is not null', 'No features on service have value of end date', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(552, 'Gully without or with wrong arc_id', 'core', 'Check om-data', 'ud', 2, 'gullies without or with incorrect arc_id.', 'SELECT c.gully_id, c.gullycat_id, c.the_geom, c.expl_id, l.feature_type, link_id 
FROM arc a, link l
JOIN v_prefix_gully c ON l.feature_id = c.gully_id 
WHERE st_dwithin(a.the_geom, st_endpoint(l.the_geom), 0.01)
AND exit_type = ''ARC''
AND (a.arc_id <> c.arc_id or c.arc_id is null) 
AND l.feature_type = ''GULLY'' AND a.state=1 and c.state = 1 and l.state=1
EXCEPT
SELECT c.gully_id, c.gullycat_id, c.the_geom, c.expl_id, l.feature_type, link_id
FROM node n, link l
JOIN v_prefix_gully c ON l.feature_id = c.gully_id 
WHERE st_dwithin(n.the_geom, st_endpoint(l.the_geom), 0.01)
AND exit_type IN (''NODE'', ''ARC'')
AND l.feature_type = ''GULLY'' AND n.state=1 and c.state = 1 and l.state=1
ORDER BY feature_type, link_id', 'All gullies have correct arc_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(553, 'Features with code null', 'core', 'Check om-data', 'ud', 3, 'features with code with NULL values. Please, check your data before continue with code with NULL values. Please, check your data before continue', 'SELECT arc_id, arccat_id, the_geom FROM v_prefix_arc WHERE code IS NULL 
UNION SELECT node_id, nodecat_id, the_geom FROM v_prefix_node WHERE code IS NULL
UNION SELECT connec_id, conneccat_id, the_geom FROM v_prefix_connec WHERE code IS NULL
UNION SELECT gully_id, gullycat_id, the_geom FROM v_prefix_gully WHERE code IS NULL
UNION SELECT element_id, elementcat_id, the_geom FROM v_prefix_element WHERE code IS NULL', 'No features (arc, node, connec, element, gully) with NULL values on code found.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(554, 'Features state=0 without end date', 'core', 'Check om-data', 'ud', 2, 'features with state 0 without value of end date.', 'SELECT arc_id as feature_id from v_prefix_arc where state = 0 and enddate is null
UNION SELECT node_id from v_prefix_node where state = 0 and enddate is null
UNION SELECT connec_id from v_prefix_connec where state = 0 and enddate is null
UNION SELECT gully_id from v_prefix_gully where state = 0 and enddate is null', 'No features with state 0 are missing the end date', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(555, 'Check connecs with more than 1 link on service', 'core', 'Check om-data', 'ud', 2, 'connecs with more than 1 link on service', 'SELECT connec_id, conneccat_id, the_geom, expl_id FROM v_prefix_connec WHERE connec_id 
IN (SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)
UNION SELECT gully_id, gullycat_id, the_geom, expl_id FROM v_prefix_gully WHERE gully_id 
IN (SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)', 'No connects with more than 1 link on service', '[gw_fct_om_check_data, gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(556, 'Check orphan visits', 'core', 'Function process', 'ud', 2, 'visits not related to any feature and without geometry.', 'select id, the_geom from om_visit where the_geom is null and id not in (
with mec as (
select distinct visit_id from om_visit_x_arc UNION
select distinct visit_id from om_visit_x_connec UNION
select distinct visit_id from om_visit_x_node UNION
select distinct visit_id from om_visit_x_gully UNION
select distinct visit_id from om_visit_x_link)
select a.visit_id from mec a left join om_visit b on a.visit_id = id
)', 'All visits are related to the features or have geometry.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(557, 'Builddate before 1900', 'core', 'Check om-data', 'ud', 2, 'features with built date before 1900.', 'SELECT arc_id, ''ARC''::text FROM v_prefix_arc WHERE builtdate < ''1900/01/01''::date
UNION 
SELECT  node_id, ''NODE''::text FROM v_prefix_node WHERE builtdate < ''1900/01/01''::date
UNION  
SELECT  connec_id, ''CONNEC''::text FROM v_prefix_connec WHERE builtdate < ''1900/01/01''::date
UNION 
SELECT  gully_id, ''GULLY''::text FROM v_prefix_gully WHERE builtdate < ''1900/01/01''::date', 'No feature with builtdate before 1900.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(558, 'Check location_type values exists on man_ table', 'core', 'Check om-data', 'ud', 3, 'features with location_type does not exists on man_type_location table.', 'SELECT ''ARC'', arc_id, location_type FROM v_prefix_arc WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, location_type FROM v_prefix_node WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, location_type FROM v_prefix_connec WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, location_type FROM v_prefix_gully WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL', 'All features has location_type informed on man_type_location table', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(559, 'Planned connecs without reference link', 'core', 'Check om-data', 'ud', 3, 'planned connecs without reference link planned connecs or gullys without reference link', 'SELECT * FROM plan_psector_x_connec WHERE link_id IS NULL
UNION SELECT * FROM plan_psector_x_gully WHERE link_id IS NULL', 'All planned connecs or gullys have a reference link', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(561, 'Duplicated ID between arc, node, connec, gully', 'core', 'Check om-data', 'ud', 3, 'features with duplicated ID value between arc, node, connec, gully features with duplicated ID values between arc, node, connec, gully', 'SELECT * FROM (SELECT node_id FROM node UNION ALL SELECT arc_id FROM arc UNION ALL SELECT connec_id FROM connec UNION ALL SELECT gully_id FROM gully)a 
group by node_id having count(*) > 1', 'All features have a diferent ID to be correctly identified', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(562, 'Features state=2 are involved in psector', 'core', 'Check plan-config', 'ud', 3, 'planified arcs without psector. planified nodes without psector. planified connecs without psector. planified gullys without psector. features with state=2 without psector assigned. Please, check your data before continue', 'SELECT a.arc_id FROM v_prefix_arc a RIGHT JOIN plan_psector_x_arc USING (arc_id) WHERE a.state = 2 AND a.arc_id IS NULL
UNION
SELECT a.node_id FROM v_prefix_node a RIGHT JOIN plan_psector_x_node USING (node_id) WHERE a.state = 2 AND a.node_id IS NULL
UNION
SELECT a.connec_id FROM v_prefix_connec a RIGHT JOIN plan_psector_x_connec USING (connec_id) WHERE a.state = 2 AND a.connec_id IS NULL
UNION 
SELECT a.gully_id FROM v_prefix_gully a RIGHT JOIN plan_psector_x_gully USING (gully_id) WHERE a.state = 2 AND a.gully_id IS NULL', 'There are no features with state=2 without psector.', '[gw_fct_plan_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(563, 'Connec or gully with different expl_id than arc', 'core', 'Check om-data', 'ud', 3, 'connecs with exploitation different than the exploitation of the related arc', 'SELECT DISTINCT connec_id, conneccat_id, c.the_geom, c.expl_id FROM v_prefix_connec c JOIN v_prefix_arc b using (arc_id) 
WHERE b.expl_id::text != c.expl_id::text
UNION 
SELECT DISTINCT  gully_id, gullycat_id, g.the_geom gully_id, g.expl_id FROM v_prefix_gully g JOIN v_prefix_arc d using (arc_id) WHERE d.expl_id::text != g.expl_id::text', 'All connecs or gullys have the same exploitation as the related arc', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(564, 'Check orphan documents', 'core', 'Function process', 'ud', 2, 'documents not related to any feature.', 'select id from doc where id not in (
select distinct  doc_id from doc_x_arc UNION
select distinct  doc_id from doc_x_connec UNION
select distinct  doc_id from doc_x_node UNION
select distinct  doc_id from doc_x_gully)', 'All documents are related to the features.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(565, 'Node orphan with isarcdivide=FALSE (OM)', 'core', 'Check om-topology', 'ud', 2, 'orphan nodes with isarcdivide=FALSE.', 'SELECT * FROM v_prefix_node a JOIN cat_feature_node ON id = a.node_type WHERE a.state>0 AND isarcdivide=''false''', 'There are no orphan nodes with isarcdivide=FALSE', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(566, 'Features state=1 and end date before start date', 'core', 'Check om-data', 'ud', 2, 'features with end date earlier than built date.', 'SELECT arc_id as feature_id from v_prefix_arc where enddate < builtdate and state = 1
UNION SELECT node_id from v_prefix_node where enddate < builtdate and state = 1
UNION SELECT connec_id from v_prefix_connec where enddate < builtdate and state = 1
UNION SELECT gully_id from v_prefix_gully where enddate < builtdate and state = 1', 'No features with end date earlier than built date', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(567, 'Check features without defined sector_id', 'core', 'Check om-data', 'ud', 2, 'connecs with sector_id 0 or -1.', 'SELECT connec_id, conneccat_id, the_geom, expl_id FROM v_prefix_connec WHERE state > 0 AND (sector_id=0 OR sector_id=-1)
UNION SELECT gully_id, gullycat_id, the_geom, expl_id FROM v_prefix_gully WHERE state > 0 AND (sector_id=0 OR sector_id=-1)', 'No connecs with 0 or -1 value on sector_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(568, 'Check category_type values exists on man_ table', 'core', 'Check om-data', 'ud', 3, 'features with category_type does not exists on man_type_category table.', 'SELECT ''ARC'', arc_id, category_type FROM v_prefix_arc WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, category_type FROM v_prefix_node WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, category_type FROM v_prefix_connec WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, category_type FROM v_prefix_gully WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL', 'All features has category_type informed on man_type_category table', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(569, 'Check matcat null for arcs', 'core', 'Check epa-config', 'ud', 3, 'arcs without matcat_id informed.', 'SELECT * FROM selector_sector s, v_edit_arc a JOIN cat_arc c ON c.id = a.matcat_id  
WHERE a.sector_id = s.sector_id and cur_user=current_user 
AND a.matcat_id IS NULL AND sys_type !=''VARC''', 'All arcs have matcat_id filled.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(571, 'Arcs less than 20 cm.', 'core', 'Check epa-topology', 'ud', 2, 'pipes with length less than node proximity distance configured.', 'SELECT * FROM v_edit_inp_conduit WHERE st_length(the_geom) < (SELECT value::json->>''value'' FROM config_param_system WHERE parameter = ''edit_node_proximity'')::float', 'Standard minimun length checked. No values less than node proximity distance configured.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(572, 'arcs less than 5 cm.', 'core', 'Check epa-topology', 'ud', 3, 'conduits with length less than configured minimum length.', 'SELECT the_geom, st_length(the_geom) AS length FROM v_edit_inp_conduit WHERE st_length(the_geom) < (SELECT value FROM config_param_system WHERE parameter = ''epa_arc_minlength'')::float', 'Critical minimun length checked. No values less than configured minimum length found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(573, 'y0 on storage data', 'core', 'Check epa-data', 'ud', 3, 'storages with null values at least on mandatory columns for initial status (y0).', 'SELECT * FROM v_edit_inp_storage where (y0 is null)', 'No y0 column without values for storages.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(576, 'Check flow regulator length fits on destination arc (orifice)', 'core', 'Check epa-data', 'ud', 3, 'orifice flow regulator which has length that do not respect the minimum length for target arc.', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frorifice f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id 
AND cur_user=current_user AND 
flwreg_length + (SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All orifice flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(577, 'Check flow regulator length fits on destination arc (weir)', 'core', 'Check epa-data', 'ud', 3, 'weir flow regulator length do not respect the minimum length for target arc', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frweir f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All weir flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(578, 'Check flow regulator length fits on destination arc (outlet)', 'core', 'Check epa-data', 'ud', 3, 'outlet flow regulator length do not respect the minimum length for target arc', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frpump f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All outlet flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(579, 'Check flow regulator length fits on destination arc (pump)', 'core', 'Check epa-data', 'ud', 3, 'pump flow regulator length do not respect the minimum length for target arc.', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frpump f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All pump flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(580, 'Check valid relative timeseries', 'core', 'Check epa-data', 'ud', 3, 'columns on relative timeserires related to this exploitation with errors.', 'SELECT id, a.timser_id, case when a.time is not null then a.time end as time FROM v_edit_inp_timeseries_value a 
JOIN (SELECT id-1 as id, timser_id, case when time is not null then time end as time FROM v_edit_inp_timeseries_value)b USING (id) where a.time::time - b.time::time > ''0 seconds'' AND a.timser_id = b.timser_id', 'All relative timeseries related ot this exploitation are correctly defined.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(581, 'Check shape with null values on arc catalog', 'core', 'Check epa-data', 'utils', 3, 'ows on arc catalog without values on shape column.', 'SELECT * FROM cat_arc WHERE shape is null', 'No rows on arc catalog without values on shape column.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(582, 'Check geom1 with null values on arc catalog', 'core', 'Check epa-data', 'ud', 3, 'rows on arc catalog without values on shape column.', 'SELECT * FROM cat_arc WHERE geom1 is null', 'No rows on arc catalog without values on geom1 column.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(583, 'Missing data on inp tables', 'core', 'Check epa-data', 'ud', 3, 'missed features on inp tables. Please, check your data before continue', 'SELECT arc_id, ''arc'' as feature_tpe FROM arc JOIN
(select arc_id from inp_conduit UNION select arc_id from inp_virtual UNION select arc_id from inp_weir UNION select arc_id from inp_pump UNION select arc_id from inp_outlet UNION select arc_id from inp_orifice) a
USING (arc_id) 
WHERE state > 0 AND epa_type !=''UNDEFINED'' AND a.arc_id IS NULL
UNION
SELECT node_id, ''node'' FROM node JOIN
(select node_id from inp_junction UNION select node_id from inp_storage UNION select node_id from inp_outfall UNION select node_id from inp_divider) a
USING (node_id) 
WHERE state > 0 AND epa_type !=''UNDEFINED'' AND a.node_id IS NULL', 'No features missed on inp_tables found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(584, 'Nodes without elevation', 'core', 'Check epa-data', 'ud', 3, 'EPA nodes without sys_elevation values.', 'SELECT * FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE epa_type !=''UNDEFINED'' AND sys_elev IS NULL AND cur_user = current_user', 'No nodes with null values on field elevation have been found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(585, 'Check that EPA OBJECTS (pollutants) do not contain spaces', 'core', 'Check epa-data', 'ud', 3, 'pollutants have name with spaces. Please fix it!', 'SELECT * FROM inp_pollutant WHERE poll_id like''% %''', 'All pollutants checked have names without spaces.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(586, 'Check that EPA OBJECTS (snowpacks) do not contain spaces', 'core', 'Check epa-data', 'ud', 3, 'snowpacks have name with spaces. Please fix it!', 'SELECT * FROM inp_snowpack WHERE snow_id like''% %''', 'All snowpacks checked have names without spaces.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(587, 'Check that EPA OBJECTS (lids) do not contain spaces', 'core', 'Check epa-data', 'ud', 3, 'lids have name with spaces. Please fix it!', 'SELECT * FROM inp_lid WHERE lidco_id like''% %''', 'All lids checked have names without spaces.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(591, 'Check for inp_connec tables and epa_type consistency', 'core', 'Check epa-data', 'ws', 3, 'connecs features with epa_type not according with epa table. Check your data before continue.', 'SELECT * FROM (SELECT count(*) as c1, null AS c2 FROM connec UNION SELECT null, count(*) FROM inp_connec)a1 WHERE c1 > c2', 'Epa type for arc features checked. No inconsistencies aganints epa table found.Epa type for connec features checked. No inconsistencies aganints epa table found.', '[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name, addparam) VALUES(592, 'Control null values on crm.hydrometer.code', 'core', 'Function process', 'utils', 3, 'hydrometers in crm schema without code.', 'SELECT id FROM crm.hydrometer WHERE code IS NULL', 'All hydrometers on crm schema have code', '[gw_fct_om_check_data]', '{"addschema":"crm"}');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(593, 'Check estimated depth', 'core', 'Function process', 'utils', 2, 'rows without values on cat_arc.estimated_depth column.', 'SELECT * FROM cat_arc WHERE estimated_depth IS NOT NULL and active=TRUE', 'There is/are no rows without values on cat_arc.estimated_depth column.', '[gw_fct_plan_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(594, 'Null values on valve_type of virtualvalve', 'core', 'Check epa-data', 'ws', 1, 'virtualvalves with null values on valve_type column.', 'SELECT n.node_id, n.nodecat_id, n.the_geom, expl_id FROM man_valve JOIN v_prefix_node n USING (node_id) 
WHERE n.state = 1 AND (broken IS NULL OR closed IS NULL)', 'Virtualvalve valve_type checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(595, 'Null values on valve status of virtualvalves', 'core', 'Check epa-data', 'ws', 3, 'virtualvalves with null values on mandatory column status.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE status IS NULL AND state > 0', 'Virtualvalve status checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(596, 'Null values on virtualvalve pressure', 'core', 'Check epa-data', 'ws', 3, 'PBV-PRV-PSV virtualvalves with null values on the mandatory column for Pressure valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))', 'PBC-PRV-PSV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(597, 'Null values on GPV virtualvalve config', 'core', 'Check epa-data', 'ws', 3, 'GPV virtualvalves with null values on mandatory column for General purpose valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))', 'GPV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(598, 'Null values on TCV virtualvalve config', 'core', 'Check epa-data', 'ws', 3, 'TCV virtualvalves with null values on mandatory column for Losses Valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE valve_type=''TCV'' AND setting IS NULL', 'TCV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(599, 'Null values on FCV virtualvalve config', 'core', 'Check epa-data', 'ws', 3, 'FCV virtualvalves with null values on mandatory column for Flow Control Valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE ((valve_type=''FCV'') AND (setting IS NULL))', 'FCV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(600, 'Null values on virtualpumps type', 'core', 'Check epa-data', 'ws', 3, 'virtualpumps with null values on pump_type column. virtualpump''''s with null values on pump_type column.', 'SELECT * FROM v_edit_inp_virtualpump WHERE pump_type IS NULL', 'Virtualpumps checked. No mandatory values for pump_type missed. Virtualpumps checked. No mandatory values for pump_type missed.', '[gw_fct_plan_check_data, gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(601, 'Null values on virtualpump curve_id ', 'core', 'Check epa-data', 'ws', 3, 'virtualpumps with null values at least on mandatory column curve_id. virtualpumps with null values at least on mandatory column curve_id.', 'SELECT * FROM v_edit_inp_virtualpump WHERE curve_id IS NULL', 'Virtualpumps checked. No mandatory values for curve_id missed. Virtualpumps checked. No mandatory values for curve_id missed.', '[gw_fct_plan_check_data, gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(602, 'Check for inp_arc tables and epa_type consistency', 'core', 'Check epa-data', 'ws', 3, 'arcs features with epa_type not according with epa table. Check your data before continue.', 'with sub1 as (SELECT a.arc_id, a.arccat_id, concat(epa_type, '' using inp_pipe table'') AS epa_table, a.the_geom, a.sector_id FROM v_edit_inp_virtualvalve JOIN arc a USING (arc_id) WHERE epa_type !=''VIRTUAL''
		UNION
		SELECT a.arc_id, a.arccat_id,  concat(epa_type, '' using inp_virtualvalve table'') AS epa_table, a.the_geom, a.sector_id FROM v_edit_inp_pipe JOIN arc a USING (arc_id) WHERE epa_type !=''PIPE''
) select*from sub1', 'Epa type for arcs features checked. No inconsistencies aganints epa table found.Epa type for connec features checked. No inconsistencies aganints epa table found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(603, 'Check that EPA OBJECTS (patterns) name do not contain spaces', 'core', 'Check epa-config', 'utils', 3, 'patterns name with spaces. Please fix it!', 'SELECT * FROM inp_pattern WHERE pattern_id like''% %''', 'All patterns checked have names without spaces.', '[gw_fct_pg2epa_check_data]');


-- xtr (from 26/12/2024)
------------------------

-- pending
-- UPDATE sys_fprocess SET except_table = 'anl_loquesea' from discord
-- UPDATE sys_fprocess SET fprocess_name ='name normalizado' from discord


update sys_fprocess set query_text = replace(query_text,'v_prefix_', 't_');

UPDATE sys_fprocess set query_text = 'SELECT * FROM 
(SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state as state1, 
t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 106, t1.the_geom 
FROM t_node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 1 AND a.state2 = 1' WHERE fid = 106;

UPDATE sys_fprocess set query_text = 'with c as 
(select t_connec.connec_id, arc_id as arc, 
t_connec.conneccat_id, the_geom, t_connec.expl_id from t_connec)     
select c1.connec_id, c1.conneccat_id, c1.the_geom, c1.expl_id from link a 
left join c c1 on a.feature_id = c1.connec_id
left join c c2 on a.exit_id = c2.connec_id
where (a.exit_type =''CONNEC'') and c1.arc <> c2.arc'  WHERE fid = 205;

UPDATE sys_fprocess set query_text =
'with a as (SELECT arc_id, node_1, node_2, arccat_id, expl_id, state, the_geom FROM arc WHERE state = 1),
n1 as (SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_startpoint(arc.the_geom))) as d FROM node, arc 
WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_startpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
), 
n2 as (	SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_endpoint(arc.the_geom))) as d FROM node, arc 
WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_endpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
)
select a.* from a 
left join n1 on a.arc_id = n1.arc_id
left join n2 on a.arc_id = n2.arc_id 
where (a.node_1 != n1.node_id) or (a.node_2 != n2.node_id)' WHERE fid = 372;

UPDATE sys_fprocess set query_text =
'with
mec as ( -- links with startpoint close to connec
SELECT l.link_id as arc_id, c.conneccat_id as arccat_id, l.the_geom, l.expl_id FROM connec c, link l
WHERE l.state = 1 and c.state = 1 and ST_DWithin(ST_startpoint(l.the_geom), c.the_geom, 0.01) group by 1,2 ORDER BY 1 DESC
), 
moc as ( -- links connected to connec
SELECT link_id, feature_id, ''417'', l.state, l.the_geom 
FROM link l JOIN connec c ON feature_id = connec_id WHERE l.state = 1 and l.feature_type = ''CONNEC'') 
select * from mec where arc_id not in (select link_id from moc)'  WHERE fid = 417;

UPDATE sys_fprocess set query_text =
'SELECT * FROM (SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state as state1, 
t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 453, t1.the_geom 
FROM t_node AS t1 JOIN t_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 2 AND a.state2 = 2' WHERE fid = 453;

INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type)
VALUES (604, 'Check DB data', 'core', 'Function process', 'utils');

UPDATE config_param_system SET value= '{"omCheck":true, "graphCheck":true, "epaCheck":true, "planCheck":true, "adminCheck":true, "ignoreVerifiedExceptions":false}'
WHERE parameter = 'admin_checkproject';

update sys_fprocess set query_text = replace(query_text,'v_edit_', 't_');

update sys_fprocess set query_text = 'SELECT * FROM t_inp_inlet WHERE initlevel is null or minlevel is null or maxlevel is null or diameter is null or minvol is null'
where fid  =153;

update sys_fprocess set query_text = '
SELECT * FROM (
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n JOIN selector_sector USING (sector_id) 
JOIN t_arc a1 ON node_id=a1.node_1  AND n.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user 
UNION ALL 
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n JOIN selector_sector USING (sector_id) 
JOIN t_arc a1 ON node_id=a1.node_2  AND n.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user)a 
GROUP by node_id, nodecat_id, the_geom, expl_id HAVING count(*) > 2'
where fid = 166;

update sys_fprocess set query_text = 'SELECT arc_id, arccat_id, the_geom, expl_id FROM t_inp_pipe WHERE status =''CV'''
where fid = 169;

update sys_fprocess set query_text = '
select node_id, nodecat_id, n.the_geom,  n.expl_id
from man_valve join t_node n using (node_id) JOIN t_arc v on v.arc_id = to_arc
where node_id not in (node_1, node_2)'
where fid = 170;

update sys_fprocess set query_text = '
select node_id, nodecat_id, n.the_geom,  n.expl_id
from man_pump join t_node n using (node_id) JOIN t_arc v on v.arc_id = to_arc
where node_id not in (node_1, node_2)'
where fid = 171;

update sys_fprocess set query_text = 'SELECT * FROM t_inp_tank WHERE initlevel is null or minlevel is null or maxlevel is null or diameter is null or minvol is null'
where fid = 198;

update sys_fprocess set query_text = '
SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.the_geom, t1.expl_id,  st_distance(t1.the_geom, t2.the_geom) as dist
FROM t_node AS t1 JOIN t_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id AND ((t1.epa_type IN (''PUMP'', ''VALVE'') AND t2.epa_type !=''UNDEFINED'') OR 
(t2.epa_type IN (''PUMP'', ''VALVE'') AND t1.epa_type !=''UNDEFINED''))  ORDER BY dist'
where fid = 411;

update sys_fprocess set query_text = '
SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.the_geom, t1.expl_id,  st_distance(t1.the_geom, t2.the_geom) as dist
FROM t_node AS t1 JOIN t_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id AND ((t1.epa_type IN (''SHORTPIPE'') AND t2.epa_type !=''UNDEFINED'') OR 
(t2.epa_type IN (''SHORTPIPE'') AND t1.epa_type !=''UNDEFINED''))  ORDER BY dist'
where fid = 412;

update sys_fprocess set function_name ='[gw_fct_pg2epa_check_data]', query_text = '
SELECT  count(*), node_id, nodecat_id, the_geom, expl_id FROM (
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n
JOIN arc ON node_id=node_1 WHERE n.epa_type IN (''SHORTPIPE'')
UNION all
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n
JOIN arc ON node_id=node_2 WHERE n.epa_type IN (''SHORTPIPE''))a
GROUP by node_id, nodecat_id, the_geom, expl_id
HAVING count(*) < 2'
WHERE fid = 292;

UPDATE sys_fprocess SET
fprocess_name = 'Arc without node_1/node_2 (go2epa)',
except_level = 3,
except_msg = 'arcs without some node_1 or node_2 (go2epa)',
query_text = 'SELECT arc_id, arccat_id, the_geom, expl_id FROM temp_t_arc WHERE node_1 IS NULL UNION SELECT arc_id,	arccat_id, the_geom, expl_id FROM temp_t_arc WHERE node_2 IS NULL',
info_msg = 'No arcs without node_1 / node_2 found (goepa)',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 454;

UPDATE sys_fprocess SET
fprocess_name = 'Duplicated nodes (go2epa)',
except_level = 3,
except_msg = 'nodes duplicated (go2epa)',
query_text = 'SELECT DISTINCT ON(the_geom) n1.node_id as n1, n1.node_id as node_id, n2.node_id as n2, n1.the_geom, n1.nodecat_id, n1.expl_id FROM temp_t_node n1, temp_t_node n2 WHERE st_dwithin(n1.the_geom, n2.the_geom, 0.00001) AND n1.node_id != n2.node_id',
info_msg = 'No nodes duplicated found (goepa)',
except_table = 'anl_node',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 290;


UPDATE sys_fprocess SET
fprocess_name = 'Link over nodarc (go2epa)',
except_level = 3,
except_msg = 'links over nodarc (go2epa)',
query_text = 'select link_id as arc_id, conneccat_id as arccat_id, a.expl_id, l.the_geom FROM t_link l, temp_t_arc a WHERE st_dwithin(st_endpoint(l.the_geom), a.the_geom, 0.001) AND a.epa_type NOT IN (''CONDUIT'', ''PIPE'', ''VIRTUALVALVE'', ''VIRTUALPUMP'')',
info_msg = 'No links over nodarc found',
project_type = 'ud',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 404;


UPDATE sys_fprocess SET
fprocess_name = 'Arc disconnected from any inlet (go2epa)',
except_level = 3,
project_type = 'ws',
except_msg = 'arcs disconnected from any inlet which have been removed on the go2epa process. The reason may be: state_type, epa_type, sector_id, init age material of cat_roughness, or expl_id or some node not connected',
query_text = 'SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc where sector_id = 0',
info_msg = 'No arcs disconnected from any inlet found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 139;


UPDATE sys_fprocess SET
fprocess_name = 'Arc disconnected from any outfall (go2epa)',
except_level = 3,
project_type = 'ud',
except_msg = 'arcs disconnected from any outfall which have been removed on the go2epa process',
query_text = 'SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc where sector_id = 0',
info_msg = 'No arcs disconnected from any outfall found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 231;

UPDATE sys_fprocess SET
fprocess_name = 'Dry arc because closed elements (go2epa)',
except_level = 2,
project_type = 'ws',
except_msg = 'dry arcs because closed elements (go2epa)',
query_text = 'SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc WHERE dma_id = 0 and sector_id > 0',
info_msg = 'No arcs dry because closed elements found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 232;


UPDATE sys_fprocess SET
fprocess_name = 'Dry node/connec with associated demand (go2epa)',
except_level = 3,
project_type = 'ws',
except_msg = 'dry nodes/connecs with demand which have been set to cero on the go2epa process',
query_text = 'SELECT node_id, nodecat_id, expl_id, the_geom FROM temp_t_node WHERE demand > 0 and dma_id = 0',
info_msg = 'No connecs dry with associated demand found',
except_table = 'anl_node',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 233;


UPDATE sys_fprocess SET
fprocess_name = 'Arc with less length than minimum configured (go2epa)',
except_level = 2,
project_type = 'ud',
except_msg = 'arcs with less length than minimum configured (go2epa)',
query_text = '
	WITH 
	minlength AS (SELECT value::numeric FROM config_param_system WHERE parameter = ''epa_arc_minlength'')
	SELECT * FROM temp_t_arc, minlength WHERE st_length(the_geom) < value',
info_msg = 'No arcs with less length than minimum configured found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 431;


UPDATE sys_fprocess SET
fprocess_name = 'Check pumps with 3-point curves',
except_level = 2,
project_type = 'ud',
except_msg = 'pumps with curve defined by 3 points found. Check if this 3-points has thresholds defined (133%) acording EPANET user''s manual',
query_text = ' SELECT count(*) FROM (select curve_id, count(*) as ct from (select * from inp_curve_value 
			   join (select distinct curve_id FROM t_inp_pump)a using (curve_id)) b group by curve_id having count(*)=3)c',
info_msg = 'No curves with 3-points found',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 172;


UPDATE sys_fprocess SET
fprocess_name = 'Nodarc length control (go2epa)',
except_level = 2,
project_type = 'ud',
except_msg = 'arcs with less length than minimum configured (go2epa)',
query_text = '
	WITH 
	minlength AS (SELECT value::numeric FROM config_param_system WHERE parameter = ''epa_arc_minlength'')
	SELECT * FROM temp_t_arc, minlength WHERE st_length(the_geom) < value',
info_msg = 'No arcs with less length than minimum configured found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 375;


UPDATE sys_fprocess SET
fprocess_name = 'Arc with less length than minimum configured (go2epa)',
except_level = 3,
except_msg = 'value of roughness out of range acording headloss formula used',
query_text = '
	SELECT * FROM (WITH 
		rgh as (SELECT min(roughness), max(roughness) FROM cat_mat_roughness),
		hdl as (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter=''inp_options_headloss'')
		SELECT 
			case when value = ''D-W'' and min < 0.0025 or max > 0.15 then 1 
				 when value = ''H-W'' and min < 110 or max > 150 then 1
				 when value = ''C-M'' and min < 0.011 or max > 0.017 then 1
				 else 0 END roughness
		 from rgh, hdl) a WHERE roughness = 1',
info_msg = 'Roughness values have been checked against head-loss formula using the minimum and maximum EPANET user''s manual values. Any out-of-range values have been detected.',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 377;

-- TODO: Activate this process once 'top_elev' is added to 'ws.node'.
UPDATE sys_fprocess SET
fprocess_name = 'Connec/node with outlayer value on elevation',
except_level = 3,
except_msg = ' connecs/nodes found with outlayer values on elevation',
info_msg = 'All connec/nodes with elevation values according system tresholds',
query_text = '
	WITH 
	outlayer AS (SELECT ((value::json->>''elevation'')::json->>''max'')::numeric as max_elev, 
    ((value::json->>''elevation'')::json->>''min'')::numeric as min_elev FROM config_param_system WHERE parameter = ''epa_outlayer_values'')
	select node_id, nodecat_id from outlayer, node where top_elev < min_elev or top_elev > max_elev
	union
	select connec_id, conneccat_id from outlayer, connec where top_elev < min_elev or top_elev > max_elev',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = false
WHERE fid = 407;


insert into sys_fprocess (fid, fprocess_name, except_level, except_msg, info_msg, query_text, function_name, active) values
(605, 'Check EPA outlayer depth', 3, 'nodes/connecs found with outlayers values for depth', 'All nodes/connecs has depth values according system tresholds',
	'WITH 
	outlayer AS (SELECT ((value::json->>''depth'')::json->>''max'')::numeric as max_depth, 
    ((value::json->>''depth'')::json->>''min'')::numeric as min_depth FROM config_param_system WHERE parameter = ''epa_outlayer_values'')
	select node_id, nodecat_id from outlayer, node where coalesce(depth,0) < min_depth or coalesce(depth,0) > max_depth
	union
	select connec_id, conneccat_id from outlayer, connec where coalesce(depth,0) < min_depth or coalesce(depth,0) > max_depth',
	'[gw_fct_pg2epa_check_result]', true) on conflict (fid) do NOTHING;


-- TODO
--- NO SE COM RESOLDRE: networkmode AS (SELECT value::integer FROM config_param_user WHERE parameter = ''inp_options_networkmode'' AND cur_user = current_user)
--> es podria crear una funció nova que fos gw_fct_pg2epa_check_networkmode_connec
----------------------
UPDATE sys_fprocess SET
fprocess_name = 'EPA connec over EPA node (goe2pa)',
except_level = 3,
except_msg = 'EPA connecs over EPA nodes',
query_text = ' 
	SELECT connec_id, conneccat_id, expl_id, the_geom FROM (
	SELECT DISTINCT t2.connec_id, t2.conneccat_id , t2.expl_id, t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, t1.state as state1, t2.state as state2 
	FROM temp_t_node AS t1 JOIN temp_t_connec AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.1) 
	WHERE t1.epa_type != ''UNDEFINED''
	AND t2.epa_type = ''JUNCTION'') a 
    WHERE a.state1 > 0 AND a.state2 > 0 AND value = 4 ORDER BY dist',
except_table = 'anl_connec',
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
info_msg = 'No EPA connecs over EPA node have been detected.',
active = false
WHERE fid = 413;

UPDATE sys_fprocess SET
fprocess_name = 'Check pjoint_id/ pjoint_type on connec',
except_level = 3,
except_msg = 'Connec without pjoint_id/pjoint_type',
query_text = 'SELECT connec_id, conneccat_id, expl_id, the_geom FROM t_connec WHERE pjoint_id IS NULL OR pjoint_type IS NULL',
except_table = 'anl_connec',
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
active = true
WHERE fid = 415;

UPDATE sys_fprocess SET
fprocess_name = 'Check dint on connec catalog',
except_level = 3,
except_msg = 'Connec catalog without dint defined',
info_msg = 'All connec catalog registers has dint defined',
query_text = 'SELECT * FROM cat_connec WHERE dint is null',
except_table = null,
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
active = true
WHERE fid = 400;

-- TODO
UPDATE sys_fprocess SET
fprocess_name = 'Check material on connec catalog',
except_level = 3,
except_msg = 'Connec catalog without material defined',
info_msg = 'All connec catalog registers has material defined',
query_text = 'SELECT * FROM cat_connec, networkmode n WHERE matcat_id IS NULL',
except_table = null,
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
active = false
WHERE fid = 414;


UPDATE sys_fprocess SET
fprocess_name = 'Check controls for ARC',
except_level = 3,
except_msg = 'Controls with links (arc o nodarc) are not present on this result',
info_msg = 'All Controls has correct link id (arc or nodarc) values.',
query_text = '
        SELECT * FROM (SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
        (SELECT substring(split_part(text,''LINK '', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_controls WHERE active is true)a
        LEFT JOIN temp_t_arc b USING (arc_id)
        WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
        AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
        OR a.sector_id::text != b.sector_id::text) a',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 402;


insert into sys_fprocess values (606, 'Check controls for NODE');

UPDATE sys_fprocess SET
fprocess_name = 'Check controls for NODE',
except_level = 3,
except_msg = 'Controls with nodes are not present on this result',
info_msg = 'All Controls has correct node id values.',
query_text = '
SELECT * FROM (SELECT a.id, a.node_id as controls, b.node_id as templayer FROM 
(SELECT substring(split_part(text,''NODE '', 2) FROM ''[^ ]+''::text) node_id, id, sector_id FROM inp_controls WHERE active is true)a
LEFT JOIN temp_t_node b USING (node_id)
WHERE b.node_id IS NULL AND a.node_id IS NOT NULL 
AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
OR a.sector_id::text != b.sector_id::text) a',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 406;

insert into sys_fprocess values (607, 'Check rules for NODE','ws');
insert into sys_fprocess values (608, 'Check rules for JUNCTION','ws');
insert into sys_fprocess values (609, 'Check rules for RESERVOIR','ws');
insert into sys_fprocess values (610, 'Check rules for TANK','ws');
insert into sys_fprocess values (611, 'Check rules for LINK','ws');
insert into sys_fprocess values (612, 'Check rules for PIPE','ws');
insert into sys_fprocess values (613, 'Check rules for VALVE','ws');
insert into sys_fprocess values (614, 'Check rules for PUMP','ws');

insert into sys_fprocess values (615, 'Tank present in more than one enabled scenario','ws');
insert into sys_fprocess values (616, 'Reservoir present in more than one enabled scenario','ws');
insert into sys_fprocess values (617, 'Junction present in more than one enabled scenario','ws');
insert into sys_fprocess values (618, 'Pipe present in more than one enabled scenario','ws');
insert into sys_fprocess values (619, 'Pump present in more than one enabled scenario','ws');
insert into sys_fprocess values (620, 'Pump additional present in more than one enabled scenario','ws');
insert into sys_fprocess values (621, 'Valve present in more than one enabled scenario','ws');
insert into sys_fprocess values (622, 'Virtualvalve present in more than one enabled scenario','ws');
insert into sys_fprocess values (623, 'Virtualpump present in more than one enabled scenario','ws');
insert into sys_fprocess values (624, 'Inlet present in more than one enabled scenario','ws');
insert into sys_fprocess values (625, 'Connec present in more than one enabled scenario','ws');

insert into sys_fprocess values (626, 'Outfall present in more than one enabled scenario','ud');
insert into sys_fprocess values (627, 'Outlet present in more than one enabled scenario','ud');
insert into sys_fprocess values (628, 'Storage present in more than one enabled scenario','ud');
insert into sys_fprocess values (629, 'Rainage present in more than one enabled scenario','ud');
insert into sys_fprocess values (630, 'Conduit present in more than one enabled scenario','ud');
insert into sys_fprocess values (631, 'Pump additional present in more than one enabled scenario','ud');
insert into sys_fprocess values (632, 'Orifice present in more than one enabled scenario','ud');
insert into sys_fprocess values (633, 'Pump present in more than one enabled scenario','ud');
insert into sys_fprocess values (634, 'Weir present in more than one enabled scenario','ud');
insert into sys_fprocess values (635, 'Junction present in more than one enabled scenario','ud');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(636, 'dma-nodeparent acording with graph_delimiter (unactive dma)', 'ws', NULL, 'core', true, 'Check graph-config', NULL, 2, 'nodes with ''DMA''  is on cat_feature_node.graph_delimiter array configured for unactive mapzone.', NULL, NULL, 'SELECT node_id, nodecat_id, the_geom, t_node.expl_id FROM t_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type LEFT JOIN (SELECT node_id FROM t_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer as node_id FROM t_dma WHERE graphconfig IS NOT NULL )a USING (node_id)) a USING (node_id) WHERE ''DMA'' = ANY(graph_delimiter) AND (a.node_id IS NULL  OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM t_dma)) AND t_node.state > 0 and verified <> 2', 'All nodes with cat_feature_node.graph_delimiter=''DMA'' are defined as nodeParent on dma.graphconfig', '[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]', true) ON CONFLICT (fid) DO NOTHING;

UPDATE sys_fprocess SET except_table='anl_arc' WHERE fid=103;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=106;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=107;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=111;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=113;
UPDATE sys_fprocess SET fprocess_name='Inlet with null mandatory values', except_table='anl_node' WHERE fid=153;
UPDATE sys_fprocess SET fprocess_name='Node without elevation', except_table='anl_node' WHERE fid=164;
UPDATE sys_fprocess SET fprocess_name='Node with elevation=0', except_table='anl_node' WHERE fid=165;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=166;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=167;
UPDATE sys_fprocess SET fprocess_name='Pipe with status CV', except_table='anl_arc' WHERE fid=169;
UPDATE sys_fprocess SET fprocess_name='Valve with wrong to_arc', except_table='anl_node' WHERE fid=170;
UPDATE sys_fprocess SET fprocess_name='Pump with wrong to_arc', except_table='anl_node' WHERE fid=171;
UPDATE sys_fprocess SET fprocess_name='Valve with null values closed/broken', except_table='anl_node' WHERE fid=176;


ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3326, 'gw_fct_graphanalytics_arrangenetwork', 'utils', 'function', NULL, 'json', 'Function to arrenge the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3328, 'gw_fct_graphanalytics_initnetwork', 'utils', 'function', 'json', 'json', 'Function to init the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3330, 'gw_fct_graphanalytics_create_temptables', 'utils', 'function', 'json', 'json', 'Function to create temporal tables for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3332, 'gw_fct_graphanalytics_delete_temptables', 'utils', 'function', 'json', 'json', 'Function to create temporal tables for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3334, 'gw_fct_graphanalytics_settempgeom', 'utils', 'function', 'json', 'json', 'Function to update the geometry of the mapzones in the temp_minsector table for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3336, 'gw_fct_graphanalytics_macrominsector', 'utils', 'function', 'json', 'json', 'Function to create macrominsectors', 'role_master', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

-- update graphanalytic_minsector description to include explotation id description
UPDATE sys_function SET descript='Dynamic analisys to sectorize network using the flow traceability function and establish Minimum Sectors. 
Before start you need to configure:
- Field graph_delimiter on [cat_feature_node] table to establish which elements will be used to sectorize. 
- Enable status for minsector on utils_graphanalytics_status variable from [config_param_system] table.

In explotation id you can use ''-9'' to select all explotations, or a list of explotations separated by comma.'
WHERE id=2706;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3336, 'Macrominsector analysis', '{"featureType":[]}'::json, NULL, NULL, true, '{4}');

INSERT INTO sys_param_user VALUES ('utils_psector_strategy', 'config', 'Psector strategy', 'role_master', null, 'Value for psector_strategy', null, null, TRUE,
20, 'utils', FALSE, null, null, null, FALSE, 'text', 'check', TRUE, null, 'true', 'lyt_other', TRUE, null, null, null, null, 'core') ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3338,'gw_fct_getgraphinundation','utils','function',NULL,'json','Retrieves GeoJSON data representing the inundation (flooding) graph for a specific area','role_edit','core');


INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3336, 'gw_fct_getgraphinundation', '{
  "style": {
    "line": {
      "style": "unique",
      "values": {
        "width": 1.5,
        "color": [
          0,
          0,
          255
        ],
        "transparency": 0.7
      }
    }
  }
}'::json, NULL, NULL);


UPDATE sys_feature_class SET man_table  = 'element' WHERE id = 'ELEMENT';
UPDATE sys_feature_class SET man_table  = 'link' WHERE id = 'LINK';

ALTER TABLE sys_feature_class ALTER COLUMN man_table SET NOT NULL;


UPDATE config_form_fields SET widgetcontrols='{
  "reloadFields": [
    "fluid_type",
    "location_type",
    "category_type",
    "function_type",
    "featurecat_id"
  ]
}'::json WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';


UPDATE config_form_fields
  SET widgetcontrols='{"labelPosition": "top", "filterSign": ">="}'::json
  WHERE formtype='form_feature' AND columnname='date_event_from' AND tabname='tab_event';
UPDATE config_form_fields
  SET widgetcontrols='{"labelPosition": "top", "filterSign": "<="}'::json
  WHERE formtype='form_feature' AND columnname='date_event_to' AND tabname='tab_event';


INSERT INTO config_style (id,idval,is_templayer,active)
	VALUES (109,'GwSelectedPsector',true,true);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3340, 'gw_fct_getpsectorfeatures', 'utils', 'function', 'json', 'json', 'Retrieves GeoJSON data with all the features from the selected psector ', 'role_edit', NULL, 'core');

INSERT INTO config_function (id,function_name,"style")
	VALUES (3340,'gw_fct_getpsectorfeatures','{
  "style": {
    "point": {
      "style": "qml",
      "id": "109"
    },
    "line": {
      "style": "qml",
      "id": "109"
    }
  }
}'::json);

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('line', 109, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.34.7-Prizren">
  <renderer-v2 attr="state" enableorderby="0" symbollevels="0" forceraster="0" referencescale="-1" type="categorizedSymbol">
    <categories>
      <category symbol="0" render="true" type="string" label="0" uuid="{29a5669a-e822-4c73-b36c-7525620f3c98}" value="0"/>
      <category symbol="1" render="true" type="string" label="1" uuid="{85682659-f88f-41b7-8234-84fc30c576b2}" value="1"/>
    </categories>
    <symbols>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="1" force_rhr="0" type="line" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{a391b56d-2384-467a-ade2-b0885f58876d}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="219,30,42,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.66"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="1" force_rhr="0" type="line" name="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9d0ced51-3130-401a-a360-e50baff730f8}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="84,176,74,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.66"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="0.5" force_rhr="0" type="line" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{a187d0f2-a38f-4516-bb7b-6db32e370dbf}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="255,1,1,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="2"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="1" force_rhr="0" type="line" name="">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{b8e8cee6-e913-4fe1-ad85-fd1b7d97a05b}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="35,35,35,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.26"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>', true);

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('point', 109, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.34.7-Prizren">
  <renderer-v2 type="categorizedSymbol" symbollevels="0" attr="state" enableorderby="0" forceraster="0" referencescale="-1">
    <categories>
      <category type="string" uuid="{f8df73fa-3878-4caf-a44f-e30b3d14c36c}" label="0" symbol="0" value="0" render="true"/>
      <category type="string" uuid="{80f70d8a-963a-4de8-858a-7f0fb1934891}" label="1" symbol="1" value="1" render="true"/>
    </categories>
    <symbols>
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{81483f17-9467-4a85-9ff7-f65635a16ac1}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="219,30,42,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{81483f17-9467-4a85-9ff7-f65635a16ac1}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="84,176,74,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{81483f17-9467-4a85-9ff7-f65635a16ac1}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,1,1,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{b137c48a-f52b-41be-b83b-5d204974aab6}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,0,0,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>', true);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3342, 'gw_fct_set_current', 'utils', 'function', 'json', 'json', 'Sets the selected value as "current" for the user in config_param_user(value) and return the id and name to set it on label', 'role_basic', NULL, 'core');




DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_param_energy' AND target_table='inp_pump' AND target_field='energyparam';
DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_param_energy' AND target_table='inp_pump_additional' AND target_field='energyparam';
DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_param_energy' AND target_table='inp_dscenario_pump_additional' AND target_field='energyparam';

DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_pattern_type' AND target_table='inp_pattern' AND target_field='pattern_type';

DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_status_valve' AND target_table='inp_valve' AND target_field='status';

DELETE FROM sys_foreignkey  WHERE typevalue_table='config_typevalue' AND typevalue_name='linkedaction_typevalue' AND target_table='config_form_fields' AND target_field='linkedaction';

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue='inp_value_param_energy' AND id='EFFIC';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_param_energy' AND id='PATTERN';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_param_energy' AND id='PRICE';

DELETE FROM inp_typevalue WHERE typevalue='inp_value_pattern_type' AND id='VOLUME';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_pattern_type' AND id='UNITARY';

DELETE FROM inp_typevalue WHERE typevalue='inp_value_status_valve' AND id='CLOSED';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_status_valve' AND id='OPEN';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

ALTER TABLE config_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM config_typevalue WHERE typevalue='linkedaction_typevalue' AND id='action_catalog';
DELETE FROM config_typevalue WHERE typevalue='linkedaction_typevalue' AND id='action_link';
DELETE FROM config_typevalue WHERE typevalue='linkedaction_typevalue' AND id='action_workcat';
ALTER TABLE config_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

DELETE FROM plan_typevalue WHERE typevalue = 'result_type';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (474, 'Get epa calibration file for pressures', 'ws', NULL, 'core', true, 'Function process', NULL) ON CONFLICT (fid) DO NOTHING;
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (475, 'Get epa calibration file for volumes', 'ws', NULL, 'core', true, 'Function process', NULL) ON CONFLICT (fid) DO NOTHING;
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (476, 'Get log for epa calibration volumes', 'ws', NULL, 'core', true, 'Function process', NULL) ON CONFLICT (fid) DO NOTHING;


INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (474, 'vcp_pipes', '[PIPES]', NULL, 1, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_times', '[TIMES]', NULL, 1, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_dma', '[DMA]', NULL, 2, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_junction', '[JUNCTIONS]', NULL, 3, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_emitters', '[EMITTERS]', NULL, 4, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_demands', '[DEMANDS]', NULL, 5, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_patterns', '[PATTERNS]', NULL, 6, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (476, 'vcv_emitters_log', '[EMITTER]', NULL, 1, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (476, 'vcv_dma_log', '[DMA]', NULL, 2, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_times', 'View times for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_dma', 'View dma for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_emitters', 'View emitters for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3344, 'gw_fct_getepacalfile', 'utils', 'function', 'json', 'json', 'Function to get calibration files from epatools', 'role_admin', NULL, 'core');


INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) VALUES(532, 'Dynamic macrominsector analysis', 'utils', NULL, 'core', true, 'Function process', NULL);


UPDATE config_form_fields
	SET stylesheet='{"icon":"129"}'::json
	WHERE stylesheet->>'icon'='70';

UPDATE config_form_fields
	SET stylesheet='{"icon":"113"}'::json
	WHERE stylesheet->>'icon'='111b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"143"}'::json
	WHERE stylesheet->>'icon'='131b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"144"}'::json
	WHERE stylesheet->>'icon'='134b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"147"}'::json
	WHERE stylesheet->>'icon'='170b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"145"}'::json
	WHERE stylesheet->>'icon'='136b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"114"}'::json
	WHERE stylesheet->>'icon'='112b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"119"}'::json
	WHERE stylesheet->>'icon'='64';

UPDATE config_form_fields
	SET stylesheet='{"icon":"101"}'::json
	WHERE stylesheet->>'icon'='101';

UPDATE config_form_fields
	SET stylesheet='{"icon":"127"}'::json
	WHERE stylesheet->>'icon'='65';

UPDATE config_form_fields
	SET stylesheet='{"icon":"149"}'::json
	WHERE stylesheet->>'icon'='191';

UPDATE config_form_fields
	SET stylesheet='{"icon":"152"}'::json
	WHERE stylesheet->>'icon'='195';


UPDATE config_form_fields SET widgettype='typeahead' WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='featurecat_id' AND tabname='tab_none';



INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3346, 'gw_trg_mantypevalue_fk', 'utils', 'trigger', NULL, NULL, 'Control foreign keys created in man_type_* tables', 'role_edit', 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3348, 'gw_fct_get_dialog', 'utils', 'function', 'json', 'json', 'Function to build dialogs for generic forms', 'role_basic', 'core');

UPDATE config_form_fields SET widgetfunction='{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}'::json WHERE formname='connec' AND formtype='form_feature' AND columnname='btn_link' AND tabname='tab_hydrometer';
UPDATE config_form_fields SET widgetfunction='{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}'::json WHERE formname='node' AND formtype='form_feature' AND columnname='btn_link' AND tabname='tab_hydrometer';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('arc', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"70", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_elements_tbl_elements", "columnfind": "link"}}'::json, 'v_edit_arc', false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"70", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_elements_tbl_elements", "columnfind": "link"}}'::json, 'v_edit_node', false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"70", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_elements_tbl_elements", "columnfind": "link"}}'::json, 'v_edit_connec', false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3350, 'gw_fct_set_epa_selector', 'utils', 'function', 'json', 'json', 'Function to update tables with new selected values', 'role_basic', 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3352, 'gw_fct_get_epa_selector', 'utils', 'function', 'json', 'json', 'Function to get epa selector dialog with filled combos', 'role_basic', 'core');


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_select_1', 'lyt_epa_select_1', 'layoutEpaSelector1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_select_2', 'lyt_epa_select_2', 'layoutEpaSelector2', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_select_3', 'lyt_epa_select_3', 'layoutEpaSelector3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_result_1', 'lyt_result_1', 'layoutResult1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_time_1', 'lyt_time_1', 'layoutTime1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_result', 'tab_result', 'tabResult', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_time', 'tab_time', 'tabTime', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('widgettype_typevalue', 'tabwidget', 'tabwidget', 'tabwidget', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'epa_selector', 'epa_selector', 'epaSelector', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('epa_selector', 'tab_result', 'Result', 'Result', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'btn_cancel', 'lyt_buttons', 2, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Cancel"
}'::json, '{
  "functionName": "close_dlg",
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Accept"
}'::json, '{
  "functionName": "accept",
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'spacer', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('epa_selector_tab_result', '{"layouts":["lyt_result_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_mngr_3', 'lyt_epa_mngr_3', 'layoutEpaManager3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_mngr_1', 'lyt_epa_mngr_1', 'layoutEpaManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_mngr_2', 'lyt_epa_mngr_2', 'layoutEpaManager2', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'epa_manager', 'epa_manager', 'epaManager', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{"functionName": "closeDlg"}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_manager', 'tab_none', 'txt_info', 'lyt_epa_mngr_1', 1, NULL, 'textarea', 'Info:', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_manager', 'tab_none', 'table_view', 'lyt_epa_mngr_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'epa_results', false, 0);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'addparam', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'export_options', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "result_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'inp_options', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'network_stats', NULL, false, NULL, NULL, NULL, NULL);


UPDATE config_form_fields
	SET widgetfunction='{"functionName": "btn_accept_featuretype_change", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_accept' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "btn_cancel_featuretype_change", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_cancel' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "btn_catalog_featuretype_change", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_catalog' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "cmb_new_featuretype_selection_changed", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source") VALUES('epa_maxresults_peruser', 'hidden', 'Limit of maximum number of models for user', 'role_epa', NULL, NULL, NULL, NULL, NULL, NULL, 'utils', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, NULL, '20', NULL, NULL, NULL, NULL, NULL, NULL, 'core');


DELETE FROM sys_table where id = 'v_sector_node';

DELETE FROM config_toolbox WHERE id = 3204;
DELETE FROM sys_function WHERE id = 3204;
DELETE FROM sys_function WHERE id = 3238;
DELETE FROM sys_function WHERE id = 3190;


DELETE FROM sys_table WHERE id = 'node_border_sector';



INSERT INTO doc (id, "name", doc_type, "path", observ, "date", user_name, tstamp, the_geom)
SELECT id, "name", doc_type, "path", observ, "date", user_name, tstamp, the_geom FROM _doc;

-- 09/12(2024
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  }
]'::json, 0, '{4,5}');

DELETE FROM config_fprocess WHERE fid=239 AND tablename='vi_backdrop' AND target='[BACKDROP]';
DELETE FROM config_fprocess WHERE fid=141 AND tablename='vi_t_backdrop' AND target='[BACKDROP]';


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3354, 'gw_fct_getlid', 'ud', 'function', 'json', 'json', 'Function to get lid dialog with filled combos', 'role_basic', 'core');


INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('edit_arc_automatic_link2netowrk', '{"active":"false", "buffer":"10"}', current_user)
ON CONFLICT ("parameter", cur_user) DO NOTHING;

UPDATE sys_message SET log_level=2 WHERE id=3268; --get closest address


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3356, 'gw_trg_cat_material_fk', 'utils', 'trigger', NULL, NULL, 'Control foreign keys created in cat_material', 'role_edit', 'core');

DELETE FROM sys_table WHERE id='cat_mat_node';
DELETE FROM sys_table WHERE id='cat_mat_arc';
DELETE FROM sys_table WHERE id='cat_mat_element';

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('cat_material', 'Catalog of materials.', 'role_edit', 2, '{"level_1":"INVENTORY","level_2":"CATALOGS"}', 7, 'Materials catalog', NULL, NULL, NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3358, 'gw_fct_admin_transfer_cat_material', 'utils', 'function', NULL, NULL, 'Function to transfer all values from old cat_mat_* tables to new one: cat_material', 'role_edit', 'core');


UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='inp_cat_mat_roughness' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_mat_roughness' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_arc' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_arc' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_arc' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='inp_dscenario_conduit' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='v_edit_gully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully_gully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully_pgully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully_vgully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='v_edit_inp_dscenario_conduit' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_node' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_node' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_node' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_connec' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_connec' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_connec' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_node' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''ELEMENT'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_element' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_gully' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_gully' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_gully' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_grate' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_arc', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_arc%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_node', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_node%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_grate', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_grate%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_gully', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_gully%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_connec', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_connec%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_element', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_element%';


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3360, 'gw_fct_create_thyssen_subcatchments', 'ud', 'function', 'json', 'json', 'Calculate subcatchment parameters.', 'role_epa', NULL, 'core');


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_mngr_2', 'lyt_dscenario_mngr_2', 'layoutDscenarioManager2', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_mngr_3', 'lyt_dscenario_mngr_3', 'layoutDscenarioManager3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_mngr_1', 'lyt_dscenario_mngr_1', 'layoutDscenarioManager1', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'dscenario_manager', 'dscenario_manager', 'dscenarioManager', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'chk_show_inactive', 'lyt_dscenario_mngr_1', 0, 'boolean', 'check', 'Show inactive', 'Show inactive', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "functionName": "showInactive"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'spacer_1', 'lyt_dscenario_mngr_1', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{"functionName": "close_dlg"}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'table_view', 'lyt_dscenario_mngr_2', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_results', false, 0);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'active', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'descript', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'dscenario_type', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'expl_id', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'id', 0, true, NULL, NULL, NULL, '{
  "header": "dscenario_id",
  "accessorKey": "id"
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'log', 7, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'name', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "name",
  "header": "name",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'parent_id', 4, true, NULL, NULL, NULL, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_2', 'lyt_dscenario_2', 'layoutDscenario2', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_3', 'lyt_dscenario_3', 'layoutDscenario3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_1', 'lyt_dscenario_1', 'layoutDscenario1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'dscenario', 'dscenario', 'dscenario', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close_dlg"
}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'spacer', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);




ALTER TABLE IF EXISTS config_style ADD CONSTRAINT idval_chk UNIQUE (idval);


UPDATE sys_param_user SET id='plan_psector_current' WHERE id='plan_psector_vdefault';


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3362, 'gw_fct_create_logtables', 'utils', 'function', 'json', 'json', 'Create temporal tables for check process.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3364, 'gw_fct_setcheckdatabase', 'utils', 'function', 'json', 'json', 'Check database exceptions.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3366, 'gw_fct_create_logreturn', 'utils', 'function', 'json', 'json', 'Create log return for check functions.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3368, 'gw_fct_create_querytables', 'utils', 'function', 'json', 'json', 'Create temporal tables for check process.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3370, 'gw_fct_create_return', 'utils', 'function', 'json', 'json', 'Create return for all fucntions.', 'role_basic', NULL, 'core');

DELETE FROM sys_param_user where id='utils_checkproject_database';
DELETE FROM sys_param_user where id='utils_checkproject_qgislayer';
DELETE FROM sys_param_user where id='qgis_form_initproject_hidden';

UPDATE config_param_system SET value = '
{"omCheck":true, "graphCheck":false, "epaCheck":false, "planCheck":false, "adminCheck":false, "verifiedExceptions":false}'
WHERE parameter = 'admin_checkproject';

UPDATE sys_function SET project_type = 'utils' WHERE id = 2430;


UPDATE config_form_fields
	SET stylesheet='{"icon":"173"}'::json
	WHERE formtype='form_feature' AND columnname='btn_link' AND tabname='tab_elements';


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_workspace_mngr_3', 'lyt_workspace_mngr_3', 'layoutWorkspaceManager3', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_workspace_mngr_1', 'lyt_workspace_mngr_1', 'layoutWorkspaceManager1', '{
"lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_workspace_mngr_2', 'lyt_workspace_mngr_2', 'layoutWorkspaceManager2', '{
"lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('formtype_typevalue', 'workspace_manager', 'workspace_manager', 'workspaceManager', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'workspace_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Close"
}'::json, '{"functionName": "closeDlg"}'::json, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'workspace_manager', 'tab_none', 'txt_info', 'lyt_workspace_mngr_1', 1, NULL, 'textarea', 'Info:', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'workspace_manager', 'tab_none', 'table_view', 'lyt_workspace_mngr_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'workspace_results', false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_workspace_manager', 'SELECT id, "name", private::text, descript, config::text FROM v_ui_workspace', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
"widgetfunction": {
"functionName": "setCurrent",
"params": {}
},
"color": "default",
"text": "Set Current",
"disableOnSelect": true,
"moreThanOneDisable": true
},
{
"widgetfunction": {
"functionName": "togglePrivacy",
"params": {}
},
"color": "default",
"text": "Toggle privacy",
"disableOnSelect": true,
"moreThanOneDisable": false
},
{
"widgetfunction": {
"functionName": "create",
"params": {}
},
"color": "success",
"text": "Create",
"disableOnSelect": false,
"moreThanOneDisable": false
},
{
"widgetfunction": {
"functionName": "edit",
"params": {}
},
"color": "info",
"text": "Edit",
"disableOnSelect": true,
"moreThanOneDisable": true
},
{
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

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'id', 0, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'name', 1, true, NULL, NULL, NULL, '{
"accessorKey": "name",
"header": "Name",
"filterVariant": "text",
"enableSorting": true,
"enableColumnOrdering": true,
"enableColumnFilter": true,
"enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'private', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'descript', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'config', 4, false, NULL, NULL, NULL, NULL);

INSERT INTO config_typevalue (typevalue,id,idval,camelstyle,addparam)
VALUES ('layout_name_typevalue','lyt_workspace_open_1','lyt_workspace_open_1','layoutWorkspaceOpen1','{
"lytOrientation": "vertical"
}'::json);

INSERT INTO config_typevalue (typevalue,id,idval,camelstyle)
VALUES ('formtype_typevalue','workspace_open','workspace_open','workspaceOpen');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'name', 'lyt_workspace_open_1', 0, NULL, 'text', 'Workspace name: ', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'private', 'lyt_workspace_open_1', 2, NULL, 'check', 'Private Workspace:', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'descript', 'lyt_workspace_open_1', 1, NULL, 'textarea', 'Description: ', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', '', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Save"
}'::json, '{
"functionName": "saveFeat"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', '', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Close"
}'::json, '{
"functionName": "closeDlg"
}'::json, NULL, false, 0);


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3374, 'gw_fct_featurechanges', 'utils', 'function', 'json', 'json', 'Upsert assets in gis', 'role_basic', NULL, 'core');


UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json
	WHERE formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json
	WHERE formtype='form_feature' AND columnname='btn_link' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json
	WHERE formtype='form_feature' AND columnname='delete_element' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetcontrols='{"onContextMenu":"Open gallery"}'::json
	WHERE formtype='form_feature' AND columnname='btn_open_gallery' AND tabname='tab_event';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}'::json
	WHERE formtype='form_feature' AND columnname='btn_open_visit_event' AND tabname='tab_event';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}'::json
	WHERE formtype='form_feature' AND columnname='btn_open_visit_doc' AND tabname='tab_event';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json
	WHERE formtype='form_feature' AND columnname='btn_doc_delete' AND tabname='tab_documents';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json
	WHERE formtype='form_feature' AND columnname='open_doc' AND tabname='tab_documents';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "onContextMenu":"Edit dscenario"}'::json
	WHERE formtype='form_feature' AND tabname='tab_epa' AND columnname='edit_dscenario';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "onContextMenu":"Delete dscenario"}'::json
	WHERE formtype='form_feature' AND tabname='tab_epa' AND columnname='remove_from_dscenario';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3376, 'gw_fct_getwidgets_checkproject', 'utils', 'function', 'json', 'json', 'Set widgets to show in check project button according to user''s role.', 'role_basic', NULL, 'core');


UPDATE config_form_tabs SET device='{4,5}' WHERE formname='selector_basic' AND tabname='tab_sector';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'check_project', 'check_project', 'checkProject', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_log', 'tab_log', 'tabLog', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_log', 'txt_infolog', 'lyt_data_2', 0, NULL, 'textarea', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'om_check', 'lyt_data_1', 1, NULL, 'check', 'Check om data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_basic"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'epa_check', 'lyt_data_1', 2, NULL, 'check', 'Check EPA data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_epa"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'plan_check', 'lyt_data_1', 3, NULL, 'check', 'Check plan data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_plan"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'admin_check', 'lyt_data_1', 4, NULL, 'check', 'Check admin data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_admin"}'::json, NULL, NULL, false, 1);

UPDATE config_form_fields SET columnname='conneccat_id' WHERE formname='v_edit_link' AND formtype='form_feature' AND columnname='connecat_id' AND tabname='tab_none';



INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3380, 'gw_fct_getlayerstofilter', 'utils', 'function', 'json', 'json', 'Function to filter WMS layers with imported columns', 'role_basic', NULL, 'core');


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'psector_manager', 'psector_manager', 'psectorManager', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_mngr_1', 'lyt_psector_mngr_1', 'layoutPsectorManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_mngr_2', 'lyt_psector_mngr_2', 'layoutPsectorManager2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_mngr_3', 'lyt_psector_mngr_3', 'layoutPsectorManager3', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{"functionName": "closeDlg"}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'chk_show_inactive', 'lyt_psector_mngr_1', 0, 'boolean', 'check', 'Show inactive', 'Show inactive', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "functionName": "showInactive"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'spacer_1', 'lyt_psector_mngr_1', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'table_view', 'lyt_psector_mngr_2', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'psector_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'txt_info', 'lyt_psector_mngr_2', 1, NULL, 'textarea', 'Info:', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('psector_results', 'SELECT psector_id AS id, ext_code, name, descript, priority, status, text1, text2, observ, vat, other, expl_id, psector_type, active::text, workcat_id, parent_id FROM plan_psector WHERE psector_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
        "id": "name",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_show_psector",
      "widgetfunction": {
        "functionName": "showPsector",
        "params": {}
      },
      "color": "default",
      "text": "Show psector",
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



UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json
	WHERE formname='connec' AND formtype='form_feature' AND columnname='btn_link' AND tabname='tab_hydrometer';

-- edit_typevalue
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '1', 'GMAO', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '2', 'CRM', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '3', 'DEM', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '4', 'TOPO', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3382, 'gw_fct_import_epanet_nodarcs', 'ws', 'function', 'json', 'json', 'Function to manage nodarcs after importing INP file', 'role_epa', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3384, 'gw_fct_import_swmm_flwreg', 'ud', 'function', 'json', 'json', 'Function to manage nodarcs after importing INP file', 'role_epa', NULL, 'core');


UPDATE config_form_list SET listname='v_ui_hydrometer' WHERE listname='tbl_hydrometer';

UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL AND curve_type = ''STORAGE'''
WHERE formname='ve_epa_storage' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';

UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL AND curve_type IN (''PUMP'', ''PUMP1'', ''PUMP2'', ''PUMP3'', ''PUMP4'')'
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';

UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_node WHERE node_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_node' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_arc WHERE arc_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_arc' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_connec WHERE connec_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_connec' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_gully WHERE gully_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_gully' AND device=4;

UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_arc WHERE arc_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_arc' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_node WHERE node_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_node' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_connec WHERE connec_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_connec' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_gully WHERE gully_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_gully' AND device=4;

UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_arc WHERE arc_id IS NOT NULL', vdefault=NULL WHERE listname='v_ui_element_x_arc' AND device=3;


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_log_1', 'lyt_log_1', 'lytLog1', NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_data_4', 'lyt_data_4', 'layoutData4', '{"createAddfield":"TRUE"}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'versions_check', 'lyt_data_1', 1, NULL, 'check', 'Versions', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'graph_check', 'lyt_data_3', 2, NULL, 'check', 'Check graph data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_basic"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'qgisproj_check', 'lyt_data_1', 2, NULL, 'check', 'Qgis Project', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'Info:', 'lyt_data_4', 0, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "vdefault_value": "This function verifies both the project and the database. For the database verification, all objects selected by the user through their sector and exploitation selector are checked."
}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'verified_exceptions', 'lyt_data_2', 0, NULL, 'check', 'Ignore verified exception:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_basic"}'::json, NULL, NULL, false, 1);
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=1, "datatype"=NULL, widgettype='check', "label"='Check om data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_basic"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='om_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=2, "datatype"=NULL, widgettype='check', "label"='Check graph data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_basic"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='graph_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=3, "datatype"=NULL, widgettype='check', "label"='Check EPA data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_epa"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='epa_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=4, "datatype"=NULL, widgettype='check', "label"='Check plan data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{
  "minRole": "role_master"
}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='plan_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=5, "datatype"=NULL, widgettype='check', "label"='Check admin data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_admin"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='admin_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_log_1', layoutorder=0, "datatype"=NULL, widgettype='textarea', "label"=NULL, tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols=NULL, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='txt_infolog' AND tabname='tab_log';


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3386, 'gw_fct_manage_relations', 'utils', 'function', 'json', 'json', 'Function to manage relations between elements and documents', 'role_edit', NULL, 'core');

UPDATE sys_message
SET error_message = 'The inserted catalog value does not exist --> %catalog_value%'
WHERE id = 3282;

UPDATE sys_fprocess SET fprocess_name='EPA connec over EPA node (goe2pa)', project_type='ws', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-result', addparam=NULL, except_level=3, except_msg='EPA connecs over EPA nodes', except_table='anl_connec', except_table_msg=NULL, query_text='	SELECT connec_id, conneccat_id, expl_id, the_geom FROM (
	SELECT DISTINCT t2.connec_id, t2.conneccat_id , t2.expl_id, t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, t1.state as state1, t2.state as state2 
	FROM v_edit_node AS t1 JOIN v_edit_connec AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.1) 
	WHERE t1.epa_type != ''UNDEFINED''
	AND t2.epa_type = ''JUNCTION'') a 
    WHERE a.state1 > 0 AND a.state2 > 0 ', info_msg='No EPA connecs over EPA node have been detected.', function_name='[gw_fct_pg2epa_check_networkmode_connec]', active=false WHERE fid=413;


UPDATE sys_message
SET error_message = 'Cannot do this operation because the lock level is set to %lock_level%',
    hint_message = 'Please review the lock level'
WHERE id = 3284;

-- edit_typevalue
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '0', 'ALLOW EVERYTHING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '1', 'BLOCK UPDATE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '2', 'BLOCK DELETE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '3', 'BLOCK UPDATE AND DELETE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_add_info_1', 'lyt_add_info_1', 'layoutAddInfo1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_1', 'lyt_budget_1', 'layoutBudget1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_10', 'lyt_budget_10', 'layoutBudget10', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_11', 'lyt_budget_11', 'layoutBudget11', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_12', 'lyt_budget_12', 'layoutBudget12', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_13', 'lyt_budget_13', 'layoutBudget13', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_2', 'lyt_budget_2', 'layoutBudget2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_3', 'lyt_budget_3', 'layoutBudget3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_4', 'lyt_budget_4', 'layoutBudget4', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_5', 'lyt_budget_5', 'layoutBudget5', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_6', 'lyt_budget_6', 'layoutBudget6', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_7', 'lyt_budget_7', 'layoutBudget7', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_8', 'lyt_budget_8', 'layoutBudget8', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_9', 'lyt_budget_9', 'layoutBudge9', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_1', 'lyt_general_1', 'layoutGeneral1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_2', 'lyt_general_2', 'layoutGeneral2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_3', 'lyt_general_3', 'layoutGeneral3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_4', 'lyt_general_4', 'layoutGeneral4', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_5', 'lyt_general_5', 'layoutGeneral5', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_6', 'lyt_general_6', 'layoutGeneral6', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_7', 'lyt_general_7', 'layoutGeneral7', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_8', 'lyt_general_8', 'layoutGeneral8', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_other_prices_1', 'lyt_other_prices_1', 'layoutOtherPrices1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_1', 'lyt_psector_1', 'layoutPsector1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_2', 'lyt_psector_2', 'layoutPsector2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_3', 'lyt_psector_3', 'layoutPsector3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_1', 'lyt_relations_1', 'layoutRelations1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_arc_1', 'lyt_relations_arc_1', 'layoutRelationsArc1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_connec_1', 'lyt_relations_connec_1', 'layoutRelationsConnec1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_node_1', 'lyt_relations_node_1', 'layoutRelationsNode1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'psector', 'psector', 'psector', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_add_info', 'tab_add_info', 'tabAddInfo', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_budget', 'tab_budget', 'tabBudget', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_document', 'tab_document', 'tabDocument', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_general', 'tab_general', 'tabGeneral', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_other_prices', 'tab_other_prices', 'tabOtherPrices', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_arc', 'tab_relations_arc', 'tabRelationsArc', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_connec', 'tab_relations_connec', 'tabRelationsConnec', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_node', 'tab_relations_node', 'tabRelationsNode', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_other_prices_all', 'tab_other_prices_all', 'tabOtherPricesAll', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_other_prices_mine', 'tab_other_prices_mine', 'tabOtherPricesMine', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_other_prices_all_1', 'lyt_other_prices_all_1', 'layoutOtherPricesAll1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_other_prices_mine_1', 'lyt_other_prices_mine_1', 'layoutOtherPricesMine1', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_node', 'Node', 'Node', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_connec', 'Connec', 'Connec', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_add_info', 'Additional info', 'Additional info', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_budget', 'Budget', 'Budget', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_document', 'Document', 'Document', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_general', 'General', 'General', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_other_prices', 'Other prices', 'Other prices', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations', 'Relations', 'Relations', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_arc', 'Arc', 'Arc', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_other_prices_mine', 'My prices', 'My prices', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_other_prices_all', 'All prices', 'All prices', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'atlas_id', 'lyt_general_8', 4, 'text', 'text', 'Atlas id:', 'Atlas id', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "enable"
}'::json, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'chk_enable_all', 'lyt_general_7', 0, 'boolean', 'check', 'Enable all (visualize obsolete state on features related to psector)', 'Enable all (visualize obsolete state on features related to psector)', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": true
}'::json, '{
  "functionName": "enable",
  "module": "psector"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'descript', 'lyt_general_6', 0, 'text', 'textarea', 'Descript:', 'Descript', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'expl_id', 'lyt_general_4', 1, 'string', 'combo', 'Exploitation:', 'Exploitation', NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id != 0', NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'ext_code', 'lyt_general_2', 0, 'text', 'text', 'Ext code:  ', 'Ext code', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'name', 'lyt_general_1', 0, 'text', 'text', 'Name:      ', 'Name', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'observ', 'lyt_general_6', 3, 'text', 'textarea', 'Observation:', 'Observation', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'parent_id', 'lyt_general_2', 1, 'text', 'text', 'Parent id: ', 'Parent id', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'priority', 'lyt_general_3', 1, 'string', 'combo', 'Priority:', 'Priority', NULL, false, false, false, false, false, 'SELECT id, idval FROM plan_typevalue WHERE typevalue = ''value_priority''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'psector_id', 'lyt_general_1', 1, 'text', 'text', 'Psector id:', 'Psector id', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'psector_type', 'lyt_general_4', 3, 'string', 'combo', 'Psector type:', 'Psector type:', NULL, false, false, false, false, false, 'SELECT id, idval FROM plan_typevalue WHERE typevalue = ''psector_type''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'rotation', 'lyt_general_8', 2, 'text', 'text', 'Rotation:', 'Rotation', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'scale', 'lyt_general_8', 0, 'text', 'text', 'Scale:', 'Scale', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'spacer_1', 'lyt_general_4', 2, 'string', 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'status', 'lyt_general_3', 0, 'string', 'combo', 'Status:     ', 'Status', NULL, false, false, false, false, false, 'SELECT id, idval FROM plan_typevalue WHERE typevalue = ''psector_status''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'text1', 'lyt_general_6', 1, 'text', 'textarea', 'Text 1:', 'Text 1:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'text2', 'lyt_general_6', 2, 'text', 'textarea', 'Text 2:', 'Text 2:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'workcat_id', 'lyt_general_4', 0, 'string', 'combo', 'Worcat id:', 'Worcat id', NULL, false, false, false, false, false, 'SELECT id, id as idval  FROM cat_work', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'total_other', 'lyt_budget_3', 2, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'vat_total', 'lyt_budget_8', 1, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_arc', 'table_view_arc', 'lyt_relations_arc_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_arc_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_1', 'lyt_budget_1', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'lbl_total_node', 'lyt_budget_2', 0, 'text', 'label', 'Total nodes:', 'Total nodes', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_2', 'lyt_budget_2', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_3', 'lyt_budget_3', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'lbl_total_arc', 'lyt_budget_1', 0, 'text', 'label', 'Total arcs:', 'Total arcs', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'lbl_total_other', 'lyt_budget_3', 0, 'text', 'label', 'Total other prices:', 'Total other prices:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_4', 'lyt_budget_5', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_5', 'lyt_budget_7', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_6', 'lyt_budget_10', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'divider3', 'lyt_budget_12', 0, NULL, 'divider', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_7', 'lyt_budget_13', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_connec', 'table_view_connec', 'lyt_relations_connec_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_connec_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_node', 'table_view_node', 'lyt_relations_node_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_node_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Cancel"
}'::json, '{
  "functionName": "close_dlg",
  "module": "psector"
}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Accept"
}'::json, '{
  "functionName": "accept",
  "module": "psector"
}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'num_value', 'lyt_add_info_1', 0, 'text', 'text', 'Num value:', 'Num value', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_document', 'table_view_docs', 'lyt_document_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'doc_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'tab_main', 'lyt_psector_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_general",
    "tab_add_info",
    "tab_relations",
    "tab_other_prices",
    "tab_budget",
    "tab_document"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text3', 'lyt_add_info_1', 1, 'string', 'textarea', 'Text 3:', 'Text 3:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text4', 'lyt_add_info_1', 2, 'string', 'textarea', 'Text 4:', 'Text 4:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text5', 'lyt_add_info_1', 3, 'string', 'textarea', 'Text 5:', 'Text 5:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text6', 'lyt_add_info_1', 4, 'string', 'textarea', 'Text 6:', 'Text 6:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'gexpenses', 'lyt_budget_6', 0, 'text', 'text', 'General expenses %', 'General expenses %', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'total_arc', 'lyt_budget_1', 2, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pec_vat', 'lyt_budget_10', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'gexpenses_total', 'lyt_budget_6', 1, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pec', 'lyt_budget_7', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'other_total', 'lyt_budget_11', 1, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pca', 'lyt_budget_13', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'vat', 'lyt_budget_8', 0, 'text', 'text', 'VAT: %', 'VAT: %', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'other', 'lyt_budget_11', 0, 'text', 'text', 'Other expenses %', 'Other expenses %', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pem', 'lyt_budget_5', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'divider1', 'lyt_budget_4', 0, NULL, 'divider', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'divider2', 'lyt_budget_9', 0, NULL, 'divider', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'total_node', 'lyt_budget_2', 2, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_other_prices', 'tab_other_prices', 'lyt_other_prices_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_other_prices_mine",
    "tab_other_prices_all"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_other_prices_all', 'tbl_prices', 'lyt_other_prices_all_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'prices_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_other_prices_mine', 'tbl_prices_plan', 'lyt_other_prices_mine_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'prices_psector_results', false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_node', '{"layouts":["lyt_relations_node_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_connec', '{"layouts":["lyt_relations_connec_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_add_info', '{"layouts":["lyt_add_info_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_document', '{"layouts":["lyt_document_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations', '{"layouts":["lyt_relations_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_arc', '{"layouts":["lyt_relations_arc_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_other_prices', '{"layouts":["lyt_other_prices_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_general', '{"layouts":["lyt_general_1","lyt_general_2","lyt_general_3","lyt_general_4","lyt_general_5","lyt_general_6","lyt_general_7","lyt_general_8"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_budget', '{"layouts":["lyt_budget_1","lyt_budget_2","lyt_budget_3","lyt_budget_4","lyt_budget_5","lyt_budget_6","lyt_budget_7","lyt_budget_8","lyt_budget_9","lyt_budget_10","lyt_budget_11","lyt_budget_12","lyt_budget_13","lyt_budget_14"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_other_prices_all', '{"layouts":["lyt_other_prices_all_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_other_prices_mine', '{"layouts":["lyt_other_prices_mine_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('prices_results', 'SELECT id, unit, descript, price FROM v_price_compost WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('doc_results', 'SELECT psector_name, doc_name, doc_type, "path", observ, "date", user_name FROM v_ui_doc_x_psector WHERE psector_name IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('prices_psector_results', 'SELECT id, price_id, unit, price_descript, price, measurement, observ, total_budget FROM v_edit_plan_psector_x_other WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_arc_results', 'SELECT id, arc_id, state, doable::text, addparam::text FROM plan_psector_x_arc WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_connec_results', 'SELECT id, connec_id, arc_id, state, doable::text FROM plan_psector_x_connec WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_node_results', 'SELECT id, node_id, state, doable::text, addparam::text FROM plan_psector_x_node WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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



UPDATE config_typevalue SET idval='lyt_bot_1', camelstyle='layoutBottom1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_bot_1';
UPDATE config_typevalue SET idval='lyt_top_1', camelstyle='layoutTop1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_top_1';
UPDATE config_typevalue SET idval='lyt_element_1', camelstyle='lytElements1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_element_1';
UPDATE config_typevalue SET idval='lyt_event_1', camelstyle='lytEvents1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_event_1';
UPDATE config_typevalue SET idval='lyt_epa_dsc_1', camelstyle='lytEpaDsc1', addparam='{"lytOrientation": "horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_epa_dsc_1';
UPDATE config_typevalue SET idval='lyt_event_2', camelstyle='lytEvents2', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_event_2';
UPDATE config_typevalue SET idval='lyt_document_1', camelstyle='lytDocuments1', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_document_1';
UPDATE config_typevalue SET idval='lyt_document_2', camelstyle='lytDocuments2', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_document_2';
UPDATE config_typevalue SET idval='lyt_hydro_val_1', camelstyle='lytHydroVal1', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_hydro_val_1';
UPDATE config_typevalue SET idval='lyt_hydrometer_1', camelstyle='lytHydrometer1', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_hydrometer_1';


UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false, "valueRelation": {"layer": "v_edit_presszone", "activated": true, "keyColumn": "presszone_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, layoutname='lyt_data_2' WHERE columnname ='presszone_id' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false, "valueRelation": {"layer": "v_edit_dqa", "activated": true, "keyColumn": "dqa_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, layoutname='lyt_data_2' WHERE columnname ='dqa_id' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false}'::json, layoutname='lyt_data_2'	WHERE columnname ='verified' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false, "valueRelation": {"layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, layoutname='lyt_data_2' WHERE columnname ='expl_id' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');

UPDATE config_form_fields SET "label"='Customer code:', tooltip='Customer code' WHERE formname='connec' AND formtype='form_feature' AND columnname='hydrometer_id' AND tabname='tab_hydrometer';


UPDATE config_form_fields SET layoutorder=2, web_layoutorder=2 WHERE formname='generic' AND formtype='epa_selector' AND columnname='btn_accept' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=3, web_layoutorder=3 WHERE formname='generic' AND formtype='epa_selector' AND columnname='btn_cancel' AND tabname='tab_none';
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'hspacer_epa_selector', 'lyt_buttons', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);


UPDATE config_form_tabs SET "label"='Data', tooltip='Data', sys_role='role_basic', tabfunction=NULL, tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionAudit",
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
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, orderby=0, device='{4,5}' WHERE formname='v_edit_node' AND tabname='tab_data';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('linkedaction_typevalue', 'action_audit', 'action_audit', 'actionAudit', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'audit_manager', 'audit_manager', 'auditManager', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_audit_manager_1', 'lyt_audit_manager_1', 'layoutAuditManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_audit_manager_2', 'lyt_audit_manager_2', 'layoutAuditManager2', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'spacer_2', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'spacer_1', 'lyt_audit_manager_1', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'spacer_3', 'lyt_audit_manager_2', 2, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'date_to', 'lyt_audit_manager_2', 0, 'date', 'datetime', 'Select date:', 'Select date', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'btn_open', 'lyt_audit_manager_1', 1, NULL, 'button', NULL, 'Open', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Open"}'::json, '{
  "functionName": "open",
  "module": "audit"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'btn_open_date', 'lyt_audit_manager_2', 1, NULL, 'button', NULL, 'Open', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Open date"}'::json, '{
  "functionName": "open_date",
  "module": "audit"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Close"}'::json, '{
  "functionName": "close_dlg",
  "module": "audit"
}'::json, NULL, false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('audit_results', 'SELECT id, tstamp, "action", query, insert_by FROM audit.log WHERE id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
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
        "id": "name",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_show_psector",
      "widgetfunction": {
        "functionName": "showPsector",
        "params": {}
      },
      "color": "default",
      "text": "Show psector",
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

DELETE FROM config_form_fields WHERE formname='v_edit_dimensions' AND formtype='form_feature' AND columnname='id' AND tabname='tab_none';



UPDATE sys_param_user
	SET layoutorder=24
	WHERE id='utils_psector_strategy';


DELETE FROM sys_function WHERE id = 3240;

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'MONTHLY', 'MONTHLY', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'DAILY', 'DAILY', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'HOURLY', 'HOURLY', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'WEEKEND', 'WEEKEND', NULL, NULL) ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET dv_querytext='SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_pattern''' WHERE formname='inp_pattern' AND formtype='form_feature' AND columnname='pattern_type' AND tabname='tab_none';


DELETE FROM sys_table WHERE id='config_file';
UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT idval AS id, idval FROM config_typevalue WHERE typevalue = ''filetype_typevalue''' WHERE formname='om_visit_event_photo' AND formtype='form_list_header' AND columnname='filetype' AND tabname='tab_none';


DELETE FROM sys_table WHERE id='cat_builder';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Brand model catalog', orderby=15 WHERE id ='cat_brand_model';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Brand catalog', orderby=16 WHERE id ='cat_brand';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Users catalog', orderby=17 WHERE id ='cat_users';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Period catalog', orderby=18 WHERE id ='ext_cat_period';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Hydrometer catalog', orderby=19 WHERE id ='ext_cat_hydrometer';

DELETE FROM config_form_fields WHERE formname='cat_builder';


DELETE FROM sys_table WHERE id='config_user_x_sector';
DELETE FROM sys_function WHERE function_name='gw_trg_cat_manager';


ALTER TABLE sys_role DROP CONSTRAINT sys_role_check;
UPDATE sys_role SET id='role_plan', context='plan', descript=NULL WHERE id='role_master';
ALTER TABLE sys_role ADD CONSTRAINT sys_role_check
CHECK (((id)::text = ANY (ARRAY[('role_admin'::character varying)::text, ('role_basic'::character varying)::text, ('role_edit'::character varying)::text, ('role_epa'::character varying)::text, ('role_plan'::character varying)::text, ('role_om'::character varying)::text, ('role_crm'::character varying)::text, ('role_system'::character varying)::text])));


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'snapshot_view', 'snapshot_view', 'snapshotView', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_1', 'lyt_snapshot_view_1', 'layoutSnapshotView1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_2', 'lyt_snapshot_view_2', 'layoutSnapshotView2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_3', 'lyt_snapshot_view_3', 'layoutSnapshotView3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_4', 'lyt_snapshot_view_4', 'layoutSnapshotView4', '{
  "lytOrientation": "vertical"
}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'spacer1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_connec', 'lyt_snapshot_view_3', 3, 'boolean', 'check', 'Connecs', 'Connecs', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_gully', 'lyt_snapshot_view_3', 4, 'boolean', 'check', 'Gullies', 'Gullies', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_node', 'lyt_snapshot_view_3', 2, 'boolean', 'check', 'Nodes', 'Nodes', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_arc', 'lyt_snapshot_view_3', 1, 'boolean', 'check', 'Arcs', 'Arcs', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_link', 'lyt_snapshot_view_4', 0, 'boolean', 'check', 'Links', 'Links', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_element', 'lyt_snapshot_view_4', 1, 'boolean', 'check', 'Elements', 'Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_doc', 'lyt_snapshot_view_4', 2, 'boolean', 'check', 'Documents', 'Documents', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'date', 'lyt_snapshot_view_1', 1, 'date', 'datetime', 'Select date', 'Select date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'extension', 'lyt_snapshot_view_2', 0, 'string', 'text', 'Grid Extension', 'Grid Extension', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close_dlg",
  "module": "snapshot_view"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'btn_grid', 'lyt_snapshot_view_2', 1, NULL, 'button', NULL, ' ', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "999"
}'::json, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'btn_run', 'lyt_buttons', 1, NULL, 'button', NULL, 'Run', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Run"
}'::json, '{
  "functionName": "run",
  "module": "snapshot_view"
}'::json, NULL, false, 0);






INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_element_mng_1', 'lyt_element_mng_1', 'layoutElementManager1', '{"lytOrientation":"horizontal"}'::json);
INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_element_mng_2', 'lyt_element_mng_2', 'layoutElementManager2', '{"lytOrientation":"horizontal"}'::json);
INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam) VALUES ('formtype_typevalue', 'form_element', 'form_element', 'formElement', null);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'hspacer_lyt_bot_3', 'lyt_buttons', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'tbl_element', 'lyt_element_mng_2', 1, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName":"open_selected_manager_item", "parameters":{"columnfind":"id"}}'::json, 'v_ui_element', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'create', 'lyt_element_mng_1', 3, NULL, 'button', NULL, 'Create', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue":false, "text":"Create"}'::json, '{"functionName": "manage_element","parameters": {}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'element_id', 'lyt_element_mng_1', 1, 'string', 'typeahead', 'Filter by: Element id', NULL, NULL, false, false, true, false, true, 'SELECT id, id as idval FROM v_ui_element WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters":{"columnfind":"id"}}'::json, 'v_ui_element', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'cancel', 'lyt_buttons', 2, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue":false, "text":"Close"}'::json, '{"functionName": "close_manager",  "parameters":{}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'hspacer_lyt_element_mng_1', 'lyt_element_mng_1', 2, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'delete', 'lyt_element_mng_1', 4, NULL, 'button', NULL, 'Delete', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue":false, "text":"Delete", "onContextMenu":"Delete"}'::json, '{"functionName": "delete_manager_item","parameters": {"sourcetable": "v_edit_element", "targetwidget":"tab_none_tbl_element"}}'::json, NULL, false, NULL);




-- link related
DELETE FROM config_form_tabs WHERE formname = 'v_edit_link' AND tabname = 'tab_none';

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_documents', 'Documents', 'List of documents', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false}]'::json, 5, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false},
{"actionName": "actionHelp", "disabled": false}]'::json, 0, '{4,5}');

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL, is_editable=true, formtemplate='info_feature', headertext='Link', orderby=7, tableparentepa_id=NULL, addparam=NULL WHERE layer_id='v_edit_link';

UPDATE config_param_system SET value='{"node":"node_id", "arc":"arc_id", "connec":"connec_id", "link":"link_id",  "gully":"gully_id", "element":{"childType":"ELEMENT", "column":"element_id"},
 "hydrometer":{"childType":"HYDROMETER", "column":"hydrometer_id"},  "newText":"NEW"}' WHERE "parameter"='admin_formheader_field';

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_doc_x_link', 'SELECT * FROM v_ui_doc_x_link WHERE link_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'sys_id', 0, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'link_id', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'doc_id', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'doc_type', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'path', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'observ', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'date', 7, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'user_name', 8, true, NULL, NULL, NULL, NULL);


UPDATE config_form_fields SET dv_querytext = REPLACE(dv_querytext, 'sys_feature_cat', ' sys_feature_class') WHERE dv_querytext ILIKE '%sys_feature_cat%';


INSERT INTO value_state_type (id, state, "name", is_operative, is_doable) VALUES  (100, 2, 'OBSOLETE-FICTICIUS', true, false) ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET dv_querytext='WITH check_value AS (
  SELECT value::integer AS psector_value 
  FROM config_param_user 
  WHERE parameter = ''plan_psector_current''
  AND cur_user = ''||CURRENT_USER||''
)
SELECT id, name as idval 
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT psector_value FROM check_value) IS NULL THEN id != 2 
  ELSE true 
END', dv_querytext_filterc = NULL WHERE formname ILIKE 've_%' AND formtype='form_feature' AND columnname='state' AND tabname='tab_data';

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_element_x_link', 'SELECT * FROM v_ui_element_x_link WHERE link_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

DELETE FROM config_form_fields WHERE formname IN ('v_edit_arc', 'v_edit_connec', 'v_edit_gully', 'v_edit_node', 'v_edit_element') AND columnname='undelete';


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connect_link_3', 'lyt_connect_link_3', 'lytConnectLink3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connect_link_2', 'lyt_connect_link_2', 'lytConnectLink2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connect_link_1', 'lyt_connect_link_1', 'lytConnectLink1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'link_to_connec', 'link_to_connec', 'linkToConnec', NULL);

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'linkcat', 'lyt_connect_link_1', 2, 'text', 'combo', 'Link catalog:', 'Link catalog', NULL, true, NULL, true, NULL, NULL, 'SELECT id, id AS idval FROM cat_link WHERE id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'pipe_diameter', 'lyt_connect_link_1', 0, 'text', 'text', 'Max. Pipe diameter:', 'Max. Pipe diameter:', '150', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'max_distance', 'lyt_connect_link_1', 1, 'text', 'text', 'Max. distance:', 'Max. distance', '100', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'tbl_ids', 'lyt_connect_link_3', 0, NULL, 'tableview', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_snapping', 'lyt_connect_link_2', 3, NULL, 'button', NULL, 'Select on canvas', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, NULL, '{
  "functionName": "snapping",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_add', 'lyt_connect_link_2', 1, NULL, 'button', NULL, 'Add', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, NULL, '{
  "functionName": "add",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_remove', 'lyt_connect_link_2', 2, NULL, 'button', NULL, 'Remove', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, NULL, '{
  "functionName": "remove",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'id', 'lyt_connect_link_2', 0, 'text', 'combo', 'Connec Id:', 'Connec Id', NULL, NULL, NULL, true, NULL, NULL, 'SELECT connec_id AS id, connec_id AS idval FROM connec WHERE connec_id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', '', 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{
  "functionName": "accept",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', '', 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_filter_expression', 'lyt_connect_link_2', 4, NULL, 'button', NULL, 'Filter by expression', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, NULL, '{
  "functionName": "filter_expression",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;


-- messages:
UPDATE sys_message SET message_type = 'UI';


-- revisar donde se hacen los inserts para cm
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'create_organization', 'create_organization', NULL, NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_create_org_1', 'lyt_create_org_1', NULL, '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'active', 'lyt_create_org_1', 2, 'text', 'check', 'Active:', 'Active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', '', 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Accept"
}'::json, '{
  "functionName": "upsert_organization",
  "module": "lot"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', '', 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close",
  "module": "lot"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'descript', 'lyt_create_org_1', 1, 'text', 'textarea', 'Description:', 'Description', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'name', 'lyt_create_org_1', 0, 'text', 'text', 'Name:', 'Name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', '', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'audit', 'audit', 'audit', NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Close"}'::json, '{
  "functionName": "close_dlg",
  "module": "audit"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);


DELETE FROM config_form_fields
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='fluid_type' AND tabname='tab_none';

UPDATE config_form_fields SET iseditable = FALSE WHERE columnname = 'fluid_type';


-- remove fluid_type from element forms
DELETE FROM config_form_fields WHERE formname ILIKE '%elem%' AND formtype = 'form_feature' AND columnname = 'fluid_type';



ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_workcat ADD CONSTRAINT doc_x_workcat_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_visit ADD CONSTRAINT doc_x_visit_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;

DROP RULE IF EXISTS insert_plan_psector_x_arc ON arc;
DROP RULE IF EXISTS insert_plan_psector_x_node ON node;


UPDATE rpt_cat_result SET iscorporate = false WHERE iscorporate IS NULL;

ALTER TABLE rpt_cat_result ALTER COLUMN iscorporate SET NOT NULL;
ALTER TABLE rpt_cat_result ALTER COLUMN iscorporate SET DEFAULT false;


CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_category FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_category');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_fluid FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_fluid');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_function FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_function');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON man_type_location FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_location');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON cat_brand FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('cat_brand');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON cat_brand_model FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('cat_brand_model');


CREATE TRIGGER gw_trg_edit_config_addfields INSTEAD OF UPDATE ON
ve_config_addfields FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_config_addfields();

CREATE TRIGGER gw_trg_edit_config_sysfields INSTEAD OF UPDATE ON ve_config_sysfields
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_config_sysfields();



CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    arc FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    fluid_type,
    location_type ON
    arc FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.fluid_type)::TEXT IS DISTINCT FROM (NEW.fluid_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');


CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    node FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    fluid_type,
    location_type ON
    node FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.fluid_type)::TEXT IS DISTINCT FROM (NEW.fluid_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');


CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    connec FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    fluid_type,
    location_type ON
    connec FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.fluid_type)::TEXT IS DISTINCT FROM (NEW.fluid_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');


CREATE TRIGGER gw_trg_doc BEFORE INSERT OR UPDATE ON doc
FOR EACH ROW EXECUTE FUNCTION gw_trg_doc();



CREATE TRIGGER gw_trg_edit_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_psector('plan');

CREATE TRIGGER gw_trg_ui_plan_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_plan_psector();


CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON cat_material
FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('cat_material');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('arc');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_arc
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('arc');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('node');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_node
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('node');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('connec');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_connec
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('connec');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('element');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_element
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('element');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('sector_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrosector_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('dma_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON macrodma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrodma_id');


DROP TRIGGER gw_trg_cat_manager ON cat_manager;

CREATE TRIGGER gw_trg_om_visit AFTER INSERT ON om_visit_x_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit('link');

CREATE TRIGGER gw_trg_ui_doc_x_link INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('link');
