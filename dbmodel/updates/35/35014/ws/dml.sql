/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/03
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode','4','PJOINT & CONNEC (ALL NODARCS)') ON CONFLICT (typevalue, id) DO NOTHING;
UPDATE connec SET epa_type = 'JUNCTION';

INSERT INTO sys_fprocess VALUES (400, 'Null values on dint for registres on cat_connec)', 'ws')
ON CONFLICT (fid) DO NOTHING;

-- 2021/10/06

INSERT INTO sys_feature_epa_type(id, feature_type, epa_table, descript, active)
VALUES ('UNDEFINED', 'CONNEC', NULL	, NULL, TRUE) ON CONFLICT (id, feature_type) DO NOTHING;

INSERT INTO sys_feature_epa_type(id, feature_type, epa_table, descript, active)
VALUES ('JUNCTION', 'CONNEC', 'inp_connec', NULL, TRUE) ON CONFLICT (id, feature_type) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_connec','form_feature', 'main', 'custom_roughness', null, null, 'double', 'text', 'custom_roughness', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_connec','form_feature', 'main', 'custom_length', null, null, 'double', 'text', 'custom_length', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_connec','form_feature', 'main', 'custom_dint', null, null, 'double', 'text', 'custom_dint', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_connec','form_feature', 'main', 'epa_type', null, null, 'string', 'combo', 'epa_type', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active IS TRUE AND feature_type = ''CONNEC''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('ve_connec','form_feature', 'data', 'epa_type', 'lyt_top_1', 11, 'string', 'combo', 'epa_type', null, null, TRUE,
FALSE, TRUE, FALSE,null,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active IS TRUE AND feature_type = ''CONNEC''', TRUE, FALSE, NULL, NULL,NULL,
NULL, '{"setMultiline":false}', NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT child_layer,'form_feature', 'data', 'epa_type', 'lyt_top_1', 11, 'string', 'combo', 'epa_type', null, null, TRUE,
FALSE, TRUE, FALSE,null,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active IS TRUE AND feature_type = ''CONNEC''', TRUE, FALSE, NULL, NULL,NULL,
NULL, '{"setMultiline":false}', NULL, FALSE FROM cat_feature WHERE feature_type='CONNEC' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_param_system SET value =
'{"status":false, "values":[
{"sourceTable":"ve_node_deposito", "query":"UPDATE inp_tank t SET minlevel = h_min, maxlevel = h_max, diameter  = diametro FROM ve_node_deposito s "},
{"sourceTable":"ve_node_valvula_reductora_pres", "query":"UPDATE inp_valve t SET pressure = pression_exit FROM ve_node_valvula_reductora_pres s "}]}',
project_type = 'utils',
descript = 'Before insert - update of any feature, automatic update of columns on inp tables from columns on man table'
WHERE parameter = 'epa_automatic_man2inp_values';


UPDATE config_param_system SET value =
'{"forcePatternOnNewDma":{"status":false, "value":"dma_id"}}'
WHERE parameter = 'epa_patterns';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'cat_feature_connec', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter,'SELECT id as id, id as idval FROM sys_feature_epa_type WHERE feature_type =''CONNEC''', dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname='cat_feature_node' AND columnname = 'epa_default' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
