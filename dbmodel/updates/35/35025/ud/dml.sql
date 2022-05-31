/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/05/23

UPDATE sys_table SET id='v_edit_cat_dwf_scenario' WHERE id='v_edit_cat_dwf_dscenario';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_dwf_scenario', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_dwf_scenario' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_dwf_scenario', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_dscenario' AND columnname IN ('expl_id', 'log') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_hydrology', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_hydrology' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_hydrology', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_dscenario' AND columnname IN ('expl_id', 'log') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


UPDATE sys_table SET context=a.context, orderby=a.orderby, alias=a.alias FROM (SELECT context, orderby, alias FROM sys_table WHERE id='cat_hydrology')a 
WHERE id='v_edit_cat_hydrology';
UPDATE sys_table SET context=a.context, orderby=a.orderby, alias=a.alias FROM (SELECT context, orderby, alias FROM sys_table WHERE id='cat_dwf_scenario')a 
WHERE id='v_edit_cat_dwf_scenario';

UPDATE sys_table SET context=NULL, orderby=NULL, alias=NULL WHERE id='cat_hydrology' or id='cat_dwf_scenario';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(447, 'Import cat_feature_gully table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (447, 'Import cat_feature_gully', 'Import cat_feature_gully', 'gw_fct_import_cat_feature', true,15, '{"table": "cat_feature_gully"}');

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(451, 'Import cat_grate table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (451, 'Import cat_grate', 'Import cat_grate', 'gw_fct_import_catalog', true,18, null) ON CONFLICT (fid) DO NOTHING;

UPDATE config_form_fields SET hidden = true where columnname IN ('geom5','geom6','geom7','geom8') and formname  ='cat_arc';

INSERT INTO inp_typevalue VALUES ('inp_value_lidtype', 'RB', 'RAIN BARREL')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE inp_typevalue SET idval = replace (idval, ' (5.1)' , '') WHERE typevalue = 'inp_value_lidtype';

UPDATE sys_table SET alias = 'Dwf catalog' WHERE id = 'v_edit_cat_dwf_dscenario';
UPDATE sys_table SET alias = 'Hydrology catalog' WHERE id = 'v_edit_cat_hydrology';

--2022/05/31
UPDATE inp_typevalue
    SET addparam='{"header": ["Depth", "Area"]}'::json
    WHERE typevalue='inp_value_curve' AND id='STORAGE';
UPDATE inp_typevalue
    SET addparam='{"header": ["Hour", "Stage"]}'::json
    WHERE typevalue='inp_value_curve' AND id='TIDAL';
UPDATE inp_typevalue
    SET addparam='{"header": ["Value", "Setting"]}'::json
    WHERE typevalue='inp_value_curve' AND id='CONTROL';
UPDATE inp_typevalue
	SET addparam='{"header": ["Inflow", "Outflow"]}'::json
	WHERE typevalue='inp_value_curve' AND id='DIVERSION';
UPDATE inp_typevalue
	SET addparam='{"header": ["Volume", "Flow"]}'::json
	WHERE typevalue='inp_value_curve' AND id='PUMP1';
UPDATE inp_typevalue
	SET addparam='{"header": ["Depth", "Flow"]}'::json
	WHERE typevalue='inp_value_curve' AND id='PUMP2';
UPDATE inp_typevalue
	SET addparam='{"header": ["Head", "Flow"]}'::json
	WHERE typevalue='inp_value_curve' AND id='PUMP3';
UPDATE inp_typevalue
	SET addparam='{"header": ["Depth", "Flow"]}'::json
	WHERE typevalue='inp_value_curve' AND id='PUMP4';
UPDATE inp_typevalue
	SET addparam='{"header": ["Head", "Outflow"]}'::json
	WHERE typevalue='inp_value_curve' AND id='RATING';
UPDATE inp_typevalue
	SET addparam='{"header": ["Depth/\nFull Depth", "Width/\nFull Depth"]}'::json
	WHERE typevalue='inp_value_curve' AND id='SHAPE';
