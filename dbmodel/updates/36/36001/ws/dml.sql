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


--FK
DELETE FROM sys_foreignkey WHERE typevalue_name = 'inp_typevalue_source' AND target_table='inp_source';
DELETE FROM sys_foreignkey WHERE typevalue_name = 'inp_value_mixing' AND target_table='inp_mixing';

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_junction', 'source_type', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_dscenario_junction', 'source_type', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_tank', 'source_type', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_dscenario_tank', 'source_type', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_reservoir', 'source_type', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_dscenario_reservoir', 'source_type', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_inlet', 'source_type', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_typevalue_source', 'inp_dscenario_inlet', 'source_type', true);

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_value_mixing', 'inp_tank', 'mixing_model', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_value_mixing', 'inp_dscenario_tank', 'mixing_model', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_value_mixing', 'inp_inlet', 'mixing_model', true);
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,  active) 
VALUES ('inp_typevalue', 'inp_value_mixing', 'inp_dscenario_inlet', 'mixing_model', true);



-- JUNCTION
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_junction', 'SELECT dscenario_id, demand, pattern_id, emitter_coeff, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL', 4, 'tab', 'list'); 

INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"filterSign":"=", "text":"DMND"}', '{"functionName": "open_epa_dlg", "module": "info", "parameters":{"ui": "GwInfoEpaDemandUi", "uiName": "info_epa_demand", "tableviews": [{"tbl": "tbl_dscenario_demand", "view": "v_edit_inp_dscenario_demand", "pk": "feature_id"}]}}', false, '');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'demand', 'lyt_epa_data_1', 1, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Pattern id:', 'Pattern id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'emitter_coeff', 'lyt_epa_data_1', 3, 'string', 'text', 'Emitter coefficient:', 'Emitter coefficient', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'initial_quality', 'lyt_epa_data_1', 4, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 5, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 6, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_pattern_id', 'lyt_epa_data_1', 7, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'total_head', 'lyt_epa_data_2', 2, 'string', 'text', 'Total head:', 'Total head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 3, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 4, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'tbl_inp_junction', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_junction');


-- PUMP
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_pump', 'SELECT dscenario_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id FROM v_edit_inp_dscenario_pump WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'manage_pumpadditional', 'lyt_epa_1', 1, 'button', 'Manage pump additional', false, false, true, false, '{"filterSign":"=", "text":"PADD"}', '{"functionName": "open_epa_dlg", "module": "info", "parameters":{"ui": "GwInfoEpaPumpadditionalUi", "uiName": "info_epa_pumpadditional", "tableviews": [{"tbl": "tbl_pumpadditional", "view": "v_edit_inp_pump_additional"}, {"tbl": "tbl_dscenario_pumpadditional", "view": "v_edit_inp_dscenario_pump_additional"}]}}', false, '');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'power', 'lyt_epa_data_1', 1, 'string', 'text', 'Power:', 'Power', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'speed', 'lyt_epa_data_1', 3, 'string', 'text', 'Speed:', 'Speed', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 4, 'string', 'text', 'Pattern:', 'Pattern', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 5, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 6, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'energyparam', 'lyt_epa_data_1', 7, 'string', 'text', 'Energy parameter:', 'Energy parameter', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'energyvalue', 'lyt_epa_data_1', 8, 'string', 'text', 'Energy value:', 'Energy value', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'pump_type', 'lyt_epa_data_1', 9, 'string', 'text', 'Pump type:', 'Pump type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'energy_price', 'lyt_epa_data_1', 10, 'string', 'text', 'Energy price:', 'Energy price', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'price_pattern', 'lyt_epa_data_1', 11, 'string', 'text', 'Price pattern:', 'Price pattern', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'headloss', 'lyt_epa_data_2', 3, 'string', 'text', 'Headloss:', 'Headloss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 4, 'string', 'text', 'Quality:', 'Quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'usage_fact', 'lyt_epa_data_2', 6, 'string', 'text', 'Usage factor:', 'Usage factor', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_effic', 'lyt_epa_data_2', 7, 'string', 'text', 'Average efficiency:', 'Average efficiency', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'kwhr_mgal', 'lyt_epa_data_2', 8, 'string', 'text', 'KWh mgal?:', 'KWh mgal?', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_kw', 'lyt_epa_data_2', 9, 'string', 'text', 'Average KW:', 'Average KW', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'peak_kw', 'lyt_epa_data_2', 10, 'string', 'text', 'Peak KW:', 'Peak KW', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'cost_day', 'lyt_epa_data_2', 11, 'string', 'text', 'Cost day:', 'Cost day', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'tbl_inp_pump', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_pump');


-- PIPE
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_pipe', 'SELECT dscenario_id, minorloss, status, roughness, dint, bulk_coeff, wall_coeff FROM v_edit_inp_dscenario_pipe WHERE arc_id IS NOT NULL', 4, 'tab', 'list'); 

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 1, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 2, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'custom_roughness', 'lyt_epa_data_1', 3, 'string', 'text', 'Custom roughness:', 'Custom roughness', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'custom_dint', 'lyt_epa_data_1', 4, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'reactionparam', 'lyt_epa_data_1', 5, 'string', 'text', 'Reaction parameter:', 'Reaction parameter', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'reactionvalue', 'lyt_epa_data_1', 6, 'string', 'text', 'Reaction value:', 'Reaction value', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'buk_coeff', 'lyt_epa_data_1', 7, 'string', 'text', 'Buk coefficient:', 'Buk coefficient', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 8, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Max flow:', 'Max Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'min_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'Min flow:', 'Min Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'max_vel', 'lyt_epa_data_2', 4, 'string', 'text', 'Max velocity:', 'Max velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'min_vel', 'lyt_epa_data_2', 5, 'string', 'text', 'Min velocity:', 'Min velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'max_headloss', 'lyt_epa_data_2', 6, 'string', 'text', 'Max headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'min_headloss', 'lyt_epa_data_2', 7, 'string', 'text', 'Min headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'max_setting', 'lyt_epa_data_2', 8, 'string', 'text', 'Max setting:', 'Max setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'min_setting', 'lyt_epa_data_2', 9, 'string', 'text', 'Min setting:', 'Min setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'max_reaction', 'lyt_epa_data_2', 10, 'string', 'text', 'Max reaction:', 'Max reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'min_reaction', 'lyt_epa_data_2', 11, 'string', 'text', 'Min reaction:', 'Min reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'max_ffactor', 'lyt_epa_data_2', 12, 'string', 'text', 'Max Ffactor:', 'Max Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'min_ffactor', 'lyt_epa_data_2', 13, 'string', 'text', 'Min Ffactor:', 'Min Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'tbl_inp_pipe', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_pipe');


-- SHORTPIPE
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_shortpipe', 'SELECT dscenario_id, minorloss, status, bulk_coeff, wall_coeff FROM v_edit_inp_dscenario_shortpipe WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 2, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 3, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 4, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'buk_coeff', 'lyt_epa_data_1', 5, 'string', 'text', 'Buk coefficient:', 'Buk coefficient', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 6, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Max flow:', 'Max Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'min_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'Min flow:', 'Min Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'max_vel', 'lyt_epa_data_2', 4, 'string', 'text', 'Max velocity:', 'Max velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'min_vel', 'lyt_epa_data_2', 5, 'string', 'text', 'Min velocity:', 'Min velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'max_headloss', 'lyt_epa_data_2', 6, 'string', 'text', 'Max headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'min_headloss', 'lyt_epa_data_2', 7, 'string', 'text', 'Min headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'max_setting', 'lyt_epa_data_2', 8, 'string', 'text', 'Max setting:', 'Max setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'min_setting', 'lyt_epa_data_2', 9, 'string', 'text', 'Min setting:', 'Min setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'max_reaction', 'lyt_epa_data_2', 10, 'string', 'text', 'Max reaction:', 'Max reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'min_reaction', 'lyt_epa_data_2', 11, 'string', 'text', 'Min reaction:', 'Min reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'max_ffactor', 'lyt_epa_data_2', 12, 'string', 'text', 'Max Ffactor:', 'Max Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'min_ffactor', 'lyt_epa_data_2', 13, 'string', 'text', 'Min Ffactor:', 'Min Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'tbl_inp_shortpipe', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_shortpipe');


-- TANK
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_tank', 'SELECT dscenario_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_tank WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'initlevel', 'lyt_epa_data_1', 1, 'string', 'text', 'Init level:', 'Initial level', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'minlevel', 'lyt_epa_data_1', 2, 'string', 'text', 'Min level:', 'Minimum level', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'maxlevel', 'lyt_epa_data_1', 3, 'string', 'text', 'Max level:', 'Maximum level', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'diameter', 'lyt_epa_data_1', 4, 'string', 'text', 'Diameter:', 'Diameter', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'minvol', 'lyt_epa_data_1', 5, 'string', 'text', 'Min volume:', 'Minimum volume', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'overflow', 'lyt_epa_data_1', 6, 'string', 'text', 'Overflow:', 'Overflow', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'mixing_model', 'lyt_epa_data_1', 7, 'string', 'text', 'Mixing model:', 'Mixing model', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'mixing_fraction', 'lyt_epa_data_1', 7, 'string', 'text', 'Mixing fraction:', 'Mixing fraction', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 10, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 11, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_pattern_id', 'lyt_epa_data_1', 13, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'max_demand', 'lyt_epa_data_2', 2, 'string', 'text', 'Max demand:', 'Max demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'min_demand', 'lyt_epa_data_2', 3, 'string', 'text', 'Min demand:', 'Min demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'max_head', 'lyt_epa_data_2', 4, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'min_head', 'lyt_epa_data_2', 5, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'max_pressure', 'lyt_epa_data_2', 6, 'string', 'text', 'Max pressure:', 'Max pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'min_pressure', 'lyt_epa_data_2', 7, 'string', 'text', 'Min pressure:', 'Min pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'max_quality', 'lyt_epa_data_2', 8, 'string', 'text', 'Max quality:', 'Max quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'min_quality', 'lyt_epa_data_2', 9, 'string', 'text', 'Min quality:', 'Min quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'tbl_inp_tank', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_tank');


-- RESERVOIR
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_reservoir', 'SELECT dscenario_id, pattern_id, head, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_reservoir WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Pattern:', 'Pattern', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'head', 'lyt_epa_data_1', 2, 'string', 'text', 'Head:', 'Head', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 3, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 4, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 5, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_pattern_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'max_demand', 'lyt_epa_data_2', 2, 'string', 'text', 'Max demand:', 'Max demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'min_demand', 'lyt_epa_data_2', 3, 'string', 'text', 'Min demand:', 'Min demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'max_head', 'lyt_epa_data_2', 4, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'min_head', 'lyt_epa_data_2', 5, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'max_pressure', 'lyt_epa_data_2', 6, 'string', 'text', 'Max pressure:', 'Max pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'min_pressure', 'lyt_epa_data_2', 7, 'string', 'text', 'Min pressure:', 'Min pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'max_quality', 'lyt_epa_data_2', 8, 'string', 'text', 'Max quality:', 'Max quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'min_quality', 'lyt_epa_data_2', 9, 'string', 'text', 'Min quality:', 'Min quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'tbl_inp_reservoir', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_reservoir');


-- VALVE
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_valve', 'SELECT dscenario_id, nodarc_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM v_edit_inp_dscenario_valve WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'valv_type', 'lyt_epa_data_1', 2, 'string', 'text', 'Valve type:', 'Valve type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_1', 3, 'string', 'text', 'Pressure:', 'Pressure', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'custom_dint', 'lyt_epa_data_1', 4, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'flow', 'lyt_epa_data_1', 5, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'coef_loss', 'lyt_epa_data_1', 6, 'string', 'text', 'Coefficient loss:', 'Coefficient loss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 7, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 8, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 9, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 10, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'add_settings', 'lyt_epa_data_1', 11, 'string', 'text', 'Add settings:', 'Add settings', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Max flow:', 'Max Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'min_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'Min flow:', 'Min Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'max_vel', 'lyt_epa_data_2', 4, 'string', 'text', 'Max velocity:', 'Max velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'min_vel', 'lyt_epa_data_2', 5, 'string', 'text', 'Min velocity:', 'Min velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'max_headloss', 'lyt_epa_data_2', 6, 'string', 'text', 'Max headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'min_headloss', 'lyt_epa_data_2', 7, 'string', 'text', 'Min headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'max_setting', 'lyt_epa_data_2', 8, 'string', 'text', 'Max setting:', 'Max setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'min_setting', 'lyt_epa_data_2', 9, 'string', 'text', 'Min setting:', 'Min setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'max_reaction', 'lyt_epa_data_2', 10, 'string', 'text', 'Max reaction:', 'Max reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'min_reaction', 'lyt_epa_data_2', 11, 'string', 'text', 'Min reaction:', 'Min reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'max_ffactor', 'lyt_epa_data_2', 12, 'string', 'text', 'Max Ffactor:', 'Max Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'min_ffactor', 'lyt_epa_data_2', 13, 'string', 'text', 'Min Ffactor:', 'Min Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'tbl_inp_valve', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_valve');


-- VIRTUALVALVE
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_virtualvalve', 'SELECT dscenario_id, valv_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status, init_quality FROM v_edit_inp_dscenario_virtualvalve WHERE arc_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'valv_type', 'lyt_epa_data_1', 2, 'string', 'text', 'Valve type:', 'Valve type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_1', 3, 'string', 'text', 'Pressure:', 'Pressure', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'diameter', 'lyt_epa_data_1', 4, 'string', 'text', 'Diameter:', 'Diameter', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'flow', 'lyt_epa_data_1', 5, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'coef_loss', 'lyt_epa_data_1', 6, 'string', 'text', 'Coefficient loss:', 'Coefficient loss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 7, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 8, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 9, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 10, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 11, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Max flow:', 'Max Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'min_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'Min flow:', 'Min Flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'max_vel', 'lyt_epa_data_2', 4, 'string', 'text', 'Max velocity:', 'Max velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'min_vel', 'lyt_epa_data_2', 5, 'string', 'text', 'Min velocity:', 'Min velocity', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'max_headloss', 'lyt_epa_data_2', 6, 'string', 'text', 'Max headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'min_headloss', 'lyt_epa_data_2', 7, 'string', 'text', 'Min headloss:', 'Max headloss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'max_setting', 'lyt_epa_data_2', 8, 'string', 'text', 'Max setting:', 'Max setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'min_setting', 'lyt_epa_data_2', 9, 'string', 'text', 'Min setting:', 'Min setting', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'max_reaction', 'lyt_epa_data_2', 10, 'string', 'text', 'Max reaction:', 'Max reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'min_reaction', 'lyt_epa_data_2', 11, 'string', 'text', 'Min reaction:', 'Min reaction', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'max_ffactor', 'lyt_epa_data_2', 12, 'string', 'text', 'Max Ffactor:', 'Max Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'min_ffactor', 'lyt_epa_data_2', 13, 'string', 'text', 'Min Ffactor:', 'Min Ffactor', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'tbl_inp_virtualvalve', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_virtualvalve');


-- INLET
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_inlet', 'SELECT dscenario_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, head, pattern_id, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_inlet WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'initlevel', 'lyt_epa_data_1', 1, 'string', 'text', 'Init level:', 'Initial level', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'minlevel', 'lyt_epa_data_1', 2, 'string', 'text', 'Min level:', 'Minimum level', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'maxlevel', 'lyt_epa_data_1', 3, 'string', 'text', 'Max level:', 'Maximum level', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'diameter', 'lyt_epa_data_1', 4, 'string', 'text', 'Diameter:', 'Diameter', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'minvol', 'lyt_epa_data_1', 5, 'string', 'text', 'Min volume:', 'Minimum volume', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 7, 'string', 'text', 'Pattern id:', 'Pattern id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'overflow', 'lyt_epa_data_1', 8, 'string', 'text', 'Overflow:', 'Overflow', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'head', 'lyt_epa_data_1', 9, 'string', 'text', 'Head:', 'Head', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'mixing_model', 'lyt_epa_data_1', 10, 'string', 'text', 'Mixing model:', 'Mixing model', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'mixing_fraction', 'lyt_epa_data_1', 11, 'string', 'text', 'Mixing fraction:', 'Mixing fraction', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'reaction_coeff', 'lyt_epa_data_1', 12, 'string', 'text', 'Reaction coefficient:', 'Reaction coefficient', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 13, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 14, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 15, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_pattern_id', 'lyt_epa_data_1', 16, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'max_demand', 'lyt_epa_data_2', 2, 'string', 'text', 'Max demand:', 'Max demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'min_demand', 'lyt_epa_data_2', 3, 'string', 'text', 'Min demand:', 'Min demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'max_head', 'lyt_epa_data_2', 4, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'min_head', 'lyt_epa_data_2', 5, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'max_pressure', 'lyt_epa_data_2', 6, 'string', 'text', 'Max pressure:', 'Max pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'min_pressure', 'lyt_epa_data_2', 7, 'string', 'text', 'Min pressure:', 'Min pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'max_quality', 'lyt_epa_data_2', 8, 'string', 'text', 'Max quality:', 'Max quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'min_quality', 'lyt_epa_data_2', 9, 'string', 'text', 'Min quality:', 'Min quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'tbl_inp_tank', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_inlet');

-- CONNEC
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_connec', 'SELECT dscenario_id, pjoint_type, pjoint_id, demand, pattern_id, peak_factor, status, minorloss, custom_roughness, custom_length, custom_dint FROM v_edit_inp_dscenario_connec WHERE connec_id IS NOT NULL', 4, 'tab', 'list'); 

INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"filterSign":"=", "text":"DMND"}', '{"functionName": "open_epa_dlg", "module": "info", "parameters":{"ui": "GwInfoEpaDemandUi", "uiName": "info_epa_demand", "tableviews": [{"tbl": "tbl_dscenario_demand", "view": "v_edit_inp_dscenario_demand", "pk": "feature_id"}]}}', false, '');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'demand', 'lyt_epa_data_1', 1, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Pattern id:', 'Pattern id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'peak_factor', 'lyt_epa_data_1', 3, 'string', 'text', 'Peak factor:', 'Peak factor', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'custom_roughness', 'lyt_epa_data_1', 4, 'string', 'text', 'Custom roughness:', 'Custom roughness', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'custom_length', 'lyt_epa_data_1', 5, 'string', 'text', 'Custom length:', 'Custom length', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'custom_dint', 'lyt_epa_data_1', 6, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 7, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 8, 'string', 'text', 'Minor loss:', 'Minor loss', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'max_demand', 'lyt_epa_data_2', 2, 'string', 'text', 'Max demand:', 'Max demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'min_demand', 'lyt_epa_data_2', 3, 'string', 'text', 'Min demand:', 'Min demand', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'max_head', 'lyt_epa_data_2', 4, 'string', 'text', 'Max head:', 'Max head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'min_head', 'lyt_epa_data_2', 5, 'string', 'text', 'Min head:', 'Min head', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'max_pressure', 'lyt_epa_data_2', 6, 'string', 'text', 'Max pressure:', 'Max pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'min_pressure', 'lyt_epa_data_2', 7, 'string', 'text', 'Min pressure:', 'Min pressure', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'max_quality', 'lyt_epa_data_2', 8, 'string', 'text', 'Max quality:', 'Max quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'min_quality', 'lyt_epa_data_2', 9, 'string', 'text', 'Min quality:', 'Min quality', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_connec', 'form_feature', 'epa', 'tbl_inp_connec', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_connec');


UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=a.dv_isnullvalue,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_junction' AND a.columnname='pattern_id' AND c.columnname='pattern_id' AND c.formname ILIKE 've_epa_%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=a.dv_isnullvalue,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_junction' AND a.columnname='source_type' AND c.columnname='source_type' AND c.formname ILIKE 've_epa_%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_pipe' AND a.columnname='status' AND c.columnname='status' AND c.formname ILIKE 've_epa_pipe';

UPDATE config_form_fields c SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_reactions''' ,
dv_orderby_id=TRUE, dv_isnullvalue=true FROM config_form_fields a
WHERE  c.columnname='reactionparam' AND c.formname ILIKE 've_epa_%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_junction' AND a.columnname='source_pattern_id' AND c.columnname='source_pattern_id' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_pump' AND a.columnname='curve_id' AND c.columnname='curve_id' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_pump' AND a.columnname='energy_pattern_id' AND c.columnname='energy_pattern_id' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_pump' AND a.columnname='status' AND c.columnname='status' AND c.formname ILIKE 've_epa_pump';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_pump' AND a.columnname='pump_type' AND c.columnname='pump_type' AND c.formname ILIKE 've_epa_pump';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_shortpipe' AND a.columnname='status' AND c.columnname='status' AND c.formname ILIKE 've_epa_shortpipe';

UPDATE config_form_fields c SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_mixing''' ,
dv_orderby_id=TRUE, dv_isnullvalue=true FROM config_form_fields a
WHERE  c.columnname='mixing_model' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_valve' AND a.columnname='status' AND c.columnname='status' AND 
(c.formname ILIKE 've_epa_valve' OR c.formname ILIKE 've_epa_virtualvalve');

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_valve' AND a.columnname='valv_type' AND c.columnname='valv_type' AND 
(c.formname ILIKE 've_epa_valve' OR c.formname ILIKE 've_epa_virtualvalve');

