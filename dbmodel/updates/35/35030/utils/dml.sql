/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/26
UPDATE config_param_system SET value = (value::jsonb - 'manageConflict')::text 
WHERE parameter='utils_graphanalytics_status';

UPDATE config_toolbox SET inputparams = b.inp FROM
(SELECT json_agg(a.inputs::json) AS inp FROM
(SELECT json_array_elements_text(inputparams) as inputs
FROM   config_toolbox
WHERE id=2768
union select concat('{"widgetname":"checkData" , "label":"Check data", "widgettype":"combo","datatype":"text","tooltip": "Execute graphanalytics_check or/and om_check data function", "layoutname":"grl_option_parameters","layoutorder":"',maxord+1,'",
"comboIds":["FULL","PARTIAL","NONE"],
"comboNames":["FULL","PARTIAL","NONE"], "selectedId":""}')
from (select max(d.layoutord::integer) as maxord from
(SELECT json_extract_path_text(json_array_elements(inputparams),'layoutorder') as layoutord
FROM   config_toolbox
WHERE id=2768)d where layoutord is not null)e)a)b WHERE  id=2768;


INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3174, 'gw_trg_edit_setarcdata', 'utils', 'trigger function', 
'Trigger that fills arc with values captured or calculated based on attributes stored on final nodes', 'role_edit', 'core');
