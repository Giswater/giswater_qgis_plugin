/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- 2020/05/25
ALTER TABLE config_param_system DROP CONSTRAINT config_param_system_pkey;
ALTER TABLE config_param_system DROP CONSTRAINT config_param_system_parameter_unique;
ALTER TABLE config_param_system ADD CONSTRAINT config_param_system_pkey PRIMARY KEY(parameter);
ALTER TABLE config_param_system DROP COLUMN id;


ALTER TABLE config_param_user DROP CONSTRAINT config_param_user_pkey;
ALTER TABLE config_param_user DROP CONSTRAINT config_param_user_parameter_cur_user_unique;
ALTER TABLE config_param_user ADD CONSTRAINT config_param_user_pkey PRIMARY KEY(parameter, cur_user);
ALTER TABLE config_param_user DROP COLUMN id;

DROP RULE IF EXISTS insert_plan_psector_x_node ON node;
CREATE OR REPLACE RULE insert_plan_psector_x_node AS ON INSERT TO node
WHERE new.state = 2 DO  INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
VALUES (new.node_id, ( SELECT config_param_user.value::integer AS value FROM config_param_user
WHERE config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.cur_user::name = "current_user"() LIMIT 1), 1, true);

DROP RULE IF EXISTS insert_plan_psector_x_arc ON arc;
CREATE OR REPLACE RULE insert_plan_psector_x_arc AS ON INSERT TO arc
WHERE new.state = 2 DO  INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable)
VALUES (new.arc_id, ( SELECT config_param_user.value::integer AS value FROM config_param_user
WHERE config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.cur_user::name = "current_user"() LIMIT 1), 1, true);

DROP RULE IF EXISTS insert_plan_arc_x_pavement ON arc;
CREATE OR REPLACE RULE insert_plan_arc_x_pavement AS ON INSERT TO arc DO  
INSERT INTO plan_arc_x_pavement (arc_id, pavcat_id, percent) 
VALUES (new.arc_id,  (SELECT value FROM config_param_user WHERE parameter='edit_pavementcat_vdefault' and cur_user="current_user"()LIMIT 1), '1'::numeric);


ALTER TABLE man_addfields_parameter RENAME TO sys_addfields;
ALTER TABLE om_visit_parameter_x_parameter RENAME TO config_visit_parameter_action;
ALTER TABLE om_visit_class_x_parameter RENAME TO config_visit_class_x_parameter;
ALTER TABLE om_visit_class_x_wo RENAME TO config_visit_class_x_workorder;
ALTER TABLE om_visit_filetype_x_extension RENAME TO	config_file;
ALTER TABLE om_visit_parameter RENAME TO config_visit_parameter;
ALTER TABLE price_cat_simple RENAME TO plan_price_cat;
ALTER TABLE price_compost RENAME TO plan_price;
ALTER TABLE price_compost_value RENAME TO plan_price_compost;


ALTER TABLE config_visit_parameter_action DROP CONSTRAINT om_visit_parameter_x_parameter_pkey;
ALTER TABLE config_visit_parameter_action ADD CONSTRAINT config_visit_param_x_param_pkey PRIMARY KEY(parameter_id1, parameter_id2, action_type);
ALTER TABLE config_visit_parameter_action DROP COLUMN pxp_id;

ALTER TABLE config_visit_class_x_parameter DROP CONSTRAINT om_visit_class_x_parameter_pkey;
ALTER TABLE config_visit_class_x_parameter ADD CONSTRAINT config_visit_class_x_parameter_pkey PRIMARY KEY(parameter_id, class_id);
ALTER TABLE config_visit_class_x_parameter DROP COLUMN id;

ALTER TABLE config_visit_class_x_workorder DROP CONSTRAINT om_visit_class_x_wo_pkey;
ALTER TABLE config_visit_class_x_workorder ADD CONSTRAINT config_visit_class_x_workorder_pkey PRIMARY KEY(visitclass_id, wotype_id);
ALTER TABLE config_visit_class_x_workorder DROP COLUMN id;


ALTER TABLE config_param_system RENAME layout_order TO layoutorder;
ALTER TABLE sys_param_user RENAME layout_order TO layoutorder;


-- config csv param

ALTER TABLE config_csv_param ADD COLUMN orderby integer;
UPDATE config_csv_param SET orderby = id;
ALTER TABLE config_csv_param DROP CONSTRAINT sys_csv2pg_config_pkey;
ALTER TABLE config_csv_param ADD CONSTRAINT config_csv_param_pkey PRIMARY KEY(pg2csvcat_id,tablename, target);
ALTER TABLE config_csv_param DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_csv_param';

ALTER TABLE config_csv ALTER COLUMN readheader DROP NOT NULL;

-- config csv
UPDATE config_csv SET functionname = replace (functionname, '_utils_csv2pg_', '_');
UPDATE config_csv SET functionname = replace (functionname, '_utils_', '_');
UPDATE config_csv SET alias = 'Export ui' WHERE functionname = 'gw_fct_export_ui_xml';
UPDATE config_csv SET isdeprecated = false WHERE id IN(10,11,12);
UPDATE config_csv SET formname='main' WHERE id IN(13,19,20);
UPDATE config_csv SET isdeprecated=false;
UPDATE config_csv SET csv_structure = 'Xml qt ui dialog' WHERE id IN (19,20);
UPDATE config_csv SET readheader = NULL, orderby = null WHERE id IN (10,11,12,13,19,20);
UPDATE config_csv SET formname = 'main' WHERE id IN (12);
UPDATE config_csv SET orderby = 21 WHERE id IN (21);
DELETE FROM config_csv WHERE isdeprecated = true;

-- config form
ALTER TABLE config_form DROP CONSTRAINT config_api_form_pkey;
ALTER TABLE config_form DROP CONSTRAINT config_api_form_formname_unique;
ALTER TABLE config_form ADD CONSTRAINT config_form_pkey PRIMARY KEY(formname);
ALTER TABLE config_form DROP COLUMN id;
UPDATE config_form SET formname = 'visit_manager' WHERE formname = 'visitManager';
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_form';


-- config form actions
UPDATE config_form_actions SET actionname = 'actionVisitEnd' WHERE actionname = 'visit_end';
UPDATE config_form_actions SET actionname = 'actionVisitStart' WHERE actionname = 'visit_start';

-- config form_fields
DROP VIEW IF EXISTS ve_config_sysfields;
DROP VIEW IF EXISTS ve_config_addfields;
ALTER TABLE config_form_fields RENAME column_id TO columnname;
ALTER TABLE config_form_fields RENAME layout_order TO layoutorder;
ALTER TABLE config_form_fields DROP CONSTRAINT config_api_form_fields_pkey;
ALTER TABLE config_form_fields DROP CONSTRAINT config_api_form_fields_pkey2;
ALTER TABLE config_form_fields ADD CONSTRAINT config_form_fields_pkey PRIMARY KEY(formname, formtype, columnname);
ALTER TABLE config_form_fields DROP COLUMN id;

UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_form_fields';


-- config groupbox
ALTER TABLE config_form_groupbox DROP CONSTRAINT IF EXISTS config_api_form_groupbox_pkey;
ALTER TABLE config_form_groupbox ADD CONSTRAINT config_groupbox_pkey PRIMARY KEY(formname,layoutname);
ALTER TABLE config_form_groupbox DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_form_groupbox';


--sys_image
DELETE FROM sys_image WHERE idval ='bmaps';
UPDATE sys_image SET id = 1 WHERE idval = 'ws_shape';


-- config form list
UPDATE config_form_list SET listtype = 'tab' WHERE listtype is null;
UPDATE config_form_list SET listclass = 'list' WHERE listclass is null;
UPDATE config_form_list SET vdefault = '{"orderBy":"1", "orderType": "DESC"}' WHERE vdefault IS NULL;
ALTER TABLE config_form_list DROP CONSTRAINT config_api_list_pkey;
ALTER TABLE config_form_list ADD CONSTRAINT config_form_list_pkey PRIMARY KEY(tablename, device, listtype);
ALTER TABLE config_form_list DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_form_list';


-- config form tableview
ALTER TABLE config_form_tableview DROP COLUMN dev1_status;
ALTER TABLE config_form_tableview DROP COLUMN dev2_status;
ALTER TABLE config_form_tableview DROP COLUMN dev3_status;
ALTER TABLE config_form_tableview DROP COLUMN dev_alias;
ALTER TABLE config_form_tableview DROP CONSTRAINT config_client_forms_pkey;


-- config_form_tabs
UPDATE config_form_tabs SET device = 9 where device is null and id IN (SELECT DISTINCT ON (formname, tabname, device) id FROM config_form_tabs);
DELETE FROM config_form_tabs WHERE device is null;
ALTER TABLE config_form_tabs DROP CONSTRAINT config_api_form_tabs_pkey;
ALTER TABLE config_form_tabs DROP CONSTRAINT config_api_form_tabs_formname_tabname_device_unique;
ALTER TABLE config_form_tabs ADD CONSTRAINT config_form_tabs_pkey PRIMARY KEY(formname, tabname, device);
ALTER TABLE config_form_tabs DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_form_tabs';
DELETE FROM config_form_tabs WHERE tooltip = 'Searcher API web';
UPDATE config_form_tabs SET formname = 'visit_manager' WHERE formname = 'visitManager';
UPDATE config_form_tabs SET sys_role = 'role_basic' WHERE sys_role IS NULL;


DELETE FROM config_form_tableview WHERE id NOT IN (select distinct on (table_id, column_id) id from config_form_tableview);
ALTER TABLE config_form_tableview ADD CONSTRAINT config_form_tableview_pkey PRIMARY KEY(table_id, column_id);
ALTER TABLE config_form_tableview DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_form_tableview';


-- config_info_layer_x_type
ALTER TABLE config_info_layer_x_type DROP CONSTRAINT IF EXISTS config_api_tableinfo_x_inforole_pkey;
ALTER TABLE config_info_layer_x_type ADD CONSTRAINT config_info_layer_x_type_pkey PRIMARY KEY(tableinfo_id, infotype_id);
ALTER TABLE config_info_layer_x_type DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_info_layer_x_type';


-- config_param_system
ALTER TABLE config_param_system DROP COLUMN reg_exp;
UPDATE config_param_system SET isenabled = true WHERE isenabled IS NULL;

-- config_toolbox
UPDATE config_toolbox SET inputparams = null WHERE inputparams::text = '[]';
UPDATE config_toolbox SET observ = null;

CREATE TRIGGER gw_trg_typevalue_config_fk AFTER INSERT OR UPDATE OR DELETE ON sys_typevalue FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_config_fk('sys_typevalue');

CREATE TRIGGER gw_trg_typevalue_config_fk AFTER INSERT OR UPDATE OR DELETE ON config_typevalue FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_config_fk('config_typevalue');


ALTER TABLE om_visit_class RENAME TO config_visit_class;
