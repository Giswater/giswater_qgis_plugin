/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/04
UPDATE config_toolbox SET functionparams = '{"featureType":["arc"]}' WHERE id = 2496;

-- 2021/06/07
INSERT INTO config_param_system (parameter, value, descript, project_type) VALUES(
'edit_element_widgets_to_hiden',  '{}', 
'Variable to customize widgets from element form. Available widggets:
["element_id", "code", "element_type", "elementcat_id", "num_elements", "state", "state_type", "expl_id", "ownercat_id", "location_type", "buildercat_id", "builtdate", "workcat_id", "workcat_id_end", "comment", "observ", "link", "verified", "rotation", "undelete", "btn_add_geom"]',
'ws')
ON CONFLICT (parameter) DO NOTHING;

--2021/06/02
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source)
VALUES (381, 'Arc duplicated', 'utils',NULL, NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3040, 'gw_fct_anl_arc_duplicated', 'utils', 'function', 'json', 'json',
'Check topology assistant. Detect arcs duplicated only by final nodes or the entire geometry',
'role_edit', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3040,'Check arcs duplicated', '{"featureType":["arc"]}', 
'[{"widgetname":"checkType", "label":"Check type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["geometry","finalNodes"], "comboNames":["GEOMETRY", "FINAL NODES"], "selectedId":"finalNodes"}]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;


-- 2021/06/08
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_version", "column":"sample"}}$$);