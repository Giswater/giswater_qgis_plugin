/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;





DROP VIEW IF EXISTS v_anl_pgrouting_node CASCADE;
CREATE OR REPLACE VIEW v_anl_pgrouting_node AS 
SELECT 
row_number() OVER (order by node_id) AS rid,
node_id
from node
;



DROP VIEW IF EXISTS v_anl_pgrouting_arc CASCADE;
CREATE OR REPLACE VIEW v_anl_pgrouting_arc AS 
 SELECT row_number() OVER (ORDER BY arc.arc_id) AS id,
    arc.arc_id,
    a.rid::integer AS source,
    b.rid::integer AS target,
    st_length(arc.the_geom) AS cost
from arc
JOIN v_anl_pgrouting_node a on node_1=a.node_id
JOIN v_anl_pgrouting_node b on node_2=b.node_id 
;
