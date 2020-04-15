/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_table SET isdeprecated = true WHERE id = 'anl_mincut_arc_x_node';
UPDATE audit_cat_table SET isdeprecated = true WHERE id = 'v_anl_mincut_flowtrace';

UPDATE audit_cat_function SET
alias = ''
WHERE function_name = 'gw_fct_debug';

UPDATE audit_cat_function SET
function_type = 'trigger function'
WHERE function_name = 'gw_trg_doc';

UPDATE audit_cat_function SET 
return_type  ='[]', 
descript ='NO input parameters needed.
The function allows the possibility to find errors and data inconsistency before exportation to EPA models.' 
WHERE function_name = 'gw_fct_pg2epa_check_data';

UPDATE audit_cat_function SET 
return_type  ='[]', 
descript ='NO input parameters needed.
The function allows the possibility to find errors and data inconsistency for prices cheching catalog elements.'
WHERE function_name = 'gw_fct_plan_check_data';

UPDATE audit_cat_function SET
input_params = '{"featureType":[]}',
function_type = 'function', 
return_type = '[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"value":""}]',
istoolbox= true,
isparametric= true,
descript ='This function analyze data quality for specific result.',
alias = 'Check data quality for specific result'
WHERE function_name = 'gw_fct_pg2epa_check_result';

UPDATE audit_cat_function SET
input_params = '{"featureType":[]}',
function_type = 'function',
return_type = '[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"value":""}]',
istoolbox= true,
isparametric= true,
descript ='This function analyze network topology for specific result. Nodes orphan and disconnected elements are checked.',
alias = 'Check network topology for specific result'
WHERE function_name = 'gw_fct_pg2epa_check_network';

INSERT INTO audit_cat_function VALUES (2850, 'gw_fct_pg2epa_check_options', 'utils', 'function', NULL, NULL, NULL, 'Check consistency options for epa result', 'role_epa', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2852, 'gw_fct_lot_psector_geom', 'utils', 'function', NULL, NULL, NULL, 'Generate lot geometry', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2854, 'gw_fct_pg2epa_manage_varc', 'utils', 'function', NULL, NULL, NULL, 'Manage varcs when export to epa', 'role_epa', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2856, 'gw_api_getunexpected', 'utils', 'function', NULL, NULL, NULL, 'Get unexpected visit', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2858, 'gw_api_get_combochilds', 'utils', 'function', NULL, NULL, NULL, 'Get combo childs', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2860, 'gw_api_getselectors', 'utils', 'function', NULL, NULL, NULL, 'Get selectors', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2862, 'gw_api_setlot', 'utils', 'function', NULL, NULL, NULL, 'Set lot', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2864, 'gw_trg_manage_raster_dem', 'utils', 'trigger function', NULL, NULL, NULL, 'Trigger to manage raster', 'role_edit', false) 
ON CONFLICT (id) DO NOTHING;


UPDATE audit_cat_function SET
istoolbox= false 
WHERE function_name = 'gw_fct_update_elevation_from_dem';

UPDATE config_client_forms SET status = false WHERE table_id = 'v_ui_rpt_cat_result' AND column_id = 'id';

UPDATE config_param_system set standardvalue ='{"status":false, "server":""}' WHERE parameter  ='sys_transaction_db';
UPDATE config_param_system set standardvalue ='1' WHERE parameter  ='i18n_update_mode';

UPDATE audit_cat_table SET isdeprecated  = true where id  like '%v_edit_man_%';