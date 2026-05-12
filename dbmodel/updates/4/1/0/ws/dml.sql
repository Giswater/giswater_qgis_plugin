/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_feature_class SET man_table = 'man_pipelink' WHERE id = 'LINK';
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EPUMP', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_epump', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EVALVE', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_evalve', true) ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer)
SELECT concat('E', upper(REPLACE(id, ' ', '_'))), 'GENELEM', 'ELEMENT', 've_genelem', concat('ve_genelem_', concat('e', lower(REPLACE(id, ' ', '_')))) FROM _element_type
ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
VALUES('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 've_link_link', 'Link', NULL, true, true, NULL);

INSERT INTO cat_feature_link (id) VALUES ('LINK') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",dv_querytext,isenabled,layoutorder,project_type,isparent,feature_field_id,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable)
VALUES ('edit_linkcat_vdefault','config','Value default catalog for link','role_edit','Default catalog for linkcat','SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_feature.feature_class = ''LINK''',true,16,'utils',false,'linkcat_id',false,'text','combo',true,'PVC25-PN16-DOM','lyt_connec',true);

INSERT INTO cat_link (id, link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label)
SELECT id, 'LINK' AS link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label
FROM cat_connec ON CONFLICT DO NOTHING;

INSERT INTO cat_link (id, link_type) VALUES ('UPDATE_LINK_40','LINK');

INSERT INTO link (link_id, code, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, state_type, expl_id, the_geom, created_at, sector_id,
dma_id, fluid_type, presszone_id, dqa_id, minsector_id, expl_visibility, epa_type, is_operative, created_by, updated_at, updated_by, staticpressure, linkcat_id,
workcat_id, workcat_id_end, builtdate, enddate, uncertain, muni_id, verified, supplyzone_id, top_elev1, depth1, top_elev2, depth2)
SELECT nextval('SCHEMA_NAME.urn_id_seq'::regclass), link_id::text, feature_id::int4, feature_type, exit_id::int4, exit_type, userdefined_geom, state, 2, expl_id, the_geom, tstamp, sector_id,
dma_id, fluid_type, presszone_id, dqa_id, minsector_id, ARRAY[expl_id2], epa_type, is_operative, insert_user, lastupdate, lastupdate_user, staticpressure,
CASE
  WHEN conneccat_id IS NULL THEN
    CASE
      WHEN feature_type = 'CONNEC' THEN
        (SELECT conneccat_id FROM connec WHERE connec_id = feature_id::int4 LIMIT 1)
      ELSE
        'UPDATE_LINK_40'
    END
  ELSE conneccat_id
END	AS conneccat_id, workcat_id, workcat_id_end, builtdate, enddate, uncertain, muni_id, verified, supplyzone_id,
(SELECT c.top_elev FROM connec c WHERE c.connec_id=feature_id::int4 LIMIT 1) AS top_elev1,
(SELECT c.depth FROM connec c WHERE c.connec_id = feature_id::int4 LIMIT 1) AS depth1,
exit_topelev,
CASE
  WHEN exit_topelev IS NOT NULL AND exit_elev IS NOT NULL THEN
    exit_topelev - exit_elev
  ELSE NULL
END AS depth2
FROM _link;

UPDATE link l
SET state_type = c.state_type
FROM connec c
WHERE l.feature_id = c.connec_id AND l.feature_type = 'CONNEC' AND l.state = 1;

UPDATE link SET state_type = (
  SELECT (value::json->>'plan_statetype_planned')::int2 FROM config_param_system WHERE parameter = 'plan_statetype_vdefault'
)
WHERE state = 2;

DO $func$
DECLARE
  connecr record;
BEGIN
  FOR connecr IN (SELECT c.connec_id, c.conneccat_id FROM connec c LEFT JOIN link l ON l.feature_id = c.connec_id WHERE l.feature_id IS NULL)
  LOOP
    EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
    "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
    UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
  END LOOP;
END $func$;

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRVALVE', 'ELEMENT', 'inp_frvalve', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('UNDEFINED', 'ELEMENT', NULL, NULL, true);


-- 15/04/2025
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'depth1', 'lyt_data_1', 37, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'depth2', 'lyt_data_1', 40, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 9, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 19, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 23, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'depth1', 'lyt_data_1', 37, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'depth2', 'lyt_data_1', 40, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 9, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 19, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 23, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO man_pipelink (link_id)
SELECT link_id
FROM link;

-- 22/04/2025
UPDATE config_param_system
SET value='{"catfeatureId":["PR_REDUC_VALVE"], "vdefault":{"valve_type":"PRV", "minorloss":0.001, "status":"ACTIVE"}}'
WHERE "parameter"='epa_valve_vdefault_prv';
UPDATE config_param_system
SET value='{"catfeatureId":["SHUTOFF_VALVE", "FL_CONTR_VALVE"], "vdefault":{"valve_type":"TCV", "coef_loss":0.001, "minorloss":0.001, "status":"OPEN"}}'
WHERE "parameter"='epa_valve_vdefault_tcv';

-- Auto-generated SQL script #202504221023
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_valve' AND target_field='valv_type';
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_dscenario_valve' AND target_field='valv_type';
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_virtualvalve' AND target_field='valv_type';
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_dscenario_virtualvalve' AND target_field='valv_type';


UPDATE sys_fprocess
SET fprocess_name='Null values on valve_type table'
WHERE fid=273;

UPDATE config_form_list
SET query_text='SELECT dscenario_id, valve_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status, init_quality FROM v_edit_inp_dscenario_virtualvalve WHERE arc_id IS NOT NULL'
WHERE listname='tbl_inp_dscenario_virtualvalve' AND device=4;
UPDATE config_form_list
SET query_text='SELECT dscenario_id, node_id, nodarc_id, valve_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM v_edit_inp_dscenario_valve WHERE node_id IS NOT NULL'
WHERE listname='tbl_inp_dscenario_valve' AND device=4;
UPDATE config_form_list
SET query_text='SELECT dscenario_id AS id, arc_id, valve_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status FROM inp_dscenario_virtualvalve where dscenario_id is not null'
WHERE listname='dscenario_virtualvalve' AND device=5;
UPDATE config_form_list
SET query_text='SELECT dscenario_id AS id, node_id, valve_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM inp_dscenario_valve where dscenario_id is not null'
WHERE listname='dscenario_valve' AND device=5;


UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE valve_type IS NULL',info_msg='Valve valve_type checked. No mandatory values missed.',except_msg='valves with null values on valve_type column.'
WHERE fid=273;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))'
WHERE fid=275;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))'
WHERE fid=276;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE valve_type=''TCV'' AND setting IS NULL'
WHERE fid=277;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE ((valve_type=''FCV'') AND (setting IS NULL))'
WHERE fid=278;
UPDATE sys_fprocess
SET info_msg='Virtualvalve valve_type checked. No mandatory values missed.',except_msg='virtualvalves with null values on valve_type column.'
WHERE fid=594;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))'
WHERE fid=596;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))'
WHERE fid=597;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE valve_type=''TCV'' AND setting IS NULL'
WHERE fid=598;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE ((valve_type=''FCV'') AND (setting IS NULL))'
WHERE fid=599;

UPDATE config_form_fields
SET columnname='valve_type'
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='valv_type' AND tabname='tab_epa';
UPDATE config_form_fields
SET columnname='valve_type'
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='valv_type' AND tabname='tab_epa';


-- 23/04/2025

-- node
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_node' AND columnname='sys_id';
DELETE FROM config_form_tableview	WHERE objectname='tbl_element_x_node' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_node' AND columnname='node_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_node' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_node' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_node' AND columnname='num_elements';


-- arc
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_arc' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_arc' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_arc' AND columnname='arc_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_arc' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_arc' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_arc' AND columnname='num_elements';


-- connec
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_connec' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_connec' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_connec' AND columnname='connec_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_connec' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_connec' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_connec' AND columnname='num_elements';

UPDATE config_toolbox SET inputparams='
[
{"widgetname": "name","label": "Scenario name:","widgettype": "text","datatype": "text","layoutname": "grl_option_parameters", "layoutorder": 1, "value": ""},
{"widgetname": "descript","label": "Scenario descript:","widgettype": "text","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 2,"value": ""},
{"widgetname": "exploitation","label": "Exploitation:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 4,"dvQueryText":"SELECT expl_id as id, name as idval FROM exploitation where expl_id>0 UNION select 99999 as id, ''ALL'' as idval order by id desc", "selectedId":"0"}, 
{"widgetname": "patternOrDate","label": "Choose time method:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","comboIds": [1,2],"comboNames": ["PERIOD ID","DATE INTERVAL"],"layoutorder": 5,"isMandatory":true},
{"widgetname": "period", "label": "if PERIOD_ID - Period:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 6,"dvQueryText":"SELECT id, code as idval FROM ext_cat_period", "selectedId":"1"},
{"widgetname": "initDate","label": "[if DATE INTERVAL] Source CRM init date:","widgettype": "datetime","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 7,"value": null},
{"widgetname": "endDate","label": "[if DATE INTERVAL] Source CRM end date:","widgettype": "datetime","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 8,"value":"2015-07-30 00:00:00"},
{"widgetname": "onlyIsWaterBal","label": "Only hydrometers with waterbal true:","widgettype": "check","datatype": "boolean","layoutname": "grl_option_parameters","layoutorder": 9,"value": null},
{"widgetname": "pattern","label": "Feature pattern:","widgettype": "combo","tooltip": "This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 10,"comboIds": [1,2,3,4,5,6,7],"comboNames": ["NONE","SECTOR-DEFAULT","DMA-DEFAULT","DMA-PERIOD","HYDROMETER-PERIOD","HYDROMETER-CATEGORY","FEATURE-PATTERN"],"selectedId": ""},
{"widgetname": "demandUnits","label": "Demand units:","tooltip": "Choose units to insert volume data on demand column. This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 11,"comboIds": ["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"],"comboNames": ["LPS","LPM", "MLD","CMH","CMD","CFS","GPM","MGD","AFD"],"selectedId": ""}
]'::json WHERE id=3110;

UPDATE config_toolbox SET inputparams =
'[
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"WITH aux AS (SELECT ''-9'' as id, ''ALL'' as idval, 0 AS rowid UNION SELECT expl_id::text as id, name as idval, row_number() over()+1 AS  rowid FROM exploitation where expl_id>0) SELECT id, idval FROM aux ORDER BY rowid ASC", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"method", "label":"Method:","widgettype":"combo","datatype":"text","isMandatory":true,"tooltip":"Water balance method", "dvQueryText":"SELECT id, idval FROM om_typevalue WHERE typevalue = ''waterbalance_method''", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"period","label": "    [if PERIOD_ID] Period:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 4,"dvQueryText":"SELECT id, code as idval FROM ext_cat_period ORDER BY id desc","selectedId": ""},
{"widgetname":"initDate", "label":"    [if DATE INTERVAL] Period (init date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"Start date", "layoutname":"grl_option_parameters","layoutorder":5, "value":null},
{"widgetname":"endDate", "label":"    [if DATE INTERVAL] Period (end date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"End date", "layoutname":"grl_option_parameters","layoutorder":6, "value":"9999-12-12"},
{"widgetname":"executeGraphDma", "label":"Execute DMA:","widgettype":"check","datatype":"boolean","isMandatory":true,"tooltip":"Execute DMA","layoutname":"grl_option_parameters","layoutorder":7, "value":""}
]'
WHERE id = 3142;

UPDATE om_typevalue set typevalue = 'waterbalance_method_' WHERE typevalue = 'waterbalance_method' AND id = 'DCW';

-- 30/04/2025
UPDATE config_form_fields SET columnname='streetaxis_id' WHERE formname IN ('v_edit_node', 'v_edit_arc', 'v_edit_connec') AND formtype='form_feature' AND columnname='streetname' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='streetaxis2_id' WHERE formname IN ('v_edit_node', 'v_edit_arc', 'v_edit_connec') AND formtype='form_feature' AND columnname='streetname2' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='streetaxis_id' WHERE formname ILIKE 've_%' AND formtype='form_feature' AND columnname='streetname' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='streetaxis2_id' WHERE formname ILIKE 've_%' AND formtype='form_feature' AND columnname='streetname2' AND tabname='tab_data';

-- 06/05/2025
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_id', 'lyt_data_1', 1, 'integer', 'text', 'omzone_id', 'omzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_type', 'lyt_data_1', 4, 'string', 'combo', 'omzone_type', 'omzone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'macroomzone', 'lyt_data_1', 5, 'string', 'combo', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, 'SELECT name as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'avg_press', 'lyt_data_1', 6, 'numeric', 'text', 'average pressure', 'avg_press', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'muni_id', 'lyt_data_1', 7, 'text', 'text', 'muni_id', 'muni_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_2', 8, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'link', 'lyt_data_3', 9, 'text', 'text', 'link', 'link', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'undelete', 'lyt_data_1', 10, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 11, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'macroomzone_id', 'lyt_data_1', 1, 'integer', 'text', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"nullValue":true, "layer": "v_edit_macroomzone", "activated": true, "keyColumn": "macroomzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'code', 'lyt_data_1', 2, 'string', 'text', 'code', 'code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 3, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 5, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


--06/05/2025
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='v_edit_connec' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_wjoin' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_vconnec' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_fountain' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_tap' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_greentap' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';

UPDATE sys_function SET descript='Function to analyze network as a graph. Multiple analysis is avaliable (SECTOR, DQA, PRESSZONE & DMA). Before start you need to configurate:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [dma, sector, cat_presszone and dqa] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.' WHERE id=2768;

-- 09/05/2025
UPDATE config_form_fields SET dv_querytext =  'SELECT id, matcat_id as idval FROM cat_mat_roughness'
WHERE formname='generic' AND formtype='nvo_roughness' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE sys_fprocess SET query_text='SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM man_valve JOIN t_node n USING (node_id) JOIN t_arc v ON v.arc_id = to_arc WHERE node_id NOT IN (node_1, node_2)' WHERE fid=170;
UPDATE sys_fprocess SET query_text='SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM man_pump JOIN t_node n USING (node_id) JOIN t_arc v ON v.arc_id = to_arc WHERE node_id NOT IN (node_1, node_2)' WHERE fid=171;

UPDATE inp_typevalue SET idval='HEADPUMP',id='HEADPUMP' WHERE typevalue='inp_typevalue_pumptype' AND id='PRESSPUMP';
UPDATE inp_typevalue SET idval='POWERPUMP',id='POWERPUMP' WHERE typevalue='inp_typevalue_pumptype' AND id='FLOWPUMP';

--15/05/2025
INSERT INTO connec_add (connec_id) SELECT connec_id FROM connec ON CONFLICT (connec_id) DO NOTHING;

-- 19/05/2025
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_edit_supplyzone', 'Shows editable information about supplyzone.', 'role_basic', '{"template": [1]}', '{"level_1":"INVENTORY","level_2":"MAP ZONES"}', 6, 'Supplyzone', NULL, NULL, NULL, 'core', NULL);

UPDATE sys_table SET project_template = '{"template": [1]}'
WHERE id IN (
	'v_edit_macrodma',
	'v_edit_dma',
	'v_edit_dqa',
	'v_edit_presszone'
);

-- 21/05/2025
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_arc_traceability', 'archived_psector_arc_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_connec_traceability', 'archived_psector_connec_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_link_traceability', 'archived_psector_link_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_node_traceability', 'archived_psector_node_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_arc_stats', 'archived_rpt_arc_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_arc', 'archived_rpt_inp_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_node', 'archived_rpt_inp_node', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_node_stats', 'archived_rpt_node_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_element', 'cat_feature_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_link', 'cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_link', 'cat_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('config_form_help', 'config_form_help', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_element', 'doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_link', 'doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('element_x_link', 'element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ext_region_x_province', 'ext_region_x_province', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frpump', 'inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frvalve', 'inp_dscenario_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frpump', 'inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frvalve', 'inp_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('macroomzone', 'macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_frelem', 'man_frelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_genelem', 'man_genelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_pipelink', 'man_pipelink', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('minsector_mincut', 'minsector_mincut', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('om_visit_x_link', 'om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('omzone', 'omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('supplyzone', 'supplyzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('sys_feature_class', 'sys_feature_class', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_cat_feature_link', 'v_edit_cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frpump', 'v_edit_inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frvalve', 'v_edit_inp_dscenario_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frpump', 'v_edit_inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frvalve', 'v_edit_inp_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_macroexploitation', 'v_edit_macroexploitation', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_macroomzone', 'v_edit_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_omzone', 'v_edit_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_arc_stats', 'v_rpt_arc_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_node_stats', 'v_rpt_node_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_element', 'v_ui_doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_link', 'v_ui_doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_element_x_link', 'v_ui_element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_event_x_link', 'v_ui_event_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrodma', 'v_ui_macrodma', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrodqa', 'v_ui_macrodqa', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macroomzone', 'v_ui_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrosector', 'v_ui_macrosector', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_om_visit_x_link', 'v_ui_om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_om_visitman_x_link', 'v_ui_om_visitman_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_omzone', 'v_ui_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_supplyzone', 'v_ui_supplyzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_sys_style', 'v_ui_sys_style', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frpump', 've_epa_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frvalve', 've_epa_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_genelem', 've_genelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_arc', 'vu_element_x_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_connec', 'vu_element_x_connec', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_link', 'vu_element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_node', 'vu_element_x_node', 'role_edit');

DELETE FROM sys_table WHERE id = 'audit_psector_arc_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_connec_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_node_traceability';
DELETE FROM sys_table WHERE id = 'doc_type';
DELETE FROM sys_table WHERE id = 'inp_backdrop';
DELETE FROM sys_table WHERE id = 'macrominsector';
DELETE FROM sys_table WHERE id = 'selector_netscenario';
DELETE FROM sys_table WHERE id = 'sys_feature_cat';
DELETE FROM sys_table WHERE id = 'v_arc';
DELETE FROM sys_table WHERE id = 'v_connec';
DELETE FROM sys_table WHERE id = 'v_edit_element';
DELETE FROM sys_table WHERE id = 'v_link';
DELETE FROM sys_table WHERE id = 'v_link_connec';
DELETE FROM sys_table WHERE id = 'v_node';
DELETE FROM sys_table WHERE id = 'v_om_mincut_current_initpoint';
DELETE FROM sys_table WHERE id = 'v_om_visit';
DELETE FROM sys_table WHERE id = 'v_plan_psector_budget_node';
DELETE FROM sys_table WHERE id = 'v_rpt_arc_all';
DELETE FROM sys_table WHERE id = 'v_rpt_compare_arc';
DELETE FROM sys_table WHERE id = 'v_rpt_node_all';
DELETE FROM sys_table WHERE id = 'v_state_link_connec';
DELETE FROM sys_table WHERE id = 've_arc';
DELETE FROM sys_table WHERE id = 've_connec';
DELETE FROM sys_table WHERE id = 've_node';
DELETE FROM sys_table WHERE id = 'vi_backdrop';
DELETE FROM sys_table WHERE id = 'vi_controls';
DELETE FROM sys_table WHERE id = 'vi_coordinates';
DELETE FROM sys_table WHERE id = 'vi_curves';
DELETE FROM sys_table WHERE id = 'vi_demands';
DELETE FROM sys_table WHERE id = 'vi_emitters';
DELETE FROM sys_table WHERE id = 'vi_energy';
DELETE FROM sys_table WHERE id = 'vi_junctions';
DELETE FROM sys_table WHERE id = 'vi_labels';
DELETE FROM sys_table WHERE id = 'vi_mixing';
DELETE FROM sys_table WHERE id = 'vi_options';
DELETE FROM sys_table WHERE id = 'vi_parent_dma';
DELETE FROM sys_table WHERE id = 'vi_patterns';
DELETE FROM sys_table WHERE id = 'vi_pipes';
DELETE FROM sys_table WHERE id = 'vi_pjointpattern';
DELETE FROM sys_table WHERE id = 'vi_pumps';
DELETE FROM sys_table WHERE id = 'vi_quality';
DELETE FROM sys_table WHERE id = 'vi_reactions';
DELETE FROM sys_table WHERE id = 'vi_report';
DELETE FROM sys_table WHERE id = 'vi_reservoirs';
DELETE FROM sys_table WHERE id = 'vi_rules';
DELETE FROM sys_table WHERE id = 'vi_sources';
DELETE FROM sys_table WHERE id = 'vi_status';
DELETE FROM sys_table WHERE id = 'vi_tags';
DELETE FROM sys_table WHERE id = 'vi_tanks';
DELETE FROM sys_table WHERE id = 'vi_times';
DELETE FROM sys_table WHERE id = 'vi_title';
DELETE FROM sys_table WHERE id = 'vi_valves';
DELETE FROM sys_table WHERE id = 'vi_vertices';
DELETE FROM sys_table WHERE id = 'vu_arc';
DELETE FROM sys_table WHERE id = 'vu_connec';
DELETE FROM sys_table WHERE id = 'vu_exploitation';
DELETE FROM sys_table WHERE id = 'vu_ext_municipality';
DELETE FROM sys_table WHERE id = 'vu_link';
DELETE FROM sys_table WHERE id = 'vu_macroexploitation';
DELETE FROM sys_table WHERE id = 'vu_macrosector';
DELETE FROM sys_table WHERE id = 'vu_node';
DELETE FROM sys_table WHERE id = 'vu_om_mincut';

--28/05/2025

UPDATE sys_function SET function_alias = 'CALCULATE THE REACH OF HYDRANTS' WHERE function_name = 'gw_fct_graphanalytics_hydrant';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3514, 'Process executed for hydrant: %rec_hydrant%.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'DATA QUALITY ANALYSIS ACORDING graph ANALYTICS RULES' WHERE function_name = 'gw_fct_graphanalytics_check_data';



UPDATE sys_function SET function_alias = 'CHECK USER DATA' WHERE function_name = 'gw_fct_user_check_data';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES
(3390, 'gw_fct_admin_forms_renum_layoutorder', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3392, 'gw_fct_audit_manager', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3394, 'gw_fct_check_fprocess', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3396, 'gw_fct_create_full_network_dscenario', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3398, 'gw_fct_execute_foreign_audit', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3400, 'gw_fct_graphanalytics_initnetwork', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3402, 'gw_fct_graphanalytics_manage_temporary', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3404, 'gw_fct_graphanalytics_mapzones_v1', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3406, 'gw_fct_manage_temp_tables', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3408, 'gw_fct_update_audit_triggers', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3410, 'gw_trg_array_fk_array_table', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3412, 'gw_trg_array_fk_id_table', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3414, 'gw_trg_audit', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3416, 'gw_trg_cat_manager', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3418, 'gw_trg_edit_macroomzone', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3420, 'gw_trg_edit_omzone', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3422, 'gw_trg_presszone_check_datatype', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL);


-- 02/06/2025

UPDATE sys_function SET function_alias = 'NODE TOPOLOGICAL CONSISTENCY ANALYSIS' WHERE function_name = 'gw_fct_anl_node_topological_consistency';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3594, 'There are %v_count% nodes with topological inconsistency.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3596, 'There are no nodes with topological inconsistency.', null, 0, true, 'utils', 'core', 'AUDIT');

-- 03/06/2025

-- Insert mapzone supplyzones widgets
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'supplyzone_id', 'lyt_data_1', 1, 'integer', 'text', 'supplyzone_id', 'supplyzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_supplyzone", "activated": true, "keyColumn": "supplyzone_id", "valueColumn": "name", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'supplyzone_type', 'lyt_data_1', 3, 'string', 'combo', 'supplyzone_type', 'supplyzone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''supplyzone_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'macrosector', 'lyt_data_1', 4, 'string', 'combo', 'macrosector', 'macrosector', NULL, false, false, true, false, NULL, 'SELECT name as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 5, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'parent_id', 'lyt_data_1', 8, 'string', 'combo', 'parent_id', 'parent_id', NULL, false, false, true, false, false, 'SELECT supplyzone_id as id,name as idval FROM v_ui_supplyzone WHERE supplyzone_id > -1 AND active IS TRUE', true, true, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_supplyzone", "activated": true, "keyColumn": "supplyzone_id", "valueColumn": "name", "filterExpression": "supplyzone_id > -1 AND active IS TRUE"}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'pattern_id', 'lyt_data_1', 9, 'string', 'combo', 'pattern_id', 'pattern_id', NULL, false, false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 10, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 11, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','avg_press','lyt_data_1',12,'numeric','text','average pressure','avg_press', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','link','lyt_data_1',13,'text','text','link','link', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','muni_id','lyt_data_1',14,'text','text','muni_id','muni_id', 'Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','expl_id','lyt_data_1',15,'text','text','expl_id','expl_id', 'Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Insert mapzone macrodma widgets
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'macrodma_id', 'lyt_data_1', 1, 'integer', 'text', 'macrodma_id', 'macrodma_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"nullValue":true, "layer": "v_edit_macrodma", "activated": true, "keyColumn": "macrodma_id", "valueColumn": "name", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 5, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1',6, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- Insert mapzone macrosector widgets
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'macrosector_id', 'lyt_data_1', 1, 'integer', 'text', 'macrosector_id', 'macrosector_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"NULLValue":true, "layer": "v_edit_macrosector", "activated": true, "keyColumn": "macrosector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 5, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

--03/06/2025

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3542, 'No mincuts are being executed right now: %v_count%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3544, 'There are: %v_count% mincuts being executed at the moment..', null, 0, true, 'utils', 'core', 'AUDIT');

-- 04/06/2025
UPDATE sys_function SET function_alias = 'CREATE DSCENARIO' WHERE function_name = 'gw_fct_create_dscenario_demand';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3530, 'ERROR: The dscenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3532, 'New scenario %v_name% have been created with id:%v_scenarioid% .', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3534, 'Feature type: %v_featuretype%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3536, 'Exploitation: %v_expl%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3538, 'Selection mode: %v_selectionmode%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3540, 'INFO: Process done successfully.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3722, 'INFO: %v_count% rows with features have been inserted on table %v_table%.', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3706, 'INFO: %v_count% features have been inserted on table %v_table%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3708, 'New scenario %v_name% have been created with id:%v_scenarioid%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3710, 'Exploitation: %v_expl%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3712, 'Selection mode: %v_selectionmode%.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SHOW CURRENTLY EXECUTED MINCUTS' WHERE function_name = 'ws_gw_fct_mincut_show_current';


-- 06/06/2025
UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": ""
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use masterplan psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": ""
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": ""
  },
  {
    "widgetname": "updateMapZone",
    "label": "Update mapzone geometry method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "comboIds": [
      0,
      1,
      2,
      3
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER"
    ],
    "selectedId": ""
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Geometry parameter:",
    "widgettype": "text",
    "datatype": "float",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": ""
  }
]'::json WHERE id=2706;

--06/06/2025

UPDATE sys_function SET function_alias = 'INSERT FEATURES WITH PATTERN INTO DEMAND DSCENARIO' WHERE function_name = 'gw_fct_set_netscenario_pattern';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3756, '%v_count% connecs  were inserted into demand table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3758, '%v_count% nodes were inserted into demand table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3760, 'Exists %v_count% mapzones without assigned pattern_id. Fill the data before executing the process.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CREATE EMPTY NETSCENARIO' WHERE function_name = 'gw_fct_create_netscenario_empty';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3762, 'Type: %v_netscenario_type%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3764, 'The netscenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3766, 'The new netscenario have been created sucessfully', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CREATE EMPTY NETSCENARIO' WHERE function_name = 'gw_fct_create_netscenario_from_toc';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3768, 'Mapzones configuration (graphconfig) related to selected exploitation has been copied to new netscenario.', null, 0, true, 'utils', 'core', 'AUDIT');

--10/06/2025
UPDATE sys_function SET function_alias = 'MASSIVE MINCUT ANALYSIS (fid 129 & 149)' WHERE function_name = 'gw_fct_massivemincut';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3770, 'All arcs (state=1) on the selected exploitation(s) have not minsector_id informed. Please check your data before continue', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3772, 'There are %v_count2% arcs (state=1) on the selected exploitation(s) without minsector_id informed. Please check your data before continue', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3774, 'There are %v_count1% arcs (state=1) on the selected exploitation(s) and all of them have minsector_id informed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3776, 'Massive analysis have been done. %v_count1% mincut''s have been triggered (one by each minsector all of them using the mincut_id = -1). To check results you can query:', null, 0, true, 'utils', 'core', 'AUDIT');

--06/06/2025
UPDATE sys_function SET function_alias = 'CREATE EMPTY NETSCENARIO' WHERE function_name = 'gw_fct_duplicate_netscenario';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3800, 'Name: %v_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3802, 'Descript: %v_descript%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3804, 'Parent: %v_parent_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3806, 'Type: %v_netscenario_type%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3808, 'active: %v_active%', null, 0, true, 'utils', 'core', 'AUDIT');



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3810, 'ERROR: The netscenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3812, 'The new netscenario have been created successfully.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3814, 'Mapzones configuration (graphconfig) related to selected exploitation has been copied to new netscenario.', null, 0, true, 'utils', 'core', 'AUDIT');
-- 09/06/2025
ALTER TABLE cat_feature DISABLE TRIGGER gw_trg_cat_feature_after;

INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VLINK', 'LINK', 'VIRTUAL', 'man_vlink');
INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VCONNEC', 'CONNEC', 'VIRTUAL', 'man_vconnec');
UPDATE sys_feature_class SET id = 'PIPELINK', man_table = 'man_pipelink' WHERE id = 'LINK';

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, descript, active) VALUES ('VLINK', 'VLINK', 'LINK', 'v_edit_link', 've_link_vlink', 'Virtual link', true);

UPDATE cat_feature SET id = 'PIPELINK', child_layer = 've_link_pipelink' WHERE id = 'LINK';

INSERT INTO cat_feature_link (id) VALUES ('VLINK');

ALTER TABLE cat_feature ENABLE TRIGGER gw_trg_cat_feature_after;

-- Update sys_table context syntax and update config_typevalue references
DO $$
DECLARE
  level_values text[];
  output_json jsonb;
	layer record;
BEGIN

	FOR layer IN (SELECT * FROM config_typevalue WHERE typevalue = 'sys_table_context')
	LOOP
    -- Extract values of keys starting with 'level_' into an array
    IF layer.id::text NOT LIKE '{"levels":%}' THEN
      level_values := ARRAY(
          SELECT value::text
          FROM jsonb_each_text(layer.id::jsonb)
          WHERE key LIKE 'level_%'
          ORDER BY key
      );

      -- Build the resulting JSON
      output_json := jsonb_build_object('levels', level_values);

    UPDATE config_typevalue SET id = output_json WHERE id = layer.id AND typevalue = 'sys_table_context';
  END IF;

	END LOOP;
END
$$;

-- 10/06/2025
UPDATE sys_function SET function_alias = 'SET INITLEVEL VALUES' WHERE function_name = 'gw_fct_pg2epa_setinitvalues';

DO $$
DECLARE
  level_values text[];
  output_json jsonb;
	layer record;
BEGIN

	FOR layer IN (select * from sys_table where context is not null)
	LOOP
    IF layer.context::text NOT LIKE '{"levels":%}' THEN
      -- Extract values of keys starting with 'level_' into an array
      level_values := ARRAY(
          SELECT value::text
          FROM jsonb_each_text(layer.context::jsonb)
          WHERE key LIKE 'level_%'
          ORDER BY key
      );

      -- Build the resulting JSON
      output_json := jsonb_build_object('levels', level_values);

      UPDATE sys_table set context = output_json where id = layer.id;
    END IF;
	END LOOP;
END
$$;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('config_typevalue', 'sys_table_context', 'sys_table', 'context', NULL, true);


UPDATE sys_table SET orderBy = 1, alias = 'Municipality', project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb,context='{"levels": ["BASEMAP", "ADDRESS"]}' WHERE id='v_ext_municipality';

UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_supplyzone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_presszone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dqa';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias= 'Link' WHERE id='v_edit_link';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_macrodma';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_exploitation';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_sector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_macrosector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dimensions';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_ext_address';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_plot';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_streetaxis';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dma';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Connec' WHERE id='v_edit_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Arc' WHERE id='v_edit_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias = 'Node' WHERE id='v_edit_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_material';

UPDATE sys_table SET context = NULL, orderBy = NULL, alias = NULL WHERE id='ext_municipality';

UPDATE sys_style SET layername='v_ext_municipality' WHERE layername='ext_municipality' AND styleconfig_id=101;

DELETE FROM sys_table WHERE id = 've_link_link';


UPDATE config_typevalue SET addparam='{"orderBy":5}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "POLYGON"]}';
UPDATE config_typevalue SET addparam='{"orderBy":4}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":7}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "GULLY"]}';
UPDATE config_typevalue SET addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4002, 'Initlevel of %v_count% inlets has been updated.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4004, 'Initlevel of %v_count% tanks has been updated.', null, 0, true, 'utils', 'core', 'AUDIT');

-- 11/06/2025
UPDATE sys_function SET function_alias = 'CALCULATE COST OF RECONSTRUCTION' WHERE function_name = 'gw_fct_plan_result_recr';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4006, 'I1ST. STEP Result with this name is already defined on plan_result tables.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4008, '1ST. STEP executed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4010, 'Snapshot of values form v_plan_arc and v_plan_node have been inserted on plan_result_arc and plan_result_node tables.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4012, 'This proces enables to execute STEP 2 in order to calculate amortized values using age,cost and acoeff (amortized rate per year).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4014, '2ND STEP executed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4016, 'Amortized values using age,cost and acoeff have been calculated.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'MINSECTOR DYNAMIC SECTORITZATION' WHERE function_name = 'gw_fct_graphanalytics_minsector';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4018, 'Use psectors: %v_usepsector%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4020, 'Minsector attribute on arc/node/connec/link features have NOT BEEN updated by this process.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SET PSECTOR COST FOR REMOVED PIPES' WHERE function_name = 'gw_fct_setpsectorcostremovedpipes';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4022, 'Missing node_1 or node_2 on arcs: %v_arc_list%. Please check your data before continue', null, 2, true, 'ws', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4024, 'Minsector attribute on arc/node/connec/link features have been updated by this process.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'IMPORT DSCENARIO DEMAND' WHERE function_name = 'gw_fct_import_dscenario_demands';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3922, 'Reading values from temp_csv table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3924, 'Inserting values on inp_dscenario_demand table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'BUILT MISSING NODES USING START/END VERTICES' WHERE function_name = 'gw_fct_setnodefromarc';

--16/06/2025

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4026, 'There are no nodes to be repaired.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4028, '%v_count% nodes have been created to repair topology.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('ignoreBrokenOnlyMassiveMincut', 'false', 'Ignore broken only on massive mincut', 'Ignore broken only on massive mincut:', NULL, NULL, false, NULL, 'ws', NULL, NULL, 'boolean', 'checkbox', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('ignoreCheckValvesMincut', 'false', 'Ignore check valves on mincut', 'Ignore check valves on mincut:', NULL, NULL, false, NULL, 'ws', NULL, NULL, 'boolean', 'checkbox', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--17/06/2025

UPDATE sys_function SET function_alias = 'CREATE VALVE DSCENARIO FROM MINCUT' WHERE function_name = 'gw_fct_create_dscenario_from_mincut';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3954, 'New scenario %v_name% have been created with id:%v_scenarioid%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3956, '%v_count% rows with features have been inserted on table inp_dscenario_shortpipe', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3958, '%v_count% rows with features have been inserted on table inp_dscenario_valve', null, 0, true, 'utils', 'core', 'AUDIT');





VALUES(4024, '%v_count% nodes have been created to repair topology.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'WATER BALANCE BY EXPLOITATION AND PERIOD' WHERE function_name = 'gw_fct_waterbalance';

--17/06/2025
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4040, 'Process done succesfully for period: %v_period%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4042, 'Number of DMA processed: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4030, 'Number of hydrometer processed: %v_hydrometer%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4032, 'Total System Input: %v_tsi% CMP', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4034, 'Billed metered consumtion: %v_bmc% CMP', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4036, 'Non-revenue water: %v_nrw% CMP', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4038, 'DMAs updated %v_day% days ago.', null, 0, true, 'utils', 'core', 'AUDIT');

--17/06/2025
UPDATE sys_function SET function_alias = 'IMPORT CLOSED VALVE FOR NETSCENARIO' WHERE function_name = 'gw_fct_import_netscenario_valve_closed';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3858, 'Nothing to import', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3860, 'Reading values from temp_csv table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3862, 'Inserting values on cat_dscenario table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3864, 'Inserting values on inp_dscenario_shortpipe table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3868, 'Netscenario doesn''t exist.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3870, 'Data wasn''t imported.', null, 0, true, 'utils', 'core', 'AUDIT');

-- 19/06/2025
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 6, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 15, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_2', 1, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_2', 2, 'string', 'text', 'epa_type', 'epa_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_2', 3, 'boolean', 'check', 'is_operative', 'is_operative', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_2', 4, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_2', 5, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_2', 6, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_2', 7, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 8, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_2', 9, 'boolean', 'check', 'Uncertain', 'uncertain - To set if the element''s location is uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_2', 10, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'depth1', 'lyt_data_2', 11, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_2', 12, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_2', 13, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'depth2', 'lyt_data_2', 14, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_2', 15, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', 'Date from:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 6, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 2, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 6, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 7, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json, 'tbl_element_x_link', false, 1);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 6, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 15, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_2', 1, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_2', 2, 'string', 'text', 'epa_type', 'epa_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_2', 3, 'boolean', 'check', 'is_operative', 'is_operative', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_2', 4, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_2', 5, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_2', 6, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_2', 7, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 8, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_2', 9, 'boolean', 'check', 'Uncertain', 'uncertain - To set if the element''s location is uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_2', 10, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'depth1', 'lyt_data_2', 11, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_2', 12, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_2', 13, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'depth2', 'lyt_data_2', 14, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_2', 15, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', 'Date from:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 6, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 2, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 6, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 7, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json, 'tbl_element_x_link', false, 1);

--23/06/2025
UPDATE inp_typevalue SET idval='TRIMMED NETWORK' WHERE typevalue='inp_options_networkmode' AND id='3';UPDATE inp_typevalue SET idval='TRIMMED NETWORK' WHERE typevalue='inp_options_networkmode' AND id='3';

UPDATE config_param_system SET value='UPDATE v_table set the_geom = geom FROM
        (SELECT v_field, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
        (SELECT v_field, st_buffer(st_collect(the_geom), v_geomparamupdate) as geom 
        FROM v_edit_arc arc
        where arc.state > 0 AND  v_field NOT IN (''0'', ''-1'') AND arc.v_field IN
        (SELECT DISTINCT arc.v_field FROM arc JOIN anl_arc ON anl_arc.arc_id = arc.arc_id::text WHERE fid = v_fid and cur_user = current_user)
        group by v_field
        UNION
        SELECT v_field, st_collect(ext_plot.the_geom) as geom FROM v_edit_connec, ext_plot
        WHERE v_edit_connec.state > 0 AND v_field NOT IN (''0'', ''-1'')
        AND v_edit_connec.v_field IN
        (SELECT DISTINCT arc.v_field FROM arc JOIN anl_arc ON anl_arc.arc_id
         = arc.arc_id::text WHERE fid = v_fid and cur_user = current_user)
        AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
        group by v_field
        )a group by v_field)b 
        WHERE b.v_field::text=v_table.v_fieldmp::text' WHERE "parameter"='utils_graphanalytics_custom_geometry_constructor';

-- 14/07/2025
UPDATE sys_function SET project_type = 'utils' WHERE id = 3410;
UPDATE sys_function SET project_type = 'utils' WHERE id = 3412;
