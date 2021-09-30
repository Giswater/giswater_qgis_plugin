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
VALUES ('inp_options_networkmode', 'hidden', 'Export geometry mode: 1D SWMM , 1D/2D coupled model (SWMM-IBER)', 'role_epa', 'Network geometry generator:',
'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_networkmode''', TRUE, 0, 'ud', FALSE, '1', FALSE, 'text','combo', TRUE, 
'lyt_general_1',TRUE, '{"from":"5.0.022", "to":null,"language":"english"}') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, vdefault, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, epaversion)
VALUES ('inp_options_minlength', 'hidden', 'Value for minimum length on 1D/2D export mode because arc triming with links', 'role_epa', 'Arc minimun length (1D/2D)',
TRUE, 0, 'ud', FALSE, '1', FALSE, 'numeric','text', TRUE, 
'lyt_general_2',TRUE, '{"from":"5.0.022", "to":null,"language":"english"}') 
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

UPDATE config_form_fields SET widgettype='combo',dv_querytext='SELECT id, id as idval FROM cat_connec WHERE active IS TRUE'
WHERE columnname='connec_arccat_id' and formname ilike '%gully%';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT DISTINCT ON (formname) formname, 'form_feature', 'data', 'connec_matcat_id', 'lyt_data_1', 11, 'string', 'combo', 'connec_matcat_id', 
'Material of a conection arc', NULL, FALSE, FALSE, TRUE, FALSE, NULL, 'SELECT id, id AS idval FROM cat_mat_arc WHERE active IS TRUE', TRUE, TRUE, 
NULL, NULL, NULL, NULL, NULL, NULL, FALSE FROM config_form_fields WHERE formname ilike '%ve_gully%' OR formname ilike '%v_edit_gully%'
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
VALUES ('v_edit_inp_gully','form_feature', 'main', 'connec_y1', null, null, 'double', 'text', 'connec_y1', NULL, NULL,  FALSE,
FALSE, FALSE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder,ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_gully','form_feature', 'main', 'connec_y2', null, null, 'double', 'text', 'connec_y2', NULL, NULL,  FALSE,
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

-- 2021/09/18
INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, vdefault, 
isautoupdate, datatype, widgettype, dv_querytext, ismandatory, layoutname, iseditable, epaversion)
VALUES ('inp_options_hydrology_scenario', 'epaoptions', 'Scenario for hydrology', 'role_epa', 'Hydrology Scenario',
TRUE, 1, 'ud', FALSE, '1', FALSE, 'text','combo', 'SELECT hydrology_id as id, name as idval FROM cat_hydrology WHERE active IS TRUE', TRUE, 
'lyt_general_1',TRUE, '{"from":"5.0.022", "to":null,"language":"english"}') 
ON CONFLICT (id) DO NOTHING;

UPDATE sys_param_user SET layoutorder = 2, layoutname = 'lyt_general_2' WHERE id = 'inp_options_dwfscenario';
UPDATE sys_param_user SET layoutorder = 2 WHERE id = 'inp_options_flow_units';
UPDATE sys_param_user SET layoutorder = 4 WHERE id = 'inp_options_flow_routing';
UPDATE sys_param_user SET layoutorder = 6 WHERE id = 'inp_options_link_offsets';


INSERT INTO config_param_system VALUES (
'basic_selector_tab_dscenario','{"table":"cat_dscenario", "selector":"selector_inp_dscenario", "table_id":"dscenario_id",  "selector_id":"dscenario_id",  "label":"dscenario_id, '' - '', name, '' ('', dscenario_type,'')''", "orderBy":"dscenario_id", "manageAll":true, "query_filter":" AND dscenario_id > 0 AND active is true", "typeaheadFilter":" AND lower(concat(dscenario_id, '' - '', name,'' ('',  dscenario_type,'')''))"}',
'Variable to configura all options related to search for the specificic tab','Selector variables','','',TRUE,null,'ws',null,null,'json')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_typevalue VALUES('tabname_typevalue', 'tab_dscenario', 'tab_dscenario');

INSERT INTO config_form_tabs VALUES ('selector_basic','tab_dscenario','Dscenario','Dscenario','role_epa',null,null,4,5)
ON CONFLICT (formname, tabname, device) DO NOTHING;

UPDATE config_form_tabs SET orderby = 6 WHERE formname = 'selector_basic' AND tabname = 'tab_psector';

INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'RAINGAGE', 'RAINGAGE');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'CONDUIT', 'CONDUIT');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'JUNCTION', 'JUNCTION');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'JOINED', 'JOINED');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'OTHER', 'OTHER');

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('cat_dscenario', 'Table to manage scenarios', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('selector_inp_dscenario', 'Table to select scenario for users', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_conduit', 'Table to manage scenario for conduits', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_raingage', 'Table to manage scenario for raingages', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_junction', 'Table to manage scenario for junctions', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_conduit', 'View to manage scenario for conduits', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_raingage', 'View to manage scenario for raingages', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_junction', 'View to manage scenario for junctions', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('rpt_inp_raingage', 'Table to store results for raingages', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (3074, 'gw_fct_pg2epa_dscenario', 'ud', 'function', null, null, 'role_epa')
ON CONFLICT (id) DO NOTHING;


--2021/09/20

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT  formname, formtype, tabname, 'gratecat2_id', layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, FALSE, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE (formname ilike '%ve_gully%' OR formname ilike '%v_edit_gully%') AND columnname='gratecat_id' 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT  formname,'form_feature', 'main','connec_y1', 'lyt_data_1', 21,  'double', 'text', 'connec_y1',NULL, NULL,  FALSE,
FALSE, FALSE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE
FROM config_form_fields WHERE (formname ilike '%ve_gully%' OR formname ilike '%v_edit_gully%') AND columnname='gratecat_id' 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT  formname,'form_feature', 'main','connec_y2', 'lyt_data_1', 22,  'double', 'text', 'connec_y2',NULL, NULL,  FALSE,
FALSE, FALSE, FALSE,FALSE,NULL, NULL, NULL, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE
FROM config_form_fields WHERE (formname ilike '%ve_gully%' OR formname ilike '%v_edit_gully%') AND columnname='gratecat_id' 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


-- 2021/09/21
UPDATE cat_feature_node SET double_geom = value::json FROM config_param_system WHERE parameter ='edit_node_doublegeom' 
AND json_extract_path_text(value::json,'activated')::boolean = true AND type IN ('NETGULLY', 'STORAGE', 'WWTP', 'CHAMBER');

UPDATE cat_feature_gully SET double_geom = concat('{"activated":true,"value":"',value,'"}')::json 
FROM config_param_user WHERE parameter ='edit_gully_doublegeom' AND value IS NOT NULL;

UPDATE cat_feature_gully SET double_geom = '{"activated":false,"value":1}' WHERE double_geom IS NULL;

UPDATE polygon p SET feature_id=node_id FROM man_netgully m WHERE p.pol_id=m._pol_id_ AND sys_type='NETGULLY';
UPDATE polygon p SET feature_id=node_id FROM man_storage m WHERE p.pol_id=m._pol_id_ AND sys_type='STORAGE';
UPDATE polygon p SET feature_id=node_id FROM man_wwtp m WHERE p.pol_id=m._pol_id_ AND sys_type='WWTP';
UPDATE polygon p SET feature_id=node_id FROM man_chamber m WHERE p.pol_id=m._pol_id_ AND sys_type='CHAMBER';
UPDATE polygon p SET feature_id=gully_id FROM gully m WHERE p.pol_id=m.pol_id AND sys_type='GULLY';

UPDATE polygon p SET featurecat_id = node_type FROM node WHERE p.feature_id = node_id;
UPDATE polygon p SET featurecat_id = connec_type FROM connec WHERE p.feature_id = connec_id;
UPDATE polygon p SET featurecat_id = gully_type FROM gully WHERE p.feature_id = gully_id;


UPDATE sys_table SET notify_action='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", 
"trg_fields":"dscenario_id","featureType":["v_edit_inp_dscenario_conduit","v_edit_inp_dscenario_junction","v_edit_inp_dscenario_raingage"]}]'
WHERE id='cat_dscenario';

UPDATE sys_table SET notify_action='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", 
"trg_fields":"rg_id","featureType":["v_edit_inp_subcatchment", "v_edit_inp_dscenario_conduit","v_edit_inp_dscenario_junction",
"v_edit_inp_dscenario_raingage"]}]'
WHERE id='raingage';

--v_edit_inp_dscenario_conduit
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'arc_id', null, null, 'string', 'text', 'arc_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'arccat_id', null, null, 'integer', 'combo', 'arccat_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT id as id, id as idval FROM cat_arc WHERE active IS TRUE', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'matcat_id', null, null, 'integer', 'combo', 'matcat_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT id as id, id as idval FROM cat_mat_arc WHERE active IS TRUE', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'custom_n', null, null, 'double', 'text', 'custom_n', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'barrels', null, null, 'integer', 'text', 'barrels', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'culvert', null, null, 'double', 'text', 'culvert', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'kentry', null, null, 'double', 'text', 'kentry', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'kexit', null, null, 'double', 'text', 'kexit', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'kavg', null, null, 'double', 'text', 'kavg', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'flap', null, null, 'string', 'text', 'flap', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'q0', null, null, 'double', 'text', 'q0', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'qmax', null, null, 'double', 'text', 'qmax', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_conduit','form_feature', 'main', 'seepage', null, null, 'double', 'text', 'seepage', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


--v_edit_inp_dscenario_junction
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_junction','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_junction','form_feature', 'main', 'node_id', null, null, 'string', 'text', 'node_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_junction','form_feature', 'main', 'y0', null, null, 'double', 'text', 'y0', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_junction','form_feature', 'main', 'ysur', null, null, 'double', 'text', 'ysur', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_junction','form_feature', 'main', 'apond', null, null, 'double', 'text', 'apond', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_junction','form_feature', 'main', 'outfallparam', null, null, 'string', 'text', 'outfallparam', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


--v_edit_inp_dscenario_raingage
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'rg_id', null, null, 'integer', 'combo', 'rg_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT rg_id as id, rg_id as idval FROM raingage WHERE rg_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'rg_id', null, null, 'string', 'text', 'rg_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'form_type', null, null, 'integer', 'combo', 'form_type', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_raingage''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'intvl', null, null, 'string', 'text', 'intvl', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'scf', null, null, 'double', 'text', 'scf', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'rgage_type', null, null, 'integer', 'combo', 'rgage_type', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_raingage''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'timser_id', null, null, 'integer', 'combo', 'timser_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT  id, id as idval FROM inp_timeseries WHERE id IS NOT NULL ', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'fname', null, null, 'string', 'text', 'fname', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'sta', null, null, 'string', 'text', 'sta', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_raingage','form_feature', 'main', 'units', null, null, 'string', 'text', 'units', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--2021/09/22
ALTER TABLE sys_foreignkey ENABLE TRIGGER gw_trg_typevalue_config_fk;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('inp_typevalue', 'inp_typevalue_raingage', 'inp_dscenario_raingage', 'rgage_type');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('inp_typevalue', 'inp_typevalue_raingage', 'inp_dscenario_raingage', 'form_type');


UPDATE arc SET inverted_slope = FALSE WHERE inverted_slope IS NULL;

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario', 'form_feature', 'main', 'dscenario_id', null, null, 'string', 'text', 'dscenario_id', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario', 'form_feature', 'main', 'name', null, null, 'string', 'text', 'name', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario', 'form_feature', 'main', 'descript', null, null, 'string', 'text', 'descript', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario', 'form_feature', 'main', 'parent_id', null, null, 'string', 'text', 'parent_id', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario','form_feature', 'main', 'dscenario_type', null, null, 'string', 'combo', 'dscenario_type', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''typevalue_dscenario''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario', 'form_feature', 'main', 'active', null, null, 'boolean', 'check', 'active', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

--2021/09/30
DELETE FROM config_param_system WHERE parameter = 'edit_node_doublegeom';