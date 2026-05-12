/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE plan_typevalue SET idval = 'PLANIFIED' WHERE idval = 'PLANNIFIED';

INSERT INTO plan_typevalue VALUES ('psector_status', '8', 'RESTORED', 'Psector that was archived but that have been restored');
INSERT INTO plan_typevalue VALUES ('psector_status', '7', 'CANCELED (ARCHIVED)', 'Psector cancelled and the same time archived');
INSERT INTO plan_typevalue VALUES ('psector_status', '6', 'COMISSIONED (ARCHIVED)', 'Psector cancelled and the same time archived');
INSERT INTO plan_typevalue VALUES ('psector_status', '5', 'MADE OPERATIONAL (ARCHIVED)', 'Psector cancelled and the same time archived');
UPDATE plan_typevalue SET idval = 'EXECUTED' WHERE typevalue = 'psector_status' AND id = '4';
UPDATE plan_typevalue SET idval = 'EXECUTION IN PROGRESS' WHERE typevalue = 'psector_status' AND id = '3';
UPDATE plan_typevalue SET idval = 'PLANNED' WHERE typevalue = 'psector_status' AND id = '2';
UPDATE plan_typevalue SET idval = 'PLANNING IN PROGRESS' WHERE typevalue = 'psector_status' AND id = '1';

UPDATE config_param_system SET value =
'{"table":"plan_psector","selector":"selector_psector","table_id":"psector_id","selector_id":"psector_id","label":"psector_id, '' - '', name",
"orderBy":"psector_id","manageAll":true,"typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))",
"query_filter":"AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user) AND status IN (1,2,3,4,8)","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift"}'
WHERE parameter = 'basic_selector_tab_psector';


UPDATE plan_psector SET status = 8 WHERE status = null;
UPDATE plan_psector SET status = 7 WHERE status = 3;
UPDATE plan_psector SET status = 6 WHERE status = 0;
UPDATE plan_psector SET status = 5 WHERE status = 4;
UPDATE plan_psector SET status = 4 WHERE status = null;
UPDATE plan_psector SET status = 3 WHERE status = null;
UPDATE plan_psector SET status = 2 WHERE status = 2;
UPDATE plan_psector SET status = 1 WHERE status = 1;

UPDATE sys_table SET id = 'archived_psector_arc' WHERE id = 'archived_psector_arc_traceability';
UPDATE sys_table SET id = 'archived_psector_node' WHERE id = 'archived_psector_node_traceability';
UPDATE sys_table SET id = 'archived_psector_connec' WHERE id = 'archived_psector_connec_traceability';
UPDATE sys_table SET id = 'archived_psector_gully' WHERE id = 'archived_psector_gully_traceability';
UPDATE sys_table SET id = 'archived_psector_link' WHERE id = 'archived_psector_link_traceability';

-- Solve issue with search
UPDATE config_param_system
	SET value='{"sys_table_id":"ve_man_frelem","sys_id_field":"element_id","sys_search_field":"element_id","alias":"Flow regulator element","cat_field":"elementcat_id","orderby":"5","search_type":"element"}'
	WHERE "parameter"='basic_search_network_frelem';
UPDATE config_param_system
	SET value='{"sys_table_id":"ve_man_genelem","sys_id_field":"element_id","sys_search_field":"element_id","alias":"General element","cat_field":"elementcat_id","orderby":"5","search_type":"element"}'
	WHERE "parameter"='basic_search_network_genelem';

-- Fix function id
UPDATE config_function SET id= 2646, function_name='gw_fct_pg2epa_main' WHERE id=2848;

UPDATE config_toolbox SET inputparams = replace(inputparams::text , 'FROM exploitation WHERE active IS NOT FALSE', 'FROM exploitation WHERE active IS NOT FALSE AND expl_id > 0')::json
WHERE id =2768;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('sys_table_context', '{"levels": ["HIDDEN"]}', NULL, NULL, '{"orderBy":0}'::json);

INSERT INTO sys_table (id,descript,sys_role,project_template,context,orderby,alias,notify_action,isaudit,keepauditdays,"source",addparam) values
('v_value_relation','Domain value table','role_basic','{"template": [1], "visibility": true, "levels_to_read": 1}','{"levels": ["HIDDEN"]}',5,'Domain value',NULL,NULL,NULL,'core',NULL);

UPDATE config_form_fields SET
widgetcontrols ='{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_value_relation", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": 
"typevalue = ''graphdelimiter_type''", "allowMulti": true, "nofColumns": 2}}'
where columnname = 'graph_delimiter' and formname = 've_cat_feature_node';


update sys_param_user set feature_field_id = 'fluid_type' WHERE id like '%fluid_vdefault';
update sys_param_user set feature_field_id = 'location_type' WHERE id like '%location_vdefault';
update sys_param_user set feature_field_id = 'category_type' WHERE id like '%category_vdefault';
update sys_param_user set feature_field_id = 'funtion_type' WHERE id like '%function_vdefault';

-- Delete parameter edit_link_link2network now is not used
DELETE FROM config_param_system WHERE parameter = 'edit_link_link2network';

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_linkcat_vdefault', 'config', 'Default value of link catalog', 'role_edit', NULL, 'Link catalog for automatic inserts:', 'SELECT cat_link.id AS id, cat_link.id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, true, 1, 'utils', false, NULL, 'linkcat_id', NULL, false, 'string', 'combo', false, NULL, NULL, 'lyt_link', true, NULL, NULL, NULL, NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3508, 'gw_fct_graphanalytics_mapzones_v1', 'utils', 'function', 'json', 'json', 'Function to analyze graph of network. Dynamic analisys to sectorize network using pgrouting functions.  Before working with this funcion, it is mandatory to configurate graphconfig on mapzone tables', 'role_om', NULL, 'core', NULL);
INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3508, 'gw_fct_graphanalytics_mapzones_v1', '{"style": {"point": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
"line": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
  "polygon": {"style": "categorized","field": "descript",  "transparency": 0.5}}}'::json, NULL, '[{"funcName": "set_style_mapzones", "params": {}}, {"funcName": "get_graph_config", "params": {}}]'::json);

-- Normalize "label": replace underscores with spaces, trim, ensure only the first letter is uppercase,
-- and append a colon if missing. Only updates rows needing changes.
UPDATE sys_param_user
SET "label" =
    UPPER(LEFT(cleaned, 1)) ||
    SUBSTRING(cleaned FROM 2) ||
    CASE WHEN RIGHT(cleaned, 1) = ':' THEN '' ELSE ':' END
FROM (
    SELECT
        "id",
        TRIM(
            regexp_replace(
                regexp_replace(replace("label", '_', ' '), '\s+', ' ', 'g'),
                '\s+$', '', 'g'
            )
        ) AS cleaned
    FROM sys_param_user
) AS sub
WHERE sys_param_user."id" = sub."id"
  AND "label" IS NOT NULL
  AND (
        LEFT("label", 1) <> UPPER(LEFT("label", 1))
     OR RIGHT(sub.cleaned, 1) <> ':'
  );


UPDATE config_form_fields SET dv_querytext =
'WITH psector_value AS (
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
  ELSE id = 1 
END'
WHERE columnname = 'state';


alter table plan_typevalue disable trigger gw_trg_typevalue_config_fk;
delete from plan_typevalue where typevalue = 'psector_status' and id = '0';
alter table plan_typevalue enable trigger gw_trg_typevalue_config_fk;

update config_form_fields set dv_orderby_id = true where formtype ='psector' and columnname ='status';

UPDATE config_param_system SET value =
'{"table":"plan_psector","selector":"selector_psector","table_id":"psector_id","selector_id":"psector_id","label":"psector_id, '' - '', name","orderBy":"psector_id","manageAll":true,"typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))","query_filter":"AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift"}'
WHERE parameter = 'basic_selector_tab_psector';

INSERT INTO sys_param_user
(id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc,
feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable,
dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_arc_division_dsbl', 'dynamic', 'If true, disable the arc divide in a internal proces of database', 'role_edit', NULL, 'Disable arc division',
NULL, NULL, true, null, 'utils', false, NULL, NULL, NULL, false, 'boolean', null, false, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, 'core')
on conflict (id) do nothing;

INSERT INTO sys_param_user
(id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc,
 feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable,
 dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('utils_transaction_mode', 'dynamic', 'Gets the transaction mode on functions', 'role_basic', NULL, 'Transaction mode', NULL, NULL, true, null,
'utils', false, NULL, NULL, NULL, false, 'boolean', null, false, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, 'core');

UPDATE sys_table
SET addparam = CASE
	WHEN addparam IS NULL THEN '{"layerProp":{"hiddenForm": "true"}}'::jsonb
	ELSE addparam::jsonb || '{"layerProp":{"hiddenForm": "true"}}'::jsonb
END
WHERE id ilike 've_pol_%';


UPDATE sys_style SET layername = 've_man_frelem' WHERE layername = 've_frelem';

-- 21/08/25
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3510, 'gw_fct_get_expl_id_array', 'utils', 'function', 'text', 'text', 'Function to get the exploitation ID array', 'role_basic', NULL, 'core', NULL);


INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_element_x_node', 'Contains the elements related to node', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_element_x_connec', 'Contains the elements related to connec', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_element_x_arc', 'Contains the elements related to arc', 'role_edit');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4346, 'To execute from zero, all %mapzone_name% mapzones must be disabled', 'Toggle active for all mapzones, or delete them', 2, true, 'utils', 'core', 'UI');

UPDATE sys_table SET context = NULL WHERE id ilike 've_element_e%';

-- 25/08/25
-- ELEMENTS
UPDATE config_form_fields
	SET columnname='element_type'
	WHERE formname='cat_element' AND formtype='form_feature' AND columnname='elementtype_id' AND tabname='tab_none' AND columnname='element_type';
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','active','boolean','check','Active:','active',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','code_autofill','boolean','check','Code autofill:','code_autofill',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','descript','string','text','Descript:','descript - Field to store additional information about the feature.',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','epa_default','string','combo','Epa default:','epa_default',true,false,true,false,false,'SELECT id as id, id as idval FROM sys_feature_epa_type WHERE feature_type =''ELEMENT''',true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','id','string','text','Id:','id',true,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','link_path','string','text','Link path:','link_path',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','shortcut_key','string','text','Shortcut:','shortcut_key',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_cat_feature_element','form_feature','tab_none','system_id','string','combo','Sys type:','system_id',true,false,true,false,false,'SELECT id as id, id as idval FROM  sys_feature_class WHERE id IS NOT NULL AND type=''ELEMENT'' ',true,false,false);

-- LINKS
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','code_autofill','boolean','check','Code autofill:','code_autofill',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','descript','string','text','Descript:','descript - Field to store additional information about the feature.',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','id','string','text','Id:','id',true,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','link_path','string','text','Link path:','link_path',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','shortcut_key','string','text','Shortcut:','shortcut_key',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','active','boolean','check','Active:','active',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','epa_default','string','combo','Epa default:','epa_default',true,false,true,false,false,'SELECT id as id, id as idval FROM sys_feature_epa_type WHERE feature_type =''LINK''',true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_cat_feature_link','form_feature','tab_none','system_id','string','combo','Sys type:','system_id',true,false,true,false,false,'SELECT id as id, id as idval FROM  sys_feature_class WHERE id IS NOT NULL AND type=''LINK'' ',true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','active','boolean','check','Active:','Active',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','m2bottom_cost','string','typeahead','Bottom cost:','(Price_compost.id) of full cost of bottom''s trench arrangement',false,false,true,false,'SELECT id, id AS idval FROM plan_price WHERE id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','area','double','text','Area:','Area',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','id','string','text','ID:','ID',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','link_type','string','combo','Link type:','cat_linktype_id - Type of link. It is auto-populated based on the linkcat_id',false,false,true,false,'SELECT id, id AS idval FROM cat_feature_link WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression":"active=true"}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','cost_unit','string','combo','Cost unit:','Units measurements. (Only ml or ut. are allowed values). Sometimes the budget of an link could be treated as unitary price (applied using length=1)',false,false,true,false,'SELECT id, idval FROM plan_typevalue 
WHERE typevalue = ''price_units''',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','brand_id','string','combo','Brand:','Brand',false,false,true,false,'SELECT id, id AS idval FROM cat_brand WHERE id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','label','string','text','Catalog label:','label - Label from the catalog of links, therefore it will not be editable in the form',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','cost','string','typeahead','Cost:','(Price_compost.id) of full cost of conduit''s subministration and installation',false,false,true,false,'SELECT id, id AS idval FROM plan_price WHERE id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','descript','string','text','Descript:','descript - Field to store additional information about the feature.',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','dnom','double','text','Dnom:','dnom',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','estimated_depth','double','text','Estimated depth:','Estimated depth',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','dext','double','text','External diameter:','External diameter',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','dint','double','text','Internal diamter:','Internal diamter',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','link','string','text','Link:','link - URL of the link that will open when clicking the button in the form bar. It must be edited from the database. link_path (from type tables) + link is concatenated',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','matcat_id','string','combo','Material:','matcat_id - Material of the element. It cannot be filled in. The one with the matcat_id field of the corresponding catalog is used',false,false,true,false,'SELECT id, descript AS idval FROM cat_material WHERE ''LINK'' = ANY(feature_type) AND id IS NOT NULL',true,false,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "cat_material", "activated": true, "keyColumn": "id", "valueColumn": "descript", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','model_id','string','combo','Model:','Model',false,false,true,false,'SELECT id, id AS idval FROM cat_brand_model WHERE id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','pnom','double','text','Pnom:','pnom',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_link','form_feature','tab_none','m3protec_cost','string','typeahead','Protection cost:','(Price_compost.id) of full cost of conduit''s proteccion material',false,false,true,false,'SELECT id, id AS idval FROM plan_price WHERE id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','svg','string','text','Svg:','Svg',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','width','double','text','Width:','Width',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','z1','double','text','Z1:','z1',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','z2','double','text','Z2:','z2',false,false,true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_link','form_feature','tab_none','thickness','string','text','Thickness:','Thickness:',false,false,true,false,false);


-- Brand_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='brand_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand WHERE %L = ANY(featurecat_id::text[]) OR featurecat_id IS NULL', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;

UPDATE config_form_fields
	SET columnname='brand_id',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand b JOIN cat_node n ON (n.node_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_node' AND formtype='form_feature' AND columnname='brand' AND tabname='tab_none';

UPDATE config_form_fields
	SET columnname='brand_id',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand b JOIN cat_arc a ON (a.arc_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='brand' AND tabname='tab_none';

UPDATE config_form_fields
	SET columnname='brand',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand b JOIN cat_element a ON (a.element_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_element' AND formtype='form_feature' AND columnname='brand' AND tabname='tab_none';

UPDATE config_form_fields
	SET columnname='brand_id',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand b JOIN cat_connec c ON (c.connec_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='brand' AND tabname='tab_none';

UPDATE config_form_fields
	SET dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand b JOIN cat_link l ON (l.link_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_link' AND formtype='form_feature' AND columnname='brand_id' AND tabname='tab_none';


-- Model_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='model_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand_model WHERE %L = ANY(featurecat_id::text[]) OR featurecat_id IS NULL', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;

UPDATE config_form_fields
	SET columnname='model_id',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand_model b JOIN cat_node n ON (n.node_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_node' AND formtype='form_feature' AND columnname='model' AND tabname='tab_none';

UPDATE config_form_fields
	SET columnname='model_id',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand_model b JOIN cat_arc a ON (a.arc_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='model' AND tabname='tab_none';

UPDATE config_form_fields
	SET columnname='model',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand_model b JOIN cat_element a ON (a.element_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_element' AND formtype='form_feature' AND columnname='model' AND tabname='tab_none';

UPDATE config_form_fields
	SET columnname='model_id',dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand_model b JOIN cat_connec c ON (c.connec_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='model' AND tabname='tab_none';

UPDATE config_form_fields
	SET dv_querytext='SELECT DISTINCT b.id, b.id as idval FROM cat_brand_model b JOIN cat_link l ON (l.link_type = ANY(b.featurecat_id::text[]) OR b.featurecat_id::text[] IS NULL)'
	WHERE formname='cat_link' AND formtype='form_feature' AND columnname='model_id' AND tabname='tab_none';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4348, 'It is not allowed to insert/updates arcs with the same geometry', NULL, 2, true, 'utils', 'core', 'UI');

-- 26/08/2025
-- arc form
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias) VALUES ('arc form','utils','tbl_element_x_arc','epa_type',6,true,'epa_type');
UPDATE config_form_tableview SET columnindex=7 WHERE objectname='tbl_element_x_arc' AND columnname='state';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_arc' AND columnname='state_type';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_arc' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_arc' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_arc' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_arc' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=13 WHERE objectname='tbl_element_x_arc' AND columnname='link';
UPDATE config_form_tableview SET columnindex=14 WHERE objectname='tbl_element_x_arc' AND columnname='publish';
UPDATE config_form_tableview SET columnindex=15 WHERE objectname='tbl_element_x_arc' AND columnname='inventory';
UPDATE config_form_tableview SET columnindex=16 WHERE objectname='tbl_element_x_arc' AND columnname='descript';
UPDATE config_form_tableview SET columnindex=17 WHERE objectname='tbl_element_x_arc' AND columnname='location_type';

-- connec form
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias) VALUES ('connec form','utils','tbl_element_x_connec','epa_type',6,true,'epa_type');
UPDATE config_form_tableview SET columnindex=7 WHERE objectname='tbl_element_x_connec' AND columnname='state';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_connec' AND columnname='state_type';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_connec' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_connec' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_connec' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_connec' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=13 WHERE objectname='tbl_element_x_connec' AND columnname='link';
UPDATE config_form_tableview SET columnindex=14 WHERE objectname='tbl_element_x_connec' AND columnname='publish';
UPDATE config_form_tableview SET columnindex=15 WHERE objectname='tbl_element_x_connec' AND columnname='inventory';
UPDATE config_form_tableview SET columnindex=16 WHERE objectname='tbl_element_x_connec' AND columnname='descript';
UPDATE config_form_tableview SET columnindex=17 WHERE objectname='tbl_element_x_connec' AND columnname='location_type';

-- link form
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias) VALUES ('link form','utils','tbl_element_x_link','epa_type',6,true,'epa_type');
UPDATE config_form_tableview SET columnindex=7 WHERE objectname='tbl_element_x_link' AND columnname='state';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_link' AND columnname='state_type';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_link' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_link' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_link' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_link' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=13 WHERE objectname='tbl_element_x_link' AND columnname='link';
UPDATE config_form_tableview SET columnindex=14 WHERE objectname='tbl_element_x_link' AND columnname='publish';
UPDATE config_form_tableview SET columnindex=15 WHERE objectname='tbl_element_x_link' AND columnname='inventory';
UPDATE config_form_tableview SET columnindex=16 WHERE objectname='tbl_element_x_link' AND columnname='descript';
UPDATE config_form_tableview SET columnindex=17 WHERE objectname='tbl_element_x_link' AND columnname='location_type';

-- node form
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias) VALUES ('node form','utils','tbl_element_x_node','epa_type',6,true,'epa_type');
UPDATE config_form_tableview SET columnindex=7 WHERE objectname='tbl_element_x_node' AND columnname='state';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_node' AND columnname='state_type';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_node' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_node' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_node' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_node' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=13 WHERE objectname='tbl_element_x_node' AND columnname='link';
UPDATE config_form_tableview SET columnindex=14 WHERE objectname='tbl_element_x_node' AND columnname='publish';
UPDATE config_form_tableview SET columnindex=15 WHERE objectname='tbl_element_x_node' AND columnname='inventory';
UPDATE config_form_tableview SET columnindex=16 WHERE objectname='tbl_element_x_node' AND columnname='descript';
UPDATE config_form_tableview SET columnindex=17 WHERE objectname='tbl_element_x_node' AND columnname='location_type';

UPDATE config_form_tabs
SET tabactions = COALESCE(
    (
        SELECT json_agg(elem)
        FROM json_array_elements(tabactions) AS elem
        WHERE elem->>'actionName' <> 'actionPump'
    ),
    '[]'::json
)
WHERE tabactions::text ILIKE '%"actionName":"actionPump"%';
UPDATE config_form_list SET query_text = concat(query_text, ' AND "schema" = ''', current_schema, '''') WHERE listname = 'audit_results';

INSERT INTO config_param_system ("parameter",value,descript,"label",dv_querytext,dv_filterbyfield,isenabled,layoutorder,project_type,dv_isparent,isautoupdate,"datatype",widgettype,ismandatory,iseditable,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,placeholder,standardvalue,layoutname) VALUES
	 ('basic_selector_sectorisexplismuni','false','Variable to configure that explotation and sector has the same code in order to make a direct correlation one each other','Selector variables',NULL,NULL,true,NULL,'utils',NULL,NULL,'boolean',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
	 on conflict (parameter) do nothing;

-- 27/08/2025
UPDATE config_form_fields SET widgetcontrols='{ "minRole": "role_plan"}'::json
WHERE formname='generic' AND formtype='check_project' AND columnname='plan_check' AND tabname='tab_data';

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden) VALUES ('ve_epa_tank','form_feature','tab_epa','reaction_coeff','lyt_epa_data_1',10,'string','text','Reaction coefficient:','Reaction coefficient',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
UPDATE config_form_fields SET layoutorder=11 WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=12 WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=13 WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=14 WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden) VALUES ('ve_inp_tank','form_feature','tab_epa','reaction_coeff','lyt_epa_data_1',10,'string','text','Reaction coefficient:','Reaction coefficient',false,false,true,false,false,'{"filterSign":"ILIKE"}'::json,false);
UPDATE config_form_fields SET layoutorder=11 WHERE formname='ve_inp_tank' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=12 WHERE formname='ve_inp_tank' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=13 WHERE formname='ve_inp_tank' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=14 WHERE formname='ve_inp_tank' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';

UPDATE config_form_fields SET layoutorder=7 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='overflow' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='mixing_model' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=9 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='mixing_fraction' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=10 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='reaction_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=11 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=12 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=13 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=14 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=15 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET layoutorder=16 WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='head' AND tabname='tab_epa';

DELETE FROM sys_function WHERE id=3496;
UPDATE config_form_fields SET dv_isnullvalue = TRUE WHERE columnname IN ('ownercat_id', 'brand_id', 'model_id');
UPDATE config_form_fields SET widgettype='combo', isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext='SELECT id, id as idval FROM cat_brand_model WHERE ''EPUMP'' = ANY(featurecat_id::text[])', dv_parent_id='brand_id', dv_querytext_filterc='AND cat_brand_model.catbrand_id' WHERE formname ILIKE 've_element_%' AND columnname='model_id';
UPDATE config_form_fields SET widgettype='combo', isparent=true, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext='SELECT id, id as idval FROM cat_brand WHERE ''EPUMP'' = ANY(featurecat_id::text[])', dv_parent_id=NULL, dv_querytext_filterc=NULL WHERE formname ILIKE 've_element_%' AND columnname='brand_id';

UPDATE sys_param_user SET sys_role='role_plan' WHERE sys_role='role_master';

UPDATE sys_message
	SET hint_message='Please check if your profile has role_plan in order to manage with plan issues'
	WHERE id=1080;

UPDATE edit_typevalue SET idval = 'FALSE1' WHERE typevalue = 'value_boolean' AND idval = 'UNKNOWN';
UPDATE edit_typevalue SET idval = 'UNKNOWN' WHERE typevalue = 'value_boolean' AND idval = 'FALSE';
UPDATE edit_typevalue SET idval = 'FALSE' WHERE typevalue = 'value_boolean' AND idval = 'FALSE1';

-- Config_toolbox
UPDATE config_toolbox
	SET inputparams='[{"label": "Exploitation:", "value": null, "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "expl", "widgettype": "combo", "dvQueryText": "SELECT expl_id as id, name as idval FROM ve_exploitation", "layoutorder": 1}, {"label": "Material:", "value": null, "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "material", "widgettype": "combo", "dvQueryText": "SELECT id, descript as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type)", "layoutorder": 2}, {"label": "Price:", "value": null, "tooltip": "Code of removal material price", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "price", "widgettype": "linetext", "isMandatory": true, "layoutorder": 3, "placeholder": ""}, {"label": "Observ:", "value": null, "tooltip": "Descriptive text for removal (it apears on psector_x_other observ)", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "observ", "widgettype": "linetext", "isMandatory": true, "layoutorder": 4, "placeholder": ""}]'::json
	WHERE id=3322;

UPDATE config_toolbox
	SET inputparams='[{"label": "Direct insert into node table:", "value": null, "datatype": "boolean", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "insertIntoNode", "widgettype": "check", "layoutorder": 1}, {"label": "Node tolerance:", "value": null, "datatype": "float", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "nodeTolerance", "widgettype": "spinbox", "layoutorder": 2}, {"label": "Exploitation ids:", "value": null, "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "exploitation", "widgettype": "combo", "dvQueryText": "select expl_id as id, name as idval from exploitation where active is not false order by name", "layoutorder": 3}, {"label": "State:", "value": null, "datatype": "integer", "isparent": "true", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "stateType", "widgettype": "combo", "dvQueryText": "select value_state_type.id as id, concat((select concat(label, '' '') from config_form_fields where columnname = ''state'' limit 1), value_state.name, (select concat('' - '', label, '' '') from config_form_fields where columnname = ''state_type'' limit 1), value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id", "layoutorder": 4}, {"label": "Workcat:", "value": null, "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "workcatId", "widgettype": "combo", "dvQueryText": "select id as id, id as idval from cat_work where id is not null", "isNullValue": true, "layoutorder": 5}, {"label": "Builtdate:", "value": null, "datatype": "date", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "builtdate", "widgettype": "datetime", "layoutorder": 6}, {"label": "Node type:", "isparent": true, "value": null, "datatype": "text", "iseditable": true, "layoutname": "grl_option_parameters", "selectedId": "$userNodetype", "widgetname": "nodeType", "widgettype": "combo", "dvQueryText": "select distinct cfn.id as id, cfn.id as idval from cat_feature_node cfn JOIN cat_node cn ON cn.node_type=cfn.id where cfn.id is not null", "layoutorder": 7}, {"label": "Node catalog:", "dvparentid": "node_type", "dvquerytext_filterc": " AND value_state_type.state", "value": null, "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": "$userNodecat", "widgetname": "nodeCat", "widgettype": "combo", "dvQueryText": "select distinct id as id, id as idval from cat_node order by id", "parentname": "nodeType", "filterquery": "select distinct id as id, id as idval from cat_node where node_type = ''{parent_value}'' order by id", "layoutorder": 8}]'::json
	WHERE id=2118;


-- update orderby for hidden levels to last position
UPDATE config_typevalue SET addparam='{"orderBy":1000}'::json
WHERE typevalue='sys_table_context' AND id='{"levels": ["HIDDEN"]}';
