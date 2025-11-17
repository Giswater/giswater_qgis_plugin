/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 13/08/2025
DELETE FROM config_form_fields WHERE formname ILIKE 've_element_%';
DO $$
DECLARE
  rec record;
  v_view text;
BEGIN
  FOR rec IN (SELECT * FROM cat_feature_element WHERE id NOT IN ('EPUMP', 'EORIFICE', 'EWEIR', 'EOUTLET'))
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
-- EPUMP
DO $$
DECLARE
  rec record;
  v_view text;
BEGIN
  FOR rec IN SELECT val AS v_view,  elem as id FROM (VALUES ('ve_element_epump', 'EPUMP'), ('ve_element_eorifice', 'EORIFICE'), ('ve_element_eweir', 'EWEIR'), ('ve_element_eoutlet', 'EOUTLET') ) AS t(val, elem)
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

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,dv_parent_id,dv_querytext_filterc,stylesheet,widgetcontrols,widgetfunction,linkedobject,hidden,web_layoutorder) VALUES
	 ('ve_arc_varc','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_siphon','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_pump_pipe','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_waccel','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99),
	 ('ve_arc_conduit','form_feature','tab_data','initoverflowpath','lyt_data_1',90,'boolean','check','inicio flujos derivados','Este campo es de suma importancia puesto que identifica aquellos tramos de red que son inicio de de flujo de caudales en tiempo de lluvia. Esta propiedad les convierte en ser frontera entre las DWFzones y la Drainzones',NULL,false,false,true,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"setMultiline":false}',NULL,NULL,false,99)
	 ON CONFLICT (formname,formtype,tabname,columnname) DO NOTHING;


update config_toolbox set active = false where id in (3424,3492);

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,sample_query,"source",function_alias) VALUES
	 (3302,'gw_fct_getgraphconfig','utils','function','json','json','Function to recover graphconfig values. ','role_om',NULL,'core',NULL);


-- 18/08/2025
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(638, 'Check that all flow regulator elements have the same length', 'ud', NULL, 'core', NULL, 'Check epa-data', NULL, 2,
'nodes with flowregulators with different lengths and same to_arc', NULL, NULL,
'SELECT count(DISTINCT flwreg_length) FROM man_frelem GROUP BY node_id, to_arc HAVING count(DISTINCT flwreg_length) > 1',
'All flow regulator elements with the same node_id and to_arc have the same length', '[gw_fct_pg2epa_check_data]', true);

UPDATE config_form_fields SET dv_querytext =
'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outlet'''
WHERE formname = 've_epa_froutlet' and columnname = 'outlet_type';

UPDATE sys_table SET context = '{"levels": ["EPA", "HYDRAULICS"]}' WHERE id LIKE '%ve_inp_fr%';
UPDATE sys_table SET context = '{"levels": ["EPA", "DSCENARIO"]}' WHERE id LIKE '%ve_inp_dscenario_fr%';

update sys_table set context = '{"levels": ["EPA", "HYDRAULICS"]}' where id like '%ve_inp_fr%';
update sys_table set context = '{"levels": ["EPA", "DSCENARIO"]}' where id like '%ve_inp_dscenario_fr%';

update sys_table set alias = 'FRoutlet Dscenario' where id = 've_inp_dscenario_froutlet';
update sys_table set alias = 'FRpump Dscenario' where id = 've_inp_dscenario_frpump';
update sys_table set alias = 'FRorifice Dscenario' where id = 've_inp_dscenario_frorifice';
update sys_table set alias = 'FRweir Dscenario' where id = 've_inp_dscenario_frweir';

update sys_table set alias = 'FRoutlet' where id = 've_inp_froutlet';
update sys_table set alias = 'FRpump' where id = 've_inp_frpump';
update sys_table set alias = 'FRorifice' where id = 've_inp_frorifice';
update sys_table set alias = 'FRweir' where id = 've_inp_frweir';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4342, 'There are %v_count% %v_feature_type%s with fluid_type equal to zero.', NULL, 0, true, 'ud', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4344, 'There are %v_count% %v_feature_type%s with fluid_type different to zero.', NULL, 0, true, 'ud', 'core', 'AUDIT');


-- 20/08/2025
-- Add columns to inp_dscenario_frpump
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'curve_id', 'lyt_main_1', 3, 'string', 'combo', 'Curve id:', 'Curve id', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type IN (''PUMP'', ''PUMP1'', ''PUMP2'', ''PUMP3'', ''PUMP4'')', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'status', 'lyt_main_1', 4, 'string', 'combo', 'Status:', 'Status', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_status''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'startup', 'lyt_main_1', 5, 'numeric', 'text', 'Startup:', 'Startup', NULL, false, NULL, true, NULL, false, NULL, true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frpump', 'form_feature', 'tab_none', 'shutoff', 'lyt_main_1', 6, 'numeric', 'text', 'Shutoff:', 'Shutoff', NULL, false, NULL, true, NULL, false, NULL, true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- Add columns to inp_dscenario_frweir

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'weir_type', 'lyt_main_1', 3, 'string', 'combo', 'Weir type:', 'Weir type', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_weirs''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'offsetval', 'lyt_main_1', 4, 'numeric', 'text', 'Offset:', 'Offset', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'cd', 'lyt_main_1', 5, 'numeric', 'text', 'Cd:', 'Discharge coefficient', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'ec', 'lyt_main_1', 6, 'numeric', 'text', 'Ec:', 'End contractions', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'cd2', 'lyt_main_1', 7, 'numeric', 'text', 'Cd2:', 'Discharge coefficient 2', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'flap', 'lyt_main_1', 8, 'string', 'text', 'Flap:', 'Flap gate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom1', 'lyt_main_1', 9, 'numeric', 'text', 'Geom1:', 'Height/Crest height', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom2', 'lyt_main_1', 10, 'numeric', 'text', 'Geom2:', 'Length/Width', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom3', 'lyt_main_1', 11, 'numeric', 'text', 'Geom3:', 'Side slope', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'geom4', 'lyt_main_1', 12, 'numeric', 'text', 'Geom4:', 'Number of steps', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'surcharge', 'lyt_main_1', 13, 'string', 'text', 'Surcharge:', 'Surcharge', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'road_width', 'lyt_main_1', 14, 'numeric', 'text', 'Road width:', 'Road width', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'road_surf', 'lyt_main_1', 15, 'string', 'text', 'Road surface:', 'Road surface', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_roadSurface''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frweir', 'form_feature', 'tab_none', 'coef_curve', 'lyt_main_1', 16, 'numeric', 'text', 'Coef curve:', 'Coefficient curve', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type = ''RATING''', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL);

-- Add columns to inp_dscenario_frorifice
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'orifice_type', 'lyt_main_1', 3, 'string', 'combo', 'Orifice type:', 'Orifice type', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_orifice''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'offsetval', 'lyt_main_1', 4, 'numeric', 'text', 'Offset:', 'Offset', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'cd', 'lyt_main_1', 5, 'numeric', 'text', 'Cd:', 'Discharge coefficient', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'orate', 'lyt_main_1', 6, 'numeric', 'text', 'Orate:', 'Opening/closing rate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'flap', 'lyt_main_1', 7, 'string', 'text', 'Flap:', 'Flap gate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'shape', 'lyt_main_1', 8, 'string', 'combo', 'Shape:', 'Shape', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_orifice_shape''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom1', 'lyt_main_1', 9, 'numeric', 'text', 'Geom1:', 'Height', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom2', 'lyt_main_1', 10, 'numeric', 'text', 'Geom2:', 'Width', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom3', 'lyt_main_1', 11, 'numeric', 'text', 'Geom3:', 'Length', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_frorifice', 'form_feature', 'tab_none', 'geom4', 'lyt_main_1', 12, 'numeric', 'text', 'Geom4:', 'Side slope', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


-- Add columns to inp_dscenario_froutlet
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_main_1', 1, 'integer', 'text', 'Dscenario id:', 'Dscenario id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'element_id', 'lyt_main_1', 2, 'integer', 'text', 'Element id:', 'Element id', NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'outlet_type', 'lyt_main_1', 3, 'string', 'combo', 'Outlet type:', 'Outlet type', NULL, false, NULL, true, NULL, false, 'SELECT DISTINCT id AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_value_outlet''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'offsetval', 'lyt_main_1', 4, 'numeric', 'text', 'Offset:', 'Offset', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'curve_id', 'lyt_main_1', 5, 'string', 'combo', 'Curve id:', 'Rating curve', NULL, false, NULL, true, NULL, false, 'SELECT id as id, id as idval FROM inp_curve WHERE id IS NOT NULL AND curve_type = ''RATING''', true, true, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'cd1', 'lyt_main_1', 6, 'numeric', 'text', 'Cd1:', 'Discharge coefficient 1', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'cd2', 'lyt_main_1', 7, 'numeric', 'text', 'Cd2:', 'Discharge coefficient 2', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('inp_dscenario_froutlet', 'form_feature', 'tab_none', 'flap', 'lyt_main_1', 8, 'string', 'text', 'Flap:', 'Flap gate', NULL, false, NULL, true, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_element_x_gully', 'Contains the elements related to gully', 'role_edit');


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
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "GULLY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "MAP ZONES"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "CATALOGS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":0}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["HIDDEN"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy": 3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}';

UPDATE sys_table SET project_template = '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context = '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}' WHERE id = 've_man_frelem';

UPDATE sys_table SET project_template = NULL WHERE id = 've_man_genelem';

UPDATE sys_table SET project_template = '{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id = 've_element';

UPDATE sys_table SET orderby=1 WHERE id='ve_node';
UPDATE sys_table SET orderby=2 WHERE id='ve_man_frelem';
UPDATE sys_table SET orderby=2 WHERE id='ve_element';
UPDATE sys_table SET orderby=3 WHERE id='ve_arc';
UPDATE sys_table SET orderby=4 WHERE id='ve_connec';
UPDATE sys_Table SET orderby=5 WHERE id='ve_gully';
UPDATE sys_table SET orderby=6 WHERE id='ve_link';

DELETE FROM cat_element WHERE id='GATE-01' AND element_type='EGATE';

-- 26/08/2025
INSERT INTO sys_table (id, descript, sys_role, context, orderby, alias, source) VALUES ('ve_inp_inlet', 'Shows editable information about inlets.', 'role_epa', '{"levels": ["EPA", "HYDRAULICS"]}', 20, 'Inp Inlet', 'core');

-- gully form
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias) VALUES ('gully form','ud','tbl_element_x_gully','epa_type',6,true,'epa_type');
UPDATE config_form_tableview SET columnindex=7 WHERE objectname='tbl_element_x_gully' AND columnname='state';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_gully' AND columnname='state_type';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_gully' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_gully' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_gully' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_gully' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=13 WHERE objectname='tbl_element_x_gully' AND columnname='descript';
UPDATE config_form_tableview SET columnindex=14 WHERE objectname='tbl_element_x_gully' AND columnname='location_type';

UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status''', dv_isnullvalue=true WHERE formname='ve_epa_frpump' AND columnname='status';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_yesno'' ', dv_isnullvalue=true WHERE formname='ve_epa_frorifice' AND columnname='flap';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_orifice'' ', dv_isnullvalue=true WHERE formname='ve_epa_frorifice' AND columnname='shape';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_yesno'' ', dv_isnullvalue=true WHERE formname='ve_epa_froutlet' AND columnname='flap';

UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', dv_isnullvalue=TRUE WHERE formname='ve_epa_froutlet' AND columnname='curve_id';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL', dv_isnullvalue=true WHERE formname='ve_epa_frpump' AND columnname='curve_id';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outlet''', dv_isnullvalue=true WHERE formname='ve_epa_froutlet' AND columnname='outlet_type';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_orifice''', dv_isnullvalue=true WHERE formname='ve_epa_frorifice' AND columnname='outlet_type';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_weirs''', dv_isnullvalue=true WHERE formname='ve_epa_frweir' AND columnname='outlet_type';

DELETE FROM config_form_fields WHERE columnname = 'nodarc_id';
-- 25/08/2025
INSERT INTO dma (dma_id, name, expl_id) VALUES (0, 'UNDEFINED', '{0}') ON CONFLICT (dma_id) DO NOTHING;

-- ve_dma
DELETE FROM config_form_fields where formname in ('v_ui_dma', 've_dma');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','sector_id','lyt_data_1',8,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
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
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','expl_id','lyt_data_1',7,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_dma','form_feature','tab_none','avg_press','lyt_data_1',10,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','pattern_id','lyt_data_1',11,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','effc','lyt_data_1',12,'string','text','Effc:','effc',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','graphconfig','lyt_data_1',13,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','stylesheet','lyt_data_1',14,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','lock_level','lyt_data_1',15,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','link','lyt_data_1',19,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','addparam','lyt_data_1',17,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_at','lyt_data_1',18,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_by','lyt_data_1',19,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_at','lyt_data_1',20,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_by','lyt_data_1',21,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_dwfzone
DELETE FROM config_form_fields WHERE formname IN ('ve_dwfzone', 'v_ui_dwfzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','dwfzone_id','lyt_data_1',1,'integer','text','Dwfzone id:','dwfzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dwfzone", "activated": true, "keyColumn": "dwfzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','dwfzone_type','lyt_data_1',6,'string','combo','Dwfzone type:','dwfzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dwfzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','drainzone_id','lyt_data_1',7,'string','combo','Drainzone:','drainzone_id',false,false,true,false,'SELECT drainzone_id as id, name as idval FROM drainzone WHERE drainzone_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','graphconfig','lyt_data_1',11,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','stylesheet','lyt_data_1',12,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','lock_level','lyt_data_1',13,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','link','lyt_data_1',14,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','addparam','lyt_data_1',15,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','created_at','lyt_data_1',16,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','created_by','lyt_data_1',17,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','updated_at','lyt_data_1',18,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','updated_by','lyt_data_1',19,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_drainzone
DELETE FROM config_form_fields WHERE formname IN ('ve_drainzone', 'v_ui_drainzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','sector_id','lyt_data_1',8,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','drainzone_id','lyt_data_1',1,'integer','text','Drainzone id:','drainzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_drainzone", "activated": true, "keyColumn": "drainzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','drainzone_type','lyt_data_1',6,'string','combo','Drainzone type:','drainzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''drainzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','expl_id','lyt_data_1',7,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','graphconfig','lyt_data_1',10,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','stylesheet','lyt_data_1',11,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','lock_level','lyt_data_1',12,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','link','lyt_data_1',13,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','addparam','lyt_data_1',14,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','created_at','lyt_data_1',15,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','created_by','lyt_data_1',16,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','updated_at','lyt_data_1',17,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','updated_by','lyt_data_1',18,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

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
	VALUES ('ve_macroomzone','form_feature','tab_none','macroomzone_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,true,true,false,'{"setMultiline":false}'::json,false);
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

-- ve_macrosector
DELETE FROM config_form_fields WHERE formname IN ('ve_macrosector', 'v_ui_macrosector');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','macrosector_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
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
	VALUES ('ve_sector','form_feature','tab_none','sector_id','lyt_data_1',1,'integer','text','Sector id:','sector_id',true,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
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
DELETE FROM edit_typevalue WHERE typevalue = 'sector_type';
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('sector_type','COLLECTION SYSTEMS','COLLECTION SYSTEMS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('sector_type','TRUNK SEWERS','TRUNK SEWERS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('sector_type','UNDEFINED','UNDEFINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dma_type','COLLECTION SYSTEMS','COLLECTION SYSTEMS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dma_type','TRUNK SEWERS','TRUNK SEWERS');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dma_type','UNDEFINED','UNDEFINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','4','COMBINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','2','DILUTE COMBINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','1','STORMWATER');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','3','SEWAGE');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('dwfzone_type','0','NOT INFORMED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','4','COMBINED');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','3','SEWAGE');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','1','STORMWATER');
INSERT INTO edit_typevalue (typevalue,id,idval)
	VALUES ('drainzone_type','0','NOT INFORMED');


-- 27/08/2025
INSERT INTO config_typevalue (typevalue,id,idval) VALUES ('widgettype_typevalue','list','list');
UPDATE config_form_fields SET widgettype='list' WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('expl_id', 'sector_id', 'muni_id');

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = 'inp_typevalue_weir' WHERE typevalue='inp_value_weirs';

UPDATE sys_foreignkey SET typevalue_name='inp_typevalue_weir', target_table='inp_weir' WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_weirs' AND target_table='inp_weir' AND target_field='weir_type';
UPDATE sys_foreignkey SET typevalue_name='inp_typevalue_weir', target_table='inp_frweir' WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_weirs' AND target_table='inp_flwreg_weir' AND target_field='weir_type';
UPDATE sys_foreignkey SET typevalue_name='inp_typevalue_weir', target_table='inp_dscenario_frweir' WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_weirs' AND target_table='inp_dscenario_flwreg_weir' AND target_field='weir_type';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE config_form_fields SET dv_querytext = REPLACE(dv_querytext, 'inp_value_weirs', 'inp_typevalue_weir') WHERE dv_querytext ILIKE '%inp_value_weirs%';

update sys_table set orderby =  1 WHERE id = 've_exploitation';
update sys_table set orderby =  2 WHERE id = 've_drainzone';
update sys_table set orderby =  3 WHERE id = 've_dwfzone';
update sys_table set orderby =  4 WHERE id = 've_sector';
update sys_table set project_template = null WHERE id = 've_macrosector';

UPDATE config_form_fields SET iseditable=true WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname = 'graphconfig';
UPDATE config_form_fields SET widgettype='text' WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('created_at', 'updated_at');

UPDATE config_form_fields SET placeholder=NULL WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('expl_id', 'sector_id', 'muni_id') AND iseditable=false;
