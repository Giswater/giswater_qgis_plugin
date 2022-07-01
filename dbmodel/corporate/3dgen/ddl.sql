/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public;

CREATE view v_arc_3d as
SELECT * FROM v_arc 
JOIN
(
WITH j AS (
  SELECT arc_id , ST_MakeLine(j.pointz) AS the_geom3d
  FROM (
  SELECT arc_id,
  	 ST_linelocatepoint(the_geom, (ST_DumpPoints(the_geom)).geom) as locate,
         ST_MakePoint(ST_X((ST_DumpPoints(the_geom)).geom), ST_Y((ST_DumpPoints(the_geom)).geom),
         (elevation1 + (elevation2 - elevation1)*(ST_linelocatepoint(the_geom, (ST_DumpPoints(the_geom)).geom)))
         ) AS pointz
  FROM v_arc ORDER BY arc_id,the_geom
  )j
  group by arc_id
  )
  select * from  j)a USING (arc_id);

 
CREATE view v_node_3d as
SELECT *, ST_MakePoint(ST_X(the_geom), ST_Y(the_geom), elevation)  as the_geom3d FROM v_node;