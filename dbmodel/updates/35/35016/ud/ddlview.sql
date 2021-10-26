/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/10/21

DROP VIEW IF EXISTS vi_losses;
CREATE OR REPLACE VIEW vi_losses AS 
 SELECT arc_id,
 CASE WHEN kentry IS NOT NULL THEN kentry ELSE 0 END AS kentry,
 CASE WHEN kexit IS NOT NULL THEN kexit ELSE 0 END AS kexit,
 CASE WHEN kavg IS NOT NULL THEN kavg ELSE 0 END AS kavg,
 CASE WHEN flap IS NOT NULL THEN flap ELSE 'NO' END AS flap,
    seepage
   FROM temp_arc
  WHERE kentry > 0::numeric OR kexit > 0::numeric OR kavg > 0::numeric 
  OR flap::text = 'YES'::text OR seepage is not null;


DROP VIEW IF EXISTS vi_subcatch2node;
CREATE OR REPLACE VIEW vi_subcatch2node AS 
 SELECT s1.subc_id,
 s2.hydrology_id,
        CASE
            WHEN s2.the_geom IS NOT NULL THEN st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))
            ELSE st_makeline(st_centroid(s1.the_geom), v_node.the_geom)
        END AS the_geom
   FROM v_edit_inp_subcatchment s1
     LEFT JOIN v_edit_inp_subcatchment s2 ON s2.subc_id::text = s1.outlet_id::text
     LEFT JOIN v_node ON v_node.node_id::text = s1.outlet_id::text;


DROP VIEW IF EXISTS vi_subcatchcentroid;
CREATE OR REPLACE VIEW vi_subcatchcentroid AS 
 SELECT v_edit_inp_subcatchment.subc_id,
  hydrology_id,
    st_centroid(v_edit_inp_subcatchment.the_geom) AS the_geom
   FROM v_edit_inp_subcatchment;