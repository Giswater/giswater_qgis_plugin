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
   JOIN v_edit_inp_subcatchment s2 ON s1.outlet_id = s2.subc_id