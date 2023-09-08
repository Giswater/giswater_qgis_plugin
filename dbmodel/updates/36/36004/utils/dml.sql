/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_param_user SET value = value::jsonb - 'autoRepair'
WHERE  parameter = 'inp_options_debug';

UPDATE config_param_user SET value = value::jsonb - 'steps'
WHERE  parameter = 'inp_options_debug';

UPDATE sys_table SET context='{"level_1":"OM","level_2":"VISIT"}', orderby=3, alias='Visit Catalog' WHERE id='om_visit_cat';
UPDATE sys_table SET context='{"level_1":"OM","level_2":"VISIT"}', orderby=4, alias='Parameter Catalog' WHERE id='config_visit_parameter';

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3270, 'gw_fct_config_mapzones', 'ws', 'function', 'json', 'json', 
'Function that modifies the configuration of mapzones', 'role_edit', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (512, 'Modify mapzone configuration', 'utils', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3240, 'It''s not possible to configure thid node as mapzone header, cause this type of node that can''t be a header of', 'Select different parent node.', 2, true, 'utils', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3242, 'It''s not possible to configure this node as mapzone header, cause it''s not an operative nor planified node', 'Select different parent node.', 2, true, 'utils', 'core')  ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3244, 'It''s not possible to use selected arcs. They are not connected to node parent', 'Select different arcs.', 2, true, 'utils', 'core')  ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, "source") 
VALUES(3246, 'The inserted streetname value doesn''t exist on ext_streetaxis table', 'Please insert an existing one', 2, true, 'utils', 'core') ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET context='{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"POLYGON"}', orderby=4, alias='Element polygon'  WHERE id='ve_pol_element';
