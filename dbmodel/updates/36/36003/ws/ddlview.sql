/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_minsector;

CREATE OR REPLACE VIEW v_edit_minsector AS 
SELECT 
minsector_id, 
code,
dma_id, 
dqa_id, 
presszone_id, 
sector_id, 
m.expl_id, 
num_border, 
num_connec, 
num_hydro, 
length,
descript,
addparam, 
the_geom
FROM selector_expl, minsector m
  WHERE m.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_vertices AS 
 SELECT arc.arc_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    arc.point AS the_geom
   FROM ( SELECT (st_dumppoints(temp_arc.the_geom)).geom AS point,
            st_startpoint(temp_arc.the_geom) AS startpoint,
            st_endpoint(temp_arc.the_geom) AS endpoint,
            temp_arc.sector_id,
            temp_arc.arc_id
           FROM selector_inp_result,
            temp_arc
          WHERE temp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint);



CREATE OR REPLACE VIEW vi_status AS 
 SELECT temp_arc.arc_id,
    temp_arc.status
   FROM selector_inp_result,
    temp_arc
  WHERE (temp_arc.status::text = 'CLOSED'::text OR temp_arc.status::text = 'OPEN'::text) 
  AND temp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text 
  AND temp_arc.epa_type::text = 'VALVE'::text
UNION
 SELECT temp_arc.arc_id,
    temp_arc.status
   FROM selector_inp_result,
    temp_arc
  WHERE temp_arc.status::text = 'CLOSED'::text AND temp_arc.result_id::text = selector_inp_result.result_id::text 
  AND selector_inp_result.cur_user = "current_user"()::text AND temp_arc.epa_type::text = 'PUMP'::text
UNION
 SELECT temp_arc.arc_id,
    temp_arc.status
   FROM selector_inp_result,
    temp_arc
  WHERE temp_arc.status::text = 'CLOSED'::text AND temp_arc.result_id::text = selector_inp_result.result_id::text 
  AND selector_inp_result.cur_user = "current_user"()::text AND temp_arc.epa_type::text = 'PUMP'::text;


CREATE OR REPLACE VIEW vi_coordinates AS 
 SELECT temp_node.node_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    temp_node.the_geom
   FROM temp_node,
    selector_inp_result a
  WHERE a.result_id::text = temp_node.result_id::text AND a.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS vi_pjointpattern ;