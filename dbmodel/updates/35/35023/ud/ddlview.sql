/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/02

DROP VIEW vi_subcatch2node;
CREATE OR REPLACE VIEW vi_subcatch2outlet AS 
 SELECT
   subc_id,
   hydrology_id,
   (st_makeline(st_centroid(s1.the_geom), v_node.the_geom))::geometry(LINESTRING,SRID_VALUE) AS the_geom
   FROM v_edit_inp_subcatchment s1
   JOIN v_node ON v_node.node_id::text = s1.outlet_id::text
UNION
SELECT
   s1.subc_id,
   s1.hydrology_id,
   st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))::geometry(LINESTRING,SRID_VALUE) AS the_geom
   FROM v_edit_inp_subcatchment s1
   JOIN v_edit_inp_subcatchment s2 ON s1.outlet_id = s2.subc_id;

--2022/03/07
CREATE OR REPLACE VIEW vi_vertices AS
 SELECT DISTINCT ON (the_geom, path) arc.arc_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    arc.point AS the_geom
   FROM ( SELECT (st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
     (st_dumppoints(rpt_inp_arc.the_geom)).path AS path,
            st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM selector_inp_result,
            rpt_inp_arc
          WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint)
  ORDER BY path;

--2022/03/15

CREATE OR REPLACE VIEW vi_inflows AS 
 SELECT temp_node_other.node_id,
    temp_node_other.type,
    temp_node_other.timser_id,
    'FLOW'::text AS format,
    1::numeric(12,4) AS mfactor,
    temp_node_other.sfactor,
    temp_node_other.base,
    temp_node_other.pattern_id
   FROM temp_node_other
  WHERE temp_node_other.type::text = 'FLOW'::text
UNION
 SELECT temp_node_other.node_id,
    temp_node_other.poll_id AS type,
    temp_node_other.timser_id,
    temp_node_other.other AS format,
    temp_node_other.mfactor,
    temp_node_other.sfactor,
    temp_node_other.base,
    temp_node_other.pattern_id
   FROM temp_node_other
  WHERE temp_node_other.type::text = 'POLLUTANT'::text
  order by node_id;


  