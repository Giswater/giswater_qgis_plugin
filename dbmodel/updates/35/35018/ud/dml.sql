/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/08
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (418, 'Links without gully on startpoint','ud', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/11/11
INSERT INTO config_function(id, function_name) VALUES (3104, 'gw_fct_import_istram');

--2021/11/18
UPDATE config_csv SET addparam = '{"query": "SELECT node_id, top_elev, sys_elev FROM SCHEMA_NAME.v_edit_node ", "layerName":"Nodes", "group": "ISTRAM"}'
WHERE fid=408;

UPDATE config_csv SET addparam = '{"query": "SELECT arc_id, sys_elev1, sys_elev2, cat_shape, matcat_id, cat_geom1, cat_geom2 FROM SCHEMA_NAME.v_edit_arc ", "layerName":"Arcs", "group": "ISTRAM"}'
WHERE fid=409;