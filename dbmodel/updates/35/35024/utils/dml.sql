/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type)
VALUES ('440', 'Check outlet_id assigned to subcatchments','ud',null, 'core', true, 'Check epa-config')
ON CONFLICT (fid) DO NOTHING;

UPDATE config_param_system SET parameter='admin_debug' WHERE parameter = 'om_mincut_debug';

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3140, 'gw_trg_edit_inp_coverage', 'ud', 'trigger function', NULL, 'json', 'Trigger to make editable v_edit_inp_coverage', 'role_epa', NULL, 'core');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_controls', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_controls';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_controls', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE columnname='dscenario_id' AND formname='v_edit_inp_dscenario_junction';

INSERT INTO sys_table(id, descript, sys_role,  context, orderby, alias, source)
VALUES ('inp_dscenario_controls', '"Table to manage scenario for controls"', 'role_epa', null,null,NULL, 'core');

INSERT INTO sys_table(id, descript, sys_role,  context, orderby, alias, source)
VALUES ('v_edit_inp_dscenario_controls', '"Editable view to manage scenario for controls"', 'role_epa',  '{"level_1":"EPA","level_2":"DSCENARIO"}',15, 'Controls Dscenario', 
'core');

UPDATE sys_table SET source = 'core' WHERE source = 'giswater' or source IS NULL;
UPDATE sys_function SET source = 'core' WHERE source = 'giswater' or source IS NULL;
UPDATE sys_fprocess SET source = 'core' WHERE source = 'giswater' or source IS NULL;
UPDATE sys_message SET source = 'core' WHERE source = 'giswater' or source IS NULL;
UPDATE sys_param_user SET source = 'core' WHERE source = 'giswater' or source IS NULL;

UPDATE config_report SET active=TRUE;