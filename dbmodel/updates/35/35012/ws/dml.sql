/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2021/08/19
INSERT INTO dma VALUES (-1, 'Conflict',0,null,'DMA used on grafanalytics algorithm when two ore more DMA has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (dma_id) DO NOTHING;
INSERT INTO dqa VALUES (-1, 'Conflict',0, null, 'DQA used on grafanalytics algorithm when two ore more DQA has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (dqa_id) DO NOTHING;
INSERT INTO presszone VALUES (-1, 'Conflict', 0, 'PRESSZONE used on grafanalytics algorithm when two ore more PRESSZONE has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (presszone_id) DO NOTHING;
INSERT INTO sector VALUES (-1, 'Conflict', 0, 'SECTOR used on grafanalytics algorithm when two ore more SECTOR has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (sector_id) DO NOTHING;

UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'manageConflict') WHERE parameter = 'utils_grafanalytics_status';

--2021/08/24
INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_pipe', 'Table to manage scenario for pipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_pipe', 'View to manage scenario for pipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_shortpipe', 'Table to manage scenario for shortpipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_shortpipe', 'View to manage scenario for shortpipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_valve', 'Table to manage scenario for valves', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_valve', 'View to manage scenario for valves', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_pump', 'Table to manage scenario for pump', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_pump', 'View to manage scenario for pump', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_tank', 'Table to manage scenario for tank', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_tank', 'View to manage scenario for tank', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_reservoir', 'Table to manage scenario for reservoir', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_reservoir', 'View to manage scenario for reservoir', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

--2021/08/30
DELETE FROM config_param_system WHERE project_type='ud';
DELETE FROM sys_param_user WHERE project_type='ud';


--2021/09/02
UPDATE sys_table SET id = 'selector_inp_dscenario' WHERE id = 'selector_inp_demand';

UPDATE sys_table SET notify_action='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", 
"trg_fields":"dscenario_id","featureType":["v_edit_inp_demand","v_edit_inp_dscenario_pipe","v_edit_inp_dscenario_pump","v_edit_inp_dscenario_reservoir","v_edit_inp_dscenario_shortpipe",
"v_edit_inp_dscenario_tank", "v_edit_inp_dscenario_valve"]}]'
WHERE id='cat_dscenario';

--v_edit_inp_dscenario_pipe
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pipe','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL, TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pipe','form_feature', 'main', 'arc_id', null, null, 'string', 'text', 'arc_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pipe','form_feature', 'main', 'minorloss', null, null, 'double', 'text', 'minorloss', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pipe','form_feature', 'main', 'status', null, null, 'integer', 'combo', 'status', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_status_pipe''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pipe','form_feature', 'main', 'roughness', null, null, 'double', 'text', 'roughness', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pipe','form_feature', 'main', 'dint', null, null, 'double', 'text', 'dint', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--v_edit_inp_dscenario_pump
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump','form_feature', 'main', 'node_id', null, null, 'string', 'text', 'node_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump','form_feature', 'main', 'power', null, null, 'double', 'text', 'power', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump','form_feature', 'main', 'curve_id', null, null, 'string', 'combo', 'curve_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump','form_feature', 'main', 'speed', null, null, 'double', 'text', 'speed', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, FALSE, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump','form_feature', 'main', 'pattern', null, null, 'string', 'combo', 'pattern', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump','form_feature', 'main', 'status', null, null, 'integer', 'combo', 'status', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_status_pump''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--v_edit_inp_dscenario_reservoir
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_reservoir','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_reservoir','form_feature', 'main', 'node_id', null, null, 'string', 'text', 'node_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_reservoir','form_feature', 'main', 'pattern_id', null, null, 'string', 'combo', 'pattern_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_reservoir','form_feature', 'main', 'head', null, null, 'double', 'text', 'head', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, FALSE, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--v_edit_inp_dscenario_shortpipe
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_shortpipe','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_shortpipe','form_feature', 'main', 'node_id', null, null, 'string', 'text', 'node_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_shortpipe','form_feature', 'main', 'minorloss', null, null, 'double', 'text', 'minorloss', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_shortpipe','form_feature', 'main', 'status', null, null, 'integer', 'combo', 'status', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_status_pipe''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--v_edit_inp_dscenario_tank
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'node_id', null, null, 'string', 'text', 'node_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'initlevel', null, null, 'double', 'text', 'initlevel', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'minlevel', null, null, 'double', 'text', 'minlevel', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, FALSE, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'maxlevel', null, null, 'double', 'text', 'maxlevel', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, FALSE, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'diameter', null, null, 'double', 'text', 'diameter', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, FALSE, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'minvol', null, null, 'double', 'text', 'minvol', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, FALSE, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_tank','form_feature', 'main', 'curve_id', null, null, 'string', 'combo', 'curve_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--v_edit_inp_dscenario_valve
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'dscenario_id', null, null, 'integer', 'combo', 'dscenario_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'node_id', null, null, 'string', 'text', 'node_id', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'valv_type', null, null, 'string', 'combo', 'valv_type', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_typevalue_valve''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'pressure', null, null, 'double', 'text', 'pressure', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'flow', null, null, 'double', 'text', 'flow', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'coef_loss', null, null, 'double', 'text', 'coef_loss', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'curve_id', null, null, 'string', 'combo', 'curve_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'minorloss', null, null, 'double', 'text', 'minorloss', NULL, NULL,  TRUE,
FALSE, TRUE, FALSE,FALSE,NULL, NULL, FALSE, FALSE, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve','form_feature', 'main', 'status', null, null, 'integer', 'combo', 'status', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_status_valve''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


-- 2021/09/03
UPDATE cat_dscenario SET active = true;
UPDATE cat_dscenario SET dscenario_type = 'DEMAND';

INSERT INTO config_param_system VALUES (
'basic_selector_tab_dscenario','{"table":"cat_dscenario", "selector":"selector_inp_dscenario", "table_id":"dscenario_id",  "selector_id":"dscenario_id",  "label":"dscenario_id, '' - '', name ''('', dscenario_type,'')''", "orderBy":"dscenario_id", "manageAll":true, "query_filter":" AND dscenario_id > 0 AND active is true", "typeaheadFilter":" AND lower(concat(dscenario_id, '' - '', name,''('',  dscenario_type,'')''))"}',
'Variable to configura all options related to search for the specificic tab','Selector variables','','',TRUE,null,'ws',null,null,'json')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_form_tabs VALUES ('selector_basic','tab_dscenario','Dscenario','Dscenario','role_epa',null,null,4,5)
ON CONFLICT (formname, tabname, device) DO NOTHING;

UPDATE config_form_tabs SET orderby = 6 WHERE formname = 'selector_basic' AND tabname = 'tab_psector';

INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'DEMAND', 'DEMAND');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'VALVE', 'VALVE');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'INLET', 'INLET');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'PUMP', 'PUMP');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'PIPE', 'PIPE');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'JOINED', 'JOINED');
INSERT INTO inp_typevalue VALUES ('typevalue_dscenario', 'OTHER', 'OTHER');

-- 2021/09/05
INSERT INTO audit_check_data (fid, criticity, error_message) 
VALUES (214, 1, '3.5.012 has an important enhancement for ws dscenarios. Due this v_edit_inp_demand view need to be replaced by v_edit_inp_dscenario_* (pipe/pump/valve/demand/reservoir/inlet)');

-- 2021/09/06
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_dscenario','form_feature', 'main', 'dscenario_type', null, null, 'string', 'combo', 'dscenario_type', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''typevalue_dscenario''', TRUE, FALSE, NULL, NULL,NULL,
NULL, NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;