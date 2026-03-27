/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,dv_parent_id,dv_querytext_filterc,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder) VALUES
	 ('ve_link','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector_id  - Sector identifier.',NULL,false,false,false,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,3),
	 ('ve_link','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',NULL,false,false,false,false,NULL,'WITH psector_value AS (
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
	 ('ve_link','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type:','State_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,5),
	 ('ve_link','form_feature','tab_data','link_id','lyt_data_1',1,'integer','text','Link id:','Link id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_link','form_feature','tab_data','feature_type','lyt_data_1',2,'string','combo','Feature type:','Feature type',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,7),
	 ('ve_link','form_feature','tab_data','feature_id','lyt_data_1',3,'string','text','Feature id:','Feature_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,8),
	 ('ve_link','form_feature','tab_data','exit_type','lyt_data_1',4,'string','combo','Exit type:','Exit type',NULL,false,false,false,false,NULL,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_link','form_feature','tab_data','exit_id','lyt_data_1',5,'string','text','Exit id:','Exit id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_link','form_feature','tab_data','omzone_id','lyt_data_1',6,'integer','combo','Omzone id:','Omzone id',NULL,false,false,false,false,NULL,'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,11),
	 ('ve_link','form_feature','tab_data','presszone_id','lyt_data_1',7,'integer','text','Presszone id:','Presszone_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,12),
	 ('ve_link','form_feature','tab_data','minsector_id','lyt_data_1',8,'integer','text','Minsector id:','Minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,13),
	 ('ve_link','form_feature','tab_data','fluid_type','lyt_data_1',9,'string','combo','Fluid type:','Fluid_type',NULL,true,false,true,false,NULL,'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''',NULL,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_link','form_feature','tab_data','gis_length','lyt_data_1',10,'double','text','Gis length:','Gis length',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_link','form_feature','tab_data','sector_name','lyt_data_1',11,'string','text','Sector name:','Sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,16),
	 ('ve_link','form_feature','tab_data','dma_name','lyt_data_1',12,'string','text','Dma name:','Dma_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,17),
	 ('ve_link','form_feature','tab_data','dqa_name','lyt_data_1',13,'string','text','Dqa name:','Dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,18),
	 ('ve_link','form_feature','tab_data','presszone_name','lyt_data_1',14,'string','text','Presszone name:','Presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,19),
	 ('ve_link','form_feature','tab_data','macroomzone_id','lyt_data_1',15,'integer','text','Macroomzone id:','Macroomzone id',NULL,false,false,false,false,NULL,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,20),
	 ('ve_link','form_feature','tab_data','macrosector_id','lyt_data_1',16,'integer','text','Macrosector id:','Macrosector id','Ex.macrosector_id',false,false,false,false,NULL,NULL,true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,21),
	 ('ve_link','form_feature','tab_data','macrodqa_id','lyt_data_2',1,'integer','text','Macrodqa id:','Macrodqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,22),
	 ('ve_link','form_feature','tab_data','is_operative','lyt_data_2',3,'boolean','check','Is operative:','Is_operative',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,23),
	 ('ve_link','form_feature','tab_data','conneccat_id','lyt_data_2',4,'string','typeahead','Connecat id:','Connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ',true,NULL,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,24),
	 ('ve_link','form_feature','tab_data','workcat_id','lyt_data_2',5,'string','typeahead','Workcat id:','Workcat_id - Related to the catalog of work files (cat_work). File that registers the element',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,25),
	 ('ve_link','form_feature','tab_data','workcat_id_end','lyt_data_2',6,'string','typeahead','Workcat id end:','Workcat_id_end - id of the  end of construction work.','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,26),
	 ('ve_link','form_feature','tab_data','builtdate','lyt_data_2',7,'date','datetime','Builtdate:','Builtdate - Date the element was added. In insertion of new elements the date of the day is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,27),
	 ('ve_link','form_feature','tab_data','enddate','lyt_data_2',8,'date','datetime','Enddate:','Enddate - End date of the element. It will only be filled in if the element is in a deregistration state.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,28),
	 ('ve_link','form_feature','tab_data','uncertain','lyt_data_2',9,'boolean','check','Uncertain:','Uncertain - To set if the element''s location is uncertain',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,29),
	 ('ve_link','form_feature','tab_data','top_elev1','lyt_data_2',10,'integer','text','Top Elev 1:','Top_elev1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,30),
	 ('ve_link','form_feature','tab_data','depth1','lyt_data_2',11,'integer','text','Depth1:','Depth1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,31),
	 ('ve_link','form_feature','tab_data','elevation1','lyt_data_2',12,'integer','text','Elevation1:','Elevation1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,32),
	 ('ve_link','form_feature','tab_data','top_elev2','lyt_data_2',13,'integer','text','Top elev 2:','Top_elev2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,33),
	 ('ve_link','form_feature','tab_data','depth2','lyt_data_2',14,'integer','text','Depth2:','Depth2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,34),
	 ('ve_link','form_feature','tab_data','elevation2','lyt_data_2',15,'integer','text','Elevation2:','Elevation2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,35),
	 ('ve_link','form_feature','tab_data','dqa_id','lyt_data_2',16,'integer','text','Dqa id:','Dqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,true,36),
	 ('ve_link','form_feature','tab_data','expl_id','lyt_data_2',17,'integer','combo','Exploitation id:','Expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,false,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,37),
	 ('ve_link','form_feature','tab_data','expl_visibility','lyt_data_2',43,'text','text','Expl id visibility:','Expl_id visibility',NULL,false,false,true,false,NULL,'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_link','form_feature','tab_data','link_type','lyt_top_1',1,'string','combo','Link Type:','Type of link. It is auto-populated based on the linkcat_id',NULL,true,true,false,false,NULL,'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,1),
	 ('ve_link','form_feature','tab_data','linkcat_id','lyt_top_1',2,'string','typeahead','Linkcat id:','Linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,'link_type',' AND cat_link.link_type IS NULL OR cat_link.link_type',NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,2),
	 ('ve_link','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,1),
	 ('ve_link','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,2),
	 ('ve_link','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_link',false,3),
	 ('ve_link','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_link','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_link',false,NULL),
	 ('ve_link','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_link',false,4),
	 ('ve_link','form_feature','tab_elements','element_id','lyt_element_1',1,'string','typeahead','Element id:','Element id',NULL,false,false,true,false,false,'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}',NULL,false,NULL),
	 ('ve_link','form_feature','tab_elements','insert_element','lyt_element_1',2,NULL,'button',NULL,'Insert element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}','v_edit_link',false,NULL),
	 ('ve_link','form_feature','tab_elements','delete_element','lyt_element_1',3,NULL,'button',NULL,'Delete element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}','{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}','tbl_element_x_link',false,NULL),
	 ('ve_link','form_feature','tab_elements','new_element','lyt_element_1',4,NULL,'button',NULL,'New element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}','v_edit_link',false,NULL),
	 ('ve_link','form_feature','tab_elements','hspacer_lyt_element','lyt_element_1',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link','form_feature','tab_elements','open_element','lyt_element_1',6,NULL,'button',NULL,'Open element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}','v_edit_link',false,NULL),
	 ('ve_link','form_feature','tab_elements','btn_link','lyt_element_1',7,NULL,'button',NULL,'Open link',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"173"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}','v_edit_link',false,NULL),
	 ('ve_link','form_feature','tab_elements','tbl_elements','lyt_element_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"parameters": {"columnfind": "element_id", "sourcetable": "v_ui_element_x_link"}, "functionName": "open_selected_manager_item"}','tbl_element_x_link',false,1),
	 ('ve_link','form_feature','tab_event','date_event_from','lyt_event_1',1,'date','datetime','From:','From:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign": ">="}','{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}','tbl_event_x_link',false,1),
	 ('ve_link','form_feature','tab_event','date_event_to','lyt_event_1',2,'date','datetime','To:','To:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign": "<="}','{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}','tbl_event_x_link',false,2),
	 ('ve_link','form_feature','tab_event','parameter_type','lyt_event_1',3,'string','combo','Parameter type:','Parameter type:',NULL,false,false,true,false,true,'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_event_x_link',false,3),
	 ('ve_link','form_feature','tab_event','parameter_id','lyt_event_1',4,'string','combo','Parameter:','Parameter:',NULL,false,false,true,false,true,'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_event_x_link',false,4),
	 ('ve_link','form_feature','tab_event','btn_open_visit','lyt_event_2',1,NULL,'button',NULL,'Open visit',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"127"}','{"saveValue":false, "filterSign":"="}','{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}','tbl_event_x_link',false,NULL),
	 ('ve_link','form_feature','tab_event','btn_new_visit','lyt_event_2',2,NULL,'button',NULL,'New visit',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"119"}','{"saveValue":false, "filterSign":"="}','{"functionName": "new_visit", "module": "info", "parameters":{}}','tbl_event_x_link',false,NULL),
	 ('ve_link','form_feature','tab_event','hspacer_event_1','lyt_event_2',3,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link','form_feature','tab_event','btn_open_gallery','lyt_event_2',4,NULL,'button',NULL,'Open gallery',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"145"}','{"onContextMenu":"Open gallery"}','{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}','tbl_event_x_link',false,NULL),
	 ('ve_link','form_feature','tab_event','btn_open_visit_doc','lyt_event_2',5,NULL,'button',NULL,'Open visit document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}','{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}','tbl_event_x_link',false,NULL),
	 ('ve_link','form_feature','tab_event','btn_open_visit_event','lyt_event_2',6,NULL,'button',NULL,'Open visit event',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}','{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}','tbl_event_x_link',false,NULL),
	 ('ve_link','form_feature','tab_event','tbl_event_cf','lyt_event_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}','tbl_event_x_link',false,5),
	 ('ve_link','form_feature','tab_visit','date_visit_from','lyt_visit_1',1,'date','datetime','From:','From:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}',NULL,false,1),
	 ('ve_link','form_feature','tab_visit','date_visit_to','lyt_visit_1',2,'date','datetime','To:','To:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}',NULL,false,2),
	 ('ve_link','form_feature','tab_visit','visit_class','lyt_visit_1',3,'string','combo','Visit class:','Visit class:',NULL,false,false,true,false,false,'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''LINK'',''ALL'') ',NULL,false,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "manage_visit_class","parameters": {}}','tbl_event_x_link',false,3),
	 ('ve_link','form_feature','tab_visit','hspacer_lyt_document_1','lyt_visit_2',1,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link','form_feature','tab_visit','open_gallery','lyt_visit_2',2,NULL,'button',NULL,'Open gallery',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"145"}','{"saveValue":false, "filterSign":"="}','{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}','tbl_event_x_link',false,NULL),
	 ('ve_link','form_feature','tab_visit','tbl_visits','lyt_visit_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"functionName": "open_visit", "parameters": {"columnfind": "visit_id"}}',NULL,false,4),
	 ('ve_link_conduitlink','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector_id  - Sector identifier.',NULL,false,false,false,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,3),
	 ('ve_link_conduitlink','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',NULL,false,false,false,false,NULL,'WITH psector_value AS (
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
	 ('ve_link_conduitlink','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type:','State_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,5),
	 ('ve_link_conduitlink','form_feature','tab_data','link_id','lyt_data_1',1,'integer','text','Link id:','Link id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_link_conduitlink','form_feature','tab_data','feature_type','lyt_data_1',2,'string','combo','Feature type:','Feature type',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,7),
	 ('ve_link_conduitlink','form_feature','tab_data','feature_id','lyt_data_1',3,'string','text','Feature id:','Feature_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,8),
	 ('ve_link_conduitlink','form_feature','tab_data','exit_type','lyt_data_1',4,'string','combo','Exit type:','Exit type',NULL,false,false,false,false,NULL,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_link_conduitlink','form_feature','tab_data','exit_id','lyt_data_1',5,'string','text','Exit id:','Exit id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_link_conduitlink','form_feature','tab_data','omzone_id','lyt_data_1',6,'integer','combo','Omzone id:','Omzone id',NULL,false,false,false,false,NULL,'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,11),
	 ('ve_link_conduitlink','form_feature','tab_data','presszone_id','lyt_data_1',7,'integer','text','Presszone id:','Presszone_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,12),
	 ('ve_link_conduitlink','form_feature','tab_data','minsector_id','lyt_data_1',8,'integer','text','Minsector id:','Minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,13),
	 ('ve_link_conduitlink','form_feature','tab_data','fluid_type','lyt_data_1',9,'string','combo','Fluid type:','Fluid_type',NULL,true,false,true,false,NULL,'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''',NULL,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_link_conduitlink','form_feature','tab_data','gis_length','lyt_data_1',10,'double','text','Gis length:','Gis length',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_link_conduitlink','form_feature','tab_data','sector_name','lyt_data_1',11,'string','text','Sector name:','Sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,16),
	 ('ve_link_conduitlink','form_feature','tab_data','dma_name','lyt_data_1',12,'string','text','Dma name:','Dma_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,17),
	 ('ve_link_conduitlink','form_feature','tab_data','dqa_name','lyt_data_1',13,'string','text','Dqa name:','Dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,18),
	 ('ve_link_conduitlink','form_feature','tab_data','presszone_name','lyt_data_1',14,'string','text','Presszone name:','Presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,19),
	 ('ve_link_conduitlink','form_feature','tab_data','macroomzone_id','lyt_data_1',15,'integer','text','Macroomzone id:','Macroomzone id',NULL,false,false,false,false,NULL,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,20),
	 ('ve_link_conduitlink','form_feature','tab_data','macrosector_id','lyt_data_1',16,'integer','text','Macrosector id:','Macrosector id','Ex.macrosector_id',false,false,false,false,NULL,NULL,true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,21),
	 ('ve_link_conduitlink','form_feature','tab_data','macrodqa_id','lyt_data_2',1,'integer','text','Macrodqa id:','Macrodqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,22),
	 ('ve_link_conduitlink','form_feature','tab_data','is_operative','lyt_data_2',3,'boolean','check','Is operative:','Is_operative',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,23),
	 ('ve_link_conduitlink','form_feature','tab_data','conneccat_id','lyt_data_2',4,'string','typeahead','Connecat id:','Connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ',true,NULL,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,24),
	 ('ve_link_conduitlink','form_feature','tab_data','workcat_id','lyt_data_2',5,'string','typeahead','Workcat id:','Workcat_id - Related to the catalog of work files (cat_work). File that registers the element',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,25),
	 ('ve_link_conduitlink','form_feature','tab_data','workcat_id_end','lyt_data_2',6,'string','typeahead','Workcat id end:','Workcat_id_end - id of the  end of construction work.','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,26),
	 ('ve_link_conduitlink','form_feature','tab_data','builtdate','lyt_data_2',7,'date','datetime','Builtdate:','Builtdate - Date the element was added. In insertion of new elements the date of the day is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,27),
	 ('ve_link_conduitlink','form_feature','tab_data','enddate','lyt_data_2',8,'date','datetime','Enddate:','Enddate - End date of the element. It will only be filled in if the element is in a deregistration state.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,28),
	 ('ve_link_conduitlink','form_feature','tab_data','uncertain','lyt_data_2',9,'boolean','check','Uncertain:','Uncertain - To set if the element''s location is uncertain',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,29),
	 ('ve_link_conduitlink','form_feature','tab_data','top_elev1','lyt_data_2',10,'integer','text','Top Elev 1:','Top_elev1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,30),
	 ('ve_link_conduitlink','form_feature','tab_data','depth1','lyt_data_2',11,'integer','text','Depth1:','Depth1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,31),
	 ('ve_link_conduitlink','form_feature','tab_data','elevation1','lyt_data_2',12,'integer','text','Elevation1:','Elevation1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,32),
	 ('ve_link_conduitlink','form_feature','tab_data','top_elev2','lyt_data_2',13,'integer','text','Top elev 2:','Top_elev2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,33),
	 ('ve_link_conduitlink','form_feature','tab_data','depth2','lyt_data_2',14,'integer','text','Depth2:','Depth2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,34),
	 ('ve_link_conduitlink','form_feature','tab_data','elevation2','lyt_data_2',15,'integer','text','Elevation2:','Elevation2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,35),
	 ('ve_link_conduitlink','form_feature','tab_data','dqa_id','lyt_data_2',16,'integer','text','Dqa id:','Dqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,true,36),
	 ('ve_link_conduitlink','form_feature','tab_data','expl_id','lyt_data_2',17,'integer','combo','Exploitation id:','Expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,false,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,37),
	 ('ve_link_conduitlink','form_feature','tab_data','expl_visibility','lyt_data_2',43,'text','text','Expl id visibility:','Expl_id visibility',NULL,false,false,true,false,NULL,'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','link_type','lyt_top_1',1,'string','combo','Link Type:','Type of link. It is auto-populated based on the linkcat_id',NULL,true,true,false,false,NULL,'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,1),
	 ('ve_link_conduitlink','form_feature','tab_data','linkcat_id','lyt_top_1',2,'string','typeahead','Linkcat id:','Linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,'link_type',' AND cat_link.link_type IS NULL OR cat_link.link_type',NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,2),
	 ('ve_link_conduitlink','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,1),
	 ('ve_link_conduitlink','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,2),
	 ('ve_link_conduitlink','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_link',false,3),
	 ('ve_link_conduitlink','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_link',false,4),
	 ('ve_link_conduitlink','form_feature','tab_elements','element_id','lyt_element_1',1,'string','typeahead','Element id:','Element id',NULL,false,false,true,false,false,'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}',NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_elements','insert_element','lyt_element_1',2,NULL,'button',NULL,'Insert element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}','v_edit_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_elements','delete_element','lyt_element_1',3,NULL,'button',NULL,'Delete element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}','{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}','tbl_element_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_elements','new_element','lyt_element_1',4,NULL,'button',NULL,'New element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}','v_edit_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_elements','hspacer_lyt_element','lyt_element_1',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_elements','open_element','lyt_element_1',6,NULL,'button',NULL,'Open element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}','v_edit_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_elements','btn_link','lyt_element_1',7,NULL,'button',NULL,'Open link',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"173"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}','v_edit_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_elements','tbl_elements','lyt_element_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"parameters": {"columnfind": "element_id", "sourcetable": "v_ui_element_x_link"}, "functionName": "open_selected_manager_item"}','tbl_element_x_link',false,1),
	 ('ve_link_conduitlink','form_feature','tab_event','date_event_from','lyt_event_1',1,'date','datetime','From:','From:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign": ">="}','{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}','tbl_event_x_link',false,1),
	 ('ve_link_conduitlink','form_feature','tab_event','date_event_to','lyt_event_1',2,'date','datetime','To:','To:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign": "<="}','{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}','tbl_event_x_link',false,2),
	 ('ve_link_conduitlink','form_feature','tab_event','parameter_type','lyt_event_1',3,'string','combo','Parameter type:','Parameter type:',NULL,false,false,true,false,true,'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_event_x_link',false,3),
	 ('ve_link_conduitlink','form_feature','tab_event','parameter_id','lyt_event_1',4,'string','combo','Parameter:','Parameter:',NULL,false,false,true,false,true,'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_event_x_link',false,4),
	 ('ve_link_conduitlink','form_feature','tab_event','btn_open_visit','lyt_event_2',1,NULL,'button',NULL,'Open visit',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"127"}','{"saveValue":false, "filterSign":"="}','{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_event','btn_new_visit','lyt_event_2',2,NULL,'button',NULL,'New visit',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"119"}','{"saveValue":false, "filterSign":"="}','{"functionName": "new_visit", "module": "info", "parameters":{}}','tbl_event_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_event','hspacer_event_1','lyt_event_2',3,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_event','btn_open_gallery','lyt_event_2',4,NULL,'button',NULL,'Open gallery',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"145"}','{"onContextMenu":"Open gallery"}','{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_event','btn_open_visit_doc','lyt_event_2',5,NULL,'button',NULL,'Open visit document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}','{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_event','btn_open_visit_event','lyt_event_2',6,NULL,'button',NULL,'Open visit event',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}','{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}','tbl_event_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_event','tbl_event_cf','lyt_event_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}','tbl_event_x_link',false,5),
	 ('ve_link_conduitlink','form_feature','tab_visit','date_visit_from','lyt_visit_1',1,'date','datetime','From:','From:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}',NULL,false,1),
	 ('ve_link_conduitlink','form_feature','tab_visit','date_visit_to','lyt_visit_1',2,'date','datetime','To:','To:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}',NULL,false,2),
	 ('ve_link_conduitlink','form_feature','tab_visit','visit_class','lyt_visit_1',3,'string','combo','Visit class:','Visit class:',NULL,false,false,true,false,false,'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''LINK'',''ALL'') ',NULL,false,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "manage_visit_class","parameters": {}}','tbl_event_x_link',false,3),
	 ('ve_link_conduitlink','form_feature','tab_visit','hspacer_lyt_document_1','lyt_visit_2',1,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_visit','open_gallery','lyt_visit_2',2,NULL,'button',NULL,'Open gallery',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"145"}','{"saveValue":false, "filterSign":"="}','{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_visit','tbl_visits','lyt_visit_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"functionName": "open_visit", "parameters": {"columnfind": "visit_id"}}',NULL,false,4),
	 ('ve_link_vlink','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector id:','Sector_id  - Sector identifier.',NULL,false,false,false,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,3),
	 ('ve_link_vlink','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',NULL,false,false,false,false,NULL,'WITH psector_value AS (
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
	 ('ve_link_vlink','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type:','State_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,5),
	 ('ve_link_vlink','form_feature','tab_data','link_id','lyt_data_1',1,'integer','text','Link id:','Link id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,6),
	 ('ve_link_vlink','form_feature','tab_data','feature_type','lyt_data_1',2,'string','combo','Feature type:','Feature type',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,7),
	 ('ve_link_vlink','form_feature','tab_data','feature_id','lyt_data_1',3,'string','text','Feature id:','Feature_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,8),
	 ('ve_link_vlink','form_feature','tab_data','exit_type','lyt_data_1',4,'string','combo','Exit type:','Exit type',NULL,false,false,false,false,NULL,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_link_vlink','form_feature','tab_data','exit_id','lyt_data_1',5,'string','text','Exit id:','Exit id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_link_vlink','form_feature','tab_data','omzone_id','lyt_data_1',6,'integer','combo','Omzone id:','Omzone id',NULL,false,false,false,false,NULL,'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,11),
	 ('ve_link_vlink','form_feature','tab_data','presszone_id','lyt_data_1',7,'integer','text','Presszone id:','Presszone_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,12),
	 ('ve_link_vlink','form_feature','tab_data','minsector_id','lyt_data_1',8,'integer','text','Minsector id:','Minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,13),
	 ('ve_link_vlink','form_feature','tab_data','fluid_type','lyt_data_1',9,'string','combo','Fluid type:','Fluid_type',NULL,true,false,true,false,NULL,'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''',NULL,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_link_vlink','form_feature','tab_data','gis_length','lyt_data_1',10,'double','text','Gis length:','Gis length',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,15),
	 ('ve_link_vlink','form_feature','tab_data','sector_name','lyt_data_1',11,'string','text','Sector name:','Sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,16),
	 ('ve_link_vlink','form_feature','tab_data','dma_name','lyt_data_1',12,'string','text','Dma name:','Dma_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,17),
	 ('ve_link_vlink','form_feature','tab_data','dqa_name','lyt_data_1',13,'string','text','Dqa name:','Dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,18),
	 ('ve_link_vlink','form_feature','tab_data','presszone_name','lyt_data_1',14,'string','text','Presszone name:','Presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,19),
	 ('ve_link_vlink','form_feature','tab_data','macroomzone_id','lyt_data_1',15,'integer','text','Macroomzone id:','Macroomzone id',NULL,false,false,false,false,NULL,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,20),
	 ('ve_link_vlink','form_feature','tab_data','macrosector_id','lyt_data_1',16,'integer','text','Macrosector id:','Macrosector id','Ex.macrosector_id',false,false,false,false,NULL,NULL,true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,21),
	 ('ve_link_vlink','form_feature','tab_data','macrodqa_id','lyt_data_2',1,'integer','text','Macrodqa id:','Macrodqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,22),
	 ('ve_link_vlink','form_feature','tab_data','is_operative','lyt_data_2',3,'boolean','check','Is operative:','Is_operative',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,23),
	 ('ve_link_vlink','form_feature','tab_data','conneccat_id','lyt_data_2',4,'string','typeahead','Connecat id:','Connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ',true,NULL,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,24),
	 ('ve_link_vlink','form_feature','tab_data','workcat_id','lyt_data_2',5,'string','typeahead','Workcat id:','Workcat_id - Related to the catalog of work files (cat_work). File that registers the element',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,25),
	 ('ve_link_vlink','form_feature','tab_data','workcat_id_end','lyt_data_2',6,'string','typeahead','Workcat id end:','Workcat_id_end - id of the  end of construction work.','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,26),
	 ('ve_link_vlink','form_feature','tab_data','builtdate','lyt_data_2',7,'date','datetime','Builtdate:','Builtdate - Date the element was added. In insertion of new elements the date of the day is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,27),
	 ('ve_link_vlink','form_feature','tab_data','enddate','lyt_data_2',8,'date','datetime','Enddate:','Enddate - End date of the element. It will only be filled in if the element is in a deregistration state.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,28),
	 ('ve_link_vlink','form_feature','tab_data','uncertain','lyt_data_2',9,'boolean','check','Uncertain:','Uncertain - To set if the element''s location is uncertain',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,29),
	 ('ve_link_vlink','form_feature','tab_data','top_elev1','lyt_data_2',10,'integer','text','Top Elev 1:','Top_elev1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,30),
	 ('ve_link_vlink','form_feature','tab_data','depth1','lyt_data_2',11,'integer','text','Depth1:','Depth1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,31),
	 ('ve_link_vlink','form_feature','tab_data','elevation1','lyt_data_2',12,'integer','text','Elevation1:','Elevation1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,32),
	 ('ve_link_vlink','form_feature','tab_data','top_elev2','lyt_data_2',13,'integer','text','Top elev 2:','Top_elev2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,33),
	 ('ve_link_vlink','form_feature','tab_data','depth2','lyt_data_2',14,'integer','text','Depth2:','Depth2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,34),
	 ('ve_link_vlink','form_feature','tab_data','elevation2','lyt_data_2',15,'integer','text','Elevation2:','Elevation2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,35),
	 ('ve_link_vlink','form_feature','tab_data','dqa_id','lyt_data_2',16,'integer','text','Dqa id:','Dqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,true,36),
	 ('ve_link_vlink','form_feature','tab_data','expl_id','lyt_data_2',17,'integer','combo','Exploitation id:','Expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,false,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,37),
	 ('ve_link_vlink','form_feature','tab_data','expl_visibility','lyt_data_2',43,'text','text','Expl id visibility:','Expl_id visibility',NULL,false,false,true,false,NULL,'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','link_type','lyt_top_1',1,'string','combo','Link Type:','Type of link. It is auto-populated based on the linkcat_id',NULL,true,true,false,false,NULL,'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,1),
	 ('ve_link_vlink','form_feature','tab_data','linkcat_id','lyt_top_1',2,'string','typeahead','Linkcat id:','Linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,'link_type',' AND cat_link.link_type IS NULL OR cat_link.link_type',NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,2),
	 ('ve_link_vlink','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,1),
	 ('ve_link_vlink','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,2),
	 ('ve_link_vlink','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_link',false,3),
	 ('ve_link_vlink','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_link',false,4),
	 ('ve_link_vlink','form_feature','tab_elements','element_id','lyt_element_1',1,'string','typeahead','Element id:','Element id',NULL,false,false,true,false,false,'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}',NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_elements','insert_element','lyt_element_1',2,NULL,'button',NULL,'Insert element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}','v_edit_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_elements','delete_element','lyt_element_1',3,NULL,'button',NULL,'Delete element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}','{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}','tbl_element_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_elements','new_element','lyt_element_1',4,NULL,'button',NULL,'New element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element",
    "linked_feature": true
  }
}','v_edit_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_elements','hspacer_lyt_element','lyt_element_1',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_elements','open_element','lyt_element_1',6,NULL,'button',NULL,'Open element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}','v_edit_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_elements','btn_link','lyt_element_1',7,NULL,'button',NULL,'Open link',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"173"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}','v_edit_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_elements','tbl_elements','lyt_element_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"parameters": {"columnfind": "element_id", "sourcetable": "v_ui_element_x_link"}, "functionName": "open_selected_manager_item"}','tbl_element_x_link',false,1),
	 ('ve_link_vlink','form_feature','tab_event','date_event_from','lyt_event_1',1,'date','datetime','From:','From:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign": ">="}','{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}','tbl_event_x_link',false,1),
	 ('ve_link_vlink','form_feature','tab_event','date_event_to','lyt_event_1',2,'date','datetime','To:','To:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign": "<="}','{"functionName": "filter_table", "parameters":{"columnfind": "visit_start"}}','tbl_event_x_link',false,2),
	 ('ve_link_vlink','form_feature','tab_event','parameter_type','lyt_event_1',3,'string','combo','Parameter type:','Parameter type:',NULL,false,false,true,false,true,'SELECT DISTINCT parameter_type as id, parameter_type as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_event_x_link',false,3),
	 ('ve_link_vlink','form_feature','tab_event','parameter_id','lyt_event_1',4,'string','combo','Parameter:','Parameter:',NULL,false,false,true,false,true,'SELECT id as id, id as idval FROM config_visit_parameter WHERE feature_type IN (''LINK'', ''ALL'') ',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_event_x_link',false,4),
	 ('ve_link_vlink','form_feature','tab_event','btn_open_visit','lyt_event_2',1,NULL,'button',NULL,'Open visit',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"127"}','{"saveValue":false, "filterSign":"="}','{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_event','btn_new_visit','lyt_event_2',2,NULL,'button',NULL,'New visit',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"119"}','{"saveValue":false, "filterSign":"="}','{"functionName": "new_visit", "module": "info", "parameters":{}}','tbl_event_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_event','hspacer_event_1','lyt_event_2',3,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_event','btn_open_gallery','lyt_event_2',4,NULL,'button',NULL,'Open gallery',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"145"}','{"onContextMenu":"Open gallery"}','{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_event','btn_open_visit_doc','lyt_event_2',5,NULL,'button',NULL,'Open visit document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}','{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_event','btn_open_visit_event','lyt_event_2',6,NULL,'button',NULL,'Open visit event',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}','{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}','tbl_event_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_event','tbl_event_cf','lyt_event_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"functionName": "open_visit_event", "module": "info", "parameters":{"columnfind":["visit_id", "event_id"]}}','tbl_event_x_link',false,5),
	 ('ve_link_vlink','form_feature','tab_visit','date_visit_from','lyt_visit_1',1,'date','datetime','From:','From:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}',NULL,false,1),
	 ('ve_link_vlink','form_feature','tab_visit','date_visit_to','lyt_visit_1',2,'date','datetime','To:','To:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}',NULL,false,2),
	 ('ve_link_vlink','form_feature','tab_visit','visit_class','lyt_visit_1',3,'string','combo','Visit class:','Visit class:',NULL,false,false,true,false,false,'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''LINK'',''ALL'') ',NULL,false,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "manage_visit_class","parameters": {}}','tbl_event_x_link',false,3),
	 ('ve_link_vlink','form_feature','tab_visit','hspacer_lyt_document_1','lyt_visit_2',1,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_visit','open_gallery','lyt_visit_2',2,NULL,'button',NULL,'Open gallery',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"145"}','{"saveValue":false, "filterSign":"="}','{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}','tbl_event_x_link',false,NULL),
	 ('ve_link_vlink','form_feature','tab_visit','tbl_visits','lyt_visit_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"functionName": "open_visit", "parameters": {"columnfind": "visit_id"}}',NULL,false,4);
