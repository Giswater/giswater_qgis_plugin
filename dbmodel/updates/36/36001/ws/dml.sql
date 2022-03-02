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
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_junction', 'SELECT dscenario_id, demand, pattern_id FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL', 4); -- SELECT dscenario_id, demand, pattern_id, emitter_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_junction WHERE node_id IS NOT NULL

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', NULL, false, '');
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'demand', 'lyt_epa_data_1', 1, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Pattern id:', 'Pattern id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'emitter_coeff', 'lyt_epa_data_1', 3, 'string', 'text', 'Emitter coefficient:', 'Emitter coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'initial_quality', 'lyt_epa_data_1', 4, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 5, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 6, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 7, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'total_head', 'lyt_epa_data_2', 2, 'string', 'text', 'Total head:', 'Total head', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 3, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 4, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'tbl_inp_junction', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_junction');


-- PUMP
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_pump', 'SELECT dscenario_id, power, curve_id, speed, pattern, status, pump_type, energy_price, price_pattern FROM ve_inp_dscenario_pump WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'power', 'lyt_epa_data_1', 1, 'string', 'text', 'Power:', 'Power', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'speed', 'lyt_epa_data_1', 3, 'string', 'text', 'Speed:', 'Speed', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'pattern', 'lyt_epa_data_1', 4, 'string', 'text', 'Pattern:', 'Pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 5, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 6, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'pump_type', 'lyt_epa_data_1', 7, 'string', 'text', 'Pump type:', 'Pump type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'energy_price', 'lyt_epa_data_1', 8, 'string', 'text', 'Energy price:', 'Energy price', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'price_pattern', 'lyt_epa_data_1', 9, 'string', 'text', 'Price pattern:', 'Price pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'headloss', 'lyt_epa_data_2', 3, 'string', 'text', 'Headloss:', 'Headloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 4, 'string', 'text', 'Quality:', 'Quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'status', 'lyt_epa_data_2', 5, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'usage_fact', 'lyt_epa_data_2', 6, 'string', 'text', 'Usage factor:', 'Usage factor', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_effic', 'lyt_epa_data_2', 7, 'string', 'text', 'Average efficiency:', 'Average efficiency', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'kwhr_mgal', 'lyt_epa_data_2', 8, 'string', 'text', 'KWh mgal?:', 'KWh mgal?', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_kw', 'lyt_epa_data_2', 9, 'string', 'text', 'Average KW:', 'Average KW', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'peak_kw', 'lyt_epa_data_2', 10, 'string', 'text', 'Peak KW:', 'Peak KW', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'cost_day', 'lyt_epa_data_2', 11, 'string', 'text', 'Cost day:', 'Cost day', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'tbl_inp_pump', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_pump');


-- PIPE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_pipe', 'SELECT dscenario_id, minorloss, status, buk_coeff, wall_coeff FROM ve_inp_dscenario_pipe WHERE arc_id IS NOT NULL', 4); -- 

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 1, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 2, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'buk_coeff', 'lyt_epa_data_1', 3, 'string', 'text', 'Buk coefficient:', 'Buk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 4, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Flow:', 'Flow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'velocity', 'lyt_epa_data_2', 3, 'string', 'text', 'Velocity:', 'Velocity', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'unit_headloss', 'lyt_epa_data_2', 4, 'string', 'text', 'Unit headloss:', 'Unit headloss', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'friction_factor', 'lyt_epa_data_2', 5, 'string', 'text', 'Friction factor:', 'Friction factor', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'reaction_rate', 'lyt_epa_data_2', 6, 'string', 'text', 'Reaction rate:', 'Reaction rate', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 7, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_2', 8, 'string', 'text', 'Status:', 'Status', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_pipe', 'form_feature', 'epa', 'tbl_inp_pipe', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_pipe');


-- SHORTPIPE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_shortpipe', 'SELECT dscenario_id, minorloss, to_arc, status, buk_coeff, wall_coeff FROM ve_inp_dscenario_shortpipe WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 2, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 3, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 4, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'buk_coeff', 'lyt_epa_data_1', 5, 'string', 'text', 'Buk coefficient:', 'Buk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 6, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Flow:', 'Flow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'velocity', 'lyt_epa_data_2', 3, 'string', 'text', 'Velocity:', 'Velocity', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'unit_headloss', 'lyt_epa_data_2', 4, 'string', 'text', 'Unit headloss:', 'Unit headloss', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'friction_factor', 'lyt_epa_data_2', 5, 'string', 'text', 'Friction factor:', 'Friction factor', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'reaction_rate', 'lyt_epa_data_2', 6, 'string', 'text', 'Reaction rate:', 'Reaction rate', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 7, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'status', 'lyt_epa_data_2', 8, 'string', 'text', 'Status:', 'Status', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_shortpipe', 'form_feature', 'epa', 'tbl_inp_shortpipe', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_shortpipe');


-- TANK
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_tank', 'SELECT dscenario_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, mixing_model, bulk_coeff, wall_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_tank WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'initlevel', 'lyt_epa_data_1', 1, 'string', 'text', 'Init level:', 'Initial level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'minlevel', 'lyt_epa_data_1', 2, 'string', 'text', 'Min level:', 'Minimum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'maxlevel', 'lyt_epa_data_1', 3, 'string', 'text', 'Max level:', 'Maximum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'diameter', 'lyt_epa_data_1', 4, 'string', 'text', 'Diameter:', 'Diameter', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'minvol', 'lyt_epa_data_1', 5, 'string', 'text', 'Min volume:', 'Minimum volume', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'mixing_model', 'lyt_epa_data_1', 7, 'string', 'text', 'Mixing model:', 'Mixing model', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'bulk_coeff', 'lyt_epa_data_1', 8, 'string', 'text', 'Bulk coefficient:', 'Bulk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 9, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 10, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 11, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 13, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_tank', 'form_feature', 'epa', 'tbl_inp_tank', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_tank');


-- RESERVOIR
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_reservoir', 'SELECT dscenario_id, head, pattern, initial_quality, source_type, source_quality_source_pattern FROM ve_inp_dscenario_reservoir WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'head', 'lyt_epa_data_1', 1, 'string', 'text', 'Head:', 'Head', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'pattern', 'lyt_epa_data_1', 2, 'string', 'text', 'Pattern:', 'Pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'initial_quality', 'lyt_epa_data_1', 3, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 4, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 5, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 6, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_reservoir', 'form_feature', 'epa', 'tbl_inp_reservoir', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_reservoir');


-- VALVE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_valve', 'SELECT dscenario_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, to_arc, status, custom_dint, add_settings, quality FROM ve_inp_dscenario_valve WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_1', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'valv_type', 'lyt_epa_data_1', 2, 'string', 'text', 'Valve type:', 'Valve type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_1', 3, 'string', 'text', 'Pressure:', 'Pressure', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'flow', 'lyt_epa_data_1', 4, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'coef_loss', 'lyt_epa_data_1', 5, 'string', 'text', 'Coefficient loss:', 'Coefficient loss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 7, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 8, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 9, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'custom_dint', 'lyt_epa_data_1', 10, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'add_settings', 'lyt_epa_data_1', 11, 'string', 'text', 'Add settings:', 'Add settings', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Quality:', 'Quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_valve', 'form_feature', 'epa', 'tbl_inp_valve', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_valve');


-- VIRTUALVALVE
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_virtualvalve', 'SELECT dscenario_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, to_arc, status, custom_dint, add_settings, quality, status FROM ve_inp_dscenario_virtualvalve WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'valv_type', 'lyt_epa_data_1', 1, 'string', 'text', 'Valve type:', 'Valve type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_1', 2, 'string', 'text', 'Pressure:', 'Pressure', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'flow', 'lyt_epa_data_1', 3, 'string', 'text', 'Flow:', 'Flow', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'coef_loss', 'lyt_epa_data_1', 4, 'string', 'text', 'Coefficient loss:', 'Coefficient loss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 5, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'minorloss', 'lyt_epa_data_1', 6, 'string', 'text', 'Minorloss:', 'Minorloss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'to_arc', 'lyt_epa_data_1', 7, 'string', 'text', 'To arc:', 'To arc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 8, 'string', 'text', 'Status:', 'Status', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'custom_dint', 'lyt_epa_data_1', 9, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'add_settings', 'lyt_epa_data_1', 10, 'string', 'text', 'Add settings:', 'Add settings', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_1', 11, 'string', 'text', 'Quality:', 'Quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'nodarc_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Nodarc id:', 'Nodarc id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 2, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 3, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 4, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 5, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 6, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_virtualvalve', 'form_feature', 'epa', 'tbl_inp_virtualvalve', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_virtualvalve');


-- INLET
INSERT INTO ws_sample35.config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_inlet', 'SELECT dscenario_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, pattern_id, head, mixing_model, bulk_coeff, wall_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_inlet WHERE node_id IS NOT NULL', 4);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'initlevel', 'lyt_epa_data_1', 1, 'string', 'text', 'Init level:', 'Initial level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'minlevel', 'lyt_epa_data_1', 2, 'string', 'text', 'Min level:', 'Minimum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'maxlevel', 'lyt_epa_data_1', 3, 'string', 'text', 'Max level:', 'Maximum level', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'diameter', 'lyt_epa_data_1', 4, 'string', 'text', 'Diameter:', 'Diameter', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'minvol', 'lyt_epa_data_1', 5, 'string', 'text', 'Min volume:', 'Minimum volume', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 6, 'string', 'text', 'Curve id:', 'Curve id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'pattern_id', 'lyt_epa_data_1', 7, 'string', 'text', 'Pattern id:', 'Pattern id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'head', 'lyt_epa_data_1', 8, 'string', 'text', 'Head:', 'Head', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'mixing_model', 'lyt_epa_data_1', 9, 'string', 'text', 'Mixing model:', 'Mixing model', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'bulk_coeff', 'lyt_epa_data_1', 10, 'string', 'text', 'Bulk coefficient:', 'Bulk coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'wall_coeff', 'lyt_epa_data_1', 11, 'string', 'text', 'Wall coefficient:', 'Wall coefficient', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'init_quality', 'lyt_epa_data_1', 12, 'string', 'text', 'Initial quality:', 'Initial quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_type', 'lyt_epa_data_1', 13, 'string', 'text', 'Source type:', 'Source type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_quality', 'lyt_epa_data_1', 14, 'string', 'text', 'Source quality:', 'Source quality', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'source_pattern', 'lyt_epa_data_1', 15, 'string', 'text', 'Source pattern:', 'Source pattern', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'result_id', 'lyt_epa_data_2', 1, 'string', 'text', 'Result id:', 'Result id', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'net_inflow', 'lyt_epa_data_2', 2, 'string', 'text', 'Net inflow:', 'Net inflow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'elevation', 'lyt_epa_data_2', 3, 'string', 'text', 'Elevation:', 'Elevation', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'pressure', 'lyt_epa_data_2', 4, 'string', 'text', 'Pressure:', 'Pressure', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'quality', 'lyt_epa_data_2', 5, 'string', 'text', 'Quality:', 'Quality', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO ws_sample35.config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_inlet', 'form_feature', 'epa', 'tbl_inp_tank', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_inlet');


-- TAB HYDROMETER
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_1', 'lyt_hydrometer_1','lytHydrometer1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_2', 'lyt_hydrometer_2','lytHydrometer2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydrometer_3', 'lyt_hydrometer_3','lytHydrometer3');

INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_hydrometer', 'SELECT * FROM v_ui_hydrometer WHERE hydrometer_id IS NOT NULL', 4);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('connec', 'form_feature', 'hydrometer', 'hydrometer_id', 'lyt_hydrometer_1', 1, 'string', 'text', '', 'Hydrometer id', false, false, true, false, '','{"saveValue": false, "filterSign":"ILIKE"}', '{"functionName": "filter_table", "parameters": {"columnfind": "hydrometer_customer_code"}}', true, 'v_ui_hydrometer');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('connec', 'form_feature', 'hydrometer', 'hspacer_lyt_hydrometer_1', 'lyt_hydrometer_1', 10, 'hspacer', false, false, true, false);
INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('connec', 'form_feature', 'hydrometer', 'btn_link', 'lyt_hydrometer_1', 11, 'button', 'Open link', false, false, true, false,  '{"icon":"70", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', '{"functionName": "open_selected_path", "parameters":{"targetwidget":"hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}', false, 'v_ui_hydrometer');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydrometer', 'tbl_hydrometer', 'lyt_hydrometer_3', 1, 'tableview', false, false, false, false, false, '{"saveValue": false}', '{"functionName": "open_selected_hydro", "module": "info", "parameters":{}}', 'v_ui_hydrometer');


-- TAB HYDROMETER VALUES
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_1', 'lyt_hydro_val_1','lytHydroVal1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_2', 'lyt_hydro_val_2','lytHydroVal2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_hydro_val_3', 'lyt_hydro_val_3','lytHydroVal3');

INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_hydrometer_value', 'SELECT * FROM v_ui_hydroval_x_connec WHERE hydrometer_id IS NOT NULL', 4);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydro_val', 'cat_period_id_filter', 'lyt_hydro_val_1', 0, 'string', 'combo', 'Cat period filter:', false, false, true, false, true, 'SELECT DISTINCT(t1.code) as id, t2.cat_period_id as idval FROM ext_cat_period AS t1 JOIN (SELECT * FROM v_ui_hydroval_x_connec) AS t2 on t1.id = t2.cat_period_id ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_hydrometer_value');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_isnullvalue, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydro_val', 'hyd_customer_code', 'lyt_hydro_val_1', 2, 'string', 'combo', 'Customer code:', false, false, true, false, true, 'SELECT hydrometer_id as id, hydrometer_customer_code as idval FROM v_rtc_hydrometer ', True, '{"functionName": "filter_table", "parameters":{}}', 'tbl_hydrometer_value');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('connec', 'form_feature', 'hydro_val', 'hspacer_lyt_hydro_val_1', 'lyt_hydro_val_1', 10, 'hspacer', false, false, true, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('connec', 'form_feature', 'hydro_val', 'tbl_hydrometer_value', 'lyt_hydro_val_3', 1, 'tableview', false, false, true, false, false, '{"saveValue": false}', NULL, 'tbl_hydrometer_value');

