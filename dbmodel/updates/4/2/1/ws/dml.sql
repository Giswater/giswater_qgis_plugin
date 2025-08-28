/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_feature_class SET epa_default = 'UNDEFINED' WHERE type IN ('ELEMENT','CONNEC');

UPDATE sys_function SET function_name = 'gw_fct_pg2epa_flwreg2arc', descript = 'This functions transform flwreg elements to arcs.' WHERE id = 2318;

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('epa_toolbar', 'utils', 'v_ui_rpt_cat_result', 'dma_id', (SELECT MAX(columnindex) FROM config_form_tableview WHERE location_type = 'epa_toolbar' AND project_type = 'utils' AND objectname = 'v_ui_rpt_cat_result'), true, NULL, 'dma_id', NULL, NULL);


DELETE FROM config_form_fields WHERE formname ILIKE 've_element_%';
DO $$
DECLARE
  rec record;
  v_view text;
BEGIN
  FOR rec IN (SELECT * FROM cat_feature_element WHERE id NOT IN ('EPUMP', 'EORIFICE', 'EWEIR', 'EOUTLET', 'EVALVE', 'EMETER'))
  LOOP
    v_view := concat('ve_element_', lower(REPLACE(REC.id, ' ', '_')));

    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID:','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type:','State type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','code','lyt_data_1',1,'string','text','Code:','Code:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Element number:','Element number',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comment:','Comment',false,false,true,false,'{"setMultiline":true}'::json,true);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function type:','Function type',false,false,true,false,concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''E',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category type:','Category type',false,false,true,false,concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''E',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location type:','Location type',false,false,true,false,concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''E',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat:','Workcat',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID end:','Workcat ID end','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Builtdate:','Builtdate:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','Enddate:','Enddate',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner:','ownercat_id - Related to the catalog of owners (cat_owner)',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
        VALUES (v_view,'form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand:','brand_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand WHERE ''E',rec.id,''' = ANY(featurecat_id::text[])'),false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
        VALUES (v_view,'form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model:','model_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand_model WHERE ''E',rec.id,''' = ANY(featurecat_id::text[])'),false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','rotation','lyt_data_1',14,'double','text','Rotation:','Rotation:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','top_elev','lyt_data_1',15,'double','text','Top elevation:','top_elev - Elevation of the node in ft or m.',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation:','Exploitation',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
        VALUES (v_view,'form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observation:','Observation',false,false,true,false,'{"setMultiline":true}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Catalog:','Catalog',true,false,true,false,concat('SELECT id, id as idval FROM cat_element WHERE element_type = ''E',rec.id,''''),true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
        VALUES (v_view,'form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
        VALUES (v_view,'form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
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
        VALUES (v_view,'form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
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
        VALUES (v_view,'form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
    "icon": "137"
    }'::json,'{
    "saveValue": false
    }'::json,'{
    "functionName": "selection_init"
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
        VALUES (v_view,'form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
    "icon": "178"
    }'::json,'{
    "saveValue": false
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_arc",
    "featureType": "arc"
    }'::json,'tbl_element_x_arc',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_connec",
    "featureType": "connec"
    }'::json,'tbl_element_x_connec',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_link",
    "featureType": "link"
    }'::json,'tbl_element_x_link',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
        VALUES (v_view,'form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview',':','',false,false,false,false,false,'{
    "saveValue": false,
    "tableUpsert": "v_ui_element_x_node",
    "featureType": "node"
    }'::json,'tbl_element_x_node',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
      VALUES (v_view,'form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (v_view,'form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (v_view,'form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (v_view,'form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }'::json,'tbl_doc_x_element',false,4);
      END LOOP;
END $$;

-- FRELEM
DO $$
DECLARE
  rec record;
  v_view text;
BEGIN
  FOR rec IN SELECT val AS v_view,  elem as id FROM (VALUES ('ve_element_epump', 'EPUMP'), ('ve_element_evalve', 'EVALVE'), ('ve_element_emeter', 'EMETER')) AS t(val, elem)
  LOOP
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID:','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State:','State:',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State type:','State type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','code','lyt_data_1',2,'string','text','Code:','Code:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','num_elements','lyt_data_1',3,'integer','text','Element number:','Element number',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','comment','lyt_data_1',4,'string','text','Comment:','Comment',false,false,true,false,'{"setMultiline":true}'::json,true);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','function_type','lyt_data_1',5,'string','combo','Function type:','Function type',false,false,true,false,concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','category_type','lyt_data_1',6,'string','combo','Category type:','Category type',false,false,true,false,concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','location_type','lyt_data_1',7,'string','combo','Location type:','Location type',false,false,true,false,concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''',rec.id,''' = ANY(featurecat_id::text[])'),true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','workcat_id','lyt_data_1',8,'string','typeahead','Workcat:','Workcat',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','workcat_id_end','lyt_data_1',9,'string','typeahead','Workcat ID end:','Workcat ID end','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','builtdate','lyt_data_1',10,'date','datetime','Builtdate:','Builtdate:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','enddate','lyt_data_1',11,'date','datetime','Enddate:','Enddate',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','ownercat_id','lyt_data_1',12,'string','combo','Owner:','ownercat_id - Related to the catalog of owners (cat_owner)',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
      VALUES (rec.v_view,'form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand:','brand_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand WHERE ''',rec.id,''' = ANY(featurecat_id::text[])'));
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
      VALUES (rec.v_view,'form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model:','model_id',false,false,true,false,concat('SELECT id, id as idval FROM cat_brand_model WHERE ''',rec.id,''' = ANY(featurecat_id::text[])'));
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','rotation','lyt_data_1',15,'double','text','Rotation:','Rotation:',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','top_elev','lyt_data_1',16,'double','text','Top elevation:','top_elev - Elevation of the node in ft or m.',false,false,true,false,'{"setMultiline":false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','flwreg_length','lyt_data_2',1,'double','text','Flwreg length:','flwreg_length',true,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','node_id','lyt_data_1',1,'integer','text','Node id:','node_id',false,false,false,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','to_arc','lyt_data_2',2,'integer','text','To arc:','to_arc',true,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','expl_id','lyt_data_2',3,'integer','combo','Exploitation:','Exploitation',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observation:','Observation',false,false,true,false,'{"setMultiline":true}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Catalog:','Catalog',true,false,true,false,concat('SELECT id, id as idval FROM cat_element WHERE element_type = ''',rec.id,''''),true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
        VALUES (rec.v_view,'form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type:','EPA Type',false,false,true,true,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''','{"setMultiline": false, "labelPosition": "top"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','date_from','lyt_document_1',1,'date','datetime','Date from:','Date from:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":">="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,1);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','date_to','lyt_document_1',2,'date','datetime','Date to:','Date to:',false,false,true,false,true,'{"labelPosition": "top", "filterSign":"<="}'::json,'{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json,'tbl_doc_x_element',false,2);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_isnullvalue,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','doc_type','lyt_document_1',3,'string','combo','Doc type:','Doc type:',false,false,true,false,true,'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''',true,'{"labelPosition": "top"}'::json,'{"functionName": "filter_table", "parameters":{}}'::json,'tbl_doc_x_element',false,3);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,widgetfunction,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','doc_name','lyt_document_2',0,'string','typeahead','Doc id:','Doc id:',false,false,true,false,false,'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL','{"saveValue": false, "filterSign":"ILIKE"}'::json,'{"functionName": "filter_table"}'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','btn_doc_insert','lyt_document_2',2,'button','Insert document',false,false,true,false,false,'{"icon":"113"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "add_object",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','btn_doc_delete','lyt_document_2',3,'button','Delete document',false,false,true,false,false,'{"icon":"114"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json,'{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','btn_doc_new','lyt_document_2',4,'button','New document',false,false,true,false,false,'{"icon":"143"}'::json,'{"saveValue":false, "filterSign":"="}'::json,'{
      "functionName": "manage_document",
      "parameters": {
        "sourcewidget": "tab_documents_doc_name",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','hspacer_document_1','lyt_document_2',10,'hspacer',false,false,true,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_documents','open_doc','lyt_document_2',11,'button','Open document',false,false,true,false,false,'{"icon":"147"}'::json,'{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "columnfind": "path",
        "targetwidget": "tab_documents_tbl_documents",
        "sourceview": "doc"
      }
    }'::json,'tbl_doc_x_element',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder)
      VALUES (rec.v_view,'form_feature','tab_documents','tbl_documents','lyt_document_3',1,'tableview',false,false,false,false,false,'{"saveValue": false}'::json,'{
      "functionName": "open_selected_path",
      "parameters": {
        "targetwidget": "tab_documents_tbl_documents",
        "columnfind": "path"
      }
    }'::json,'tbl_doc_x_element',false,4);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','feature_id','lyt_features_1',0,'text','text',false,false,true,false,false,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
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
      VALUES (rec.v_view,'form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
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
      VALUES (rec.v_view,'form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
      "icon": "137"
    }'::json,'{
      "saveValue": false
    }'::json,'{
      "functionName": "selection_init"
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
      "icon": "178"
    }'::json,'{
      "saveValue": false
    }'::json,false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_arc",
      "featureType": "arc"
    }'::json,'tbl_element_x_arc',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_connec",
      "featureType": "connec"
    }'::json,'tbl_element_x_connec',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_link",
      "featureType": "link"
    }'::json,'tbl_element_x_link',false);
    INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
      VALUES (rec.v_view,'form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview',':','',false,false,false,false,false,'{
      "saveValue": false,
      "tableUpsert": "v_ui_element_x_node",
      "featureType": "node"
    }'::json,'tbl_element_x_node',false);
      END LOOP;
END $$;

DELETE FROM cat_element WHERE id = 'EMETER-01' AND element_type = 'EMETER';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4342, 'Node not valid because it has more than 2 arcs', 'Select a valid node', 1, true, 'utils', 'core', 'UI');

UPDATE sys_function SET project_type = 'utils' WHERE id =3302;

UPDATE sys_fprocess set query_text = 'SELECT node_id, nodecat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_node WHERE dma_id = 0 and sector_id > 0'
WHERE fid = 233;


UPDATE sys_fprocess set fprocess_name = 'Node orphan', except_level = 2, info_msg ='No nodes orphan found', except_msg ='nodes orphan with is_arcdivide in true', except_table='anl_node', function_name ='[gw_fct_om_check_data]',
query_text = 'SELECT n.node_id, n.nodecat_id, n.the_geom, n.expl_id FROM t_node n JOIN cat_feature_node on node_type = id 
WHERE NOT EXISTS (SELECT 1 FROM t_arc a WHERE a.node_1 = n.node_id) AND NOT EXISTS (SELECT 1 FROM t_arc a WHERE a.node_2 = n.node_id) AND isarcdivide'
WHERE fid = 107;

UPDATE sys_fprocess set fprocess_name = 'Node orphan (EPA)', except_level = 2, info_msg ='No nodes orphan found',  except_msg ='nodes orphan ready-to-export ', except_table='anl_node', function_name ='[gw_fct_pg2epa_check_result]',
query_text = 'SELECT n.node_id, n.nodecat_id, n.the_geom, n.expl_id FROM t_node n WHERE NOT EXISTS (SELECT 1 FROM t_arc a WHERE a.node_1 = n.node_id) AND NOT EXISTS (SELECT 1 FROM t_arc a WHERE a.node_2 = n.node_id)
AND epa_type !=''UNDEFINED'' AND sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user = current_user) AND is_operative'
WHERE fid = 228;

update sys_fprocess set active =false WHERE fid = 460;

UPDATE config_param_system set isenabled =true where parameter = 'basic_search_hydrometer';

UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_pump' WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_pump' WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_pump' WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_pump' WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_pump' WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_link', 'tab_epa', 'EPA', 'List of Result EPA values', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false}]'::json, 1, '{4,5}');


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'custom_roughness', 'lyt_epa_data_1', 1, 'string', 'text', 'Custom roughness:', 'Custom roughness', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'custom_length', 'lyt_epa_data_1', 2, 'string', 'text', 'Custom length:', 'Custom length', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'matcat_id', 'lyt_epa_data_1', 3, 'string', 'text', 'Matcat ID:', 'Matcat ID:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'cat_roughness', 'lyt_epa_data_1', 4, 'string', 'text', 'Roughness:', 'Roughness:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'dint', 'lyt_epa_data_1', 5, 'string', 'text', 'Dint:', 'Dint:', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'result_id', 'lyt_epa_data_2', 6, 'string', 'text', 'Result ID:', 'Result ID:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'flow_max', 'lyt_epa_data_2', 7, 'string', 'text', 'Flow max:', 'Flow max:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'flow_min', 'lyt_epa_data_2', 8, 'string', 'text', 'Flow min:', 'Flow min:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'flow_avg', 'lyt_epa_data_2', 9, 'string', 'text', 'Flow avg:', 'Flow avg:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'vel_max', 'lyt_epa_data_2', 10, 'string', 'text', 'Vel max:', 'Vel max:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'vel_min', 'lyt_epa_data_2', 11, 'string', 'text', 'Vel min:', 'Vel min:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'vel_avg', 'lyt_epa_data_2', 12, 'string', 'text', 'Vel avg:', 'Vel avg:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'headloss_max', 'lyt_epa_data_2', 13, 'string', 'text', 'Headloss max:', 'Headloss max:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'headloss_min', 'lyt_epa_data_2', 14, 'string', 'text', 'Headloss min:', 'Headloss min:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'setting_max', 'lyt_epa_data_2', 15, 'string', 'text', 'Setting max:', 'Setting max:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'seetting_min', 'lyt_epa_data_2', 16, 'string', 'text', 'Setting min:', 'Setting min:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'reaction_max', 'lyt_epa_data_2', 17, 'string', 'text', 'Reaction max:', 'Reaction max:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'reaction_min', 'lyt_epa_data_2', 18, 'string', 'text', 'Reaction min:', 'Reaction min:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'ffactor_max', 'lyt_epa_data_2', 19, 'string', 'text', 'Ffactor max:', 'Ffactor max:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'ffactor_min', 'lyt_epa_data_2', 20, 'string', 'text', 'Ffactor min:', 'Ffactor min:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'total_headloss_max', 'lyt_epa_data_2', 21, 'string', 'text', 'Total headloss max:', 'Total headloss max:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'total_headloss_min', 'lyt_epa_data_2', 22, 'string', 'text', 'Total headloss min:', 'Total headloss min:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'custom_dint', 'lyt_epa_data_1', 23, 'string', 'text', 'Custom dint:', 'Custom dint:', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'minorloss', 'lyt_epa_data_1', 24, 'string', 'text', 'Minor loss:', 'Minor loss', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'status', 'lyt_epa_data_1', 25, 'string', 'combo', 'Status:', 'Status', NULL, false, false, true, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_status_pipe''', true, true, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);


DELETE FROM config_form_fields WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='custom_length' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='custom_roughness' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
DELETE FROM config_form_fields WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('sys_table_context', '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}', NULL, NULL, '{
  "orderBy": 9
}'::json);
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":30}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "ANALYTICS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":29}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["BASEMAP", "CARTO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":28}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["BASEMAP", "ADDRESS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":27}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "NETSCENARIO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":26}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "TRACEABILITY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":25}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "PRICES"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":24}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "PSECTOR"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":23}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "COMPARE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":22}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "RESULTS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":21}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "DSCENARIO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":20}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "FLOWREG"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":19}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "HYDRAULICS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":18}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "HYDROLOGY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":17}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "CATALOGS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":16}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "VISIT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":15}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "FLOWTRACE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":14}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "MINCUT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":13}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "VALUE DOMAIN"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":12}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "AUXILIAR"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 11}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "OTHER"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 5}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "POLYGON"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 4}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "MAP ZONES"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "CATALOGS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":0}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["HIDDEN"]}';

UPDATE sys_table SET project_template = NULL, context = '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}' WHERE id = 've_man_frelem';

UPDATE sys_table SET project_template = NULL WHERE id = 've_man_genelem';

UPDATE sys_table SET project_template = '{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id = 've_element';

UPDATE sys_table SET orderby=1 WHERE id='ve_node';
UPDATE sys_table SET orderby=2, alias = 'FRegulator' WHERE id='ve_man_frelem';
UPDATE sys_table SET orderby=6, alias = 'Element' WHERE id='ve_element';
UPDATE sys_table SET orderby=3 WHERE id='ve_arc';
UPDATE sys_table SET orderby=4 WHERE id='ve_connec';
UPDATE sys_table SET orderby=5 WHERE id='ve_link';

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder,
project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet,
widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('epa_export_hybrid_dma', 'false', 'If True, hybrid DMAs are exported when network mode is TRANSMISSION NETWORK',
'EPA Export Hybrid DMA:', NULL, NULL, true, 8, 'ws', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
'lyt_admin_other');

update sys_table set alias = 'FRpump Dscenario' where id = 've_inp_dscenario_frpump';
update sys_table set alias = 'FRvalve Dscenario' where id = 've_inp_dscenario_frvalve';
update sys_table set alias = 'FRshortpipe Dscenario' where id = 've_inp_dscenario_frshortpipe';

update sys_table set alias = 'FRpump' where id = 've_inp_frpump';
update sys_table set alias = 'FRvalve' where id = 've_inp_frvalve';
update sys_table set alias = 'FRshortpipe' where id = 've_inp_frshortpipe';

-- 26/08/2025
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_air_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_check_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_fl_contr_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_gen_purp_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_green_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_outfall_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_pr_break_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_pr_reduc_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_pr_susta_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_shutoff_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true WHERE formname='ve_node_throttle_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';

DELETE FROM config_param_system WHERE "parameter"='basic_selector_tab_hydro_state';

DELETE FROM sys_table WHERE id='ve_inp_dscenario_pump_additional';
DELETE FROM sys_table WHERE id='ve_inp_pump_additional';

-- 27/08/2025
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_valve' WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_valve' WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_valve' WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_valve' WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_valve' WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='tbl_inp_valve' AND tabname='tab_epa';

UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_shortpipe' WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_shortpipe' WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_shortpipe' WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_shortpipe' WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET linkedobject='tbl_frelem_dsc_shortpipe' WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='tbl_inp_shortpipe' AND tabname='tab_epa';

DELETE FROM config_form_fields WHERE columnname = 'nodarc_id' and formname ilike 've_epa_fr%';

UPDATE config_form_fields SET widgettype = 'combo', dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_typevalue_valve'''
WHERE formname = 've_epa_frvalve' AND columnname = 'valve_type';

UPDATE config_form_fields SET iseditable = TRUE, widgettype = 'combo',
dv_querytext = 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_valve'''
WHERE formname = 've_epa_frvalve' AND columnname = 'status';

UPDATE config_form_fields SET iseditable = TRUE, widgettype = 'combo',
dv_querytext = 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE typevalue=''inp_value_status_shortpipe_dscen'''
WHERE formname = 've_epa_frshortpipe' AND columnname = 'status';

DELETE FROM config_form_fields WHERE tabname = 'tab_epa' AND columnname = 'to_arc';

UPDATE config_form_fields SET label = 'Bulk coefficient:', tooltip = 'Bulk coefficient' WHERE formtype = 'form_feature' AND columnname = 'bulk_coeff';
-- 25/08/2025
-- ve_dma
DELETE FROM config_form_fields where formname in ('v_ui_dma', 've_dma');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','dma_id','lyt_data_1',1,'integer','text','Dma id:','dma_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','dma_type','lyt_data_1',6,'string','combo','Dma type:','dma_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dma_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','macrodma_id','lyt_data_1',7,'string','combo','Macrodma id:','macrodma_id',false,false,true,false,'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_dma','form_feature','tab_none','avg_press','lyt_data_1',11,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','pattern_id','lyt_data_1',12,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','effc','lyt_data_1',13,'string','text','Effc:','effc',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','graphconfig','lyt_data_1',14,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','stylesheet','lyt_data_1',15,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','lock_level','lyt_data_1',16,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','link','lyt_data_1',17,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','addparam','lyt_data_1',18,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_at','lyt_data_1',19,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_by','lyt_data_1',20,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_at','lyt_data_1',21,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_by','lyt_data_1',22,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_dqa
DELETE FROM config_form_fields WHERE formname IN ('ve_dqa', 'v_ui_dqa');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','dqa_id','lyt_data_1',1,'integer','text','Dqa id:','dqa_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dqa", "activated": true, "keyColumn": "dqa_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','dqa_type','lyt_data_1',6,'string','combo','Dqa type:','dma_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dqa_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','macrodqa_id','lyt_data_1',7,'string','combo','Macrodqa:','macrodqa_id',false,false,true,false,'SELECT macrodqa_id as id, name as idval FROM macrodqa WHERE macrodqa_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','avg_press','lyt_data_1',11,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','pattern_id','lyt_data_1',12,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','graphconfig','lyt_data_1',13,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','stylesheet','lyt_data_1',14,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','lock_level','lyt_data_1',15,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','link','lyt_data_1',16,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','addparam','lyt_data_1',17,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','created_at','lyt_data_1',18,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','created_by','lyt_data_1',19,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','updated_at','lyt_data_1',20,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dqa','form_feature','tab_none','updated_by','lyt_data_1',21,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_presszone
DELETE FROM config_form_fields WHERE formname IN ('ve_presszone', 'v_ui_presszone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','presszone_id','lyt_data_1',1,'integer','text','Presszone id:','presszone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_presszone", "activated": true, "keyColumn": "presszone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','presszone_type','lyt_data_1',6,'string','combo','Presszone type:','presszone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''presszone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','avg_press','lyt_data_1',11,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','head','lyt_data_1',12,'numeric','text','Head:','head',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','graphconfig','lyt_data_1',13,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','stylesheet','lyt_data_1',14,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','lock_level','lyt_data_1',15,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','link','lyt_data_1',16,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','addparam','lyt_data_1',17,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','created_at','lyt_data_1',18,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','created_by','lyt_data_1',19,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','updated_at','lyt_data_1',20,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_presszone','form_feature','tab_none','updated_by','lyt_data_1',21,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);


-- ve_supplyzone
DELETE FROM config_form_fields WHERE formname IN ('ve_supplyzone', 'v_ui_supplyzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",placeholder,tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','sector_id','lyt_data_1',8,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','supplyzone_id','lyt_data_1',1,'integer','text','Supplyzone id:','supplyzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_supplyzone", "activated": true, "keyColumn": "supplyzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','supplyzone_type','lyt_data_1',6,'string','combo','Supply type:','supplyzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''supplyzone_type''',true,true,'{"setMultiline":false}'::json,true);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','expl_id','lyt_data_1',7,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','avg_press','lyt_data_1',10,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','pattern_id','lyt_data_1',11,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','graphconfig','lyt_data_1',12,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','stylesheet','lyt_data_1',13,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','lock_level','lyt_data_1',14,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','link','lyt_data_1',15,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','addparam','lyt_data_1',16,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','created_at','lyt_data_1',17,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','created_by','lyt_data_1',18,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','updated_at','lyt_data_1',19,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_supplyzone','form_feature','tab_none','updated_by','lyt_data_1',20,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_omzone
DELETE FROM config_form_fields WHERE formname IN ('ve_omzone', 'v_ui_omzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','omzone_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','omzone_type','lyt_data_1',6,'string','combo','Omzone type:','omzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''omzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','macroomzone_id','lyt_data_1',7,'string','combo','Macroomzone:','macroomzone_id',false,false,true,false,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','graphconfig','lyt_data_1',11,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','stylesheet','lyt_data_1',12,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','lock_level','lyt_data_1',13,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','link','lyt_data_1',14,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','addparam','lyt_data_1',15,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','created_at','lyt_data_1',16,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','created_by','lyt_data_1',17,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','updated_at','lyt_data_1',18,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','updated_by','lyt_data_1',19,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macroomzone
DELETE FROM config_form_fields WHERE formname IN ('ve_macroomzone', 'v_ui_macroomzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','macroomzone_id','lyt_data_1',1,'integer','text','Macroomzone id:','macroomzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_macroomzone", "activated": true, "keyColumn": "macroomzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macrodqa
DELETE FROM config_form_fields WHERE formname IN ('ve_macrodqa', 'v_ui_macrodqa');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','macrodqa_id','lyt_data_1',1,'integer','text','Macrodqa id:','macrodqa_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_macrodqa", "activated": true, "keyColumn": "macrodqa_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodqa','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macrodma
DELETE FROM config_form_fields WHERE formname IN ('ve_macrodma', 'v_ui_macrodma');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','macrodma_id','lyt_data_1',1,'integer','text','Macrodma id:','macrodma_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_macrodma", "activated": true, "keyColumn": "macrodma_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrodma','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macrosector
DELETE FROM config_form_fields WHERE formname IN ('ve_macrosector', 'v_ui_macrosector');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','macrosector_id','lyt_data_1',1,'integer','text','Macrosector id:','macrosector_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_macrosector", "activated": true, "keyColumn": "macrosector_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_sector
DELETE FROM config_form_fields WHERE formname IN ('v_ui_sector','ve_sector');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','sector_id','lyt_data_1',1,'integer','text','Sector id:','sector_id',true,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','sector_type','lyt_data_1',6,'string','combo','Sector type:','sector_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','macrosector_id','lyt_data_1',7,'string','combo','Macrosector id:','macrosector_id',false,false,true,false,'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_sector','form_feature','tab_none','avg_press','lyt_data_1',10,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','pattern_id','lyt_data_1',11,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','graphconfig','lyt_data_1',12,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','stylesheet','lyt_data_1',13,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','lock_level','lyt_data_1',14,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','link','lyt_data_1',15,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','addparam','lyt_data_1',16,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','created_at','lyt_data_1',17,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','created_by','lyt_data_1',18,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','updated_at','lyt_data_1',19,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','updated_by','lyt_data_1',20,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- Mapzone types
ALTER TABLE edit_typevalue DISABLE TRIGGER ALL;
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('sector_type','TRANSMISSION','TRANSMISSION');
UPDATE edit_typevalue
	SET id='HYBRID',idval='HYBRID'
	WHERE typevalue='sector_type' AND id='SOURCE';
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dqa_type','TANK','TANK');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dqa_type','RECLORINATOR','RECLORINATOR');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dqa_type','UNDEFINED','INDEFINIDO');
UPDATE edit_typevalue
	SET id='WATERWELL',idval='WATERWELL'
	WHERE typevalue='presszone_type' AND id='PSV';
ALTER TABLE edit_typevalue ENABLE TRIGGER ALL;

-- 27/08/2025
INSERT INTO config_typevalue (typevalue,id,idval) VALUES ('widgettype_typevalue','list','list');
UPDATE config_form_fields SET widgettype='list' WHERE formname IN('ve_dma', 've_dqa', 've_sector', 've_supplyzone', 've_macrodma', 've_macrodqa', 've_macrosector', 've_omzone', 've_macroomzone', 've_presszone') AND columnname IN('expl_id', 'sector_id', 'muni_id');

-- 28/08/2025
UPDATE config_toolbox SET alias='Macromapzones analysis', functionparams='{"featureType":[]}'::json, inputparams='[{"widgetname": "graphClass", "label": "Graph class:", "widgettype": "combo", "datatype": "text", "tooltip": "Graphanalytics method used", "layoutname": "grl_option_parameters", "layoutorder": 1, "comboIds": ["MACROSECTOR", "MACROOMZONE"], "comboNames": ["MACROSECTOR", "MACROOMZONE"], "selectedId": null}, {"widgetname": "exploitation", "label": "Exploitation:", "widgettype": "combo", "datatype": "text", "tooltip": "Choose exploitation to work with", "layoutname": "grl_option_parameters", "layoutorder": 2, "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId": null}, {"widgetname": "commitChanges", "label": "Commit changes:", "widgettype": "check", "datatype": "boolean", "tooltip": "If True, changes will be applied to DB. If False, algorithm results will be saved in anl tables", "layoutname": "grl_option_parameters", "layoutorder": 8, "value": null}]'::json WHERE id=3482;


update sys_table set project_template = null WHERE id IN ('ve_macrosector', 've_dqa','ve_supplyzone','ve_macrodma');