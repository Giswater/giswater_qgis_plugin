/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (124,'Go2epa-temporal nodarcs','ws', 'epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (125,'role epa check network data','utils', 'epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (126,'Go2epa check demands data','ws', 'epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (127,'Go2epa check','ws', 'epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (128,'Go2epa check orphan nodes','utils', 'epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (129,'arcs less than 20 cm.','utils', 'edit') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (130,'arcs less than 5 cm.','utils', 'edit') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (131,'Go2epa check arc without some node','utils', 'epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (132,'Go2epa check dry arcs','ws', 'epa') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (133,'Go2epa check dry nodes with positive demand','ws', 'epa') ON CONFLICT (id) DO NOTHING;


UPDATE sys_function set function_name = 'gw_fct_pg2epa_demand' where function_name = 'gw_fct_pg2epa_rtc';

UPDATE sys_function set function_name = 'gw_fct_pg2epa_check_network', project_type = 'utils' WHERE id = 2680;

UPDATE sys_function set function_name = 'gw_fct_connect_to_network' where function_name = 'gw_fct_connec_to_network';

UPDATE sys_function set function_name = 'gw_trg_edit_inp_connec' where function_name = 'trg_edit_inp_connec';

UPDATE sys_function set function_name = 'gw_fct_pg2epa_build_supply' where function_name = 'gw_fct_go2epa_fast_buildup';

DELETE FROM sys_function WHERE function_name IN 
('gw_fct_pg2epa_nodescouplecapacity', 'gw_state_searchnodes', 'gw_fct_pg2epa_singlenodecapacity', 
'gw_fct_audit_function', 'gw_fct_module_activate', 'gw_fct_dinlet', 'gw_fct_node_replace');

DELETE FROM sys_function WHERE id = 2648; -- duplicated gw_fct_admin_schema_manage_ct

INSERT INTO sys_function VALUES (2846, 'gw_fct_pg2epa_vdefault', 'utils', 'Function', NULL, NULL, NULL, 'Default values for epa', 'role_epa', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (2848, 'gw_fct_pg2epa_check_result', 'utils', 'Function', NULL, NULL, NULL, 'Check data for epa result', 'role_epa', false) 
ON CONFLICT (id) DO NOTHING;

