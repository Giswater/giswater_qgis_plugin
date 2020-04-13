/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_param_user SET vdefault =
'{"reservoir":{"switch2Junction":["ETAP", "POU", "CAPTACIO"]},
"tank":{"distVirtualReservoir":0.01}, 
"pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE", "defaultCurve":"GP30"}, 
"pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED", "defaultCurve":"IM00"}, 
"PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"}, 
"PSV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"}
}'
WHERE id = 'inp_options_buildup_supply';



-- 09/03/2020
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) 
VALUES ('mincut form', 'ws', 'v_anl_mincut_result_hydrometer', 'id', 1, false);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) 
VALUES ('mincut form', 'ws', 'v_anl_mincut_result_hydrometer', 'result_id', 2, false);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) 
VALUES ('mincut form', 'ws', 'v_anl_mincut_result_hydrometer', 'work_order', 3, false);


-- 12/03/2020
UPDATE audit_cat_param_user 
SET widgetcontrols = (replace (widgetcontrols::text, '{"minValue":0.001, "maxValue":100}', '{"maxMinValues":{"min":0.001, "max":100}}'))::json 
WHERE widgetcontrols is not null;