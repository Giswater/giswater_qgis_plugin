/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/11
UPDATE connec SET pjoint_id = exit_id, pjoint_type = exit_type 
FROM (select feature_id, exit_id, exit_type from link where feature_id IN (select connec_id from connec where pjoint_id is null) 
AND exit_type IN ('NODE', 'VNODE'))a
WHERE connec_id  = feature_id AND pjoint_id IS NULL;

--2021/11/12
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (417, 'Check ','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3106, 'gw_fct_pg2epa_check_nodarc', 'ws', 'function', 'json', 
'json', 'Function to check nodarcs inconsistency.
This function must be used when go2epa crashes creating nodarcs. It works with the selected expl/sector choosed by user', 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3106,'Check nodarc inconsistency', '{"featureType":[]}', NULL, NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;
