/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 3.1.112
INSERT INTO audit_cat_function VALUES (2682, 'gw_fct_api_getprint', 'utils', 'api function', NULL, NULL, NULL, 'Get print form', 'role_basic', false, false, NULL, false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_function VALUES (2684, 'gw_fct_api_setprint', 'utils', 'api function', NULL, NULL, NULL, 'Set print form', 'role_basic', false, false, NULL, false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_function VALUES (2686, 'gw_trg_doc', 'utils', 'function trigger', NULL, NULL, NULL, 'Automatic replace of path for docs', 'role_edit', false, false, NULL, false) 
ON CONFLICT (id) DO NOTHING;

SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('edit_replace_doc_folderpath','{"enabled":true, "values":[{"source":"c://dades/","target":"http:www.giswater.org/"},{"source":"c://test/test/","target":"http:www.bgeo.org/"}]}','json', 'edit', 'Variable to identify the text to replace and the text to be replaced on folder path. More than one must be possible. Managed on triggers of doc tables when insert new row')
ON CONFLICT (parameter) DO nothing;

UPDATE config_param_system SET data_type = NULL, context = 'edit', descript = 'Automatic path string replace when document is inserted', 
label = 'Doc path replace:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = null, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = NULL, widgettype = NULL, tooltip = NULL, ismandatory = NULL,iseditable = NULL, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_replace_doc_folderpath';
    

--24/04/2019
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='v_ui_om_visitman_x_arc';
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='v_ui_om_visitman_x_node';
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='v_ui_om_visitman_x_connec';

UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='v_ui_om_visit';


INSERT INTO audit_cat_error VALUES (2015, 'There is no state-1 feature as endpoint of link. It is impossible to create it', 'Try to connect the link to one arc / node / connec / gully or vnode with state=1', 2, true, NULL)
ON CONFLICT (id) DO NOTHING;