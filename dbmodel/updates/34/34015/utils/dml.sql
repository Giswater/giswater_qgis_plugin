/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/06/21

-- reorder config_typevalue
UPDATE config_typevalue SET id = 'tab_hydro_state' WHERE id = 'tab_hdyro_state';
INSERT INTO config_typevalue VALUES ('tabname_typevalue', 'tab_sector', 'Sector', 'sector');
INSERT INTO config_form_tabs VALUES ('filters', 'tab_psector', 'Psector', 'Psector', 'role_master', null, null, 4);
INSERT INTO config_form_tabs VALUES ('filters', 'tab_sector', 'Sector', 'Sector', 'role_epa', null, null, 4);

INSERT INTO config_typevalue VALUES ('tabname_typevalue', 'tab_add_network', 'tab_add_network', 'tabAddNetwork');
INSERT INTO config_form_tabs VALUES ('search', 'tab_add_network', 'Add Network', 'Additional Network', 'role_basic', null, null, 4);


UPDATE config_param_system SET value = replace (value, 'feature_type', 'search_type') where parameter like '%basic_search_network%';


-- reorder config_form_tabs
DELETE FROM config_form_tabs where formname in ('exploitation' , 'hydrometer');
UPDATE config_form_tabs SET formname = 'selector_basic'  WHERE formname = 'selector';
UPDATE config_form_tabs SET formname = 'selector_mincut'  WHERE formname = 'mincut';

UPDATE config_form_tabs SET label = 'Expl' WHERE tabname = 'tab_exploitation';
UPDATE config_form_tabs SET label = 'State' WHERE tabname = 'tab_network_state';

DELETE FROM config_form_tabs WHERE tabname ='tab_hydro_state' AND formname = 'selector_basic';

--reorder config_param_system
UPDATE config_param_system set parameter = 'basic_selector_tab_network_state' where parameter = 'basic_selector_state';
UPDATE config_param_system set parameter = 'basic_selector_tab_hydro_state' where parameter = 'basic_selector_hydrometer';
UPDATE config_param_system set parameter = 'basic_selector_tab_exploitation' where parameter = 'basic_selector_exploitation';
UPDATE config_param_system set parameter = 'basic_selector_tab_mincut' where parameter = 'basic_selector_mincut';

UPDATE config_param_system set value =
'{"table":"exploitation", "selector":"selector_expl", "table_id":"expl_id",  "selector_id":"expl_id",  "label":"expl_id, ' - ', name", 
"manageAll":true, "selectionMode":"keepPreviousUsingShift" ,  "query_filter":"AND expl_id > 0", "typeaheadFilter":{"queryText":"SELECT expl_id as id, name AS idval FROM v_edit_exploitation WHERE expl_id > 0"}}'
WHERE parameter = 'basic_selector_tab_exploitation';

UPDATE config_param_system set value =
'{"table":"value_state", "selector":"selector_state", "table_id":"id",  "selector_id":"state_id",  "label":"id, '' - '', name", 
"manageAll":false, "query_filter":""}'
WHERE parameter = 'basic_selector_tab_network_state';

INSERT INTO config_param_system VALUES ('basic_selector_tab_sector', 
'{"table":"sector", "selector":"selector_sector", "table_id":"sector_id",  "selector_id":"sector_id",  "label":"sector_id, '' - '', name", 
"manageAll":true, "query_filter":" AND sector_id > 0"}');

INSERT INTO config_param_system VALUES ('basic_selector_tab_psector',
'{"table":"plan_psector", "selector":"selector_psector", "table_id":"psector_id",  "selector_id":"psector_id",  "label":"psector_id, '' - '', name", 
"manageAll":true, "query_filter":" AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)",
"layermanager":{"active":"v_edit_psector", "visible":["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_gully"], "addToc":["v_edit_psector"]},
"typeaheadFilter":{"queryText":"SELECT psector_id as id, name AS idval FROM v_edit_psector"}}');

UPDATE config_param_system set descript = 'Variable to configura all options related to search for the specificic tab' , label = 'Selector variables' ,
isenabled  = true, project_type = 'utils', datatype = 'json' where parameter like '%basic_selector%';

UPDATE sys_table SET notify_action = (replace (notify_action::text, 'indexing_spatial_layer', 'set_layer_index'))::json WHERE notify_action::text like '%indexing_spatial_layer%';

DELETE FROM config_param_system WHERE parameter = 'admin_role_permisions';

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_criticity)
    VALUES ('sys_style', 'Table to store styles to be used on client passed by json response of bbdd', 'role_basic', 0, 0)
    ON CONFLICT (id) DO NOTHING;