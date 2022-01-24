/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/01/05
--reactions
INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_bulk_order', 'epaoptions', 'Power to which concentration is raised when computing a bulk flow reaction rate','role_epa',
'ORDER BULK', 'Bulk Reaction Order', null, null, true, 1, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'integer',
'linetext', TRUE, NULL, NULL, 'lyt_reactions_1', TRUE, NULL,TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_wall_order', 'epaoptions', 'Power to which concentration is raised when computing a bulk flow reaction rate','role_epa',
'ORDER WALL', 'Wall Reaction Order', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'integer',
'linetext', TRUE, NULL, NULL, 'lyt_reactions_1', TRUE, NULL,TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_global_bulk', 'epaoptions', 'Default bulk reaction rate coefficient (Kb) assigned to all pipes.','role_epa',
'GLOBAL BULK', 'Global Bulk Coefficient', null, null, true, 3, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', TRUE, NULL, NULL, 'lyt_reactions_1', TRUE, NULL,TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_global_wall', 'epaoptions', 'Wall reaction rate coefficient (Kw) assigned to all pipes.','role_epa',
'GLOBAL WALL', 'Global Wall Coefficient', null, null, true, 1, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', TRUE, NULL, NULL, 'lyt_reactions_2', TRUE, NULL,TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_limit_concentration', 'epaoptions', 'Maximum concentration that a substance can grow to or minimum value it can decay to.','role_epa',
'LIMITING POTENTIAL', 'Limiting Concentration', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', TRUE, NULL, NULL, 'lyt_reactions_2', TRUE, NULL,TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_wall_coeff_correlation', 'epaoptions', 'Factor correlating wall reaction coefficient to pipe roughness.','role_epa',
'ROUGHNESS CORRELATION', 'Wall Coefficient Correlation', null, null, true, 3, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', TRUE, NULL, NULL, 'lyt_reactions_2', TRUE, NULL, TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

--energy

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_pump_effic', 'epaoptions', 'Default pump efficiency','role_epa',
'GLOBAL EFFIC', 'Pump Efficiency', 'SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', null, true, 1, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'string',
'combo', TRUE, NULL, NULL, 'lyt_energy_1', TRUE, NULL, TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_price', 'epaoptions', 'Price of energy per kilowatt-hour','role_epa',
'GLOBAL PRICE', 'Energy Price per Kwh', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'text',
'linetext', TRUE, NULL, NULL, 'lyt_energy_1', TRUE, NULL, TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_price_pattern', 'epaoptions', 'ID label of a time pattern used to represent variations in energy price with time.','role_epa',
'GLOBAL PATTERN', 'Price Pattern', 'SELECT pattern_id AS id, pattern_id AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', null, true, 1, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'string',
'combo', TRUE, NULL, NULL, 'lyt_energy_2', TRUE, NULL, TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_demand_charge', 'epaoptions', 'Additional energy charge per maximum kilowatt usage.','role_epa',
'DEMAND CHARGE', 'Demand Charge', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'text',
'linetext', TRUE, NULL, NULL, 'lyt_energy_2', TRUE, NULL, TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

--junction
UPDATE config_form_fields SET columnname = 'emitter_coeff', label ='emitter_coeff' WHERE columnname='coef' and formname = 'inp_emitter';
UPDATE config_form_fields SET columnname = 'init_quality', label= 'init_quality' WHERE columnname='initqual' and formname = 'inp_quality';
UPDATE config_form_fields SET columnname = 'source_type', label = 'source_type' WHERE columnname='sourc_type' and formname = 'inp_source';
UPDATE config_form_fields SET columnname = 'source_quality',label = 'source_quality' WHERE columnname='quality' and formname = 'inp_source';
UPDATE config_form_fields SET columnname = 'source_pattern_id' ,label = 'source_pattern_id' WHERE columnname='pattern_id' and formname = 'inp_source';

UPDATE config_form_fields SET formname = 'v_edit_inp_junction' 
WHERE formname IN ('inp_quality','inp_source','inp_emitter') AND columnname!='node_id';

DELETE FROM config_form_fields WHERE formname in ('inp_quality', 'inp_source','inp_emitter');

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_junction', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND columnname in ('node_id','demand','pattern_id','demand_type', 'emitter_coeff',
'init_quality', 'source_type', 'source_quality', 'source_pattern_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--tank
INSERT INTO config_form_fields 
SELECT 'v_edit_inp_tank', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND 
columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_tank', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_tank' 
AND columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--inlet
INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_inlet', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_tank' 
AND columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_inlet', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_tank' 
AND columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


--reservoir
INSERT INTO config_form_fields 
SELECT 'v_edit_inp_reservoir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND 
columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_reservoir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_reservoir' 
AND columnname in ('init_quality', 'source_type', 'source_quality', 'source_pattern_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--valve
INSERT INTO config_form_fields 
SELECT 'v_edit_inp_valve', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_reservoir' AND columnname in ('init_quality') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_valve', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_valve' AND columnname in ('init_quality')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--virtualvalve

INSERT INTO config_form_fields 
SELECT 'inp_virtualvalve', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND columnname in ('init_quality') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'inp_dscenario_virtualvalve', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_virtualvalve' AND columnname in ('init_quality')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--pump

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_pump', formtype, tabname, 'effic_curve_id', layoutname, layoutorder, datatype, widgettype, 'effic_curve_id', tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',
 widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_pump' AND 
columnname in ('curve_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_pump', formtype, tabname, 'effic_curve_id', layoutname, layoutorder, datatype, widgettype, 'effic_curve_id', tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',
widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_pump' AND 
columnname in ('curve_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_pump', formtype, tabname, 'energy_pattern_id', layoutname, layoutorder, datatype, widgettype, 'energy_pattern_id', tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND 
columnname in ('pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_pump', formtype, tabname, 'energy_pattern_id', layoutname, layoutorder, datatype, widgettype, 'energy_pattern_id', tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_junction' AND 
columnname in ('pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_pump_additional', formtype, tabname, 'energy_pattern_id', layoutname, layoutorder, datatype, widgettype, 'energy_pattern_id', tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_pump_additional' AND 
columnname in ('pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields set dv_isnullvalue=TRUE WHERE columnname='source_pattern_id' or columnname='source_type';

UPDATE config_form_fields set widgetcontrols='{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}' 
WHERE columnname='source_pattern_id';

UPDATE config_form_fields set widgetcontrols='{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}' 
WHERE columnname='pattern_id';

UPDATE config_form_fields set columnname='pattern_id' 
WHERE columnname='pattern' AND (formname ilike '%inp_pump%' or formname ilike '%inp_dscenario_pump%');
