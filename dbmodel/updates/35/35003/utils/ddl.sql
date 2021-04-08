/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_feature_cat", "column":"man_table", "dataType":"character varying(30)", "isUtils":"False"}}$$);

UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_node f WHERE sys_feature_cat.id=f.type;
UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_arc f WHERE sys_feature_cat.id=f.type;
UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_connec f WHERE sys_feature_cat.id=f.type;

ALTER TABLE cat_feature_node DROP COLUMN man_table;
ALTER TABLE cat_feature_arc DROP COLUMN man_table;
ALTER TABLE cat_feature_connec DROP COLUMN man_table;

DELETE FROM sys_table WHERE id  IN ('inp_arc_type', 'inp_node_type');
INSERT INTO sys_table VALUES ('sys_feature_epa_type', 'epa types', 'role_admin', 0, null, null, null, null, null, null, null, null, 'giswater') ON CONFLICT (id) DO NOTHING;

--2021/03/18

CREATE TABLE IF NOT EXISTS crm_typevalue
( typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(100),
  descript text,
  addparam json,
  CONSTRAINT crm_typevalue_pkey PRIMARY KEY (typevalue, id)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"value_type", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"value_status", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"value_state", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_form_list", "column":"actionfields"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_list", "column":"columnname", "dataType":"varchar(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_fields", "column":"isfilter", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_fields", "column":"tabname", "dataType":"varchar(30)", "isUtils":"False"}}$$);

--2021/03/29
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature_node", "column":"grafconfig", "dataType":"varchar(30)", "isUtils":"False"}}$$);

--2021/04/07
ALTER TABLE IF EXISTS config_form_fields RENAME TO _config_form_fields_;
ALTER TABLE IF EXISTS _config_form_fields_ RENAME CONSTRAINT config_form_fields_pkey TO config_form_fieldspkey_;

CREATE TABLE IF NOT EXISTS config_form_fields(
formname character varying(50) NOT NULL,
formtype character varying(50) NOT NULL,
tabname character varying(30) NOT NULL,
columnname character varying(30) NOT NULL,
layoutname character varying(16),
layoutorder integer,
datatype character varying(30),
widgettype character varying(30),
widgetcontrols json,
label text,
tooltip text,
placeholder text,
ismandatory boolean,
isparent boolean,
iseditable boolean,
isautoupdate boolean,
isfilter boolean,
dv_querytext text,
dv_orderby_id boolean,
dv_isnullvalue boolean,
dv_parent_id text,
dv_querytext_filterc text,
stylesheet json,
widgetfunction text,
linkedaction text,
hidden boolean NOT NULL DEFAULT false,
CONSTRAINT config_form_fields_pkey PRIMARY KEY (formname, formtype, columnname, tabname)
);
COMMENT ON TABLE config_form_fields
  IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table form fields are configured:
The function gw_api_get_formfields is called to build widget forms using this table.
formname: warning with formname. If it is used to work with listFilter fields tablename of an existing relation on database must be mandatory to put here
formtype: There are diferent formtypes:
	feature: the standard one. Used to show fields from feature tables
	info: used to build the infoplan widget
	visit: used on visit forms
	form: used on specific forms (search, mincut)
	catalog: used on catalog forms (workcat and featurecatalog)
	listfilter: used to filter list
	editbuttons:  buttons on form bottom used to edit (accept, cancel)
	navbuttons: buttons on form bottom used to navigate (goback....)
layout_id and layout_order, used to define the position';

--2021/04/08
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_info_layer", "column":"link_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_info_layer", "column":"tableinfo_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_info_layer", "column":"is_tiled"}}$$);

ALTER TABLE IF EXISTS config_form RENAME TO _config_form_;