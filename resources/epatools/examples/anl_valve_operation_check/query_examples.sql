/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- How to get a list of minsectors to use in the .in file
SELECT E'[SCENARIOS]\n' || string_agg(minsectors, E'\n\n')
FROM (
  SELECT E'MINSECTOR-' || minsector_id || ' CLOSED ' || string_agg(arc_id, ' ' ORDER BY arc_id) minsectors
  FROM ws.v_edit_arc
  GROUP BY minsector_id
  ORDER BY minsector_id
) AS m;

-- How to add the minsectors to anl_arc as input (fid=493)
INSERT INTO ws.anl_arc (arc_id, fid, cur_user, the_geom, addparam)
SELECT arc_id, 493, current_user, the_geom,
  '{"scenario": "MINSECTOR-' || minsector_id || '", "valve_status": "closed"}'
FROM ws.v_edit_arc
ORDER BY minsector_id, arc_id;

-- output example (fid=494)
select node_id, the_geom,
	addparam::json ->> 'scenario' as scenario,
	(addparam::json ->> 'pressure')::numeric as pressure,
	addparam::json ->> 'status' as status,
	addparam
from ws.anl_node
where fid=494 and cur_user = current_user;