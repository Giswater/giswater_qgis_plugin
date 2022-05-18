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

INSERT INTO config_param_system VALUES ('admin_checkproject', '{"usePsectors":false, "ignoreGrafanalytics":false, "ignoreEpa":false, "ignorePlan":true}', 'Variable to manage customization for admin_checkproject function')
ON CONFLICT (parameter) DO NOTHING;


INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(442, 'Node orphan with isarcdivide=TRUE (OM)', 'utils', NULL, 'core', true, 'Check om-topology', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(443, 'Node orphan with isarcdivide=FALSE (OM)', 'utils', NULL, 'core', true, 'Check om-topology', NULL)
ON CONFLICT (fid) DO NOTHING;

UPDATE sys_fprocess
SET fprocess_name='Node orphan (EPA)'
WHERE fid=107;

UPDATE config_toolbox
SET inputparams=NULL
WHERE id=2110;

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3146, 'gw_trg_edit_cat_feature', 'utils', 'trigger function', 'Trigger to fill cat_feature tables', 'role_admin','core')
ON CONFLICT (id) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_arc', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature' and columnname in ('id', 'system_id', 'shortcut_key', 'code_autofill', 'link_path', 
'config', 'descript', 'active');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_arc', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature_arc' and columnname in ('epa_default');


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_connec', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature' and columnname in ('id', 'system_id', 'shortcut_key', 'code_autofill', 'link_path', 
'config', 'descript', 'active');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_connec', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature_connec' and columnname in ('epa_default');


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_node', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature' and columnname in ('id', 'system_id', 'shortcut_key', 'code_autofill', 'link_path', 
'config', 'descript', 'active');

UPDATE config_form_fields SET label='sys_type' WHERE columnname='system_id' and formname ilike 'v_edit_cat_feature_%';

UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM sys_feature_cat WHERE id IS NOT NULL AND type=''ARC'' ' 
WHERE columnname='system_id' and formname ilike 'v_edit_cat_feature_arc';

UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM sys_feature_cat WHERE id IS NOT NULL AND type=''CONNEC'' ' 
WHERE columnname='system_id' and formname ilike 'v_edit_cat_feature_connec';

UPDATE sys_table set orderby = orderby+2 WHERE context='{"level_1":"INVENTORY","level_2":"CATALOGS"}';

UPDATE sys_table set context=null  WHERE id='cat_feature_node' or id = 'cat_feature';

INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, source, style_id, addparam)
VALUES ('v_edit_cat_feature_arc', 'Editable view for cat_feature_arc configuration', 'role_admin', null, '{"level_1":"INVENTORY","level_2":"CATALOGS"}', 1,'Arc feature catalog', null,null,null,'core',null,null);

INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, source, style_id, addparam)
VALUES ('v_edit_cat_feature_node', 'Editable view for cat_feature_node configuration', 'role_admin', null, '{"level_1":"INVENTORY","level_2":"CATALOGS"}',2, 'Node feature catalog', null,null,null,'core',null,null);

INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, source, style_id, addparam)
VALUES ('v_edit_cat_feature_connec', 'Editable view for cat_feature_connec configuration', 'role_admin', null, '{"level_1":"INVENTORY","level_2":"CATALOGS"}',3, 'Connec feature catalog', null,null,null,'core',null,null);
