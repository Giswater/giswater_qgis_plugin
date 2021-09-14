/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/19
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '1', '1D SWMM');
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '2', '1D/2D SWMM-IBER');

INSERT INTO sys_param_user(id, formname, descript, sys_role,  label, dv_querytext, isenabled, layoutorder, project_type, isparent, vdefault, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, epaversion)
VALUES ('inp_options_networkmode', 'epaoptions', 'Export geometry mode: 1D SWMM , 1D/2D coupled model (SWMM-IBER)', 'role_epa', 'Network geometry generator:',
'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_networkmode''', TRUE, 0, 'ud', FALSE, '1', FALSE, 'text','combo', TRUE, 
'lyt_general_1',TRUE, '{"from":"5.0.022", "to":null,"language":"english"}') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (3070, 'gw_fct_pg2epa_vnodetrimarcs', 'ud', 'function', 'text', 'json', 'Function to trim arcs using gullies', 'role_epa')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (3072, 'gw_trg_edit_inp_gully', 'ud', 'trigger function', null, null, 'role_epa')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_gully', 'Table to manage gullies on epa', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('temp_gully', 'Table to manage gullies on epa exportaiton process', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_gully', 'Editable view to manage gullies on epa', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('vi_gully', 'View with gully data ready to work with 2D-IBER', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('vi_grate', 'View with grate data ready to work with 2D-IBER', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('vi_link', 'View with connec data ready to work with 2D-IBER', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('vi_lsections', 'View with connec sections data ready to work with 2D-IBER', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_fprocess VALUES (141,'vi_gully', '[GULLY]', NULL, 91)
ON CONFLICT (fid, tablename, target) DO NOTHING;

INSERT INTO config_fprocess VALUES (141,'vi_grate', '[GRATE]', NULL, 92)
ON CONFLICT (fid, tablename, target) DO NOTHING;

INSERT INTO config_fprocess VALUES (141,'vi_link', '[LINK]', NULL, 93)
ON CONFLICT (fid, tablename, target) DO NOTHING;

INSERT INTO config_fprocess VALUES (141,'vi_lxsections', '[LXSECTIONS]', NULL, 94)
ON CONFLICT (fid, tablename, target) DO NOTHING;

UPDATE sys_table SET id = 'inp_demand' WHERE id = 'inp_dscenario_demand';
UPDATE sys_table SET id = 'v_edit_inp_demand' WHERE id = 'v_edit_inp_dscenario_demand';

--2021/08/30
UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"lidco_id","featureType":["v_edit_inp_lid_usage"]}]'
WHERE id='inp_lid_control';

DELETE FROM sys_param_user WHERE project_type='ws';

INSERT INTO inp_gully (gully_id, isepa, efficiency)
SELECT gully_id, true, 1 FROM gully where state > 0;

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, vdefault, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, epaversion)
VALUES ('inp_options_minlength', 'epaoptions', 'Value for minimum length on 1D/2D export mode because arc triming with links', 'role_epa', 'Arc minimun length (1D/2D)',
TRUE, 0, 'ud', FALSE, '1', FALSE, 'numeric','text', TRUE, 
'lyt_general_2',TRUE, '{"from":"5.0.022", "to":null,"language":"english"}') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('vi_gully2pjoint', 'View to manage link of gullies on epa', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

--2021/09/07
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'visit_id', 0, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'code', 1, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'visitcat_name', 2, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'gully_id', 3, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'visit_start', 4, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'visit_end', 5, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'user_name', 6, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'is_done', 7, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'feature_type', 8, true);
INSERT INTO config_form_tableview VALUES ('gully_form', 'utils', 'v_ui_om_visitman_x_gully', 'form_type', 9, true);


--2021/09/14

UPDATE config_form_fields SET columnname='effective_area' WHERE columnname='efective_area' and formname='cat_grate';

UPDATE config_form_fields SET widgettype='typeahead',dv_querytext='SELECT id, id as idval FROM cat_connec WHERE active IS TRUE'
WHERE columnname='connec_arccat_id' and formname ilike '%gully%';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT DISTINCT ON (formname) formname, 'form_feature', 'data', 'connec_matcat_id', 'lyt_data_1', 11, 'string', 'typeahead', 'connec_matcat_id', 
'Material of a conection arc', NULL, FALSE, FALSE, TRUE, FALSE, NULL, 'SELECT id, id AS idval FROM cat_mat_arc WHERE active IS TRUE', TRUE, TRUE, 
NULL, NULL, NULL, NULL, NULL, NULL, TRUE FROM config_form_fields WHERE formname ilike '%ve_gully%' OR formname ilike '%v_edit_gully%'
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

INSERT INTO config_form_fields
SELECT 'v_edit_inp_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname = 've_gully' AND columnname IN ('gully_id', 'code', 'top_elev', 'ymax', 'sandbox', 'connec_matcat_id',  'units', 'groove', 'arc_id', 'sector_id',  'annotation',
'connec_length','connec_arccat_id','pjoint_id','pjoint_type','gratecat_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET widgettype='combo' WHERE formname = 'v_edit_inp_gully' AND columnname IN ('gratecat_id');

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
false, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname = 've_gully' AND columnname in ('expl_id','gully_type')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
false, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname = 've_gully' AND columnname ='state';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname = 've_gully' AND columnname ='state_type';

UPDATE config_form_fields SET isparent=true WHERE formname = 'v_edit_inp_gully' AND columnname in ('state','gully_type');

UPDATE config_form_fields SET iseditable=FALSE
WHERE formname = 'v_edit_inp_gully' AND columnname IN ('gully_id', 'code', 'arc_id','state','sector_id','expl_id', 'connec_length',
'pjoint_id','pjoint_type');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder,ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'efficiency', null, null, 'double', 'text', 'connec_y1', NULL, NULL,  FALSE,
FALSE, FALSE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder,ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'efficiency', null, null, 'double', 'text', 'connec_y2', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'isepa', null, null, 'boolean', 'check', 'isepa', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'custom_length', null, null, 'double', 'text', 'custom_length', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'custom_n', null, null, 'double', 'text', 'custom_n', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'efficiency', null, null, 'double', 'text', 'efficiency', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'y0', null, null, 'double', 'text', 'y0', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'ysur', null, null, 'double', 'text', 'ysur', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'q0', null, null, 'double', 'text', 'q0', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'qmax', null, null, 'double', 'text', 'qmax', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'flap', null, null, 'string', 'text', 'flap', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;