/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
INSERT INTO sys_fprocess VALUES (367, 'Check graf config', 'ws');

INSERT INTO sys_function VALUES (3026, 'gw_fct_setchangevalvestatus', 'ws', 'function', 'json', 'json', 'Function that changes status valve', 'role_om');


--2021/03/01
DELETE FROM config_param_user WHERE parameter = 'qgis_toolbar_hidebuttons';
DELETE FROM sys_param_user WHERE id = 'qgis_toolbar_hidebuttons';

DELETE FROM sys_function WHERE id = 2784 OR id = 2786;
DELETE FROM sys_fprocess WHERE fid = 206;

UPDATE sys_function set sample_query=NULL WHERE sample_query='false';


UPDATE value_state SET name = 'OPERATIVE' WHERE name ='ON_SERVICE';
UPDATE value_state SET name = 'OPERATIVO' WHERE name ='EN_SERVICIO';
UPDATE value_state SET name = 'OPERATIU' WHERE name ='EN_SERVEI';

UPDATE value_state_type SET name = 'OPERATIVE' WHERE name ='ON_SERVICE';
UPDATE value_state_type SET name = 'OPERATIVO' WHERE name ='EN_SERVICIO';
UPDATE value_state_type SET name = 'OPERATIU' WHERE name ='EN_SERVEI';


--2021/03/05
INSERT INTO sys_function VALUES (3028, 'gw_fct_getaddfeaturevalues', 'utils', 'function', 'json', 'json', 'Function that return cat_feature values', 'role_basic');
INSERT INTO sys_function VALUES (3030, 'gw_fct_debugsql', 'utils', 'function', 'json', 'json', 'Function that allows debugging giving error information', 'role_basic');


--2021/03/25

UPDATE config_form_list SET columnname = 'not_used';
ALTER TABLE config_form_list DROP CONSTRAINT config_form_list_pkey;
ALTER TABLE config_form_list ADD CONSTRAINT "config_form_list_pkey" PRIMARY KEY ("tablename", "device", "listtype", "columnname");

UPDATE config_form_fields SET dv_parent_id = 'muni_id' WHERE formname = 'v_om_mincut' AND columnname = 'streetname' AND formtype ='form_feature';
UPDATE config_form_fields SET dv_parent_id = 'matcat_id' WHERE formname = 'upsert_catalog_arc' AND columnname = 'matcat_id' AND formtype ='form_catalog';
UPDATE config_form_fields SET dv_parent_id = 'matcat_id' WHERE formname = 'upsert_catalog_node' AND columnname = 'matcat_id' AND formtype ='form_catalog';
UPDATE config_form_fields SET dv_parent_id = 'matcat_id' WHERE formname = 'upsert_catalog_connec' AND columnname = 'matcat_id' AND formtype ='form_catalog';


UPDATE config_form_fields SET tabname = 'main';
UPDATE config_form_fields set tabname = 'data' WHERE formtype = 'form_feature' AND formname ILIKE 've_%_%';
ALTER TABLE config_form_fields DROP CONSTRAINT config_form_fields_pkey;
ALTER TABLE config_form_fields ADD CONSTRAINT config_form_fields_pkey PRIMARY KEY(formname, formtype, columnname, tabname);

-- 2021/01/04
INSERT INTO sys_fprocess VALUES (368, 'Null values on to_arc valves', 'ws');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)   
VALUES (3174, 'No valve has been choosen','You can continue by clicking on more valves or finish the process by clicking again on Change Valve Status', 0, TRUE, 'ws')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)   
VALUES (3176, 'Change valve status done successfully','You can continue by clicking on more valves or finish the process by executing Refresh Mincut', 0, TRUE, 'ws')
ON CONFLICT (id) DO NOTHING;

-- 07/04/2021

ALTER TABLE config_form_fields
RENAME TO _config_form_fields_;

ALTER TABLE _config_form_fields_ 
RENAME CONSTRAINT config_form_fields_pkey TO config_form_fieldspkey_;


CREATE TABLE config_form_fields
(
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
)
WITH (
OIDS=FALSE
);
ALTER TABLE config_form_fields
  OWNER TO role_admin;
GRANT ALL ON TABLE config_form_fields TO role_admin;
GRANT SELECT ON TABLE config_form_fields TO role_basic;

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


INSERT INTO config_form_fields(
            formname, formtype, tabname, columnname, layoutname, layoutorder, 
            datatype, widgettype, widgetcontrols, label, tooltip, placeholder, 
            ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, 
            dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
            stylesheet, widgetfunction, linkedaction, hidden)
SELECT formname, formtype, tabname, columnname, layoutname, layoutorder, 
		datatype, widgettype, widgetcontrols, label, tooltip, placeholder, 
		ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, 
		dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
		stylesheet, widgetfunction, linkedaction, hidden FROM config_form_fields;
            
			
CREATE TRIGGER gw_trg_config_control
  BEFORE INSERT OR UPDATE OR DELETE
  ON config_form_fields
  FOR EACH ROW
  EXECUTE PROCEDURE ws_35.gw_trg_config_control('config_form_fields');


CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON ws_35.config_form_fields
  FOR EACH ROW
  EXECUTE PROCEDURE ws_35.gw_trg_typevalue_fk('config_form_fields');

DROP VIEW ws_35.ve_config_addfields;

CREATE OR REPLACE VIEW ws_35.ve_config_addfields AS 
 SELECT sys_addfields.param_name AS columnname,
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
    config_form_fields.linkedaction,
    config_form_fields.stylesheet,
    config_form_fields.widgetcontrols,
        CASE
            WHEN sys_addfields.cat_feature_id IS NOT NULL THEN config_form_fields.formname
            ELSE NULL::character varying
        END AS formname,
    sys_addfields.id AS param_id,
    sys_addfields.cat_feature_id
   FROM ws_35.sys_addfields
     LEFT JOIN ws_35.cat_feature ON cat_feature.id::text = sys_addfields.cat_feature_id::text
     LEFT JOIN ws_35.config_form_fields ON config_form_fields.columnname::text = sys_addfields.param_name::text;

ALTER TABLE ws_35.ve_config_addfields
  OWNER TO role_admin;
GRANT ALL ON TABLE ws_35.ve_config_addfields TO role_admin;
GRANT ALL ON TABLE ws_35.ve_config_addfields TO role_basic;

CREATE TRIGGER gw_trg_edit_config_addfields
  INSTEAD OF UPDATE
  ON ws_35.ve_config_addfields
  FOR EACH ROW
  EXECUTE PROCEDURE ws_35.gw_trg_edit_config_addfields();

DROP VIEW ws_35.ve_config_sysfields;

CREATE OR REPLACE VIEW ws_35.ve_config_sysfields AS 
 SELECT row_number() OVER () AS rid,
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
    config_form_fields.linkedaction,
    cat_feature.id AS cat_feature_id
   FROM ws_35.config_form_fields
     LEFT JOIN ws_35.cat_feature ON cat_feature.child_layer::text = config_form_fields.formname::text
  WHERE config_form_fields.formtype::text = 'form_feature'::text AND config_form_fields.formname::text <> 've_arc'::text AND config_form_fields.formname::text <> 've_node'::text AND config_form_fields.formname::text <> 've_connec'::text AND config_form_fields.formname::text <> 've_gully'::text;


ALTER TABLE ws_35.ve_config_sysfields
  OWNER TO role_admin;
GRANT ALL ON TABLE ws_35.ve_config_sysfields TO role_admin;
GRANT ALL ON TABLE ws_35.ve_config_sysfields TO role_basic;


CREATE TRIGGER gw_trg_edit_config_sysfields
  INSTEAD OF UPDATE
  ON ws_35.ve_config_sysfields
  FOR EACH ROW
  EXECUTE PROCEDURE ws_35.gw_trg_edit_config_sysfields();

DROP TABLE ws_35._config_form_fields_;