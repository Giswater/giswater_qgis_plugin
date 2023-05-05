/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM config_form_tableview where tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully') and columnindex in(7,8);
UPDATE config_form_tableview SET visible = true where columnindex = 7 and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');
UPDATE config_form_tableview SET visible = false, columnindex = 8 where columnname = 'active' and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');
UPDATE config_form_tableview SET visible = false, columnindex = 9 where columnname = 'insert_tstamp' and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');
UPDATE config_form_tableview SET visible = false, columnindex = 10 where columnname = 'insert_user' and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');

UPDATE config_typevalue SET camelstyle='{"orderBy":24}'WHERE typevalue='sys_table_context' AND id='{"level_1":"BASEMAP","level_2":"ADDRESS"}';
UPDATE config_typevalue SET camelstyle='{"orderBy":25}'WHERE typevalue='sys_table_context' AND id='{"level_1":"BASEMAP","level_2":"CARTO"}';
INSERT INTO config_typevalue VALUES('sys_table_context', '{"level_1":"MASTERPLAN","level_2":"TRACEABILITY"}', NULL, '{"orderBy":23}', NULL);

INSERT INTO sys_table (id, descript, sys_role, context, orderby, alias, source)
VALUES('audit_psector_node_traceability', 'Traceability of executed planified nodes', 'role_basic', 
'{"level_1":"MASTERPLAN","level_2":"TRACEABILITY"}', 1, 'Psector node traceability', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, orderby, alias, source)
VALUES('audit_psector_connec_traceability', 'Traceability of executed planified connecs', 'role_basic', 
'{"level_1":"MASTERPLAN","level_2":"TRACEABILITY"}', 2, 'Psector connec traceability', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, context, orderby, alias, source)
VALUES('audit_psector_arc_traceability', 'Traceability of executed planified arcs', 'role_basic', 
'{"level_1":"MASTERPLAN","level_2":"TRACEABILITY"}', 3, 'Psector arc traceability', 'core') ON CONFLICT (id) DO NOTHING;


ALTER TABLE plan_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

DELETE FROM plan_typevalue WHERE typevalue='psector_status' AND id='5';

ALTER TABLE plan_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE plan_typevalue SET idval='EXECUTED (Save Trace)', descript='Psector executed. Its elements are copied to traceability tables' 
WHERE typevalue='psector_status' AND id='0';

UPDATE plan_typevalue SET idval='ONGOING (Keep Plan)'
WHERE typevalue='psector_status' AND id='1';

UPDATE plan_typevalue set idval='CANCELED (Save Trace)', descript='Psector canceled. Its elements are copied to traceability tables' 
WHERE typevalue='psector_status' AND id='3';

UPDATE plan_typevalue set idval='EXECUTED (Set OPERATIVE and Save Trace)', descript='Psector executed. Its elements are set to On Service and also copied to traceability tables' 
WHERE typevalue='psector_status' AND id='4';

UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'done_planified') WHERE parameter = 'plan_psector_status_action';
UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'done_ficticious') WHERE parameter = 'plan_psector_status_action';
UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'canceled_planified') WHERE parameter = 'plan_psector_status_action';
UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'canceled_ficticious') WHERE parameter = 'plan_psector_status_action';

