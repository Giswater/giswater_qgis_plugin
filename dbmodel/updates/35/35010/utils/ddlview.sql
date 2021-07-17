/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/29

CREATE OR REPLACE VIEW v_edit_inp_controls AS 
SELECT DISTINCT c.id,
c.sector_id,
c.text,
c.active
FROM selector_sector,
inp_controls c
WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_curve AS 
SELECT DISTINCT id, 
curve_type, 
descript, 
c.sector_id
FROM selector_sector,
inp_curve c
WHERE (c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text) OR c.sector_id IS NULL  ORDER BY id;


CREATE OR REPLACE VIEW v_edit_inp_curve_value AS 
SELECT DISTINCT
cv.id, 
cv.curve_id,
curve_type, 
descript, 
c.sector_id,
x_value, 
y_value
FROM selector_sector, inp_curve c
JOIN inp_curve_value cv ON c.id=cv.curve_id
WHERE (c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text) OR c.sector_id IS NULL ORDER BY id;


CREATE OR REPLACE VIEW vi_vertices AS 
 SELECT arc.arc_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    arc.point as the_geom
   FROM ( SELECT (st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM selector_inp_result,
            rpt_inp_arc
          WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint);


  
CREATE OR REPLACE VIEW vi_coordinates AS 
 SELECT rpt_inp_node.node_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    rpt_inp_node.the_geom
   FROM rpt_inp_node,selector_inp_result a
  WHERE a.result_id::text = rpt_inp_node.result_id::text AND a.cur_user = "current_user"()::text;

