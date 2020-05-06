/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/28
INSERT INTO om_profile (profile_id, values)
SELECT distinct on (profile_id) profile_id, (concat('{"initNode":"',start_point, '", "endNode":"', end_point,'"}'))::json
FROM _anl_arc_profile_value_;

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('profile_guitarlegend',
'{"catalog":"CATALOG", "vs":"VS", "hs":"HS", "referencePlane":"RF", "dimensions":"SLOPE/LENGTH", "ordinates": "ORDINATES", "topelev":"TOP ELEV", "ymax":"YMAX", "elev": "ELEV", "code":"CODE"}'::json,
'system', 'Profile guitar legend', 'Profile guitar legend configuration', TRUE, null, 'ud', 'json', 'linetext', true, false) 
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('profile_stylesheet',
'{"guitarText":{"color":"black", "italic":true, "bold":true},"legendText":{"color":"black", "italic":true, "bold":true},"scaleText":{"color":"black", "height":10, "italic":true, "bold":true},
"ground":{"color":"black", "width":0.2}, "infra":{"color":"black", "width":0.2}, "guitar":{"color":"black", "width":0.2}, "estimated":{"color":"black", "width":0.2}}'::json, 
'system', 'Profile stylesheet', 'Profile guitar stylesheet configuration', TRUE, null, 'ud', 'json', 'linetext', true, false) 
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('profile_guitartext',
'{"arc":"SELECT arc_id AS arc_id, concat(v_edit_arc.matcat_id,''-Ø'',(c.geom1*100)::integer) as catalog, concat((100*slope)::numeric(12,2),''-'',gis_length::numeric(12,2),''m'') as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id"}',
'system', 'Profile stylesheet', 'Profile guitar stylesheet configuration', TRUE, null, 'ud', 'json', 'linetext', true, false) 
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('profile_vdefault', 
'{"arc":{"cat_geom1":"0.40"}, "node":{"cat_geom1":"1"}}',
'system', 'Profile stylesheet', 'Profile guitar stylesheet configuration', TRUE, null, 'ud', 'json', 'linetext', true, false) 
ON CONFLICT (parameter) DO NOTHING;