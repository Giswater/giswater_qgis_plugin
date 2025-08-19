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
  ELSE id < 2 
END' 
WHERE columnname = 'state';


alter table plan_typevalue disable trigger gw_trg_typevalue_config_fk;
delete from plan_typevalue where typevalue = 'psector_status' and id = '0';
alter table plan_typevalue enable trigger gw_trg_typevalue_config_fk;

update config_form_fields set dv_orderby_id = true where formtype ='psector' and columnname ='status';

UPDATE config_param_system SET value = 
'{"table":"plan_psector","selector":"selector_psector","table_id":"psector_id","selector_id":"psector_id","label":"psector_id, '' - '', name","orderBy":"psector_id","manageAll":true,"typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))","query_filter":"AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)","typeaheadForced":true,"selectionMode":"keepPreviousUsingShift"}' 
WHERE parameter = 'basic_selector_tab_psector';

