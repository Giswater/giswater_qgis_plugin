/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/28
INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('profile_guitarlegend',
'{"catalog":"CATALOG", "vs":"VS", "hs":"HS", "referencePlane":"RF", "dimensions":"SLOPE/LENGTH", "ordinates": "ORDINATES", "topelev":"ELEVATION", "ymax":"DEPTH", "elev": "ELEV", "code":"CODE"}'::json,
'system', 'Profile guitar legend', 'Profile guitar legend configuration', TRUE, null, 'ud', 'json', 'linetext', true, false) 
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('profile_guitartext',
'{"arc":"SELECT arc_id AS arc_id, arccat_id as catalog, concat((100*(elevation1-elevation2)/gis_length)::numeric(12,2),''-'',gis_length::numeric(12,2),''m'') as dimensions , arc_id as code FROM v_edit_arc"}',
'system', 'Profile profile_guitartext', 'Profile guitar stylesheet configuration', TRUE, null, 'ud', 'json', 'linetext', true, false) 
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('profile_vdefault', 
'{"arc":{"cat_geom1":"110"}, "node":{"cat_geom1":"1"}}',
'system', 'Profile vdefault', 'Profile vdefault', TRUE, null, 'ud', 'json', 'linetext', true, false) 
ON CONFLICT (parameter) DO NOTHING;