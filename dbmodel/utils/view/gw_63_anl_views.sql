/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "ud30" , public, pg_catalog;


DROP VIEW IF EXISTS v_anl_node_orphan CASCADE;
CREATE OR REPLACE VIEW v_anl_node_orphan AS
SELECT
anl_node_orphan.node_id,
anl_node_orphan.node_type,
anl_node_orphan.the_geom,
exploitation.name AS expl_name
FROM selector_expl, anl_node_orphan
JOIN node ON node.node_id=anl_node_orphan.node_id
JOIN exploitation ON node.expl_id=exploitation.expl_id
WHERE ((node.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());

DROP VIEW IF EXISTS v_anl_node_duplicated CASCADE;
CREATE OR REPLACE VIEW v_anl_node_duplicated AS
SELECT
anl_node_duplicated.node_id,
anl_node_duplicated.node_conserv,
anl_node_duplicated.the_geom,
exploitation.name AS expl_name
FROM selector_expl, anl_node_duplicated
JOIN node ON node.node_id=anl_node_duplicated.node_id
JOIN exploitation ON node.expl_id=exploitation.expl_id
WHERE ((node.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_anl_connec_duplicated CASCADE;
CREATE OR REPLACE VIEW v_anl_connec_duplicated AS
SELECT
anl_connec_duplicated.connec_id,
anl_connec_duplicated.connec_conserv,
anl_connec_duplicated.the_geom,
exploitation.name AS expl_name
FROM selector_expl, anl_connec_duplicated
JOIN connec ON connec.connec_id=anl_connec_duplicated.connec_id
JOIN exploitation ON connec.expl_id=exploitation.expl_id
WHERE ((connec.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_anl_arc_same_startend CASCADE;
CREATE OR REPLACE VIEW v_anl_arc_same_startend AS
SELECT
anl_arc_same_startend.arc_id,
anl_arc_same_startend.length,
anl_arc_same_startend.the_geom,
exploitation.name AS expl_name
FROM selector_expl, anl_arc_same_startend
JOIN arc ON arc.arc_id=anl_arc_same_startend.arc_id
JOIN exploitation ON arc.expl_id=exploitation.expl_id
WHERE ((arc.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



-- pgrouting views

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


