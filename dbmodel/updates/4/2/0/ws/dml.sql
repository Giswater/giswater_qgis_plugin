/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 03/07/2025
UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "PRESSZONE",
      "DQA",
      "DMA",
      "SECTOR"
    ],
    "comboNames": [
      "Pressure Zonification (PRESSZONE)",
      "District Quality Areas (DQA) ",
      "District Metering Areas (DMA)",
      "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "forceOpen",
    "label": "Force open nodes: (*)",
    "widgettype": "linetext",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "value": null
  },
  {
    "widgetname": "forceClosed",
    "label": "Force closed nodes: (*)",
    "widgettype": "text",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": null
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use selected psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      3,
      4
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "selectedId": null
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": null
  }
]'::json WHERE id=2768;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3482, 'Macromapzones analysis', '{"featureType":[]}'::json, '[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "MACROSECTOR",
      "MACRODMA",
      "MACRODQA",
      "MACROOMZONE"
    ],
    "comboNames": [
      "MACROSECTOR",
      "MACRODMA",
      "MACRODQA",
      "MACROOMZONE"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      3,
      4
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "selectedId": null
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": null
  }
]'::json, NULL, true, '{4}');

-- 07/07/2025
UPDATE config_param_system
	SET value='{"status":false, "values":[
{"sourceTable":"inp_tank", "query":"UPDATE man_tank t SET hmax=maxlevel FROM inp_tank s "},
{"sourceTable":"inp_valve", "query":"UPDATE man_valve t SET pressure_exit=pressure FROM inp_valve s "}]}'
	WHERE "parameter"='epa_automatic_inp2man_values';

UPDATE config_form_fields SET columnname='staticpressure1' WHERE formname ILIKE '%arc%' AND columnname='staticpress1';
UPDATE config_form_fields SET columnname='staticpressure2' WHERE formname ILIKE '%arc%' AND columnname='staticpress2';
UPDATE config_form_fields SET columnname='pressure_exit' WHERE formname ILIKE '%valve%' AND columnname='pression_exit';
UPDATE config_form_fields SET columnname='pressure_entry' WHERE formname ILIKE '%valve%' AND columnname='pression_entry';
UPDATE config_form_fields SET columnname='pressure_exit' WHERE formname ILIKE '%pump%' AND columnname='pressure';
UPDATE config_form_fields SET columnname='staticpressure1' WHERE formname ILIKE '%link%' AND columnname='staticpressure';

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source") VALUES('edit_nodetype_vdefault', 'config', 'Default type for node when parent layer (v_edit_node) is used', 'role_edit', NULL, 'Default type for node (parent layer):', 'SELECT id AS id, id AS idval FROM cat_feature_node JOIN cat_feature USING (id) WHERE id IS NOT NULL AND cat_feature.active IS TRUE', NULL, true, 1, 'ws', false, NULL, 'node_type', NULL, false, 'string', 'combo', false, NULL, NULL, 'lyt_node', true, NULL, NULL, NULL, NULL, 'core');

-- 24/07/2025
UPDATE sys_table SET alias='Catalog for elements' WHERE id='v_edit_cat_feature_element';
UPDATE sys_table SET alias='Catalog of arc shapes'  WHERE id='cat_arc_shape';

UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "isMandatory": true,
    "tooltip": "Dscenario type",
    "dvQueryText": "WITH aux AS (SELECT ''-9'' as id, ''ALL'' as idval, 0 AS rowid UNION SELECT expl_id::text as id, name as idval, row_number() over()+1 AS  rowid FROM exploitation where expl_id>0) SELECT id, idval FROM aux ORDER BY rowid ASC",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "value": ""
  },
  {
    "widgetname": "method",
    "label": "Method:",
    "widgettype": "combo",
    "datatype": "text",
    "isMandatory": true,
    "tooltip": "Water balance method",
    "dvQueryText": "SELECT id, idval FROM om_typevalue WHERE typevalue = ''waterbalance_method''",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "value": ""
  },
  {
    "widgetname": "period",
    "label": "Period:",
    "widgettype": "combo",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 4,
    "dvQueryText": "SELECT id, code as idval FROM ext_cat_period ORDER BY id desc",
    "selectedId": ""
  },
  {
    "widgetname": "initDate",
    "label": "Period (init date):",
    "widgettype": "datetime",
    "datatype": "text",
    "isMandatory": true,
    "tooltip": "Start date",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "value": null
  },
  {
    "widgetname": "endDate",
    "label": "Period (end date):",
    "widgettype": "datetime",
    "datatype": "text",
    "isMandatory": true,
    "tooltip": "End date",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": "9999-12-12"
  },
  {
    "widgetname": "executeGraphDma",
    "label": "Execute DMA:",
    "widgettype": "check",
    "datatype": "boolean",
    "isMandatory": true,
    "tooltip": "Execute DMA",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": ""
  }
]'::json
WHERE id=3142;

UPDATE sys_function SET descript='Function to calculate water balance according stardards of IWA. 
You must select a period already created or manually select the date of the interval. One at a time. Before that:  
1) tables ext_cat_period, ext_rtc_hydrometer_x_data, ext_rtc_scada_x_data need to be filled. 
2) DMA graph need to be executed.  
>End Date proposal for 1% of hydrometers which consum is out of the period: 2015-07-31 00:00:00' WHERE id=3142;

DELETE FROM config_form_fields  WHERE formname = 've_arc';
DELETE FROM config_form_fields  WHERE formname = 've_connec';
DELETE FROM config_form_fields  WHERE formname = 've_node';
ALTER TABLE config_form_fields DISABLE TRIGGER ALL;
UPDATE config_form_fields SET formname = REPLACE(formname, 'v_edit_', 've_') WHERE formname LIKE 'v_edit_%';
ALTER TABLE config_form_fields ENABLE TRIGGER ALL;

INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_meter_metertype', '0', 'UNKNOWN', NULL, NULL)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO edit_typevalue (typevalue, id, idval, descript)
SELECT DISTINCT 'man_meter_metertype', ROW_NUMBER() OVER(), meter_type, NULL FROM man_meter ORDER BY 2 ASC LIMIT 3 ON CONFLICT DO NOTHING;

INSERT INTO cat_brand (id)
SELECT DISTINCT brand_id FROM node WHERE brand_id IS NOT NULL ON CONFLICT DO NOTHING;

INSERT INTO cat_brand_model (catbrand_id, id)
SELECT DISTINCT brand_id, model_id FROM node WHERE model_id IS NOT NULL ON CONFLICT DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('edit_typevalue', 'man_meter_metertype', 'man_meter', 'meter_type', NULL, true)
ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_param_system SET 
value='{"sys_table_id":"ve_connec","sys_id_field":"connec_id","sys_search_field":"connec_id","alias":"Connecs","cat_field":"conneccat_id","orderby":"3","search_type":"connec"}' 
WHERE "parameter"='basic_search_network_connec';

DELETE FROM config_toolbox WHERE id=2712;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(2706, 'Minsector analysis', '{"featureType":[]}'::json, '[
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": ""
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use masterplan psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "value": ""
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 3,
    "value": ""
  },
  {
    "widgetname": "updateMapZone",
    "label": "Update mapzone geometry method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 4,
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
    "layoutorder": 5,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": ""
  },
  {
    "widgetname": "executeMassiveMincut",
    "label": "Execute Massive Mincut:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": ""
  }
]'::json, NULL, true, '{4}')
ON CONFLICT (id) DO UPDATE SET inputparams=EXCLUDED.inputparams;

-- 31/07/2025
-- 28/07/2025
-- EHYDRANT PLATE
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code','Code',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','top_elev','lyt_data_1',21,'double','text','Top Elevation','Top Elevation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','rotation','lyt_data_1',18,'double','text','Rotation','Rotation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','ownercat_id','lyt_data_1',17,'string','combo','Owner Catalog','Owner Catalog',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','enddate','lyt_data_1',16,'date','datetime','End Date','End Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','builtdate','lyt_data_1',15,'date','datetime','Built Date','Built Date',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','workcat_id','lyt_data_1',13,'string','typeahead','Workcat ID','Workcat ID',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','comment','lyt_data_1',8,'string','text','Comments','Comments',false,false,true,false,'{"setMultiline":true}'::json,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','observ','lyt_data_3',15,'string','text','Observations','Observations',false,false,true,false,'{"setMultiline":true}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','category_type','lyt_data_1',10,'string','combo','Category Type','Category Type',false,false,true,false,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','function_type','lyt_data_1',9,'string','combo','Function Type','Function Type',false,false,true,false,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','num_elements','lyt_data_1',6,'integer','text','Number of Elements','Number of Elements',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','location_type','lyt_data_1',11,'string','combo','Location Type','Location Type',false,false,true,false,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
  "icon": "112"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
  "icon": "178"
}'::json,'{
  "saveValue": false
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
  "icon": "137"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "selection_init"
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json,'tbl_element_x_arc',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json,'tbl_element_x_connec',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json,'tbl_element_x_gully',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json,'tbl_element_x_link',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json,'tbl_element_x_node',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
  "icon": "111"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','workcat_id_end','lyt_data_1',14,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','state','lyt_bot_1',3,'integer','combo','State','State',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','elementcat_id','lyt_top_1',0,'string','combo','Element Catalog','Element Catalog',true,false,true,false,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EHYDRANT_PLATE''',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','element_id','lyt_top_1',1,'string','text','Element ID','Element ID',false,false,false,false,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','state_type','lyt_bot_1',4,'integer','combo','State Type','State Type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','expl_id','lyt_data_2',33,'integer','combo','Exploitation ID','Exploitation ID',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_genelem_ehydrant_plate','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false) ON CONFLICT DO NOTHING;

-- EMANHOLE
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code','Code',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','top_elev','lyt_data_1',21,'double','text','Top Elevation','Top Elevation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','rotation','lyt_data_1',18,'double','text','Rotation','Rotation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','ownercat_id','lyt_data_1',17,'string','combo','Owner Catalog','Owner Catalog',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','enddate','lyt_data_1',16,'date','datetime','End Date','End Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','builtdate','lyt_data_1',15,'date','datetime','Built Date','Built Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','workcat_id','lyt_data_1',13,'string','typeahead','Workcat ID','Workcat ID',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','comment','lyt_data_1',8,'string','text','Comments','Comments',false,false,true,false,'{"setMultiline":true}'::json,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','observ','lyt_data_3',15,'string','text','Observations','Observations',false,false,true,false,'{"setMultiline":true}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','category_type','lyt_data_1',10,'string','combo','Category Type','Category Type',false,false,true,false,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','function_type','lyt_data_1',9,'string','combo','Function Type','Function Type',false,false,true,false,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','num_elements','lyt_data_1',6,'integer','text','Number of Elements','Number of Elements',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','location_type','lyt_data_1',11,'string','combo','Location Type','Location Type',false,false,true,false,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
  "icon": "112"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
  "icon": "178"
}'::json,'{
  "saveValue": false
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
  "icon": "137"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "selection_init"
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json,'tbl_element_x_arc',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json,'tbl_element_x_connec',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json,'tbl_element_x_gully',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json,'tbl_element_x_link',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json,'tbl_element_x_node',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
  "icon": "111"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','workcat_id_end','lyt_data_1',14,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','state','lyt_bot_1',3,'integer','combo','State','State',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','elementcat_id','lyt_top_1',0,'string','combo','Element Catalog','Element Catalog',true,false,true,false,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EMANHOLE''',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','element_id','lyt_top_1',1,'string','text','Element ID','Element ID',false,false,false,false,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','state_type','lyt_bot_1',4,'integer','combo','State Type','State Type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','expl_id','lyt_data_2',33,'integer','combo','Exploitation ID','Exploitation ID',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_genelem_emanhole','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false) ON CONFLICT DO NOTHING;


-- EPROTECT_BAND
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code','Code',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','top_elev','lyt_data_1',21,'double','text','Top Elevation','Top Elevation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','rotation','lyt_data_1',18,'double','text','Rotation','Rotation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','ownercat_id','lyt_data_1',17,'string','combo','Owner Catalog','Owner Catalog',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','enddate','lyt_data_1',16,'date','datetime','End Date','End Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','builtdate','lyt_data_1',15,'date','datetime','Built Date','Built Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','workcat_id','lyt_data_1',13,'string','typeahead','Workcat ID','Workcat ID',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','comment','lyt_data_1',8,'string','text','Comments','Comments',false,false,true,false,'{"setMultiline":true}'::json,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','observ','lyt_data_3',15,'string','text','Observations','Observations',false,false,true,false,'{"setMultiline":true}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','category_type','lyt_data_1',10,'string','combo','Category Type','Category Type',false,false,true,false,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','function_type','lyt_data_1',9,'string','combo','Function Type','Function Type',false,false,true,false,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','num_elements','lyt_data_1',6,'integer','text','Number of Elements','Number of Elements',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','location_type','lyt_data_1',11,'string','combo','Location Type','Location Type',false,false,true,false,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
  "icon": "112"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
  "icon": "178"
}'::json,'{
  "saveValue": false
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
  "icon": "137"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "selection_init"
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json,'tbl_element_x_arc',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json,'tbl_element_x_connec',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json,'tbl_element_x_gully',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json,'tbl_element_x_link',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json,'tbl_element_x_node',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
  "icon": "111"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','workcat_id_end','lyt_data_1',14,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','state','lyt_bot_1',3,'integer','combo','State','State',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','elementcat_id','lyt_top_1',0,'string','combo','Element Catalog','Element Catalog',true,false,true,false,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPROTECT_BAND''',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','element_id','lyt_top_1',1,'string','text','Element ID','Element ID',false,false,false,false,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','state_type','lyt_bot_1',4,'integer','combo','State Type','State Type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','expl_id','lyt_data_2',33,'integer','combo','Exploitation ID','Exploitation ID',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_genelem_eprotect_band','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false) ON CONFLICT DO NOTHING;


-- EREGISTER
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code','Code',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','top_elev','lyt_data_1',21,'double','text','Top Elevation','Top Elevation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','rotation','lyt_data_1',18,'double','text','Rotation','Rotation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','ownercat_id','lyt_data_1',17,'string','combo','Owner Catalog','Owner Catalog',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','enddate','lyt_data_1',16,'date','datetime','End Date','End Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','builtdate','lyt_data_1',15,'date','datetime','Built Date','Built Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','workcat_id','lyt_data_1',13,'string','typeahead','Workcat ID','Workcat ID',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','comment','lyt_data_1',8,'string','text','Comments','Comments',false,false,true,false,'{"setMultiline":true}'::json,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','observ','lyt_data_3',15,'string','text','Observations','Observations',false,false,true,false,'{"setMultiline":true}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','category_type','lyt_data_1',10,'string','combo','Category Type','Category Type',false,false,true,false,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','function_type','lyt_data_1',9,'string','combo','Function Type','Function Type',false,false,true,false,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','num_elements','lyt_data_1',6,'integer','text','Number of Elements','Number of Elements',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','location_type','lyt_data_1',11,'string','combo','Location Type','Location Type',false,false,true,false,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
  "icon": "112"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
  "icon": "178"
}'::json,'{
  "saveValue": false
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
  "icon": "137"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "selection_init"
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json,'tbl_element_x_arc',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json,'tbl_element_x_connec',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json,'tbl_element_x_gully',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json,'tbl_element_x_link',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json,'tbl_element_x_node',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
  "icon": "111"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','workcat_id_end','lyt_data_1',14,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','state','lyt_bot_1',3,'integer','combo','State','State',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','elementcat_id','lyt_top_1',0,'string','combo','Element Catalog','Element Catalog',true,false,true,false,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EREGISTER''',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','element_id','lyt_top_1',1,'string','text','Element ID','Element ID',false,false,false,false,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','state_type','lyt_bot_1',4,'integer','combo','State Type','State Type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','expl_id','lyt_data_2',33,'integer','combo','Exploitation ID','Exploitation ID',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_genelem_eregister','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false) ON CONFLICT DO NOTHING;




-- ECOVER documents
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_genelem_ecover','form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json,'tbl_doc_x_element',false,4) ON CONFLICT DO NOTHING;

-- EVALVE
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','comment','lyt_data_1',8,'string','text','Comments','Comments',false,false,true,false,'{"setMultiline":true}'::json,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code','Code',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','num_elements','lyt_data_1',6,'integer','text','Number of Elements','Number of Elements',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','workcat_id','lyt_data_1',13,'string','typeahead','Workcat ID','Workcat ID',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','builtdate','lyt_data_1',15,'date','datetime','Built Date','Built Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','enddate','lyt_data_1',16,'date','datetime','End Date','End Date',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','ownercat_id','lyt_data_1',17,'string','combo','Owner Catalog','Owner Catalog',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','rotation','lyt_data_1',18,'double','text','Rotation','Rotation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','top_elev','lyt_data_1',21,'double','text','Top Elevation','Top Elevation',false,false,true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','nodarc_id','lyt_data_2',0,'string','text','nodarc_id','nodarc_id',false,false,true,false,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','function_type','lyt_data_1',9,'string','combo','Function Type','Function Type',false,false,true,false,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','category_type','lyt_data_1',10,'string','combo','Category Type','Category Type',false,false,true,false,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','location_type','lyt_data_1',11,'string','combo','Location Type','Location Type',false,false,true,false,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
  "icon": "112"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
  "icon": "178"
}'::json,'{
  "saveValue": false
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','observ','lyt_data_3',15,'string','text','Observations','Observations',false,false,true,false,'{"setMultiline":true}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,true) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
  "icon": "137"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "selection_init"
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json,'tbl_element_x_arc',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json,'tbl_element_x_connec',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json,'tbl_element_x_gully',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json,'tbl_element_x_link',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json,'tbl_element_x_node',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
  "icon": "111"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','workcat_id_end','lyt_data_1',14,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','elementcat_id','lyt_top_1',0,'string','combo','Element Catalog','Element Catalog',true,false,true,false,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EVALVE''',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','element_id','lyt_top_1',1,'string','text','Element ID','Element ID',false,false,false,false,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','epa_type','lyt_top_1',2,'string','combo','EPA Type','EPA Type',false,false,true,false,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''','{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','state','lyt_bot_1',3,'integer','combo','State','State',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','state_type','lyt_bot_1',4,'integer','combo','State Type','State Type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','expl_id','lyt_data_2',33,'integer','combo','Exploitation ID','Exploitation ID',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden,web_layoutorder)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','muni_id','lyt_data_3',1,'integer','combo','municipality','muni_id',false,false,true,false,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false,56) ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=3, "datatype"='double', widgettype='text', "label"='flwreg_length', tooltip='flwreg_length', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols=NULL, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='flwreg_length' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=4, "datatype"='integer', widgettype='text', "label"='node_id', tooltip='node_id', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols=NULL, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='node_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=5, "datatype"='double', widgettype='text', "label"='order_id', tooltip='order_id', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols=NULL, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='order_id' AND tabname='tab_data';

UPDATE config_form_fields SET widgetcontrols = '{"setMultiline": false}'::json WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields SET widgetcontrols = '{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';

-- EPUMP documents
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json,'tbl_doc_x_element',false,4) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_epump','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2) ON CONFLICT DO NOTHING;

-- EVALVE documents
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json,'tbl_doc_x_element',false,4) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_frelem_evalve','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2) ON CONFLICT DO NOTHING;


-- Tabactions
UPDATE config_form_tabs SET tabactions='[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionInterpolate","actionTooltip": "Interpolate","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false},{"actionName": "actionDemand","actionTooltip": "DWF","disabled": false}]'::json WHERE formname='ve_epa_inlet' AND tabname='tab_epa';
UPDATE config_form_tabs SET tabactions='[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionInterpolate","actionTooltip": "Interpolate","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false},{"actionName": "actionDemand","actionTooltip": "DWF","disabled": false}]'::json WHERE formname='ve_epa_pgully' AND tabname='tab_epa';
UPDATE config_form_tabs SET tabactions='[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionInterpolate","actionTooltip": "Interpolate","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false},{"actionName": "actionDemand","actionTooltip": "DWF","disabled": false}]'::json WHERE formname='ve_epa_junction' AND tabname='tab_epa';
UPDATE config_form_tabs SET tabactions='[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionInterpolate","actionTooltip": "Interpolate","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false}]'::json WHERE formname='ve_epa_storage' AND tabname='tab_epa';
UPDATE config_form_tabs SET tabfunction=NULL, tabactions='[{"actionName": "actionEdit", "disabled": false}]'::json WHERE formname='ve_frelem' AND tabname='tab_epa';
UPDATE config_form_tabs SET tabfunction=NULL, tabactions='[{"actionName": "actionEdit", "disabled": false}]'::json WHERE formname='ve_frelem' AND tabname='tab_documents';
UPDATE config_form_tabs SET tabfunction=NULL, tabactions='[{"actionName": "actionEdit", "disabled": false}]'::json WHERE formname='ve_frelem' AND tabname='tab_features';
UPDATE config_form_tabs SET tabfunction=NULL, tabactions='[{"actionName": "actionEdit", "disabled": false},{"actionName": "actionSetToArc","disabled": false}]'::json WHERE formname='ve_frelem' AND tabname='tab_data';


-- ELEMENT_ID
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline":false}'::json
	WHERE formname='v_edit_element' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline": false, "labelPosition": "top"}'::json
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline": false, "labelPosition": "top"}'::json
	WHERE formname='ve_genelem_ecover' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline": false, "labelPosition": "top"}'::json
	WHERE formname='ve_genelem_ehydrant_plate' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline": false, "labelPosition": "top"}'::json
	WHERE formname='ve_genelem_emanhole' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline": false, "labelPosition": "top"}'::json
	WHERE formname='ve_genelem_eprotect_band' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline": false, "labelPosition": "top"}'::json
	WHERE formname='ve_genelem_eregister' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false,"setMultiline": false, "labelPosition": "top"}'::json
	WHERE formname='ve_genelem_estep' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';

-- Correct expl_id
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_genelem_ehydrant_plate' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_genelem_emanhole' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_genelem_eprotect_band' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_genelem_eregister' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_genelem_ecover' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET widgetcontrols='{"setMultiline": false}'::json
	WHERE formname='ve_genelem_estep' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';

-- Config_form_tabs
INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_frelem','tab_epa','EPA','Epa','role_basic','[
  {"actionName": "actionEdit", "disabled": false}
]'::json,1,'{4}');
INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_frelem','tab_documents','Documents','List of documents','role_basic','[
  {"actionName": "actionEdit", "disabled": false}
]'::json,2,'{4}');
INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_frelem','tab_features','Features','Manage features','role_basic','[
  {"actionName": "actionEdit", "disabled": false}
]'::json,3,'{4}');
INSERT INTO config_form_tabs (formname,tabname,"label",tooltip,sys_role,tabactions,orderby,device)
	VALUES ('ve_frelem','tab_data','Data','Data','role_basic','[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionSetGeom",
    "disabled": false
  }
]'::json,0,'{4}');


-- Order epump
UPDATE config_form_fields
	SET layoutorder=4,layoutname='lyt_data_2'
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='order_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET layoutorder=3,layoutname='lyt_data_2'
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='flwreg_length' AND tabname='tab_data';
UPDATE config_form_fields
	SET layoutorder=2,layoutname='lyt_data_2'
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET layoutorder=5
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';

-- Order evalve
UPDATE config_form_fields
	SET layoutorder=0,layoutname='lyt_data_1'
	WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='node_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=false
	WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='node_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true
	WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';

-- Sector_id
UPDATE config_form_fields
	SET dv_querytext='SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0'
	WHERE formname='ve_genelem_ehydrant_plate' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET dv_querytext='SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0'
	WHERE formname='ve_genelem_emanhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET dv_querytext='SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0'
	WHERE formname='ve_genelem_eprotect_band' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET dv_querytext='SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0'
	WHERE formname='ve_genelem_eregister' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET dv_querytext='SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0'
	WHERE formname='ve_genelem_ecover' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET dv_querytext='SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0'
	WHERE formname='ve_genelem_estep' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';

-- is mandatory frelem
UPDATE config_form_fields
	SET ismandatory=true
	WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='flwreg_length' AND tabname='tab_data';
UPDATE config_form_fields
	SET ismandatory=true
	WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='order_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET ismandatory=true
	WHERE formname='ve_frelem_evalve' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET ismandatory=true
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET ismandatory=true
	WHERE formname='ve_frelem_epump' AND formtype='form_feature' AND columnname='flwreg_length' AND tabname='tab_data';


-- 22/07/2025
INSERT INTO edit_typevalue (typevalue,id,idval) VALUES ('dma_type','TRANSMISSION','TRANSMISSION');
INSERT INTO edit_typevalue (typevalue,id,idval) VALUES ('dma_type','DISTRIBUTION','DISTRIBUTION');
INSERT INTO edit_typevalue (typevalue,id,idval) VALUES ('dma_type','HYBRID','HYBRID');

INSERT INTO inp_typevalue (typevalue,id,idval) VALUES ('inp_options_networkmode','1','TRANSMISSION NETWORK');
INSERT INTO inp_typevalue (typevalue,id,idval) VALUES ('inp_options_networkmode','5','NETWORK DMA');

--23/07/2025
INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc,
feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue,
stylesheet, placeholder, "source")
VALUES('inp_options_selecteddma', 'epaoptions', 'Wich DMA will be exportad if networkmode is NETWORK DMA', 'role_epa', NULL, 'Dma (NETWORK DMA):',
'SELECT dma_id as id, name as idval FROM dma WHERE dma_id is not null and dma_id > 0', NULL, true, 2, 'ws', false, NULL, NULL, NULL, false, 'integer', 'combo', true, NULL, NULL,
'lyt_general_1', true, true, NULL, NULL, NULL, 'core');

INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('inp_options_selecteddma', '3', 'postgres') ON CONFLICT DO NOTHING;

-- 01/08/2025
UPDATE config_toolbox SET inputparams = '[
  {
    "label": "Exploitation:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id as id, name as idval FROM ve_exploitation",
    "layoutorder": 1
  },
  {
    "label": "Material:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "material",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, descript as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL",
    "layoutorder": 2
  },
  {
    "label": "Price:",
    "value": null,
    "tooltip": "Code of removal material price",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "price",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 3,
    "placeholder": ""
  },
  {
    "label": "Observ:",
    "value": null,
    "tooltip": "Descriptive text for removal (it apears on psector_x_other observ)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "observ",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 4,
    "placeholder": ""
  }
]'::json WHERE id = 3322;


-- 04/08/2025
DELETE FROM config_form_fields WHERE (formname ILIKE '%frelem%' OR formname ILIKE '%genelem%') AND tabname = 'tab_none';
DELETE FROM config_form_fields WHERE formname ILIKE '%frelem%' AND columnname = 'nodarc_id';

-- setToArc action
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json
	WHERE formname='ve_frelem' AND tabname='tab_data';

-- Correct sourcetable in widgetfunction
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_connec",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}'::json
	WHERE formname='connec' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_node",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}'::json
	WHERE formname='node' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}'::json
	WHERE formname='ve_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}'::json
	WHERE formname='ve_link_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}'::json
	WHERE formname='ve_link_pipelink' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}'::json
	WHERE formname='ve_link_vlink' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

-- FRVALVE
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','reaction_min','lyt_epa_data_2',15,'string','text','Min reaction:','Min reaction',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','ffactor_max','lyt_epa_data_2',16,'string','text','Max Ffactor:','Max Ffactor',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','ffactor_min','lyt_epa_data_2',17,'string','text','Min Ffactor:','Min Ffactor',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','tbl_inp_valve','lyt_epa_dsc_3',1,'tableview',false,false,false,false,false,'{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_valve"}'::json,'tbl_inp_dscenario_valve',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','hspacer_epa_1','lyt_epa_dsc_1',4,'hspacer',false,false,false,false,false,'{"saveValue": false}'::json,'tbl_inp_dscenario_valve',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','cat_dint','lyt_epa_data_1',13,'string','text','Cat dint:','Cat dint',false,false,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','custom_dint','lyt_epa_data_1',14,'string','text','Custom dint:','Custom dint',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','status','lyt_epa_data_1',9,'string','text','Status:','Status',false,false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','valve_type','lyt_epa_data_1',2,'string','text','Valve type:','Valve type',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','nodarc_id','lyt_epa_data_1',1,'string','text','Nodarc id:','Nodarc id',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','pressure','lyt_epa_data_1',3,'string','text','Pressure:','Pressure',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','flow','lyt_epa_data_1',5,'string','text','Flow:','Flow',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','coef_loss','lyt_epa_data_1',6,'string','text','Coefficient loss:','Coefficient loss',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','minorloss','lyt_epa_data_1',8,'string','text','Minorloss:','Minorloss',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','add_settings','lyt_epa_data_1',11,'string','text','Add settings:','Add settings',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','init_quality','lyt_epa_data_1',12,'string','text','Initial quality:','Initial quality',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','result_id','lyt_epa_data_2',1,'string','text','Result id:','Result id',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','headloss_max','lyt_epa_data_2',8,'string','text','Max headloss:','Max headloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','headloss_min','lyt_epa_data_2',9,'string','text','Min headloss:','Min headloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','uheadloss_max','lyt_epa_data_2',10,'string','text','Max uheadloss:','Max uheadloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','uheadloss_min','lyt_epa_data_2',11,'string','text','Min uheadloss:','Min uheadloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','setting_max','lyt_epa_data_2',12,'string','text','Max setting:','Max setting',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','setting_min','lyt_epa_data_2',13,'string','text','Min setting:','Min setting',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','reaction_max','lyt_epa_data_2',14,'string','text','Max reaction:','Max reaction',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','curve_id','lyt_epa_data_1',7,'string','combo','Curve id:','Curve id',false,false,true,false,false,'SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL',true,true,'{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','flow_max','lyt_epa_data_2',2,'string','text','Max flow:','Max Flow',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','flow_min','lyt_epa_data_2',3,'string','text','Min flow:','Min Flow',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','vel_max','lyt_epa_data_2',5,'string','text','Max velocity:','Max velocity',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','vel_min','lyt_epa_data_2',6,'string','text','Min velocity:','Min velocity',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','add_to_dscenario','lyt_epa_dsc_1',1,'button',false,false,false,false,false,'{"icon":"113"}'::json,'{"saveValue": false}'::json,'{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_valve",
    "tablename": "v_edit_inp_dscenario_valve",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_valve", "view": "v_edit_inp_dscenario_valve", "add_view": "v_edit_inp_dscenario_valve", "pk": ["dscenario_id", "node_id"]}
   ]
, "add_dlg_title":"Valve"   }
}'::json,'tbl_inp_dscenario_valve',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','edit_dscenario','lyt_epa_dsc_1',3,'button',false,false,true,false,false,'{"icon":"101"}'::json,'{"saveValue":false, "onContextMenu":"Edit dscenario"}'::json,'{
  "functionName": "edit_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_valve",
    "tablename": "v_edit_inp_dscenario_valve",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_valve", "view": "v_edit_inp_dscenario_valve", "add_view": "v_edit_inp_dscenario_valve", "pk": ["dscenario_id", "node_id"]}
   ]
, "add_dlg_title":"Valve"   }
}'::json,'tbl_inp_dscenario_valve',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frvalve','form_feature','tab_epa','remove_from_dscenario','lyt_epa_dsc_1',2,'button',false,false,false,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "onContextMenu":"Delete dscenario"}'::json,'{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_valve",
    "tablename": "v_edit_inp_dscenario_valve",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_valve", "view": "v_edit_inp_dscenario_valve", "add_view": "v_edit_inp_dscenario_valve", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json,'tbl_inp_dscenario_valve',false);

-- FRPUMP
DELETE FROM config_form_fields WHERE formname = 've_epa_frpump';

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','power','lyt_epa_data_1',1,'string','text','Power:','Power',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','speed','lyt_epa_data_1',3,'string','text','Speed:','Speed',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','energy_price','lyt_epa_data_1',9,'string','text','Energy price:','Energy price',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','result_id','lyt_epa_data_2',1,'string','text','Result id:','Result id',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','headloss_max','lyt_epa_data_2',6,'string','text','Max headloss:','Max headloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','headloss_min','lyt_epa_data_2',7,'string','text','Min headloss:','Min headloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','quality','lyt_epa_data_2',8,'string','text','Quality:','Quality',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','usage_fact','lyt_epa_data_2',9,'string','text','Usage factor:','Usage factor',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','kwhr_mgal','lyt_epa_data_2',11,'string','text','KWh mgal:','KWh mgal',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','avg_kw','lyt_epa_data_2',12,'string','text','Average KW:','Average KW',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','peak_kw','lyt_epa_data_2',13,'string','text','Peak KW:','Peak KW',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','cost_day','lyt_epa_data_2',14,'string','text','Cost day:','Cost day',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','status','lyt_epa_data_1',5,'string','combo','Status:','Status',false,false,true,false,false,'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_pump''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','pump_type','lyt_epa_data_1',8,'string','combo','Pump type:','Pump type',false,false,true,false,false,'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_pumptype''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','avg_effic','lyt_epa_data_2',10,'string','text','Average efficiency:','Average efficiency',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','tbl_inp_pump','lyt_epa_dsc_3',1,'tableview',false,false,false,false,false,'{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_pump"}'::json,'tbl_inp_dscenario_pump',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','hspacer_epa_1','lyt_epa_dsc_1',4,'hspacer',false,false,false,false,false,'{"saveValue": false}'::json,'tbl_inp_dscenario_pump',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','remove_from_dscenario','lyt_epa_dsc_1',2,'button',false,false,false,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "onContextMenu":"Delete dscenario"}'::json,'{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pump",
    "tablename": "v_edit_inp_dscenario_pump",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pump", "view": "v_edit_inp_dscenario_pump", "add_view": "v_edit_inp_dscenario_pump", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json,'tbl_inp_dscenario_pump',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','effic_curve_id','lyt_epa_data_1',11,'string','combo','Eff. curve','Eff. curve',false,false,true,false,false,'SELECT id as id, id as idval FROM ve_inp_curve WHERE curve_type = ''EFFICIENCY''',true,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','energy_pattern_id','lyt_epa_data_1',10,'string','combo','Price pattern:','Price pattern',false,false,true,false,false,'SELECT pattern_id as id, pattern_id as idval FROM ve_inp_pattern WHERE pattern_id is not null','{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','pattern_id','lyt_epa_data_1',4,'string','combo','Pattern:','Pattern',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','flow_max','lyt_epa_data_2',2,'string','text','Max flow:','Max Flow',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','flow_min','lyt_epa_data_2',3,'string','text','Min flow:','Min Flow',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','vel_max','lyt_epa_data_2',4,'string','text','Max velocity:','Max velocity',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','vel_min','lyt_epa_data_2',5,'string','text','Min velocity:','Min velocity',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','add_to_dscenario','lyt_epa_dsc_1',1,'button',false,false,false,false,false,'{"icon":"113"}'::json,'{"saveValue": false}'::json,'{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pump",
    "tablename": "v_edit_inp_dscenario_pump",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pump", "view": "v_edit_inp_dscenario_pump", "add_view": "v_edit_inp_dscenario_pump", "pk": ["dscenario_id", "node_id"]}
   ]
 , "add_dlg_title":"Pump" }
}'::json,'tbl_inp_dscenario_pump',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','edit_dscenario','lyt_epa_dsc_1',3,'button',false,false,true,false,false,'{"icon":"101"}'::json,'{"saveValue":false, "onContextMenu":"Edit dscenario"}'::json,'{
  "functionName": "edit_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pump",
    "tablename": "v_edit_inp_dscenario_pump",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pump", "view": "v_edit_inp_dscenario_pump", "add_view": "v_edit_inp_dscenario_pump", "pk": ["dscenario_id", "node_id"]}
   ]
 , "add_dlg_title":"Pump" }
}'::json,'tbl_inp_dscenario_pump',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','curve_id','lyt_epa_data_1',2,'string','combo','Curve id:','Curve id',false,false,true,false,false,'SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL AND curve_type IN (''PUMP'', ''PUMP1'', ''PUMP2'', ''PUMP3'', ''PUMP4'')',true,true,'{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frpump','form_feature','tab_epa','to_arc','lyt_epa_data_1',6,'string','text','To arc:','To arc',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);

-- 06/08/2025
UPDATE config_form_list SET query_text='SELECT dscenario_id, valve_type, diameter, setting, curve_id, minorloss, status, init_quality FROM ve_inp_dscenario_virtualvalve WHERE arc_id IS NOT NULL' WHERE listname='tbl_inp_dscenario_virtualvalve' AND device=4;
UPDATE config_form_list SET query_text='SELECT dscenario_id AS id, arc_id, valve_type, diameter, setting, curve_id, minorloss, status FROM inp_dscenario_virtualvalve where dscenario_id is not null' WHERE listname='dscenario_virtualvalve' AND device=5;
UPDATE config_form_list SET query_text='SELECT dscenario_id AS id, node_id, valve_type, setting, curve_id, minorloss, status, add_settings, init_quality FROM inp_dscenario_valve where dscenario_id is not null' WHERE listname='dscenario_valve' AND device=5;
UPDATE config_form_list SET query_text='SELECT dscenario_id, node_id, nodarc_id, valve_type, setting, curve_id, minorloss, status, add_settings, init_quality FROM ve_inp_dscenario_valve WHERE node_id IS NOT NULL' WHERE listname='tbl_inp_dscenario_valve' AND device=4;

DELETE FROM config_form_fields WHERE formname='inp_dscenario_valve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='inp_dscenario_valve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='inp_dscenario_valve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_inp_dscenario_valve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_dscenario_valve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_dscenario_valve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_valve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_valve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_valve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_virtualvalve' AND formtype='form_feature' AND columnname='flow' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_virtualvalve' AND formtype='form_feature' AND columnname='coef_loss' AND tabname='tab_none';
DELETE FROM config_form_fields WHERE formname='ve_inp_virtualvalve' AND formtype='form_feature' AND columnname='pressure' AND tabname='tab_none';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_inp_virtualvalve', 'form_feature', 'tab_none', 'setting', 'lyt_data_1', 16, 'double', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_inp_valve', 'form_feature', 'tab_none', 'setting', 'lyt_data_1', 14, 'double', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_inp_dscenario_virtualvalve', 'form_feature', 'tab_none', 'setting', 'lyt_data_1', 6, 'double', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_inp_dscenario_valve', 'form_feature', 'tab_none', 'setting', NULL, 5, 'double', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_virtualvalve', 'form_feature', 'tab_epa', 'setting', 'lyt_epa_data_1', 3, 'string', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'setting', 'lyt_epa_data_1', 3, 'string', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_frvalve', 'form_feature', 'tab_epa', 'setting', 'lyt_epa_data_1', 3, 'string', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_virtualvalve', 'form_feature', 'tab_none', 'setting', 'lyt_data_1', 6, 'double', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_valve', 'form_feature', 'tab_none', 'setting', NULL, 5, 'double', 'text', 'Setting:', 'Setting:', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

UPDATE config_form_fields SET ismandatory=true WHERE  formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';

UPDATE config_param_system SET value='{"status":true, "values":[
{"sourceTable":"ve_node_tank", "query":"UPDATE inp_inlet t SET maxlevel = hmax, diameter=sqrt(4*area/3.14159) FROM ve_node_tank s "},
{"sourceTable":"ve_node_pr_reduc_valve", "query":"UPDATE inp_valve t SET setting = pressure_exit FROM ve_node_pr_reduc_valve s "}]}'
WHERE parameter = 'epa_automatic_man2inp_values';

UPDATE config_param_system SET value='{"status":true, "values":[
{"sourceTable":"ve_node_pr_reduc_valve", "query":"UPDATE presszone t SET head=top_elev + pressure_exit FROM ve_node_pr_reduc_valve s "},
{"sourceTable":"ve_node_tank", "query":"UPDATE presszone t SET head=top_elev + hmax/2  FROM ve_node_tank s "}]}'
WHERE parameter = 'epa_automatic_man2graph_values';


-- 06/08/2025
-- Add brand and model to ve_node, ve_arc, ve_connec, ve_element, ve_frelem, ve_genelem
  -- Existing ones
    -- Brand_id
UPDATE config_form_fields SET dv_querytext = NULL, label = 'Brand', isparent = false, isautoupdate = false, widgetcontrols = '{"setMultiline":false}'::json
WHERE columnname = 'brand_id' AND formtype = 'form_feature' AND tabname = 'tab_data';

DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='brand_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;

    -- Model_id
UPDATE config_form_fields SET dv_querytext = NULL, label = 'Model', isparent = false, isautoupdate = false, widgetcontrols = '{"setMultiline":false}'::json
WHERE columnname = 'model_id' AND formtype = 'form_feature' AND tabname = 'tab_data';

DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='model_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand_model WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;

 -- New ones
    -- brand_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT DISTINCT formname, formtype, tabname FROM config_form_fields cff WHERE formname ILIKE ANY (ARRAY['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
      AND tabname = 'tab_data' AND formtype = 'form_feature' AND NOT EXISTS (SELECT 1 FROM config_form_fields cff2 WHERE cff2.formname = cff.formname AND cff2.formtype = cff.formtype
      AND cff2.tabname = cff.tabname AND cff2.columnname = 'brand_id')
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');

    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden) VALUES
    (rec.formname, rec.formtype, rec.tabname, 'brand_id', 'lyt_data_2', v_layoutorder, 'text', 'combo', 'Brand id', 'brand_id', false, false, true, false, v_dv_querytext, false);
  END LOOP;
END $$;

    -- model_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT DISTINCT formname, formtype, tabname FROM config_form_fields cff WHERE formname ILIKE ANY (ARRAY['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
      AND tabname = 'tab_data' AND formtype = 'form_feature' AND NOT EXISTS (SELECT 1 FROM config_form_fields cff2 WHERE cff2.formname = cff.formname AND cff2.formtype = cff.formtype
      AND cff2.tabname = cff.tabname AND cff2.columnname = 'model_id')
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand_model WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');

    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden) VALUES
    (rec.formname, rec.formtype, rec.tabname, 'model_id', 'lyt_data_2', v_layoutorder, 'text', 'combo', 'Model id', 'model_id', false, false, true, false, v_dv_querytext, false);
  END LOOP;
END $$;

  -- Elements
    -- ve_frelem
      -- evalve
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EVALVE'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_evalve','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EVALVE'' = ANY(featurecat_id::text[])');

      -- epump
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_epump','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EPUMP'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_epump','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EPUMP'' = ANY(featurecat_id::text[])');


UPDATE config_form_fields SET layoutorder=15 WHERE formname ILIKE 've_frelem_%' AND formtype='form_feature' AND columnname='rotation' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=16 WHERE formname ILIKE 've_frelem_%' AND formtype='form_feature' AND columnname='top_elev' AND tabname='tab_data';

    -- ve_genelem
      -- ecover
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_ecover','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''COVER'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_ecover','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''COVER'' = ANY(featurecat_id::text[])');

      -- ehydrant_plate
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
    VALUES ('ve_frelem_ehydrant_plate','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''HYDRANT_PLATE'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_ehydrant_plate','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''HYDRANT_PLATE'' = ANY(featurecat_id::text[])');

      -- emanhole
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_emanhole','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''MANHOLE'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_emanhole','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''MANHOLE'' = ANY(featurecat_id::text[])');

      -- eprotect_band
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eprotect_band','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EPROTECT_BAND'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eprotect_band','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EPROTECT_BAND'' = ANY(featurecat_id::text[])');

      -- eregister
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eregister','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EREGISTER'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eregister','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EREGISTER'' = ANY(featurecat_id::text[])');

      -- estep
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_estep','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''ESTEP'' = ANY(featurecat_id::text[]) ');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_estep','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''ESTEP'' = ANY(featurecat_id::text[])');

UPDATE config_form_fields SET layoutorder=14 WHERE formname ILIKE 've_genelem_%' AND formtype='form_feature' AND columnname='rotation' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=15 WHERE formname ILIKE 've_genelem_%' AND formtype='form_feature' AND columnname='top_elev' AND tabname='tab_data';


-- Generate base element
DELETE FROM config_form_fields WHERE formname = 've_element';
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',false,false,true,false,'{"setMultiline":true}'::json,true);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',false,false,true,false,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',false,false,true,false,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',false,false,true,false,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
	VALUES ('ve_element','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''GENELEM'' = ANY(featurecat_id::text[])', false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
	VALUES ('ve_element','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''GENELEM'' = ANY(featurecat_id::text[])',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation','Rotation',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top Elevation','Top Elevation',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_element','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',false,false,true,false,'{"setMultiline":true}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',true,false,true,false,'SELECT id, id as idval FROM cat_element WHERE element_type = ''ECOVER''',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',false,false,false,false,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_element','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
  "icon": "111"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
  "icon": "112"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
  "icon": "137"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "selection_init"
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
  "icon": "178"
}'::json,'{
  "saveValue": false
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json,'tbl_element_x_arc',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json,'tbl_element_x_connec',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json,'tbl_element_x_gully',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json,'tbl_element_x_link',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json,'tbl_element_x_node',false);



-- last update
-- Normalize "label": replace underscores with spaces, trim, ensure only the first letter is uppercase,
-- and append a colon if missing. Only updates rows needing changes.
ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
UPDATE config_form_fields
SET "label" =
    UPPER(LEFT(cleaned, 1)) ||
    SUBSTRING(cleaned FROM 2) ||
    CASE WHEN RIGHT(cleaned, 1) = ':' THEN '' ELSE ':' END
FROM (
    SELECT
        formname, formtype, columnname, tabname,
        TRIM(
            regexp_replace(
                regexp_replace(replace("label", '_', ' '), '\s+', ' ', 'g'),
                '\s+$', '', 'g'
            )
        ) AS cleaned
    FROM config_form_fields
) AS sub
WHERE config_form_fields.formname   = sub.formname
  AND config_form_fields.formtype   = sub.formtype
  AND config_form_fields.columnname = sub.columnname
  AND config_form_fields.tabname    = sub.tabname
  AND "label" IS NOT NULL
  AND (
        LEFT("label", 1) <> UPPER(LEFT("label", 1))
     OR RIGHT(sub.cleaned, 1) <> ':'
  );
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

UPDATE config_param_system
SET "label" =
    UPPER(LEFT(cleaned, 1)) ||
    SUBSTRING(cleaned FROM 2) ||
    CASE WHEN RIGHT(cleaned, 1) = ':' THEN '' ELSE ':' END
FROM (
    SELECT
        "parameter",
        TRIM(
            regexp_replace(
                regexp_replace(replace("label", '_', ' '), '\s+', ' ', 'g'),
                '\s+$', '', 'g'
            )
        ) AS cleaned
    FROM config_param_system
) AS sub
WHERE config_param_system."parameter" = sub."parameter"
  AND "label" IS NOT NULL
  AND (
        LEFT("label", 1) <> UPPER(LEFT("label", 1))
     OR RIGHT(sub.cleaned, 1) <> ':'
  );

UPDATE sys_fprocess SET except_msg='values of roughness out of range acording headloss formula used' WHERE fid=377;

UPDATE config_form_fields SET "datatype"='string', widgettype='combo', ismandatory=false, iseditable=false, dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE ((featurecat_id is null AND feature_type=''NODE'') ) AND active IS TRUE  OR ''WATER_CONNECTION'' = ANY(featurecat_id::text[])', dv_isnullvalue=true WHERE formname ILIKE '%ve_link%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DELETE FROM config_form_fields WHERE formname ILIKE '%ve_link%' AND formtype='form_feature' AND columnname='n_hydrometer' AND tabname='tab_none';


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4338, 'Water balance is not allowed having surpassed the threshold day limiter (parameter om_waterbalance_threshold_days)', null, 0, true, 'utils', 'core', 'AUDIT');

-- 08/08/2025
-- new layouts
INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_element_dscenario_1', 'lyt_element_dscenario_3', 'layoutElemDscenario1', '{"lytOrientation": "horizontal"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_element_dscenario_2', 'lyt_element_dscenario_3', 'layoutElemDscenario2', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_element_dscenario_3', 'lyt_element_dscenario_3', 'layoutElemDscenario3', '{"lytOrientation": "horizontal"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_elem_dsc_orifice', 'lyt_elem_dsc_orifice', 'layoutElemDscOrifice', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_elem_dsc_outlet', 'lyt_elem_dsc_outlet', 'layoutElemDscOutlet', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_elem_dsc_pump', 'lyt_elem_dsc_pump', 'layoutElemDscPump', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_elem_dsc_weir', 'lyt_elem_dsc_weir', 'layoutElemDscWeir', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_elem_dsc_valve', 'lyt_elem_dsc_valve', 'layoutElemDscValve', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_elem_dsc_shortpipe', 'lyt_elem_dsc_shortpipe', 'layoutElemDscShortpipe', '{"lytOrientation": "vertical"}'::json);

-- buttons
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_elements', 'insert_frelem_dscenario', 'lyt_element_dscenario_1', 1, NULL, 'button', NULL, 'Insert frelem into dscenario', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{
  "saveValue": false,
  "filterSign": "=",
  "onContextMenu": "Insert into dscenario"
}'::json, '{
  "functionName": "add_frelem_to_dscenario",
  "module": "info",
  "parameters": {
    "columnfind": "element_id",
    "sourcewidget": "tab_elements_tbl_elements"
  }
}'::json, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_elements', 'delete_from_dscenario', 'lyt_element_dscenario_1', 2, NULL, 'button', NULL, 'Remove frelem from dscenario', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{
  "saveValue": false,
  "filterSign": "=",
  "onContextMenu": "Remove from dscenario"
}'::json, '{
  "functionName": "remove_frelem_from_dscenario",
  "module": "info",
  "parameters": {
    "columnfind": ["element_id", "dscenario_id", "node_id"]
  }
}'::json, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_elements', 'hspacer_lyt_dsc_1', 'lyt_element_dscenario_1', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

-- frelem dscenario tableviews
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_elements', 'tbl_frelem_dsc_pump', 'lyt_elem_dsc_pump', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_frelem_dsc_pump', false, NULL);

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_elements', 'tbl_frelem_dsc_valve', 'lyt_elem_dsc_valve', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_frelem_dsc_valve', false, NULL);

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_elements', 'tbl_frelem_dsc_shortpipe', 'lyt_elem_dsc_shortpipe', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_frelem_dsc_shortpipe', false, NULL);


-- tables
INSERT INTO config_form_list
(listname, query_text, device, listtype, listclass, vdefault, addparam)
VALUES('tbl_frelem_dsc_pump', 'SELECT * FROM ve_inp_dscenario_frpump WHERE element_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

INSERT INTO config_form_list
(listname, query_text, device, listtype, listclass, vdefault, addparam)
VALUES('tbl_frelem_dsc_valve', 'SELECT * FROM ve_inp_dscenario_frvalve WHERE element_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);


INSERT INTO config_form_list
(listname, query_text, device, listtype, listclass, vdefault, addparam)
VALUES('tbl_frelem_dsc_shortpipe','SELECT * FROM ve_inp_dscenario_frshortpipe WHERE element_id IS NOT NULL',4,'tab','list',NULL,NULL);


-- config_from_tableview
INSERT INTO config_form_tableview
(location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'dscenario_id', 1, true, NULL, 'Dscenario id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'element_id', 2, true, NULL, 'Element id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'node_id', 3, true, NULL, 'Node id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'power', 4, true, NULL, 'Power', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'curve_id', 5, true, NULL, 'Curve id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'speed', 6, true, NULL, 'Speed', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'pattern_id', 7, true, NULL, 'Pattern id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'effic_curve_id', 8, true, NULL, 'Effic curve id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'energy_price', 9, true, NULL, 'Energy price', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'energy_pattern_id', 10, true, NULL, 'Energy pattern id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'status', 11, true, NULL, 'Status', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_pump', 'the_geom', 12, false, NULL, 'the_geom', NULL, NULL);

-- config_from_tableview
INSERT INTO config_form_tableview
(location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'dscenario_id', 1, true, NULL, 'Dscenario id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'element_id', 2, true, NULL, 'Element id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'node_id', 3, true, NULL, 'Node id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'valve_type', 4, true, NULL, 'Valve type', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'custom_dint', 5, true, NULL, 'Custom dint', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'setting', 6, true, NULL, 'Setting', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'curve_id', 7, true, NULL, 'Curve id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'minorloss', 8, true, NULL, 'Minorloss', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'add_settings', 9, true, NULL, 'Add settings', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'init_quality', 10, true, NULL, 'Init quality', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_valve', 'the_geom', 11, false, NULL, 'the_geom', NULL, NULL);

INSERT INTO config_form_tableview
(location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'dscenario_id', 1, true, NULL, 'Dscenario id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'element_id', 2, true, NULL, 'Element id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'node_id', 3, true, NULL, 'Node id', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'minorloss', 4, true, NULL, 'Minorloss', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'bulk_coeff', 5, true, NULL, 'Bulk coeff', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'wall_coeff', 6, true, NULL, 'Wall coeff', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'custom_dint', 7, true, NULL, 'Custom dint', NULL, NULL),
('feature form', 'ws', 'tbl_frelem_dsc_shortpipe', 'the_geom', 8, false, NULL, 'the_geom', NULL, NULL);

-- 08/08/2025
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID:', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type:', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID:', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type:', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2);

UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::text, 'v_edit_', 've_')::json WHERE widgetcontrols::text ilike '%v_edit_%';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"plan_psector_x_connec", "column":"active", "dataType":"boolean"}}$$);

DELETE FROM sys_table WHERE id = 'v_value_cat_connec';
DELETE FROM sys_table WHERE id = 'v_value_cat_node';

-- config_form_fields inp_dscenario_frpump
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'power', 'lyt_main_1', 3, 'string', 'text', 'Power:', 'Power', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'curve_id', 'lyt_main_1', 4, 'string', 'combo', 'Curve id:', 'Curve id', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type IN (''PUMP'', ''PUMP1'', ''PUMP2'', ''PUMP3'', ''PUMP4'')', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'speed', 'lyt_main_1', 5, 'numeric', 'text', 'Speed:', 'Speed', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'pattern_id', 'lyt_main_1', 6, 'string', 'combo', 'Pattern id:', 'Pattern id', NULL, false, NULL, true, NULL, false, 'SELECT pattern_id as id, pattern_id as idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'status', 'lyt_main_1', 7, 'string', 'combo', 'Status:', 'Status', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_status_pump''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'effic_curve_id', 'lyt_main_1', 8, 'string', 'combo', 'Eff. curve:', 'Eff. curve', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type = ''EFFICIENCY''', true, true, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'energy_price', 'lyt_main_1', 9, 'double', 'text', 'Energy price:', 'Energy price', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frpump', 'form_feature', 'tab_none', 'energy_pattern_id', 'lyt_main_1', 10, 'string', 'combo', 'Price pattern:', 'Price pattern', NULL, false, NULL, true, NULL, false, 'SELECT pattern_id as id, pattern_id as idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

-- config_form_fields inp_dscenario_frvalve
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'valve_type', 'lyt_main_1', 3, 'string', 'combo', 'Valve type:', 'Valve type', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_typevalue_valve''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'custom_dint', 'lyt_main_1', 4, 'numeric', 'text', 'Custom dint:', 'Custom dint', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'setting', 'lyt_main_1', 5, 'numeric', 'text', 'Setting:', 'Setting', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'curve_id', 'lyt_main_1', 6, 'string', 'combo', 'Curve id:', 'Curve id', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'minorloss', 'lyt_main_1', 7, 'numeric', 'text', 'Minorloss:', 'Minorloss', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'add_settings', 'lyt_main_1', 8, 'double', 'text', 'Add settings:', 'Add settings', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'init_quality', 'lyt_main_1', 9, 'double', 'text', 'Init quality:', 'Init quality', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL);

-- config_form_fields inp_dscenario_frshortpipe
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('inp_dscenario_frshortpipe', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frshortpipe', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frshortpipe', 'form_feature', 'tab_none', 'minorloss', 'lyt_main_1', 4, 'numeric', 'text', 'Minorloss:', 'Minorloss', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frshortpipe', 'form_feature', 'tab_none', 'status', 'lyt_main_1', 7, 'string', 'combo', 'Status:', 'Status', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_status_shortpipe_dscen''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('inp_dscenario_frshortpipe', 'form_feature', 'tab_none', 'bulk_coeff', 'lyt_main_1', 5, 'numeric', 'text', 'Bulk coeff:', 'Bulk coeff', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL),
('inp_dscenario_frshortpipe', 'form_feature', 'tab_none', 'wall_coeff', 'lyt_main_1', 5, 'numeric', 'text', 'Wall coeff:', 'Wall coeff', NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, NULL, false, NULL);

UPDATE sys_table
	SET addparam='{"pkey": "dscenario_id, element_id"}'::json
	WHERE id IN ('inp_dscenario_frpump', 'inp_dscenario_frvalve', 've_inp_dscenario_frpump', 've_inp_dscenario_frvalve');


update sys_param_user set dv_querytext= 'SELECT cat_link.id, cat_link.id AS idval FROM cat_link' where id ='edit_linkcat_vdefault';
delete from sys_param_user where id = 'edit_connec_linkcat_vdefault';
update sys_param_user set id = 'edit_connec_linkcat_vdefault' where id = 'edit_linkcat_vdefault';

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRSHORTPIPE', 'ELEMENT', 'inp_frshortpipe', NULL, true);

INSERT INTO cat_feature (id,feature_class,feature_type,parent_layer,child_layer,code_autofill,active) VALUES ('EMETER','FRELEM','ELEMENT','ve_element','ve_element_emeter',true,true);

-- FRSHORTPIPE
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','to_arc','lyt_epa_data_1',3,'string','text','To arc:','To arc',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','add_to_dscenario','lyt_epa_dsc_1',1,'button',false,false,false,false,false,'{"icon":"113"}'::json,'{"saveValue": false}'::json,'{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_frshortpipe",
    "tablename": "ve_inp_dscenario_frshortpipe",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_frshortpipe", "view": "ve_inp_dscenario_frshortpipe", "add_view": "ve_inp_dscenario_frshortpipe", "pk": ["dscenario_id", "node_id"]}
   ]
, "add_dlg_title":"Shortpipe"   }
}'::json,'tbl_inp_dscenario_frshortpipe',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','edit_dscenario','lyt_epa_dsc_1',3,'button',false,false,true,false,false,'{"icon":"101"}'::json,'{"saveValue":false, "onContextMenu":"Edit dscenario"}'::json,'{
  "functionName": "edit_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_frshortpipe",
    "tablename": "ve_inp_dscenario_frshortpipe",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_frshortpipe", "view": "ve_inp_dscenario_frshortpipe", "add_view": "ve_inp_dscenario_frshortpipe", "pk": ["dscenario_id", "node_id"]}
   ]
, "add_dlg_title":"Shortpipe"   }
}'::json,'tbl_inp_dscenario_frshortpipe',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','remove_from_dscenario','lyt_epa_dsc_1',2,'button',false,false,false,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "onContextMenu":"Delete dscenario"}'::json,'{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_frshortpipe",
    "tablename": "ve_inp_dscenario_frshortpipe",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_frshortpipe", "view": "ve_inp_dscenario_frshortpipe", "add_view": "ve_inp_dscenario_frshortpipe", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json,'tbl_inp_dscenario_frshortpipe',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','tbl_inp_shortpipe','lyt_epa_dsc_3',1,'tableview',false,false,false,false,false,'{"saveValue": false, "tableUpsert":"ve_inp_dscenario_frshortpipe"}'::json,'tbl_inp_dscenario_frshortpipe',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','nodarc_id','lyt_epa_data_1',1,'string','text','Nodarc id:','Nodarc id',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','minorloss','lyt_epa_data_1',2,'string','text','Minorloss:','Minorloss',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','wall_coeff','lyt_epa_data_1',6,'string','text','Wall coefficient:','Wall coefficient',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','result_id','lyt_epa_data_2',1,'string','text','Result id:','Result id',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','headloss_max','lyt_epa_data_2',8,'string','text','Max headloss:','Max headloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','headloss_min','lyt_epa_data_2',9,'string','text','Min uheadloss:','Max uheadloss',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','setting_max','lyt_epa_data_2',12,'string','text','Max setting:','Max setting',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','setting_min','lyt_epa_data_2',13,'string','text','Min setting:','Min setting',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','reaction_max','lyt_epa_data_2',14,'string','text','Max reaction:','Max reaction',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','reaction_min','lyt_epa_data_2',15,'string','text','Min reaction:','Min reaction',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','ffactor_max','lyt_epa_data_2',16,'string','text','Max Ffactor:','Max Ffactor',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','ffactor_min','lyt_epa_data_2',17,'string','text','Min Ffactor:','Min Ffactor',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','bulk_coeff','lyt_epa_data_1',5,'string','text','Buk coefficient:','Buk coefficient',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','hspacer_epa_1','lyt_epa_dsc_1',4,'hspacer',false,false,false,false,false,'{"saveValue": false}'::json,'tbl_inp_dscenario_frshortpipe',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','cat_dint','lyt_epa_data_1',7,'string','text','Cat dint:','Cat dint',false,false,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','custom_dint','lyt_epa_data_1',8,'string','text','Custom dint:','Custom dint',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','flow_max','lyt_epa_data_2',2,'string','text','Max flow:','Max Flow',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','flow_min','lyt_epa_data_2',3,'string','text','Min flow:','Min Flow',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','vel_max','lyt_epa_data_2',5,'string','text','Max velocity:','Max velocity',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','vel_min','lyt_epa_data_2',6,'string','text','Min velocity:','Min velocity',false,false,false,false,false,'{"filterSign":"ILIKE"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden)
	VALUES ('ve_epa_frshortpipe','form_feature','tab_epa','status','lyt_epa_data_1',4,'string','text','Status:','Status',false,false,false,false,false,'{"setMultiline":false}'::json,false);


INSERT INTO cat_element (id,element_type,active) VALUES ('EMETER-01','EMETER',true);
-- 08/08/2025
DELETE FROM config_form_fields WHERE formname ILIKE '%elem%' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_element';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_feature_element';

-- Config_form_fields
DO $$
DECLARE
  rec record;
BEGIN
-- frelem
  FOR rec IN (SELECT * FROM config_form_fields WHERE formname ILIKE '%frelem_%')
  LOOP
    UPDATE config_form_fields SET formname = replace(rec.formname, 'frelem', 'element') WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND columnname = rec.columnname;
  END LOOP;
  -- genelem
  FOR rec IN (SELECT * FROM config_form_fields WHERE formname ILIKE '%genelem_%')
  LOOP
    UPDATE config_form_fields SET formname = replace(rec.formname, 'genelem', 'element') WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND columnname = rec.columnname;
  END LOOP;
END $$;

-- cat_feature
UPDATE cat_feature SET parent_layer = 've_element' WHERE feature_type = 'ELEMENT';
DO $$
DECLARE
  rec record;
BEGIN
  FOR rec IN (SELECT * FROM cat_feature WHERE feature_type = 'ELEMENT')
  LOOP
    UPDATE cat_feature SET child_layer = 've_element_' || lower(rec.id) WHERE id = rec.id;
  END LOOP;
END $$;

-- config_form_tabs
UPDATE config_form_tabs SET formname = 've_element' WHERE formname = 've_frelem' AND tabname = 'tab_documents';
DELETE FROM config_form_tabs WHERE (formname = 've_genelem' AND (tabname = 'tab_epa' OR tabname = 'tab_documents')) OR (formname = 've_frelem' AND (tabname = 'tab_documents' OR tabname = 'tab_features'));

DO $$
DECLARE
  rec record;
BEGIN
  FOR rec IN (SELECT * FROM config_form_tabs WHERE formname = 've_frelem')
  LOOP
    UPDATE config_form_tabs SET formname = replace(rec.formname, 'frelem', 'man_frelem') WHERE formname = rec.formname AND tabname = rec.tabname;
  END LOOP;
  FOR rec IN (SELECT * FROM config_form_tabs WHERE formname = 've_genelem')
  LOOP
    UPDATE config_form_tabs SET formname = replace(rec.formname, 'genelem', 'man_genelem') WHERE formname = rec.formname AND tabname = rec.tabname;
  END LOOP;
END $$;

UPDATE config_form_tabs
	SET tabactions='[{"actionName": "actionEdit", "disabled": false}]'::json
	WHERE formname='ve_element' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET tabactions='[{"actionName": "actionEdit", "disabled": false}]'::json
	WHERE formname='ve_man_frelem' AND tabname='tab_epa';

-- Editable, datatype and mandatory fields for frelemnts
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true
	WHERE formname='ve_element_epump' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true,"datatype"='integer'
	WHERE formname='ve_element_eorifice' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true,"datatype"='integer'
	WHERE formname='ve_element_eoutlet' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true,"datatype"='integer'
	WHERE formname='ve_element_eweir' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';

-- Update element_id in config_form_fields
UPDATE config_form_fields
	SET widgetfunction='{"functionName":"open_selected_manager_item", "parameters":{"columnfind":"element_id", "elem_manager": true, "sourcetable": "v_ui_element"}}'::json
	WHERE formname='element_manager' AND formtype='form_element' AND columnname='tbl_element' AND tabname='tab_none';

-- 12/08/2025
DELETE FROM config_form_fields WHERE formname ILIKE '%element%' AND formtype='form_feature' AND columnname='order_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=4 WHERE formname ILIKE '%element%' AND formtype='form_feature'AND tabname='tab_data' AND columnname='expl_id' AND layoutorder=5;
UPDATE config_form_fields
	SET layoutorder=3
	WHERE formname='ve_element_epump' AND formtype='form_feature' AND columnname='flwreg_length' AND tabname='tab_data';
UPDATE config_form_fields
	SET layoutorder=2
	WHERE formname='ve_element_epump' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES
  ('man_pump_pump_type', '0', 'UNKNOWN', NULL, NULL),
  ('man_pump_pump_type', '1', 'SUBMERSIBLE', NULL, NULL),
  ('man_pump_pump_type', '2', 'SURFACE', NULL, NULL),
  ('man_pump_pump_type', '3', 'DRY WELL', NULL, NULL),
  ('man_pump_engine_type', '0', 'UNKNOWN', NULL, NULL),
  ('man_pump_engine_type', '1', 'ELECTRIC', NULL, NULL),
  ('man_pump_engine_type', '2', 'COMBUSTION', NULL, NULL),
  ('man_pump_engine_type', '3', 'COMBINED', NULL, NULL)
ON CONFLICT (typevalue, id) DO NOTHING;


INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('edit_typevalue', 'man_pump_pump_type', 'man_pump', 'pump_type', NULL, true)
ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('edit_typevalue', 'man_pump_engine_type', 'man_pump', 'engine_type', NULL, true)
ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

DO $$
DECLARE
  rec record;
BEGIN
  FOR rec IN (SELECT child_layer FROM cat_feature WHERE feature_class = 'PUMP')
  LOOP
    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder,
    "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
    dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
    stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES(rec.child_layer, 'form_feature', 'tab_data', 'pump_type', 'lyt_data_2', (SELECT max(layoutorder) + 1 AS layoutorder FROM config_form_fields WHERE formname = rec.child_layer AND tabname = 'tab_data' AND layoutname = 'lyt_data_2'),
    'integer', 'combo', 'Pump Type:', 'Pump Type', NULL, false, false, true, false, NULL,
    'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_pump_pump_type''', true, false, NULL, NULL,
    NULL, NULL, NULL, NULL, true, NULL)
    ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
    layoutorder = EXCLUDED.layoutorder,
    datatype = EXCLUDED.datatype,
    widgettype = EXCLUDED.widgettype,
    label = EXCLUDED.label,
    dv_querytext = EXCLUDED.dv_querytext,
    dv_orderby_id = EXCLUDED.dv_orderby_id,
    dv_isnullvalue = EXCLUDED.dv_isnullvalue,
    dv_parent_id = EXCLUDED.dv_parent_id,
    dv_querytext_filterc = EXCLUDED.dv_querytext_filterc,
    hidden = EXCLUDED.hidden;


    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder,
    "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
    dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
    stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES(rec.child_layer, 'form_feature', 'tab_data', 'engine_type', 'lyt_data_2', (SELECT max(layoutorder) + 1 AS layoutorder FROM config_form_fields WHERE formname = rec.child_layer AND tabname = 'tab_data' AND layoutname = 'lyt_data_2'),
    'integer', 'combo', 'Engine Type:', 'Engine Type', NULL, false, false, true, false, NULL,
    'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_pump_engine_type''', true, false, NULL, NULL,
    NULL, NULL, NULL, NULL, true, NULL)
    ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
    layoutorder = EXCLUDED.layoutorder,
    datatype = EXCLUDED.datatype,
    widgettype = EXCLUDED.widgettype,
    label = EXCLUDED.label,
    dv_querytext = EXCLUDED.dv_querytext,
    dv_orderby_id = EXCLUDED.dv_orderby_id,
    dv_isnullvalue = EXCLUDED.dv_isnullvalue,
    dv_parent_id = EXCLUDED.dv_parent_id,
    dv_querytext_filterc = EXCLUDED.dv_querytext_filterc,
    hidden = EXCLUDED.hidden;
  END LOOP;
END $$;

DO $$
DECLARE
  rec record;
BEGIN
  FOR rec IN (SELECT child_layer FROM cat_feature WHERE feature_class = 'METER')
  LOOP
    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder,
    "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
    dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
    stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES(rec.child_layer, 'form_feature', 'tab_data', 'nominal_flowrate', 'lyt_data_2', (SELECT max(layoutorder) + 1 AS layoutorder FROM config_form_fields WHERE formname = rec.child_layer AND tabname = 'tab_data' AND layoutname = 'lyt_data_2'),
    'numeric', 'text', 'Nominal Flowrate:', 'Nominal Flowrate:', NULL, false, false, true, false, NULL,
    NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, true, NULL)
    ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
    layoutorder = EXCLUDED.layoutorder,
    datatype = EXCLUDED.datatype,
    widgettype = EXCLUDED.widgettype,
    label = EXCLUDED.label,
    dv_querytext = EXCLUDED.dv_querytext,
    dv_orderby_id = EXCLUDED.dv_orderby_id,
    dv_isnullvalue = EXCLUDED.dv_isnullvalue,
    dv_parent_id = EXCLUDED.dv_parent_id,
    dv_querytext_filterc = EXCLUDED.dv_querytext_filterc,
    hidden = EXCLUDED.hidden;
  END LOOP;
END $$;

DO $$
DECLARE
  rec record;
BEGIN
  FOR rec IN (SELECT child_layer FROM cat_feature WHERE feature_class = 'WTP')
  LOOP
    UPDATE config_form_fields SET columnname = 'chemical' WHERE formname = rec.child_layer AND columnname = 'chemcond';
    DELETE FROM config_form_fields WHERE formname = rec.child_layer AND columnname = 'chemtreatment';
  END LOOP;
END $$;
UPDATE config_info_layer
	SET orderby=6
	WHERE layer_id='ve_dimensions';
UPDATE config_info_layer
	SET orderby=5
	WHERE layer_id='ve_arc';

DELETE FROM config_form_fields WHERE formname ILIKE 've_element%' AND formtype='form_feature' AND columnname='tbl_element_x_gully' AND tabname='tab_features';

-- Add tab_documents for emeter
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_element_emeter','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_element_emeter','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_element_emeter','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_element_emeter','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_element_emeter','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_element_emeter','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_element_emeter','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_element_emeter','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
	VALUES ('ve_element_emeter','form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json,'tbl_doc_x_element',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
	VALUES ('ve_element_emeter','form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json,'tbl_doc_x_element',false,4);

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=1, alias='Node features' WHERE id='ve_cat_feature_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=2, alias='Arc features' WHERE id='ve_cat_feature_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=3, alias='Connec features' WHERE id='ve_cat_feature_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=4, alias='Link features' WHERE id='ve_cat_feature_link';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=5, alias='Element features' WHERE id='ve_cat_feature_element';

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=6, alias='Node catalog' WHERE id='cat_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=7, alias='Arc catalog' WHERE id='cat_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=8, alias='Connec catalog' WHERE id='cat_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=9, alias='Link catalog' WHERE id='cat_link';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=10, alias='Element catalog' WHERE id='cat_element';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context='{"levels": ["INVENTORY", "CATALOGS"]}', orderby=11, alias='Material catalog' WHERE id='cat_material';


INSERT INTO sys_label (id, idval, label_type) 
VALUES(3013, 'To check CRITICAL ERRORS or WARNINGS, execute a query FROM anl_table WHERE fid=error number AND current_user. For example:

SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;

Only the errors with anl_table next to the number can be checked this way. Using Giswater Toolbox it''s also posible to check these errors.', 'header');
