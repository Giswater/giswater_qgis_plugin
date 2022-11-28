/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM config_toolbox WHERE id=2766;
DELETE FROM sys_function WHERE id=2766;

UPDATE sys_function SET project_type='utils' WHERE id =2710 OR id=2768;


INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3174, 'gw_trg_edit_setarcdata', 'utils', 'trigger function', 
'Trigger that fills arc with values captured or calculated based on attributes stored on final nodes', 'role_edit', 'core');

INSERT INTO config_param_system(parameter, value, descript, isenabled,  project_type, datatype)
VALUES ('admin_isproduction' , False, 'If true, deleting the schema using Giswater button will not be possible', FALSE, 'utils', 'boolean');

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (478, 'Check features without defined sector_id', 'utils', NULL, 'core', true, 'Check om-data', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (479, 'Check duplicated arcs', 'utils', NULL, 'core', true, 'Check om-data', NULL);

INSERT INTO config_param_system(parameter, value, descript, project_type,  datatype)
VALUES ('admin_node_code_on_arc', false, 'If true, on codes of final nodes will be visible on arc''s form. If false, node_id would be displayed', 'utils', 'boolean')
ON CONFLICT (parameter) DO NOTHING;

UPDATE sys_param_user SET dv_isnullvalue=NULL WHERE formname='epaoptions';

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sys_display_field','descript'::text) WHERE parameter = 'basic_search_street';

-- execute psector refactor
UPDATE sys_message SET hint_message='It''s used as init or final node on planified arcs' WHERE id=3142;

INSERT INTO plan_typevalue VALUES('psector_status', '4', 'EXECUTED (On Service)', 'Psector executed. Its elements are set to On Service', NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO plan_typevalue VALUES('psector_status', '5', 'EXECUTED (Do nothing)', 'Psector executed but do nothing', NULL) ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE plan_typevalue SET idval='EXECUTED (Obsolete)', descript='Psector executed. Its elements are set to Obsolete' WHERE typevalue='psector_status' AND id='0';

UPDATE plan_psector SET status = 4 where status=0 and (SELECT value::json ->> 'mode' FROM config_param_system WHERE parameter='plan_psector_execute_action')='onService';
UPDATE plan_psector SET status = 5 where status=0 and (SELECT value::json ->> 'mode' FROM config_param_system WHERE parameter='plan_psector_execute_action')='disabled';

UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'mode') WHERE parameter = 'plan_psector_execute_action';

INSERT INTO config_param_system  (parameter, value, descript, "label", isenabled, layoutorder, project_type, "datatype", widgettype, layoutname)
SELECT 'plan_statetype_vdefault',json_object_agg (parameter,value), 'Default state_type when using planified features', 'Plan state_type vdefault:', true, 10, 'utils', 'json', 'text', 'lyt_admin_other'
FROM config_param_system where parameter in ('plan_statetype_ficticius', 'plan_statetype_planned', 'plan_statetype_reconstruct');

UPDATE config_param_system  b SET value=b.value::jsonb ||a.value ::jsonb
FROM config_param_system a where a.parameter ='plan_psector_execute_action' and b.parameter='plan_psector_statetype';

DELETE FROM config_param_system where parameter in ('plan_statetype_ficticius', 'plan_statetype_planned', 'plan_statetype_reconstruct','plan_psector_execute_action');

UPDATE config_param_system SET "parameter"='plan_psector_execute', "label"='Psector execute state_type:' where "parameter"='plan_psector_statetype';

UPDATE config_param_system SET value=replace(value,'plan_obsolete_state_type', 'obsolete_planified') WHERE "parameter"='plan_psector_execute';

UPDATE sys_table SET addparam='{"pkey":"link_id, psector_rowid"}' WHERE id='v_edit_link';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (480, 'Check duplicated connec/gullies on visible psectors', 'utils', NULL, 'core', true, 'Check epa-data', NULL);

INSERT INTO config_param_system ("parameter", value, descript, isenabled, project_type, "datatype")
VALUES('admin_skip_audit', 'false', 'System parameter to identify processes that need to avoid audit log because of the big amount of data updated. Example: mapzones or daily update crm', false, 'utils', 'string');
