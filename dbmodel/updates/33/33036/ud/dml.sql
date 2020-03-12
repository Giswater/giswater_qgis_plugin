/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/13

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, qgis_criticity, qgis_message, isdeprecated)
VALUES ('v_anl_flow_gully', 'Analysis', 'View with the result of flow trace and flow exit results (gully)','role_om',0,'role_om',2,
'Cannot view the results of flowtrace analytics tool related to gullies', false);