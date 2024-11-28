/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

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
ALTER TABLE cat_feature_arc DROP COLUMN type;
ALTER TABLE cat_feature_node DROP COLUMN type;
ALTER TABLE cat_feature_connec DROP COLUMN type;

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
