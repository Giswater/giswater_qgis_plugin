/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Deprecated sequences
-- todo: insert all deprecated sequences on audit_cat_sequence

-- Deprecated tables and views
-- todo: UPDATE audit_cat_table SET isdeprecated=TRUE where id='config';

-- Deprecated functions
--todo: UPDATE audit_cat_functions SET isdeprecated=TRUE where id='config';


INSERT INTO config_param_system VALUES (1000,'api_search_muni','{"sys_table_id":"ext_municipality", "sys_id_field":"muni_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}',NULL, 'api_search_adress') ON CONFLICT (parameter) DO NOTHING;

-----------------------
-- config_param_system
-----------------------
-- network 
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}' WHERE parameter='api_search_arc';
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}' WHERE parameter='api_search_node';
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}' WHERE parameter='api_search_connec';
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}' WHERE parameter='api_search_element';


-- psector
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_plan_psector","WARNING":"sys_table_id only web, python is hardcoded: v_edit_plan_psector as self.plan_om =''plan''", "sys_id_field":"psector_id", "sys_search_field":"name", "sys_parent_field":"expl_id", "sys_geom_field":"the_geom"}'
WHERE parameter='api_search_psector';

UPDATE config_param_system SET value='{"id":"EUR", "descript":"EURO", "symbol":"€"}' WHERE parameter='sys_currency';


-----------------------
-- audit_cat_function
-----------------------
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_arc';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_node';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_connec';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_gully';

-----------------------
-- sys_csv2pg_cat
-----------------------
INSERT INTO sys_csv2pg_cat (id, name, name_i18n, sys_role, functionname, isdeprecated) VALUES (19, 'Exmport ui', 'Export ui', 'role_admin', 'gw_fct_export_ui_xml', FALSE);
INSERT INTO sys_csv2pg_cat (id, name, name_i18n, sys_role, functionname, isdeprecated) VALUES (20, 'Import ui', 'Import ui', 'role_admin', 'gw_fct_import_ui_xml', FALSE);