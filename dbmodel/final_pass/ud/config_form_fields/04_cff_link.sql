/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,dv_parent_id,dv_querytext_filterc,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder) VALUES
	 ('incident_link','form_visit','tab_data','startdate','lyt_data_1',NULL,'date','datetime','Date:',NULL,NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,4),
	 ('incident_link','form_visit','tab_data','class_id','lyt_data_1',NULL,'integer','combo','Visit class:',NULL,NULL,false,false,true,NULL,NULL,'SELECT id, idval FROM config_visit_class WHERE feature_type=''LINK'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',NULL,NULL,NULL,NULL,NULL,NULL,'{"functionName": "get_visit"}',NULL,false,1),
	 ('incident_link','form_visit','tab_data','visit_id','lyt_data_1',NULL,'double','text','Visit id:',NULL,NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,2),
	 ('incident_link','form_visit','tab_data','status','lyt_data_1',NULL,'integer','combo','Status:',NULL,NULL,false,false,true,NULL,NULL,'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,7),
	 ('incident_link','form_visit','tab_data','incident_comment','lyt_data_1',NULL,'string','text','Comment:',NULL,NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,6),
	 ('incident_link','form_visit','tab_data','incident_type','lyt_data_1',NULL,'integer','combo','Incident type:',NULL,NULL,false,false,true,NULL,NULL,'SELECT id, idval FROM om_typevalue WHERE typevalue = ''incident_type''',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,5),
	 ('incident_link','form_visit','tab_data','link_id','lyt_data_1',NULL,'double','text','Link id:',NULL,NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,3),
	 ('incident_link','form_visit','tab_data','acceptbutton','lyt_data_2',NULL,NULL,'button','',NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false, "text":"Accept"}','{
  "functionName": "set_visit"
}',NULL,false,1),
	 ('incident_link','form_visit','tab_file','addfile','lyt_files_1',NULL,NULL,'fileselector','',NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false, "text":"Add File"}','{
  "functionName": "add_file"
}',NULL,false,1),
	 ('incident_link','form_visit','tab_file','tbl_files','lyt_files_1',NULL,NULL,'tableview','',NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}',NULL,'om_visit_event_photo',false,2),
	 ('incident_link','form_visit','tab_file','backbutton','lyt_files_2',NULL,NULL,'button','',NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false, "text":"Back"}','{
  "functionName": "set_previous_form_back"
}',NULL,false,1),
	 ('v_edit_link','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','sector_id  - Sector identifier.',NULL,false,false,false,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','link_id','lyt_data_1',1,'integer','text','Link ID','Link ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','feature_type','lyt_data_1',2,'string','combo','Feature type','Feature type',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','feature_id','lyt_data_1',3,'string','text','feature_id','feature_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','exit_type','lyt_data_1',4,'string','combo','Exit type','Exit type',NULL,false,false,false,false,NULL,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','exit_id','lyt_data_1',5,'string','text','Exit ID','Exit ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','state','lyt_data_1',6,'integer','combo','State:','State:',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','expl_id','lyt_data_1',7,'integer','combo','Explotation ID','expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,false,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','omzone_id','lyt_data_1',8,'integer','combo','Omzone ID','Omzone ID',NULL,false,false,false,false,NULL,'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','presszone_id','lyt_data_1',9,'integer','text','presszone_id','presszone_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','minsector_id','lyt_data_1',10,'integer','text','minsector_id','minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','fluid_type','lyt_data_1',11,'string','text','fluid_type','fluid_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','gis_length','lyt_data_1',12,'double','text','Gis length','Gis length',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','sector_name','lyt_data_1',13,'string','text','sector_name','sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','omzone_name','lyt_data_1',14,'string','text','omzone_name','omzone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','dqa_name','lyt_data_1',15,'string','text','dqa_name','dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','presszone_name','lyt_data_1',16,'string','text','presszone_name','presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','macrosector_id','lyt_data_1',17,'integer','text','Macrosector id','Macrosector id','Ex.macrosector_id',false,false,false,false,NULL,NULL,true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','macroomzone_id','lyt_data_1',18,'integer','text','Macroomzone ID','Macroomzone ID',NULL,false,false,false,false,NULL,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','macrodqa_id','lyt_data_1',19,'integer','text','macrodqa_id','macrodqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','epa_type','lyt_data_1',20,'string','text','epa_type','epa_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','is_operative','lyt_data_1',21,'boolean','check','is_operative','is_operative',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','conneccat_id','lyt_data_1',22,'string','typeahead','Connecat ID','connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ',true,NULL,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,NULL),
	 ('v_edit_link','form_feature','tab_data','workcat_id','lyt_data_1',23,'string','typeahead','Workcat ID','workcat_id - Related to the catalog of work files (cat_work). File that registers the element',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('v_edit_link','form_feature','tab_data','workcat_id_end','lyt_data_1',24,'string','typeahead','Workcat ID end','workcat_id_end - ID of the  end of construction work.','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','builtdate','lyt_data_1',25,'date','datetime','Builtdate:','builtdate - Date the element was added. In insertion of new elements the date of the day is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','enddate','lyt_data_1',26,'date','datetime','Enddate','enddate - End date of the element. It will only be filled in if the element is in a deregistration state.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','uncertain','lyt_data_1',27,'boolean','check','Uncertain','uncertain - To set if the element''s location is uncertain',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','top_elev1','lyt_data_1',28,'integer','text','Top Elev 1','top_elev1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','y1','lyt_data_1',29,'integer','text','Y1','y1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','elevation1','lyt_data_1',30,'integer','text','Elevation1','elevation1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','top_elev2','lyt_data_1',31,'integer','text','Top elev 2','top_elev2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','y2','lyt_data_1',32,'integer','text','Y2','y2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','elevation2','lyt_data_1',33,'integer','text','Elevation2','elevation2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','location_type','lyt_data_1',34,'string','combo','Location Type','Location Type',NULL,false,false,true,false,NULL,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null AND feature_type=''LINK'') ) AND active IS TRUE',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','comment','lyt_data_1',35,'string','text','Comment','Comment',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','descript','lyt_data_1',36,'string','text','Descript','Descript',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','num_value','lyt_data_1',37,'double','text','Num Value','Num Value',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','dqa_id','lyt_data_2',1,'integer','text','dqa_id','dqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('v_edit_link','form_feature','tab_data','annotation','lyt_data_3',1,'string','text','Annotation','annotation - Annotations related to link. Additional information',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observ','Observ',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_data','link','lyt_data_3',3,'string','hyperlink','Link','Link',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,1),
	 ('v_edit_link','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,2),
	 ('v_edit_link','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_link',false,3),
	 ('v_edit_link','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('v_edit_link','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_link',false,NULL),
	 ('v_edit_link','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('v_edit_link','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('v_edit_link','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_link',false,4),
	 ('v_edit_link','form_feature','tab_elements','element_id','lyt_element_1',1,'string','typeahead','Element id:','Element id',NULL,false,false,true,false,false,'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}',NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_elements','insert_element','lyt_element_1',2,NULL,'button',NULL,'Insert element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}','v_edit_link',false,NULL),
	 ('v_edit_link','form_feature','tab_elements','delete_element','lyt_element_1',3,NULL,'button',NULL,'Delete element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}','{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}','tbl_element_x_link',false,NULL),
	 ('v_edit_link','form_feature','tab_elements','new_element','lyt_element_1',4,NULL,'button',NULL,'New element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}','v_edit_link',false,NULL),
	 ('v_edit_link','form_feature','tab_elements','hspacer_lyt_element','lyt_element_1',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('v_edit_link','form_feature','tab_elements','open_element','lyt_element_1',6,NULL,'button',NULL,'Open element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}','v_edit_link',false,NULL),
	 ('v_edit_link','form_feature','tab_elements','btn_link','lyt_element_1',7,NULL,'button',NULL,'Open link',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"173"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}','v_edit_link',false,NULL),
	 ('v_edit_link','form_feature','tab_elements','tbl_elements','lyt_element_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}','tbl_element_x_link',false,1),
	 ('v_edit_link','form_feature','tab_none','n_hydrometer','lyt_data_1',1,'integer','text','n_hydrometer','n_hydrometer',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','sector_id  - Sector identifier.',NULL,false,false,false,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type','state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','link_id','lyt_data_1',1,'integer','text','Link ID','Link ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','feature_type','lyt_data_1',2,'string','combo','Feature type','Feature type',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','feature_id','lyt_data_1',3,'string','text','feature_id','feature_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','exit_type','lyt_data_1',4,'string','combo','Exit type','Exit type',NULL,false,false,false,false,NULL,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','exit_id','lyt_data_1',5,'string','text','Exit ID','Exit ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','omzone_id','lyt_data_1',6,'integer','combo','Omzone ID','Omzone ID',NULL,false,false,false,false,NULL,'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','presszone_id','lyt_data_1',7,'integer','text','presszone_id','presszone_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','minsector_id','lyt_data_1',8,'integer','text','minsector_id','minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','fluid_type','lyt_data_1',9,'string','text','fluid_type','fluid_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','gis_length','lyt_data_1',10,'double','text','Gis length','Gis length',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','sector_name','lyt_data_1',11,'string','text','sector_name','sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','dma_name','lyt_data_1',12,'string','text','dma_name','dma_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','dqa_name','lyt_data_1',13,'string','text','dqa_name','dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','presszone_name','lyt_data_1',14,'string','text','presszone_name','presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','macroomzone_id','lyt_data_1',15,'integer','text','Macroomzone ID','Macroomzone ID',NULL,false,false,false,false,NULL,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','macrosector_id','lyt_data_1',16,'integer','text','Macrosector id','Macrosector id','Ex.macrosector_id',false,false,false,false,NULL,NULL,true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','macrodqa_id','lyt_data_2',1,'integer','text','macrodqa_id','macrodqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','epa_type','lyt_data_2',2,'string','text','epa_type','epa_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','is_operative','lyt_data_2',3,'boolean','check','is_operative','is_operative',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','conneccat_id','lyt_data_2',4,'string','typeahead','Connecat ID','connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ',true,NULL,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','workcat_id','lyt_data_2',5,'string','typeahead','Workcat ID','workcat_id - Related to the catalog of work files (cat_work). File that registers the element',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','workcat_id_end','lyt_data_2',6,'string','typeahead','Workcat ID end','workcat_id_end - ID of the  end of construction work.','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','builtdate','lyt_data_2',7,'date','datetime','Builtdate:','builtdate - Date the element was added. In insertion of new elements the date of the day is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','enddate','lyt_data_2',8,'date','datetime','Enddate','enddate - End date of the element. It will only be filled in if the element is in a deregistration state.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','uncertain','lyt_data_2',9,'boolean','check','Uncertain','uncertain - To set if the element''s location is uncertain',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','top_elev1','lyt_data_2',10,'integer','text','Top Elev 1','top_elev1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','depth1','lyt_data_2',11,'integer','text','Depth1','depth1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','elevation1','lyt_data_2',12,'integer','text','Elevation1','elevation1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','top_elev2','lyt_data_2',13,'integer','text','Top elev 2','top_elev2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','depth2','lyt_data_2',14,'integer','text','Depth2','depth2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','elevation2','lyt_data_2',15,'integer','text','Elevation2','elevation2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','dqa_id','lyt_data_2',16,'integer','text','Dqa','dqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,true,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','expl_id','lyt_data_2',17,'integer','combo','Explotation ID','expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,false,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "nullValue": false,
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "valueColumn": "name",
    "filterExpression": null
  }
}',NULL,NULL,false,NULL),
	 ('ve_link_conduitlink','form_feature','tab_data','link_type','lyt_top_1',1,'string','combo','Link Type','Type of link. It is auto-populated based on the linkcat_id',NULL,true,true,false,false,NULL,'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,2),
	 ('ve_link_conduitlink','form_feature','tab_data','linkcat_id','lyt_top_1',2,'string','typeahead','Linkcat ID','linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,'link_type',' AND cat_link.link_type IS NULL OR cat_link.link_type',NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,3),
	 ('ve_link_conduitlink','form_feature','tab_documents','date_to','lyt_document_1',1,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,2),
	 ('ve_link_conduitlink','form_feature','tab_documents','doc_type','lyt_document_1',2,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_link',false,3),
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
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
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
	 ('ve_link_conduitlink','form_feature','tab_elements','tbl_elements','lyt_element_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}','tbl_element_x_link',false,1),
	 ('ve_link_link','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','sector_id  - Sector identifier.',NULL,false,false,false,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type','state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','link_id','lyt_data_1',1,'integer','text','Link ID','Link ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','feature_type','lyt_data_1',2,'string','combo','Feature type','Feature type',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','feature_id','lyt_data_1',3,'string','text','feature_id','feature_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','exit_type','lyt_data_1',4,'string','combo','Exit type','Exit type',NULL,false,false,false,false,NULL,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','exit_id','lyt_data_1',5,'string','text','Exit ID','Exit ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','omzone_id','lyt_data_1',6,'integer','combo','Omzone ID','Omzone ID',NULL,false,false,false,false,NULL,'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','presszone_id','lyt_data_1',7,'integer','text','presszone_id','presszone_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','minsector_id','lyt_data_1',8,'integer','text','minsector_id','minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','fluid_type','lyt_data_1',9,'string','text','fluid_type','fluid_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','gis_length','lyt_data_1',10,'double','text','Gis length','Gis length',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','sector_name','lyt_data_1',11,'string','text','sector_name','sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','omzone_name','lyt_data_1',12,'string','text','omzone_name','omzone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','dqa_name','lyt_data_1',13,'string','text','dqa_name','dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','presszone_name','lyt_data_1',14,'string','text','presszone_name','presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','macroomzone_id','lyt_data_1',15,'integer','text','Macroomzone ID','Macroomzone ID',NULL,false,false,false,false,NULL,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','macrodqa_id','lyt_data_1',16,'integer','text','macrodqa_id','macrodqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','epa_type','lyt_data_1',17,'string','text','epa_type','epa_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','is_operative','lyt_data_1',18,'boolean','check','is_operative','is_operative',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','conneccat_id','lyt_data_1',19,'string','typeahead','Connecat ID','connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ',true,NULL,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,NULL),
	 ('ve_link_link','form_feature','tab_data','workcat_id','lyt_data_1',20,'string','typeahead','Workcat ID','workcat_id - Related to the catalog of work files (cat_work). File that registers the element',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_link_link','form_feature','tab_data','workcat_id_end','lyt_data_1',21,'string','typeahead','Workcat ID end','workcat_id_end - ID of the  end of construction work.','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','builtdate','lyt_data_1',22,'date','datetime','Builtdate:','builtdate - Date the element was added. In insertion of new elements the date of the day is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','enddate','lyt_data_1',23,'date','datetime','Enddate','enddate - End date of the element. It will only be filled in if the element is in a deregistration state.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','uncertain','lyt_data_1',24,'boolean','check','Uncertain','uncertain - To set if the element''s location is uncertain',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','top_elev1','lyt_data_1',25,'integer','text','Top Elev 1','top_elev1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','y1','lyt_data_1',26,'integer','text','Y1','y1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','elevation1','lyt_data_1',27,'integer','text','Elevation1','elevation1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','top_elev2','lyt_data_1',28,'integer','text','Top elev 2','top_elev2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','y2','lyt_data_1',29,'integer','text','Y2','y2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','elevation2','lyt_data_1',30,'integer','text','Elevation2','elevation2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_data','macrosector_id','lyt_data_1',31,'integer','text','Macrosector id','Macrosector id','Ex.macrosector_id',false,false,false,false,NULL,NULL,true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','dqa_id','lyt_data_2',1,'integer','text','Dqa','dqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_link','form_feature','tab_data','expl_id','lyt_data_2',2,'integer','combo','Explotation ID','expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,false,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":">="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,1),
	 ('ve_link_link','form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,2),
	 ('ve_link_link','form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_link',false,3),
	 ('ve_link_link','form_feature','tab_documents','doc_name','lyt_document_2',1,'string','typeahead','Doc id:','Doc id:',NULL,false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table"}',NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,NULL,'button',NULL,'Insert document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_link','form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,NULL,'button',NULL,'Delete document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}','{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}','tbl_doc_x_link',false,NULL),
	 ('ve_link_link','form_feature','tab_documents','btn_doc_new','lyt_document_2',4,NULL,'button',NULL,'New document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_link','form_feature','tab_documents','hspacer_document_1','lyt_document_2',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_documents','open_doc','lyt_document_2',6,NULL,'button',NULL,'Open document',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"147"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}','tbl_doc_x_link',false,NULL),
	 ('ve_link_link','form_feature','tab_documents','tbl_documents','lyt_document_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}','tbl_doc_x_link',false,4),
	 ('ve_link_link','form_feature','tab_elements','element_id','lyt_element_1',1,'string','typeahead','Element id:','Element id',NULL,false,false,true,false,false,'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ',NULL,NULL,NULL,NULL,NULL,'{"saveValue": false, "filterSign":"ILIKE"}','{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}',NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_elements','insert_element','lyt_element_1',2,NULL,'button',NULL,'Insert element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"113"}','{"saveValue":false, "filterSign":"="}','{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}','v_edit_link',false,NULL),
	 ('ve_link_link','form_feature','tab_elements','delete_element','lyt_element_1',3,NULL,'button',NULL,'Delete element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"114"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}','{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}','tbl_element_x_link',false,NULL),
	 ('ve_link_link','form_feature','tab_elements','new_element','lyt_element_1',4,NULL,'button',NULL,'New element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"143"}','{"saveValue":false, "filterSign":"="}','{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}','v_edit_link',false,NULL),
	 ('ve_link_link','form_feature','tab_elements','hspacer_lyt_element','lyt_element_1',5,NULL,'hspacer',NULL,NULL,NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,false,NULL),
	 ('ve_link_link','form_feature','tab_elements','open_element','lyt_element_1',6,NULL,'button',NULL,'Open element',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"144"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}','v_edit_link',false,NULL),
	 ('ve_link_link','form_feature','tab_elements','btn_link','lyt_element_1',7,NULL,'button',NULL,'Open link',NULL,false,false,true,false,false,NULL,NULL,NULL,NULL,NULL,'{"icon":"173"}','{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}','{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}','v_edit_link',false,NULL),
	 ('ve_link_link','form_feature','tab_elements','tbl_elements','lyt_element_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}','tbl_element_x_link',false,1),
	 ('ve_link_link','form_feature','tab_none','n_hydrometer','lyt_data_1',1,'integer','text','n_hydrometer','n_hydrometer',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','sector_id  - Sector identifier.',NULL,false,false,false,false,NULL,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:blue; font-weight:bold;"}','{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type','state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state',NULL,false,false,true,false,NULL,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'state',' AND value_state_type.state',NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','link_id','lyt_data_1',1,'integer','text','Link ID','Link ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','feature_type','lyt_data_1',2,'string','combo','Feature type','Feature type',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','feature_id','lyt_data_1',3,'string','text','feature_id','feature_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','exit_type','lyt_data_1',4,'string','combo','Exit type','Exit type',NULL,false,false,false,false,NULL,'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''',true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','exit_id','lyt_data_1',5,'string','text','Exit ID','Exit ID',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','omzone_id','lyt_data_1',6,'integer','combo','Omzone ID','Omzone ID',NULL,false,false,false,false,NULL,'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','presszone_id','lyt_data_1',7,'integer','text','presszone_id','presszone_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','minsector_id','lyt_data_1',8,'integer','text','minsector_id','minsector_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','fluid_type','lyt_data_1',9,'string','text','fluid_type','fluid_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','gis_length','lyt_data_1',10,'double','text','Gis length','Gis length',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','sector_name','lyt_data_1',11,'string','text','sector_name','sector_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','dma_name','lyt_data_1',12,'string','text','dma_name','dma_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','dqa_name','lyt_data_1',13,'string','text','dqa_name','dqa_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','presszone_name','lyt_data_1',14,'string','text','presszone_name','presszone_name',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','macroomzone_id','lyt_data_1',15,'integer','text','Macroomzone ID','Macroomzone ID',NULL,false,false,false,false,NULL,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','macrosector_id','lyt_data_1',16,'integer','text','Macrosector id','Macrosector id','Ex.macrosector_id',false,false,false,false,NULL,NULL,true,false,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','macrodqa_id','lyt_data_2',1,'integer','text','macrodqa_id','macrodqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','epa_type','lyt_data_2',2,'string','text','epa_type','epa_type',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','is_operative','lyt_data_2',3,'boolean','check','is_operative','is_operative',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','conneccat_id','lyt_data_2',4,'string','typeahead','Connecat ID','connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida',NULL,false,false,false,false,NULL,'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ',true,NULL,NULL,NULL,NULL,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}',NULL,'action_catalog',false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','workcat_id','lyt_data_2',5,'string','typeahead','Workcat ID','workcat_id - Related to the catalog of work files (cat_work). File that registers the element',NULL,false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,'action_workcat',false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','workcat_id_end','lyt_data_2',6,'string','typeahead','Workcat ID end','workcat_id_end - ID of the  end of construction work.','Only when state is obsolete',false,false,true,false,NULL,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','builtdate','lyt_data_2',7,'date','datetime','Builtdate:','builtdate - Date the element was added. In insertion of new elements the date of the day is shown',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','enddate','lyt_data_2',8,'date','datetime','Enddate','enddate - End date of the element. It will only be filled in if the element is in a deregistration state.',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','uncertain','lyt_data_2',9,'boolean','check','Uncertain','uncertain - To set if the element''s location is uncertain',NULL,false,false,true,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','top_elev1','lyt_data_2',10,'integer','text','Top Elev 1','top_elev1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','depth1','lyt_data_2',11,'integer','text','Depth1','depth1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','elevation1','lyt_data_2',12,'integer','text','Elevation1','elevation1',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','top_elev2','lyt_data_2',13,'integer','text','Top elev 2','top_elev2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','depth2','lyt_data_2',14,'integer','text','Depth2','depth2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','elevation2','lyt_data_2',15,'integer','text','Elevation2','elevation2',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','dqa_id','lyt_data_2',16,'integer','text','Dqa','dqa_id',NULL,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top"}',NULL,NULL,true,NULL),
	 ('ve_link_vlink','form_feature','tab_data','expl_id','lyt_data_2',17,'integer','combo','Explotation ID','expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry',NULL,false,false,false,false,NULL,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,NULL,NULL,'{"label":"color:green; font-weight:bold;"}','{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "nullValue": false,
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "valueColumn": "name",
    "filterExpression": null
  }
}',NULL,NULL,false,NULL),
	 ('ve_link_vlink','form_feature','tab_data','link_type','lyt_top_1',1,'string','combo','Link Type','Type of link. It is auto-populated based on the linkcat_id',NULL,true,true,false,false,NULL,'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL',true,false,NULL,NULL,NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,2),
	 ('ve_link_vlink','form_feature','tab_data','linkcat_id','lyt_top_1',2,'string','typeahead','Linkcat ID','linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch',NULL,true,false,true,false,NULL,'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ',NULL,NULL,'link_type',' AND cat_link.link_type IS NULL OR cat_link.link_type',NULL,'{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}',NULL,NULL,false,3),
	 ('ve_link_vlink','form_feature','tab_documents','date_to','lyt_document_1',1,'date','datetime','Date to:','Date to:',NULL,false,false,true,false,true,NULL,NULL,NULL,NULL,NULL,NULL,'{"labelPosition": "top", "filterSign":"<="}','{"functionName": "filter_table", "parameters":{"columnfind": "date"}}','tbl_doc_x_link',false,2),
	 ('ve_link_vlink','form_feature','tab_documents','doc_type','lyt_document_1',2,'string','combo','Doc type:','Doc type:',NULL,false,false,true,false,true,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''',NULL,true,NULL,NULL,NULL,'{"labelPosition": "top"}','{"functionName": "filter_table", "parameters":{}}','tbl_doc_x_link',false,3),
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
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
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
	 ('ve_link_vlink','form_feature','tab_elements','tbl_elements','lyt_element_3',1,NULL,'tableview',NULL,NULL,NULL,false,false,false,false,false,NULL,NULL,NULL,NULL,NULL,NULL,'{"saveValue": false}','{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}','tbl_element_x_link',false,1) ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET layoutorder=EXCLUDED.layoutorder, layoutname=EXCLUDED.layoutname;
