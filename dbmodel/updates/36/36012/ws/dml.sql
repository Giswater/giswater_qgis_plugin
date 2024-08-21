/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function VALUES (3310, 'gw_fct_setpsectorcostremovedpipes', 'ws', 'function', 'json', 'json',
'Function to set cost for removed material on specific psectors', 'role_master', null, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (523, 'fprocess to set cost for removed material on psectors','ws',null,'core',FALSE, 'Function process')
ON CONFLICT (fid) DO NOTHING;

DELETE from sys_fprocess WHERE fid = 522;

INSERT INTO config_toolbox VALUES (3310, 'Set cost for removed material on psectors', '{"featureType":[]}',
'[
{"widgetname":"expl", "label":"Exploitation:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
{"widgetname":"material", "label":"Material:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, descript as idval FROM cat_mat_node", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":""},
{"widgetname":"price", "label":"Price:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Code of removal material price", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Descriptive text for removal (it apears on psector_x_other observ)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}
]',
null, TRUE, '{4}');


UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_arc' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_arc' AND tabname='tab_relations';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_arc' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_arc' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='v_edit_arc' AND tabname='tab_plan';

UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_connec' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_connec' AND tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_connec' AND tabname='tab_hydrometer_val';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_connec' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='v_edit_connec' AND tabname='tab_documents';

UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_node' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_node' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='v_edit_node' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=7
	WHERE formname='v_edit_node' AND tabname='tab_plan';

UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='ve_node_water_connection' AND tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='ve_node_water_connection' AND tabname='tab_hydrometer_val';


-- 22/07/24
INSERT INTO archived_rpt_inp_arc(
	result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
	diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
	presszone_id, dqa_id, minsector_id, age)
SELECT
	result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
	diameter, roughness, length, status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent, dma_id,
	presszone_id, dqa_id, minsector_id, age
FROM _archived_rpt_arc;


INSERT INTO archived_rpt_arc(
	result_id, arc_id, length, diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, status)
SELECT
	result_id, arc_id, rpt_length, rpt_diameter, flow, vel, headloss, setting, reaction, ffactor, other, time, rpt_status
FROM _archived_rpt_arc;


INSERT INTO archived_rpt_inp_node(
	result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
	demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
	minsector_id, age)
SELECT
	result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation,
	demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition, dma_id, presszone_id, dqa_id,
	minsector_id, age
FROM _archived_rpt_node;


INSERT INTO archived_rpt_node(
	result_id, node_id, elevation, demand, head, press, other, time, quality)
SELECT
	result_id, node_id, rpt_elevation, rpt_demand, head, press, other, time, quality
FROM _archived_rpt_node;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3264, 'There isn''t any node configured on config_graph_mincut for the selected macroexploitation',
'Fill the config_graph_mincut with the inlets before executing the mincut', 2, true, 'utils', 'core') on conflict (id) do nothing;

-- move data from confif_graph_checkvalve to man_valve
UPDATE man_valve v SET to_arc = c.to_arc, active = true FROM config_graph_checkvalve c WHERE c.node_id = v.node_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_shortpipe", "column":"to_arc"}}$$);

-- move to_arc from inp_pump to man_pump
UPDATE man_pump m SET to_arc = i.to_arc FROM inp_pump i WHERE i.node_id = m.node_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_pump", "column":"to_arc"}}$$);

-- move to_arc from inp_valve to man_valve
UPDATE man_valve m SET to_arc = i.to_arc FROM inp_valve i where i.node_id = m.node_id;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_valve", "column":"to_arc"}}$$);

-- move status from inp_valve to man_valve
UPDATE man_valve m SET active = true FROM inp_valve i where i.node_id = m.node_id AND i.status IN ('ACTIVE', 'CLOSED');
UPDATE man_valve m SET active = false FROM inp_valve i where i.node_id = m.node_id AND i.status ='OPEN';
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_valve", "column":"status"}}$$);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('edit_typevalue', 'presszone_type', 'presszone', 'presszone_type', true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('edit_typevalue', 'dma_type', 'dma', 'dma_type', true);

INSERT INTO edit_typevalue VALUES ('dma_type','UNDEFINED', 'UNDEFINED');

ALTER TABLE edit_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE edit_typevalue SET id = upper(id), idval=upper(idval) WHERE typevalue IN ('sector_type');
ALTER TABLE edit_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

-- 17/08/2024
INSERT INTO config_typevalue VALUES ('sys_style_context', 'TEMPLAYER', 'TEMPLAYER', null,'{"orderBy":0}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'BASIC', 'BASIC', null,'{"orderBy":10}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'PRESSZONE', 'PRESSZONE',null,'{"orderBy":20}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'DMA','DMA',null, '{"orderBy":30}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'EPANET','EPANET',null, '{"orderBy":40}');

UPDATE sys_style SET context = 'TEMPLAYER' WHERE idval in ('INP result line', 'INP result point', 'Overlap affected arcs', 'Overlap affected connecs', 'Other mincuts whichs overlaps', 'Temporal-Graphconfig');
UPDATE sys_style SET context = 'EPANET' WHERE idval in ('v_edit_arc EPANET point of view', 'v_edit_connec EPANET point of view', 'v_edit_node EPANET point of view', 'v_edit_link EPANET point of view');
UPDATE sys_style SET context = 'BASIC' WHERE context is null;
UPDATE sys_style SET idval = replace(idval, ' EPANET point of view', '');
DELETE FROM sys_style WHERE id IN (210,211,212,213); -- flow trace & flow exit does not make sense for ws

SELECT setval('SCHEMA_NAME.sys_style_id_seq', 206, true);

INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_node', 'SECTOR', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_arc', 'SECTOR', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_connec', 'SECTOR', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_link', 'SECTOR', 'qml');

INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_node', 'PRESSZONE', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_arc', 'PRESSZONE', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_connec', 'PRESSZONE', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_link', 'PRESSZONE', 'qml');

INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_node', 'DMA', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_arc', 'DMA', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_connec', 'DMA', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_link', 'DMA', 'qml');


INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", style_id, addparam) 
VALUES('selector_muni', 'Selector of municipalities', 'role_basic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL, NULL);


delete from config_form_fields where columnname = 'nodetype_id' and formname ilike 've_%';
delete from config_form_fields where columnname = 'connectype_id' and formname ilike 've_%';
delete from config_form_fields where columnname = 'cat_arctype_id' and formname ilike 've_%';

delete from sys_table where id = 'vi_parent_arc';
delete from sys_table where id = 'vi_parent_connec';
delete from sys_table where id = 'vi_parent_hydrometer';
delete from sys_table where id = 'v_edit_field_valve';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_dma', 'form_feature', 'tab_none', 'dma_type', 'lyt_data_1', 18, 'string', 'combo', 'dma_type', 'dma_type', false, false, true, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dma_type''', false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, widgetcontrols, hidden)
VALUES ('v_edit_dma', 'form_feature', 'tab_none', 'sector_id', 'lyt_data_1', 19, 'string', 'combo', 'sector_id', 'sector_id', false, false, true, false, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}', false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, widgetcontrols, hidden)
VALUES ('v_edit_dqa', 'form_feature', 'tab_none', 'sector_id', 'lyt_data_1', 15, 'string', 'combo', 'sector_id', 'sector_id', false, false, true, false, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}', false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, widgetcontrols, hidden)
VALUES ('v_edit_presszone', 'form_feature', 'tab_none', 'sector_id', 'lyt_data_1', 11, 'string', 'combo', 'sector_id', 'sector_id', false, false, true, false, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}', false);


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_inlet', 'form_feature', 'tab_epa', 'demand', 'lyt_epa_data_1', 17, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, hidden)
VALUES ('ve_epa_inlet', 'form_feature', 'tab_epa', 'demand_pattern_id', 'lyt_epa_data_1', 18, 'string', 'combo', 'Demand pattern:', 'Demand pattern', false, false, true, false, 
'SELECT pattern_id as id, pattern_id as idval FROM inp_pattern', true, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_inlet', 'form_feature', 'tab_epa', 'emitter_coeff', 'lyt_epa_data_1', 19, 'string', 'text', 'Emitter coef:', 'Emitter coef', false, false, true, false, NULL, false);


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_inlet', 'form_feature', 'tab_epa', 'demand', 'lyt_epa_data_1', 14, 'string', 'text', 'Demand:', 'Demand', false, false, true, false, NULL, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_isnullvalue, hidden)
VALUES ('v_edit_inp_inlet', 'form_feature', 'tab_epa', 'demand_pattern_id', 'lyt_epa_data_1', 15, 'string', 'combo', 'Demand pattern:', 'Demand pattern', false, false, true, false, 
'SELECT pattern_id as id, pattern_id as idval FROM inp_pattern', true, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_inlet', 'form_feature', 'tab_epa', 'emitter_coeff', 'lyt_epa_data_1', 16, 'string', 'text', 'Emitter coef:', 'Emitter coef', false, false, true, false, NULL, false);


UPDATE config_form_fields SET iseditable=false, dv_querytext=null, dv_parent_id=null where formname='v_edit_inp_shortpipe' and columnname='to_arc';
UPDATE config_form_fields SET iseditable=false, dv_orderby_id=null, dv_isnullvalue=null where formname='v_edit_inp_shortpipe' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_shortpipe', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_data_1', 15, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_shortpipe', 'form_feature', 'tab_epa', 'custom_dint', 'lyt_data_1', 16, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL, false);


UPDATE config_form_fields SET iseditable=false where formname='ve_epa_shortpipe' and columnname='to_arc';
UPDATE config_form_fields SET dv_orderby_id=null, dv_isnullvalue=null where formname='ve_epa_shortpipe' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_epa_data_1', 7, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'custom_dint', 'lyt_epa_data_1', 8, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL, false);


UPDATE config_form_fields SET iseditable=false where formname='ve_epa_valve' and columnname='to_arc';
UPDATE config_form_fields SET widgettype='text', iseditable=false, dv_querytext=null, dv_orderby_id=null, dv_isnullvalue=null where formname='ve_epa_valve' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('ve_epa_valve', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_epa_data_1', 13, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
UPDATE config_form_fields SET layoutorder=14 where formname='ve_epa_valve' and columnname='custom_dint';


UPDATE config_form_fields SET iseditable=false, dv_querytext=null where formname='v_edit_inp_valve' and columnname='to_arc';
UPDATE config_form_fields SET iseditable=false, dv_querytext=null, dv_orderby_id=null, dv_isnullvalue=null where formname='v_edit_inp_valve' and columnname='status';
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_valve', 'form_feature', 'tab_epa', 'cat_dint', 'lyt_data_1', 20, 'string', 'text', 'Cat dint:', 'Cat dint', false, false, false, false, NULL, false);
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden)
VALUES ('v_edit_inp_valve', 'form_feature', 'tab_epa', 'custom_dint', 'lyt_data_1', 21, 'string', 'text', 'Custom dint:', 'Custom dint', false, false, true, false, NULL, false);

UPDATE config_form_fields SET iseditable=false where columnname='macrominsector_id';
UPDATE config_form_fields SET iseditable=false where columnname='to_arc' and formname like 've_node%';

update config_form_fields SET iseditable=true where formtype = 'form_mincut' and widgettype = 'button';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'cat_dint', 'lyt_data_1', max(layoutorder)+1, 
'string', 'text', 'cat_dint', 'cat_dint',  false, false, false, false, false
FROM cat_feature
join config_form_fields on formname = child_layer
where formtype = 'form_feature' and tabname = 'tab_data' and layoutname = 'lyt_data_1' and layoutorder < 900
group by child_layer, formname, formtype, tabname 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3266, 'Selected epa_type cannot be used in this feature',
'For valve and pump, feature type and epa type must correspond ', 2, true, 'utils', 'core') on conflict (id) do nothing;
