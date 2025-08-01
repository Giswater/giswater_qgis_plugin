INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,dv_parent_id,dv_querytext_filterc,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder) VALUES
	 ('cat_element','form_feature','tab_none','descript',NULL,1,'string','text','Descript:','Field to store additional information about the catalog.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','link',NULL,2,'string','text','Link','Link',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','matcat_id',NULL,NULL,'string','combo','Material','Material catalog identifier.',NULL,false,false,true,false,NULL,'SELECT id, descript AS idval FROM cat_material WHERE ''ELEMENT'' = ANY(feature_type) AND id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','model',NULL,NULL,'string','combo','Model','Model',NULL,false,false,true,false,NULL,'SELECT id, id AS idval FROM cat_brand_model WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','id',NULL,NULL,'string','text','ID','ID of the element catalog. Primary key.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','elementtype_id',NULL,NULL,'string','combo','Element type ID','Element type identifier.',NULL,false,false,true,false,NULL,'SELECT id, id AS idval FROM cat_feature_element WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','active',NULL,NULL,'boolean','check','Active','Active',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','brand',NULL,NULL,'string','combo','Brand','Brand',NULL,false,false,true,false,NULL,'SELECT id, id AS idval FROM cat_brand WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','geometry',NULL,NULL,'string','text','geometry','Geometry of the element.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','type',NULL,NULL,'string','text','Type:','Type:',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('cat_element','form_feature','tab_none','svg',NULL,NULL,'string','text','Svg','svg - Symbology pictogram.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('element_manager','form_element','tab_none','hspacer_lyt_bot_3',NULL,1,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('element_manager','form_element','tab_none','tbl_element',NULL,2,NULL,'tablewidget',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{"functionName":"open_selected_manager_item", "parameters":{"columnfind":"element_id"}}','v_ui_element',false,NULL),
	 ('element_manager','form_element','tab_none','element_id',NULL,3,'string','typeahead','Filter by: Element id','Filter by: Element id',NULL,false,false,true,false,true,'SELECT element_id as id, element_id as idval FROM v_ui_element WHERE element_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table", "parameters":{"columnfind":"element_id"}}','v_ui_element',false,NULL),
	 ('element_manager','form_element','tab_none','cancel',NULL,4,NULL,'button',NULL,'Close',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "text": "Close"}','{"functionName": "close_manager",  "parameters":{}}',NULL,false,NULL),
	 ('element_manager','form_element','tab_none','hspacer_lyt_element_mng_1',NULL,5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('element_manager','form_element','tab_none','create',NULL,6,NULL,'button',NULL,'Create',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "text": "Create"}','{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element",
    "targetwidget": "tbl_element",
    "field_object_id": "id"
  }
}',NULL,false,NULL),
	 ('element_manager','form_element','tab_none','delete',NULL,7,NULL,'button',NULL,'Delete',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "text": "Delete", "onContextMenu": "Delete"}','{
  "functionName": "delete_manager_item",
  "parameters": {
    "sourcetable": "v_ui_element",
    "targetwidget": "tab_none_tbl_element",
    "field_object_id": "id"
  }
}',NULL,false,NULL),
	 ('ve_element','form_feature','tab_data','top_elev','lyt_data_1',1,'double','text','Top elevation','top_elev - Elevation of the node in ft or m.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_element','form_feature','tab_data','expl_id2','lyt_data_2',1,'integer','combo','Exploitation 2','expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL and expl_id !=0',true,true,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','state',NULL,1,'integer','combo','State:','State:',NULL,true,true,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','verified',NULL,2,'integer','combo','Verified','verified',NULL,false,false,true,false,NULL,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''',true,true,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','observ',NULL,3,'string','text','Observation','Observation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','element_id',NULL,4,'string','text','Element id','Element id',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','expl_id',NULL,5,'integer','combo','Exploitation','Exploitation',NULL,true,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','state_type',NULL,6,'integer','combo','State type','State type',NULL,true,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','link',NULL,7,'text','text','Link','Link',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','code',NULL,8,'string','text','Code:','Code:',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','elementtype_id',NULL,9,'string','text','Element type ID','Element type identifier.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','elementcat_id',NULL,10,'string','text','Catalog','Catalog',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','num_elements',NULL,11,'integer','text','Element number','Element number',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','ownercat_id',NULL,12,'string','combo','Owner','ownercat_id - Related to the catalog of owners (cat_owner)',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE ',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','location_type',NULL,13,'string','combo','Location type','Location type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''ELEMENT'' AND active IS TRUE',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','builtdate',NULL,14,'date','text','Builtdate:','Builtdate:',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','workcat_id',NULL,15,'string','text','Workcat','Workcat',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','workcat_id_end',NULL,16,'string','text','Workcat ID end','Workcat ID end','Only when state is obsolete',false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','comment',NULL,17,'string','text','Comment','Comment',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','rotation',NULL,18,'double','text','Rotation:','Rotation:',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_element','form_feature','tab_none','label_y',NULL,NULL,'string','text','Label y','label_y - Y coordinate of the label''s location',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','serial_number',NULL,NULL,'string','text','Serial number','serial number - Serial number of the element',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','label_x',NULL,NULL,'string','text','Label x','label_x - X coordinate of the label''s location',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','label_rotation',NULL,NULL,'double','text','Label rotation','label_rotation - Angle of rotation of the label',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','dma_id',NULL,NULL,'integer','combo','Dma','Dma',NULL,true,false,true,false,NULL,'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','function_type',NULL,NULL,'string','text','Function type','Function type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type=''ELEMENT'' AND active IS TRUE',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','category_type',NULL,NULL,'string','combo','Category type','Category type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type=''ELEMENT'' AND active IS TRUE',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','publish',NULL,NULL,'boolean','check','Publish','Publish',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','inventory',NULL,NULL,'boolean','check','Inventory','inventory',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_element','form_feature','tab_none','enddate',NULL,NULL,'date','text','Enddate','Enddate',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','node_id','lyt_data_1',1,'string','text','node_id','node_id',NULL,true,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','num_elements','lyt_data_1',3,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','comment','lyt_data_1',4,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','function_type','lyt_data_1',5,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EPUMP'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','category_type','lyt_data_1',6,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EPUMP'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','location_type','lyt_data_1',7,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EPUMP'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','workcat_id','lyt_data_1',8,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','workcat_id_end','lyt_data_1',9,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','enddate','lyt_data_1',11,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','ownercat_id','lyt_data_1',12,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','rotation','lyt_data_1',13,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','top_elev','lyt_data_1',14,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','nodarc_id','lyt_data_2',1,'string','text','nodarc_id','nodarc_id',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','to_arc','lyt_data_2',2,'integer','text','to_arc','to_arc',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','flwreg_length','lyt_data_2',3,'double','text','flwreg_length','flwreg_length',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','order_id','lyt_data_2',4,'double','text','order_id','order_id',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','expl_id','lyt_data_2',5,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','muni_id','lyt_data_3',1,'integer','combo','municipality','muni_id',NULL,false,false,true,false,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,56),
	 ('ve_frelem_epump','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPUMP''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type','EPA Type',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_frelem_epump','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_frelem_epump','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_frelem_epump','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_element',false,4),
	 ('ve_frelem_epump','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_frelem_epump','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_frelem_epump','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','node_id','lyt_data_1',1,'integer','text','node_id','node_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','code','lyt_data_1',2,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','num_elements','lyt_data_1',3,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','comment','lyt_data_1',4,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','function_type','lyt_data_1',5,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','category_type','lyt_data_1',6,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','location_type','lyt_data_1',7,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EVALVE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','workcat_id','lyt_data_1',8,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','workcat_id_end','lyt_data_1',9,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','enddate','lyt_data_1',11,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','ownercat_id','lyt_data_1',12,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','rotation','lyt_data_1',13,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','top_elev','lyt_data_1',14,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','nodarc_id','lyt_data_2',1,'string','text','nodarc_id','nodarc_id',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','to_arc','lyt_data_2',2,'integer','text','to_arc','to_arc',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','flwreg_length','lyt_data_2',3,'double','text','flwreg_length','flwreg_length',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','order_id','lyt_data_2',4,'double','text','order_id','order_id',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','expl_id','lyt_data_2',5,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','muni_id','lyt_data_3',1,'integer','combo','municipality','muni_id',NULL,false,false,true,false,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,56),
	 ('ve_frelem_evalve','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EVALVE''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type','EPA Type',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''',NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_frelem_evalve','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_frelem_evalve','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_frelem_evalve','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_element',false,4),
	 ('ve_frelem_evalve','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_frelem_evalve','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_frelem_evalve','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','rotation','lyt_data_1',12,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''ECOVER''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,1),
	 ('ve_genelem_ecover','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_element',false,2),
	 ('ve_genelem_ecover','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_element',false,3),
	 ('ve_genelem_ecover','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_element',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_element',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_element',false,4),
	 ('ve_genelem_ecover','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_genelem_ecover','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_genelem_ecover','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','rotation','lyt_data_1',12,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EHYDRANT_PLATE''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_genelem_ehydrant_plate','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','rotation','lyt_data_1',12,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EMANHOLE''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_genelem_emanhole','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_genelem_emanhole','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','rotation','lyt_data_1',12,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPROTECT_BAND''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_genelem_eprotect_band','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_genelem_eprotect_band','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','rotation','lyt_data_1',12,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''EREGISTER''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_genelem_eregister','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_genelem_eregister','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',NULL,false,false,true,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL and sector_id >= 0',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,true,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','rotation','lyt_data_1',12,'double','text','Rotation','Rotation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation','Top Elevation',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',NULL,false,false,true,NULL,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":true}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_element WHERE element_type = ''ESTEP''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false,"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','feature_id','lyt_features_1',1,'text','text',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','btn_insert','lyt_features_1',2,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "111"
}','{
  "saveValue": false
}','{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}',NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','btn_delete','lyt_features_1',3,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
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
	 ('ve_genelem_estep','form_feature','tab_features','btn_snapping','lyt_features_1',4,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "137"
}','{
  "saveValue": false
}','{
  "functionName": "selection_init"
}',NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','btn_expr_select','lyt_features_1',5,NULL,'button',NULL,NULL,NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{
  "icon": "178"
}','{
  "saveValue": false
}',NULL,NULL,false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}',NULL,'tbl_element_x_arc',false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}',NULL,'tbl_element_x_connec',false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}',NULL,'tbl_element_x_gully',false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}',NULL,'tbl_element_x_link',false,NULL),
	 ('ve_genelem_estep','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',1,NULL,'tableview','','',NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}',NULL,'tbl_element_x_node',false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','sector','sector_id',NULL,false,false,true,false,NULL,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','dma_id','lyt_bot_1',2,'integer','combo','Dma','Dma',NULL,false,false,true,false,NULL,'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL AND active IS TRUE ',true,false,'expl_id',' AND dma.expl_id',NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,7),
	 ('ve_node_netelement','form_feature','tab_data','state','lyt_bot_1',3,'integer','combo','state','state',NULL,false,true,true,false,NULL,'WITH check_value AS (
  SELECT value::integer AS psector_value 
  FROM config_param_user 
  WHERE parameter = ''plan_psector_mode''
  AND cur_user = ''||CURRENT_USER||''
)
SELECT id, name as idval 
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT psector_value FROM check_value) IS NULL THEN id != 2 
  ELSE true 
END',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','state_type','lyt_bot_1',4,'integer','combo','State type','state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','code','lyt_data_1',1,'text','text','Code:','Code:',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,9),
	 ('ve_node_netelement','form_feature','tab_data','top_elev','lyt_data_1',2,'double','text','top_elev','top_elev',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_node_netelement','form_feature','tab_data','depth','lyt_data_1',3,'double','text','depth','depth',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,11),
	 ('ve_node_netelement','form_feature','tab_data','sys_type','lyt_data_1',4,'string','text','sys_type','sys_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','datasource','lyt_data_1',5,'integer','combo','Datasource','datasource',NULL,false,false,true,false,NULL,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,10),
	 ('ve_node_netelement','form_feature','tab_data','cat_matcat_id','lyt_data_1',6,'string','text','cat_matcat_id','cat_matcat_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,12),
	 ('ve_node_netelement','form_feature','tab_data','cat_pnom','lyt_data_1',7,'string','text','Nominal pressure','cat_pnom - Nominal pressure of the element in atm. It cannot be refilled. The one with the pnom field in the corresponding catalog is used',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,13),
	 ('ve_node_netelement','form_feature','tab_data','cat_dnom','lyt_data_1',8,'string','text','cat_dnom','cat_dnom',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,14),
	 ('ve_node_netelement','form_feature','tab_data','workcat_id','lyt_data_1',9,'string','typeahead','Workcat','Workcat',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,15),
	 ('ve_node_netelement','form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','builtdate','builtdate',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,16),
	 ('ve_node_netelement','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','ownercat_id','ownercat_id',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE ',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,18),
	 ('ve_node_netelement','form_feature','tab_data','workcat_id_end','lyt_data_1',12,'string','typeahead','Workcat ID end','Workcat ID end','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,19),
	 ('ve_node_netelement','form_feature','tab_data','enddate','lyt_data_1',13,'date','datetime','enddate','enddate',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,20),
	 ('ve_node_netelement','form_feature','tab_data','macrodqa_id','lyt_data_1',14,'integer','combo','macrodqa_id','macrodqa_id',NULL,false,false,false,false,NULL,'SELECT macrodqa_id as id, name as idval FROM macrodqa WHERE macrodqa_id IS NOT NULL  AND active IS TRUE ',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,22),
	 ('ve_node_netelement','form_feature','tab_data','staticpressure','lyt_data_1',15,'integer','text','staticpressure','staticpressure',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,24),
	 ('ve_node_netelement','form_feature','tab_data','macrodma_id','lyt_data_1',16,'integer','text','Macroomzone ID','Macroomzone ID',NULL,false,false,false,false,NULL,'SELECT macrodma_id as id, name as idval FROM macrodma where macrodma_id is not null AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,25),
	 ('ve_node_netelement','form_feature','tab_data','minsector_id','lyt_data_1',17,'integer','text','Minsector_id','minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,21),
	 ('ve_node_netelement','form_feature','tab_data','sector_name','lyt_data_1',18,'string','text','Sector name','sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','dma_name','lyt_data_1',19,'string','text','Dma name','dma_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','om_state','lyt_data_1',20,'string','text','om_state','om_state',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','conserv_state','lyt_data_1',21,'string','text','conserv_state','conserv_state',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','access_type','lyt_data_1',22,'string','text','Access type','access_type',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','placement_type','lyt_data_1',23,'string','text','Placement Type','Placement Type',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','brand','lyt_data_1',24,'string','text','brand','brand',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','model','lyt_data_1',25,'string','text','model','model',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','serial_number','lyt_data_1',26,'string','text','Serial_number','serial_number',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','brand_id','lyt_data_1',27,'text','text','Brand id','brand_id',NULL,false,NULL,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','model_id','lyt_data_1',28,'text','text','Model_id','model_id',NULL,false,NULL,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','label_quadrant','lyt_data_1',29,'text','combo','label_quadrant','label_quadrant',NULL,false,NULL,true,NULL,NULL,'select id, idval from edit_typevalue where typevalue = ''label_quadrant''',NULL,true,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','macrominsector_id','lyt_data_1',30,'integer','text','Macrominsector_id','macrominsector_id',NULL,false,NULL,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','cat_dint','lyt_data_1',31,'string','text','cat_dint','cat_dint',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','supplyzone_id','lyt_data_1',32,'text','text','Supplyzone_id','supplyzone_id',NULL,false,NULL,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','custom_top_elev','lyt_data_1',33,'text','text','custom_top_elev','custom_top_elev',NULL,false,NULL,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','lock_level','lyt_data_1',34,'integer','combo','Lock_level','lock_level',NULL,false,NULL,true,NULL,NULL,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level''',true,true,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','is_scadamap','lyt_data_1',35,'boolean','check','Is_scadamap','is_scadamap',NULL,false,NULL,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','macrosector_id','lyt_data_1',36,'integer','combo','macrosector_id','macrosector_id',NULL,false,false,false,false,NULL,'SELECT macrosector_id as id, name as idval FROM macrosector where macrosector_id is not null AND active IS TRUE ',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,26),
	 ('ve_node_netelement','form_feature','tab_data','pavcat_id','lyt_data_1',37,'text','typeahead','Pavcat_id','pavcat_id',NULL,false,NULL,true,NULL,NULL,'SELECT id, id AS idval FROM cat_pavement WHERE id IS NOT NULL',NULL,true,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','automated','lyt_data_1',38,'boolean','check','automated','automated',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','fence_type','lyt_data_1',39,'integer','combo','fence_type','fence_type',NULL,false,false,true,false,NULL,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_netelement_fencetype''',NULL,false,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','hemisphere','lyt_data_1',40,'string','text','Hemisphere','hemisphere',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,44),
	 ('ve_node_netelement','form_feature','tab_data','parent_id','lyt_data_1',41,'string','typeahead','parent_id','parent_id','Optional: Node_id of the parent node',false,false,true,false,NULL,'SELECT node_id AS id, node_id AS idval FROM node WHERE node_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,31),
	 ('ve_node_netelement','form_feature','tab_data','macroexpl_id','lyt_data_1',NULL,'text','text','Macroexploitation','macroexpl_id',NULL,true,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','arc_id','lyt_data_2',1,'string','typeahead','Arc ID','arc_id','Optional: Arc_id of related arc',false,false,false,false,NULL,'SELECT arc_id as id, arc_id as idval FROM arc WHERE arc_id IS NOT NULL',NULL,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,30),
	 ('ve_node_netelement','form_feature','tab_data','soilcat_id','lyt_data_2',2,'string','combo','Soilcat id','soilcat_id - Relacionado con el catalogo de suelos (cat_soil)',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_soil WHERE id IS NOT NULL AND active IS TRUE ',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,32),
	 ('ve_node_netelement','form_feature','tab_data','function_type','lyt_data_2',3,'string','combo','function_type','function_type',NULL,false,false,true,false,NULL,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null AND feature_type=''NODE'') ) AND active IS TRUE  OR ''NETELEMENT'' = ANY(featurecat_id::text[])',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,33),
	 ('ve_node_netelement','form_feature','tab_data','category_type','lyt_data_2',4,'string','combo','Category type','Category type',NULL,false,false,true,false,NULL,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null AND feature_type=''NODE'')) AND active IS TRUE  OR ''NETELEMENT'' = ANY(featurecat_id::text[])',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,34),
	 ('ve_node_netelement','form_feature','tab_data','fluid_type','lyt_data_2',5,'string','combo','fluid_type','fluid_type',NULL,false,false,false,false,NULL,'SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE ((featurecat_id is null AND feature_type=''NODE'') ) AND active IS TRUE  OR ''NETELEMENT'' = ANY(featurecat_id::text[])',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,35),
	 ('ve_node_netelement','form_feature','tab_data','location_type','lyt_data_2',6,'string','combo','location_type','location_type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null AND feature_type=''NODE'') ) AND active IS TRUE  OR ''NETELEMENT'' = ANY(featurecat_id::text[])',true,true,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,36),
	 ('ve_node_netelement','form_feature','tab_data','comment','lyt_data_2',7,'string','text','Comment','Comment',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,40),
	 ('ve_node_netelement','form_feature','tab_data','num_value','lyt_data_2',8,'double','text','Number value','Number value',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,41),
	 ('ve_node_netelement','form_feature','tab_data','label','lyt_data_2',9,'string','text','Catalog label','label',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,45),
	 ('ve_node_netelement','form_feature','tab_data','label_y','lyt_data_2',10,'string','text','label_y','label_y',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,46),
	 ('ve_node_netelement','form_feature','tab_data','label_x','lyt_data_2',11,'string','text','Label x','label_x - X coordinate of the label''s location',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,47),
	 ('ve_node_netelement','form_feature','tab_data','label_rotation','lyt_data_2',12,'double','text','Label rotation','label_rotation - Angle of rotation of the label',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,48),
	 ('ve_node_netelement','form_feature','tab_data','publish','lyt_data_2',13,'boolean','check','publish','publish',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,50),
	 ('ve_node_netelement','form_feature','tab_data','inventory','lyt_data_2',14,'boolean','check','inventory','inventory',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,51),
	 ('ve_node_netelement','form_feature','tab_data','rotation','lyt_data_2',15,'double','text','Rotation:','rotation - Field to use in order to rotate the symbology of the GIS canvas',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,43),
	 ('ve_node_netelement','form_feature','tab_data','svg','lyt_data_2',16,'string','text','Svg','svg - In case of using svg symbology, the path to the file containing the symbology is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,42),
	 ('ve_node_netelement','form_feature','tab_data','verified','lyt_data_2',17,'integer','combo','Verified','verified',NULL,false,false,true,false,NULL,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''',true,true,NULL,NULL,NULL,'{"setMultiline": false}',NULL,NULL,false,8),
	 ('ve_node_netelement','form_feature','tab_data','presszone_id','lyt_data_2',18,'integer','combo','Presszone','presszone_id',NULL,false,false,true,false,NULL,'SELECT presszone.presszone_id as id, name as idval FROM presszone WHERE presszone_id=''0'' UNION SELECT presszone.presszone_id AS id, presszone.name AS idval FROM presszone WHERE presszone_id IS NOT NULL AND active IS TRUE ',true,false,'expl_id',' AND presszone.expl_id',NULL,'{"setMultiline": false, "valueRelation": {"layer": "ve_presszone", "activated": true, "keyColumn": "presszone_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,6),
	 ('ve_node_netelement','form_feature','tab_data','presszone_name','lyt_data_2',19,'string','text','Presszone name','presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','dqa_id','lyt_data_2',20,'integer','combo','Dqa','dqa_id',NULL,false,false,false,false,NULL,'SELECT dqa_id as id, name as idval FROM dqa WHERE dqa_id IS NOT NULL  AND active IS TRUE ',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dqa", "activated": true, "keyColumn": "dqa_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,23),
	 ('ve_node_netelement','form_feature','tab_data','dqa_name','lyt_data_2',21,'string','text','Dqa name','dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','expl_id','lyt_data_2',22,'integer','combo','Explotation ID','Explotation ID',NULL,false,true,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false, "valueRelation": {"layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,5),
	 ('ve_node_netelement','form_feature','tab_data','workcat_id_plan','lyt_data_2',23,'string','typeahead','Workcat ID plan','workcat_id_plan - Item planning record',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,52),
	 ('ve_node_netelement','form_feature','tab_data','asset_id','lyt_data_2',24,'string','text','asset_id','asset_id',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','demand_max','lyt_data_2',25,'numeric','text','demand_max','demand_max',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','demand_min','lyt_data_2',26,'numeric','text','demand_min','demand_min',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','demand_avg','lyt_data_2',27,'numeric','text','demand_avg','demand_avg',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','press_max','lyt_data_2',28,'numeric','text','press_max','press_max',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','press_min','lyt_data_2',29,'numeric','text','press_min','press_min',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','press_avg','lyt_data_2',30,'numeric','text','press_avg','press_avg',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','head_max','lyt_data_2',31,'numeric','text','head_max','head_max',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','head_min','lyt_data_2',32,'numeric','text','head_min','head_min',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','head_avg','lyt_data_2',33,'numeric','text','head_avg','head_avg',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','quality_max','lyt_data_2',34,'numeric','text','quality_max','quality_max',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','quality_min','lyt_data_2',35,'numeric','text','quality_min','quality_min',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','quality_avg','lyt_data_2',36,'numeric','text','quality_avg','quality_avg',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','expl_id2','lyt_data_2',37,'integer','combo','Exploitation 2','expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,true,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL and expl_id !=0',true,true,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','muni_id','lyt_data_3',1,'integer','combo','muni_id','muni_id',NULL,false,true,true,false,NULL,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,54),
	 ('ve_node_netelement','form_feature','tab_data','postcode','lyt_data_3',2,'string','text','postcode','postcode',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,55),
	 ('ve_node_netelement','form_feature','tab_data','district_id','lyt_data_3',3,'integer','combo','District','district_id',NULL,false,false,true,false,NULL,'SELECT a.district_id AS id, a.name AS idval FROM ext_district a JOIN ext_municipality m USING (muni_id) WHERE district_id IS NOT NULL ',NULL,true,'muni_id',' AND m.muni_id',NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_node_netelement','form_feature','tab_data','streetaxis_id','lyt_data_3',4,'string','typeahead','streetname','streetname',NULL,false,false,true,false,NULL,'SELECT id AS id, a.descript AS idval FROM v_ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL',NULL,true,'muni_id',' AND m.name',NULL,'{"setMultiline":false}',NULL,NULL,false,56),
	 ('ve_node_netelement','form_feature','tab_data','postnumber','lyt_data_3',5,'integer','typeahead','postnumber','postnumber',NULL,false,false,true,false,NULL,'SELECT a.postnumber AS id, a.postnumber AS idval FROM ext_address a JOIN ext_streetaxis m ON streetaxis_id=m.id WHERE a.id IS NOT NULL',NULL,NULL,'streetname',' AND m.name',NULL,'{"setMultiline":false}',NULL,NULL,false,57),
	 ('ve_node_netelement','form_feature','tab_data','postcomplement','lyt_data_3',6,'string','text','postcomplement','postcomplement',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,58),
	 ('ve_node_netelement','form_feature','tab_data','streetaxis2_id','lyt_data_3',7,'string','typeahead','streetname2','streetname2',NULL,false,false,true,false,NULL,'SELECT id AS id, a.descript AS idval FROM v_ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL',NULL,true,'muni_id',' AND m.name',NULL,'{"setMultiline":false}',NULL,NULL,false,59),
	 ('ve_node_netelement','form_feature','tab_data','postnumber2','lyt_data_3',8,'integer','typeahead','Second street number','postnumber2 - Second street number',NULL,false,false,true,false,NULL,'SELECT a.postnumber AS id, a.postnumber AS idval FROM ext_address a JOIN ext_streetaxis m ON streetaxis_id=m.id WHERE a.id IS NOT NULL',NULL,NULL,'streetname2',' AND m.name',NULL,'{"setMultiline":false}',NULL,NULL,false,60),
	 ('ve_node_netelement','form_feature','tab_data','region_id','lyt_data_3',9,'integer','combo','Region','region_id',NULL,false,false,false,false,NULL,'SELECT region_id as id, name as idval FROM ext_region WHERE region_id IS NOT NULL',true,true,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','postcomplement2','lyt_data_3',10,'string','text','postcomplement2','postcomplement2',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,61),
	 ('ve_node_netelement','form_feature','tab_data','province_id','lyt_data_3',11,'integer','combo','Province','province_id',NULL,false,false,false,false,NULL,'SELECT province_id as id, name as idval FROM ext_province WHERE province_id IS NOT NULL',true,true,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','descript','lyt_data_3',12,'string','text','Descript','descript',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,37),
	 ('ve_node_netelement','form_feature','tab_data','annotation','lyt_data_3',13,'string','text','Annotation','annotation - Annotations related to node. Additional information',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,38),
	 ('ve_node_netelement','form_feature','tab_data','observ','lyt_data_3',14,'string','text','observ','observ',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,39),
	 ('ve_node_netelement','form_feature','tab_data','lastupdate','lyt_data_3',15,'date','text','Last update','lastupdate',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,28),
	 ('ve_node_netelement','form_feature','tab_data','lastupdate_user','lyt_data_3',16,'string','text','Last update user','lastupdate_user',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,29),
	 ('ve_node_netelement','form_feature','tab_data','link','lyt_data_3',17,'string','hyperlink','Link','link - Field to store link to information related to the node.',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}','{"functionName": "open_url"}','action_link',false,27),
	 ('ve_node_netelement','form_feature','tab_data','node_id','lyt_none',1,'string','text','node_id','node_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,1),
	 ('ve_node_netelement','form_feature','tab_data','node_type','lyt_top_1',1,'string','text','Node type:','nodetype_id - Node type. It is automatically populated based on nodecat_id',NULL,false,true,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,2),
	 ('ve_node_netelement','form_feature','tab_data','nodecat_id','lyt_top_1',2,'string','typeahead','nodecat_id','nodecat_id',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_node WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,'node_type',' AND node_type',NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_node", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,3),
	 ('ve_node_netelement','form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','Epa type','epa_type - Type of node to use for the hydraulic model. It is not necessary to enter it, it is automatic depending on the node type.',NULL,false,false,true,true,NULL,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''NODE''',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,4),
	 ('ve_node_netelement','form_feature','tab_data','adescript',NULL,NULL,'text','text','Adescript','adescript',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','adate',NULL,NULL,'text','text','Adate','adate',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','accessibility',NULL,NULL,'integer','text','Accessibility','Accessibility',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','dma_style',NULL,NULL,'text','text','Dma color','Dma color',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_node_netelement','form_feature','tab_data','presszone_style',NULL,NULL,'text','text','Presszone color','presszone_style',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL) ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET layoutorder=EXCLUDED.layoutorder, layoutname=EXCLUDED.layoutname;
