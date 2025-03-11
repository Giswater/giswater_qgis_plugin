/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- input example (fid = 491)
insert into anl_node (node_id, fid, nodecat_id, expl_id, cur_user, the_geom, addparam)
select node_id, 491, nodecat_id, expl_id, current_user, the_geom, '{"requiredDemand":60, "requiredPressure":10}' 
from v_edit_node where sys_type = 'HYDRANT';


-- output example (fid= 492)
select node_id, nodecat_id, expl_id, the_geom,
	addparam::jsonb ? 'error' as error,
	addparam::json #>> '{simple,status}' as simple,
	addparam::json #>> '{doubled,status}' as doubled,
	addparam::json #>> '{paired,status}' as paired,
	addparam
from ws.anl_node
where fid=492 and cur_user = current_user;


--addparam result structure (fid=492)
'{"simple":{status[ok-failed]}, requiredDemand  requiredPressure  modelDemand, modelPressure},
  "doubled":{status[ok-failed]}, requiredDemand  requiredPressure  modelDemand, modelPressure},
  "paired":[{status[ok-failed], {"nodePair":"3435", requiredDemand  requiredPressure  modelDemand, modelPressure},
           {"nodePair":"3436", requiredDemand  requiredPressure  modelDemand, modelPressure}]