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
'linetext', FALSE, NULL, NULL, 'lyt_reactions_1', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_wall_order', 'epaoptions', 'Power to which concentration is raised when computing a bulk flow reaction rate','role_epa',
'ORDER WALL', 'Wall Reaction Order', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'integer',
'linetext', FALSE, NULL, NULL, 'lyt_reactions_1', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_global_bulk', 'epaoptions', 'Default bulk reaction rate coefficient (Kb) assigned to all pipes.','role_epa',
'GLOBAL BULK', 'Global Bulk Coefficient', null, null, true, 3, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', FALSE, NULL, NULL, 'lyt_reactions_1', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_global_wall', 'epaoptions', 'Wall reaction rate coefficient (Kw) assigned to all pipes.','role_epa',
'GLOBAL WALL', 'Global Wall Coefficient', null, null, true, 1, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', FALSE, NULL, NULL, 'lyt_reactions_2', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_limit_concentration', 'epaoptions', 'Maximum concentration that a substance can grow to or minimum value it can decay to.','role_epa',
'LIMITING POTENTIAL', 'Limiting Concentration', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', FALSE, NULL, NULL, 'lyt_reactions_2', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_reactions_wall_coeff_correlation', 'epaoptions', 'Factor correlating wall reaction coefficient to pipe roughness.','role_epa',
'ROUGHNESS CORRELATION', 'Wall Coefficient Correlation', null, null, true, 3, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'double',
'spinbox', FALSE, NULL, NULL, 'lyt_reactions_2', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

--energy

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_pump_effic', 'epaoptions', 'Default pump efficiency','role_epa',
'GLOBAL EFFIC', 'Pump Efficiency', 'SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', null, true, 1, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'string',
'combo', FALSE, NULL, NULL, 'lyt_energy_1', TRUE, NULL,TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_price', 'epaoptions', 'Price of energy per kilowatt-hour','role_epa',
'GLOBAL PRICE', 'Energy Price per Kwh', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'text',
'linetext', FALSE, NULL, NULL, 'lyt_energy_1', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_price_pattern', 'epaoptions', 'ID label of a time pattern used to represent variations in energy price with time.','role_epa',
'GLOBAL PATTERN', 'Price Pattern', 'SELECT pattern_id AS id, pattern_id AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', null, true, 1, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'string',
'combo', FALSE, NULL, NULL, 'lyt_energy_2', TRUE, NULL,TRUE, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, 
idval, label, dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, 
dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, 
widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, source)
VALUES ('inp_energy_demand_charge', 'epaoptions', 'Additional energy charge per maximum kilowatt usage.','role_epa',
'DEMAND CHARGE', 'Demand Charge', null, null, true, 2, 'ws',FALSE,
FALSE,FALSE,FALSE,FALSE,'text',
'linetext', FALSE, NULL, NULL, 'lyt_energy_2', TRUE, NULL,NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;
