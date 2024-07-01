/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system set 
value = '{"arc": "SELECT arc_id AS arc_id, concat(v_edit_arc.matcat_id,''-Ø'',(c.geom1*100)::integer) as catalog, (case when slope is not null then concat((100*slope)::numeric(12,2),'' % / '',gis_length::numeric(12,2),''m'') else concat(''None / '',gis_length::numeric(12,2),''m'') end) as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id", "node": "SELECT node_id AS node_id, code AS code FROM v_edit_node"}'
where parameter = 'om_profile_guitartext';

-- 01/07/2024
UPDATE sys_table SET addparam='{"pkey":"hydrology_id"}'::json WHERE id='v_edit_cat_hydrology';
