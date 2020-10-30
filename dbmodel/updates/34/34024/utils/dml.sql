/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/10/22
UPDATE sys_param_user SET label = 'QGIS composers path' WHERE id = 'qgis_composers_folderpath';
UPDATE sys_param_user SET label = 'QGIS hide buttons on toolbox' WHERE id = 'qgis_toolbar_hidebuttons';
UPDATE sys_param_user SET label = 'Name of polygon virtual layer' WHERE id = 'virtual_polygon_vdefault';
UPDATE sys_param_user SET label = 'Name of point virtual layer' WHERE id = 'virtual_point_vdefault';
UPDATE sys_param_user SET label = 'Name of line virtual layer' WHERE id = 'virtual_line_vdefault';


INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text3', layoutorder, datatype, widgettype, 'text3', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text4', layoutorder, datatype, widgettype, 'text4', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text5', layoutorder, datatype, widgettype, 'text5', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text6', layoutorder, datatype, widgettype, 'text6', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

DELETE FROM config_csv WHERE fid IN (246, 247, 245, 237, 244);

DELETE FROM config_param_system WHERE parameter = 'utils_import_visit_parameters';

DELETE FROM sys_function WHERE id IN (2884, 2512, 2738);

--2738
DROP FUNCTION IF EXISTS gw_fct_utils_csv2pg_import_timeseries();
DROP FUNCTION IF EXISTS gw_fct_import_timeseries(json);

--2512
DROP FUNCTION IF EXISTS gw_fct_import_omvisit(json);

--2884
DROP FUNCTION IF EXISTS gw_fct_utils_csv2pg_import_omvisitlot(json);
DROP FUNCTION IF EXISTS gw_fct_import_omvisitlot(json);

-- 2020/10/26
DELETE FROM config_param_system WHERE parameter = 'edit_arc_insert_automatic_endpoint';

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, isdeprecated, vdefault)
VALUES ('edit_arc_insert_automatic_endpoint', 'config', 'If value, enables to digitize new arcs without node_2. Node2 it is automatic triggered using default nodecat value from user and common values from arc',
'role_edit', 'Automatic node insert as arc endpoint', TRUE, 7, 'utils', FALSE, FALSE, 'boolean', 'check', TRUE, 'lyt_other',
TRUE, FALSE, 'FALSE') ON CONFLICT (id) DO NOTHING;

-- 2020/10/27
INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3160, 'This feature with state = 2 is only attached to psector' , 'It''s necessary to remove feature completaly using end feature tool', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3162, 'This feature is a final node for planned arc ' , 'It''s necessary to remove arcs first, then nodes', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING;
