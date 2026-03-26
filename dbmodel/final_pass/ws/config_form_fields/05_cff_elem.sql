/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,dv_parent_id,dv_querytext_filterc,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder) VALUES
	 ('ve_element','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,5),
	 ('ve_element','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_element','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,7),
	 ('ve_element','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_element','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,11),
	 ('ve_element','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_element','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''GENELEM'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,16),
	 ('ve_element','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,17),
	 ('ve_element','form_feature','tab_data','model_id','lyt_data_1',15,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''GENELEM'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,19),
	 ('ve_element','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,20),
	 ('ve_element','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,22),
	 ('ve_element','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''ECOVER''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_ecover','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_ecover','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_ecover','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_ecover','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,5),
	 ('ve_element_ecover','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_element_ecover','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,7),
	 ('ve_element_ecover','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_ecover','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_element_ecover','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_ecover','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,11),
	 ('ve_element_ecover','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_ecover','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_element_ecover','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_ecover','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_ecover','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''COVER'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,16),
	 ('ve_element_ecover','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''COVER'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,17),
	 ('ve_element_ecover','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element_ecover','form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_element_ecover','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,20),
	 ('ve_element_ecover','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element_ecover','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,22),
	 ('ve_element_ecover','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''ECOVER''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_ecover','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_ecover','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_ecover','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_ecover','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_ecover','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_ecover','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_ecover','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_ecover','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_ecover','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_ecover','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_ecover','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "111"
    }','{
    "saveValue": false
    }','{
    "functionName": "insert_feature",
    "parameters": {
        "targetwidget": "tab_features_feature_id"
    }
    }',NULL,false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "112"
    }','{
    "saveValue": false
    }','{
    "functionName": "delete_object",
    "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
    }
    }',NULL,false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "137"
    }','{
    "saveValue": false
    }','{
    "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "178"
    }','{
    "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_ecover','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,5),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,7),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,11),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''HYDRANT_PLATE'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,16),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''HYDRANT_PLATE'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,17),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,20),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,22),
	 ('ve_element_ehydrant_plate','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EHYDRANT_PLATE''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "111"
    }','{
    "saveValue": false
    }','{
    "functionName": "insert_feature",
    "parameters": {
        "targetwidget": "tab_features_feature_id"
    }
    }',NULL,false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "112"
    }','{
    "saveValue": false
    }','{
    "functionName": "delete_object",
    "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
    }
    }',NULL,false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "137"
    }','{
    "saveValue": false
    }','{
    "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "178"
    }','{
    "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_ehydrant_plate','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_emanhole','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_emanhole','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_emanhole','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,5),
	 ('ve_element_emanhole','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_element_emanhole','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,7),
	 ('ve_element_emanhole','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_emanhole','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_element_emanhole','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_emanhole','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,11),
	 ('ve_element_emanhole','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_emanhole','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_element_emanhole','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_emanhole','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_emanhole','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''MANHOLE'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,16),
	 ('ve_element_emanhole','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''MANHOLE'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,17),
	 ('ve_element_emanhole','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element_emanhole','form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_element_emanhole','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,20),
	 ('ve_element_emanhole','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element_emanhole','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,22),
	 ('ve_element_emanhole','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EMANHOLE''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_emanhole','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_emanhole','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_emanhole','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_emanhole','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_emanhole','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_emanhole','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_emanhole','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "111"
    }','{
    "saveValue": false
    }','{
    "functionName": "insert_feature",
    "parameters": {
        "targetwidget": "tab_features_feature_id"
    }
    }',NULL,false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "112"
    }','{
    "saveValue": false
    }','{
    "functionName": "delete_object",
    "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
    }
    }',NULL,false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "137"
    }','{
    "saveValue": false
    }','{
    "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "178"
    }','{
    "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_emanhole','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_emeter','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_emeter','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_emeter','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,5),
	 ('ve_element_emeter','form_feature','tab_data','node_id','lyt_data_1',1,'string','text','Node id:','Node_id',NULL,true,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,6),
	 ('ve_element_emeter','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,7),
	 ('ve_element_emeter','form_feature','tab_data','num_elements','lyt_data_1',3,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_emeter','form_feature','tab_data','comment','lyt_data_1',4,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,9),
	 ('ve_element_emeter','form_feature','tab_data','function_type','lyt_data_1',5,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EMETER'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_emeter','form_feature','tab_data','category_type','lyt_data_1',6,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EMETER'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,11),
	 ('ve_element_emeter','form_feature','tab_data','location_type','lyt_data_1',7,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EMETER'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_emeter','form_feature','tab_data','workcat_id','lyt_data_1',8,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,13),
	 ('ve_element_emeter','form_feature','tab_data','workcat_id_end','lyt_data_1',9,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_emeter','form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_emeter','form_feature','tab_data','enddate','lyt_data_1',11,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,16),
	 ('ve_element_emeter','form_feature','tab_data','ownercat_id','lyt_data_1',12,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,17),
	 ('ve_element_emeter','form_feature','tab_data','rotation','lyt_data_1',15,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element_emeter','form_feature','tab_data','top_elev','lyt_data_1',16,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_element_emeter','form_feature','tab_data','to_arc','lyt_data_2',2,'integer','text','To arc:','To_arc',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,20),
	 ('ve_element_emeter','form_feature','tab_data','flwreg_length','lyt_data_2',3,'double','text','Flwreg length:','Flwreg_length',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element_emeter','form_feature','tab_data','expl_id','lyt_data_2',4,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,22),
	 ('ve_element_emeter','form_feature','tab_data','muni_id','lyt_data_3',1,'integer','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,false,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,23),
	 ('ve_element_emeter','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,24),
	 ('ve_element_emeter','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EMETER''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_emeter','form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type:','EPA Type',NULL,false,false,true,true,NULL,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_emeter','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_emeter','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_emeter','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_emeter','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_emeter','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_emeter','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_emeter','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_emeter','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_emeter','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_emeter','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_emeter','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "111"
    }','{
      "saveValue": false
    }','{
      "functionName": "insert_feature",
      "parameters": {
        "targetwidget": "tab_features_feature_id"
      }
    }',NULL,false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "112"
    }','{
      "saveValue": false
    }','{
      "functionName": "delete_object",
      "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
      }
    }',NULL,false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "137"
    }','{
      "saveValue": false
    }','{
      "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "178"
    }','{
      "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_arc",
      "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_connec",
      "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_link",
      "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_emeter','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_node",
      "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_eprotect_band','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_eprotect_band','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_eprotect_band','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,5),
	 ('ve_element_eprotect_band','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_element_eprotect_band','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,7),
	 ('ve_element_eprotect_band','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_eprotect_band','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_element_eprotect_band','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_eprotect_band','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,11),
	 ('ve_element_eprotect_band','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_eprotect_band','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_element_eprotect_band','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_eprotect_band','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_eprotect_band','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''EPROTECT_BAND'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,16),
	 ('ve_element_eprotect_band','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''EPROTECT_BAND'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,17),
	 ('ve_element_eprotect_band','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element_eprotect_band','form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_element_eprotect_band','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,20),
	 ('ve_element_eprotect_band','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element_eprotect_band','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,22),
	 ('ve_element_eprotect_band','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPROTECT_BAND''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_eprotect_band','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_eprotect_band','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_eprotect_band','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_eprotect_band','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_eprotect_band','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "111"
    }','{
    "saveValue": false
    }','{
    "functionName": "insert_feature",
    "parameters": {
        "targetwidget": "tab_features_feature_id"
    }
    }',NULL,false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "112"
    }','{
    "saveValue": false
    }','{
    "functionName": "delete_object",
    "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
    }
    }',NULL,false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "137"
    }','{
    "saveValue": false
    }','{
    "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "178"
    }','{
    "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_eprotect_band','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_epump','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_epump','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_epump','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,5),
	 ('ve_element_epump','form_feature','tab_data','node_id','lyt_data_1',1,'string','text','Node id:','Node_id',NULL,true,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,6),
	 ('ve_element_epump','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,7),
	 ('ve_element_epump','form_feature','tab_data','num_elements','lyt_data_1',3,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_epump','form_feature','tab_data','comment','lyt_data_1',4,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,9),
	 ('ve_element_epump','form_feature','tab_data','function_type','lyt_data_1',5,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EPUMP'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_epump','form_feature','tab_data','category_type','lyt_data_1',6,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EPUMP'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,11),
	 ('ve_element_epump','form_feature','tab_data','location_type','lyt_data_1',7,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EPUMP'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_epump','form_feature','tab_data','workcat_id','lyt_data_1',8,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,13),
	 ('ve_element_epump','form_feature','tab_data','workcat_id_end','lyt_data_1',9,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_epump','form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_epump','form_feature','tab_data','enddate','lyt_data_1',11,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,16),
	 ('ve_element_epump','form_feature','tab_data','ownercat_id','lyt_data_1',12,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,17),
	 ('ve_element_epump','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''EPUMP'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,18),
	 ('ve_element_epump','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''EPUMP'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,19),
	 ('ve_element_epump','form_feature','tab_data','rotation','lyt_data_1',15,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,20),
	 ('ve_element_epump','form_feature','tab_data','top_elev','lyt_data_1',16,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,21),
	 ('ve_element_epump','form_feature','tab_data','to_arc','lyt_data_2',2,'integer','text','To arc:','To_arc',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,22),
	 ('ve_element_epump','form_feature','tab_data','flwreg_length','lyt_data_2',3,'double','text','Flwreg length:','Flwreg_length',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,23),
	 ('ve_element_epump','form_feature','tab_data','expl_id','lyt_data_2',4,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,24),
	 ('ve_element_epump','form_feature','tab_data','muni_id','lyt_data_3',1,'integer','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,false,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,25),
	 ('ve_element_epump','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,26),
	 ('ve_element_epump','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPUMP''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_epump','form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type:','EPA Type',NULL,false,false,true,true,NULL,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_epump','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_epump','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_epump','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_epump','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_epump','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_epump','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_epump','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_epump','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_epump','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_epump','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_epump','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_epump','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "111"
    }','{
      "saveValue": false
    }','{
      "functionName": "insert_feature",
      "parameters": {
        "targetwidget": "tab_features_feature_id"
      }
    }',NULL,false,NULL),
	 ('ve_element_epump','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "112"
    }','{
      "saveValue": false
    }','{
      "functionName": "delete_object",
      "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
      }
    }',NULL,false,NULL),
	 ('ve_element_epump','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "137"
    }','{
      "saveValue": false
    }','{
      "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_epump','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "178"
    }','{
      "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_epump','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_arc",
      "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_epump','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_connec",
      "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_epump','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_link",
      "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_epump','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_node",
      "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_eregister','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_eregister','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_eregister','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_eregister','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,5),
	 ('ve_element_eregister','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_element_eregister','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,7),
	 ('ve_element_eregister','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_eregister','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_element_eregister','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_eregister','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,11),
	 ('ve_element_eregister','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_eregister','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_element_eregister','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_eregister','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_eregister','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''EREGISTER'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,16),
	 ('ve_element_eregister','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''EREGISTER'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,17),
	 ('ve_element_eregister','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element_eregister','form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_element_eregister','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,20),
	 ('ve_element_eregister','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element_eregister','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,22),
	 ('ve_element_eregister','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EREGISTER''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_eregister','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_eregister','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_eregister','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_eregister','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_eregister','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_eregister','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_eregister','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_eregister','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_eregister','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_eregister','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_eregister','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "111"
    }','{
    "saveValue": false
    }','{
    "functionName": "insert_feature",
    "parameters": {
        "targetwidget": "tab_features_feature_id"
    }
    }',NULL,false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "112"
    }','{
    "saveValue": false
    }','{
    "functionName": "delete_object",
    "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
    }
    }',NULL,false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "137"
    }','{
    "saveValue": false
    }','{
    "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "178"
    }','{
    "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_eregister','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_estep','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_estep','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_estep','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_estep','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,5),
	 ('ve_element_estep','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_element_estep','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,7),
	 ('ve_element_estep','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_estep','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_element_estep','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_estep','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,11),
	 ('ve_element_estep','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_estep','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_element_estep','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_estep','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_estep','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''ESTEP'' = ANY(featurecat_id::text[]) ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,16),
	 ('ve_element_estep','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''ESTEP'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,17),
	 ('ve_element_estep','form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_element_estep','form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_element_estep','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,20),
	 ('ve_element_estep','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,21),
	 ('ve_element_estep','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,22),
	 ('ve_element_estep','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''ESTEP''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_estep','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_estep','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_estep','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_estep','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_estep','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_estep','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_estep','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_estep','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_estep','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_estep','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_estep','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_estep','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "111"
    }','{
    "saveValue": false
    }','{
    "functionName": "insert_feature",
    "parameters": {
        "targetwidget": "tab_features_feature_id"
    }
    }',NULL,false,NULL),
	 ('ve_element_estep','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "112"
    }','{
    "saveValue": false
    }','{
    "functionName": "delete_object",
    "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
    }
    }',NULL,false,NULL),
	 ('ve_element_estep','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "137"
    }','{
    "saveValue": false
    }','{
    "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_estep','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
    "icon": "178"
    }','{
    "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_estep','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_estep','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_estep','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_estep','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_element_evalve','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,3),
	 ('ve_element_evalve','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State',NULL,false,false,true,false,NULL,'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_element_evalve','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type:','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,5),
	 ('ve_element_evalve','form_feature','tab_data','node_id','lyt_data_1',1,'integer','text','Node id:','Node_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,6),
	 ('ve_element_evalve','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code:','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,7),
	 ('ve_element_evalve','form_feature','tab_data','num_elements','lyt_data_1',3,'integer','text','Number of Elements:','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,8),
	 ('ve_element_evalve','form_feature','tab_data','comment','lyt_data_1',4,'string','text','Comments:','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,9),
	 ('ve_element_evalve','form_feature','tab_data','function_type','lyt_data_1',5,'string','combo','Function Type:','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ''ELEMENT''=ANY(feature_type) OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element_evalve','form_feature','tab_data','category_type','lyt_data_1',6,'string','combo','Category Type:','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ''ELEMENT''=ANY(feature_type) OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,11),
	 ('ve_element_evalve','form_feature','tab_data','location_type','lyt_data_1',7,'string','combo','Location Type:','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ''ELEMENT''=ANY(feature_type) OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_element_evalve','form_feature','tab_data','workcat_id','lyt_data_1',8,'string','typeahead','Workcat id:','Workcat id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,13),
	 ('ve_element_evalve','form_feature','tab_data','workcat_id_end','lyt_data_1',9,'string','typeahead','Workcat id End:','Workcat id End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_element_evalve','form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','Built Date:','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_element_evalve','form_feature','tab_data','enddate','lyt_data_1',11,'date','datetime','End Date:','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,16),
	 ('ve_element_evalve','form_feature','tab_data','ownercat_id','lyt_data_1',12,'string','combo','Owner Catalog:','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,17),
	 ('ve_element_evalve','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand:','Brand_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand WHERE ''EVALVE'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,18),
	 ('ve_element_evalve','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model:','Model_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_brand_model WHERE ''EVALVE'' = ANY(featurecat_id::text[])',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,19),
	 ('ve_element_evalve','form_feature','tab_data','rotation','lyt_data_1',15,'double','text','Rotation:','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,20),
	 ('ve_element_evalve','form_feature','tab_data','top_elev','lyt_data_1',16,'double','text','Top Elevation:','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,21),
	 ('ve_element_evalve','form_feature','tab_data','to_arc','lyt_data_2',2,'integer','text','To arc:','To_arc',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,22),
	 ('ve_element_evalve','form_feature','tab_data','flwreg_length','lyt_data_2',3,'double','text','Flwreg length:','Flwreg_length',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,23),
	 ('ve_element_evalve','form_feature','tab_data','expl_id','lyt_data_2',4,'integer','combo','Exploitation id:','Exploitation id',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,24),
	 ('ve_element_evalve','form_feature','tab_data','muni_id','lyt_data_3',1,'integer','combo','Municipality:','Muni_id - Municipality to which the element belongs. If the configuration is not modified, the program automatically selects it based on the geometry',NULL,false,false,true,false,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,25),
	 ('ve_element_evalve','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations:','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,26),
	 ('ve_element_evalve','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog:','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EVALVE''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_element_evalve','form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type:','EPA Type',NULL,false,false,true,true,NULL,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_element_evalve','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_element_evalve','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_element_evalve','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_element_evalve','form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_element_evalve','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_evalve','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_element_evalve','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_evalve','form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_evalve','form_feature','tab_documents','open_doc','lyt_document_2',11,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }','tbl_doc_x_element',false,NULL),
	 ('ve_element_evalve','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }','tbl_doc_x_element',false,4),
	 ('ve_element_evalve','form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','btn_insert','lyt_features_1',1,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "111"
    }','{
      "saveValue": false
    }','{
      "functionName": "insert_feature",
      "parameters": {
        "targetwidget": "tab_features_feature_id"
      }
    }',NULL,false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','btn_delete','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "112"
    }','{
      "saveValue": false
    }','{
      "functionName": "delete_object",
      "parameters": {
        "columnfind": "element_id",
        "targetwidget": "tab_features_tbl_element",
        "sourceview": "element"
      }
    }',NULL,false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','btn_snapping','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "137"
    }','{
      "saveValue": false
    }','{
      "functionName": "selection_init"
    }',NULL,false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','btn_expr_select','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
      "icon": "178"
    }','{
      "saveValue": false
    }',NULL,NULL,false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_arc",
      "featureType": "arc"
    }',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_connec",
      "featureType": "connec"
    }',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_link",
      "featureType": "link"
    }',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_element_evalve','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,NULL,'tableview',':',':',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_node",
      "featureType": "node"
    }',NULL,'tbl_element_x_node',false,NULL);

