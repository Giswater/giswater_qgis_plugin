/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/08 
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (417, 'Links without connec on startpoint','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (419, 'Duplicated hydrometer related to more than one connec','utils', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/11/10
UPDATE sys_function SET descript ='Check topology assistant. Helps user to identify nodes connected with more/less arcs compared to num_arcs field of cat_feature_node table' WHERE id IN (2212, 2302);
