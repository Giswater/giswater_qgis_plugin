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

INSERT INTO sys_table (id,descript,sys_role,project_template,context,orderby,alias,notify_action,isaudit,keepauditdays,"source",addparam) values
('v_value_domain','Dominios de valor','role_edit','{"template": [1], "visibility": true, "levels_to_read": 2}','{"levels": ["BASEMAP", "ADDRESS"]}',5,'Domain value',NULL,NULL,NULL,'core',NULL);

UPDATE config_form_fields SET 
widgetcontrols ='{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_value_domain", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": 
"typevalue = ''graphdelimiter_type''", "allowMulti": true, "nofColumns": 2}}' 
where columnname = 'graph_delimiter' and formname = 've_cat_feature_node';