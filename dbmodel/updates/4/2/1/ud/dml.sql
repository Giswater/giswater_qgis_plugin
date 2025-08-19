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
  FOR rec IN (SELECT * FROM _element_type WHERE id NOT IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET'))
  LOOP
    v_view := concat('ve_element_e', lower(REPLACE(REC.id, ' ', '_')));

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
        VALUES (rec.v_view,'form_feature','tab_data','epa_type','lyt_top_1',3,'string','combo','EPA Type:','EPA Type',false,false,true,false,'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''','{"setMultiline": false, "labelPosition": "top"}'::json,false);
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