/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = am, public;


CREATE OR REPLACE VIEW am.ext_arc_asset
AS WITH nodes AS MATERIALIZED (
         SELECT node.node_id,
            node_add.press_avg
           FROM PARENT_SCHEMA.node
             JOIN PARENT_SCHEMA.node_add ON node.node_id = node_add.node_id
             JOIN PARENT_SCHEMA.vf_node ON vf_node.node_id = node.node_id
        ), arcs AS MATERIALIZED (
         SELECT a_1.arc_id,
            a_1.node_2,
            a_1.sector_id,
            a_1.presszone_id,
            a_1.builtdate,
            a_1.arccat_id,
            a_1.pavcat_id,
            a_1.function_type,
            a_1.the_geom,
            a_1.code,
            a_1.expl_id,
            a_1.dma_id,
            n1.press_avg AS press1,
            a_1.state
           FROM PARENT_SCHEMA.arc a_1
             JOIN nodes n1 ON n1.node_id = a_1.node_1
        )
 SELECT a.arc_id,
    a.sector_id,
    s.macrosector_id,
    a.presszone_id,
    a.builtdate,
    a.arccat_id,
    cat.dnom,
    cat.matcat_id,
    a.pavcat_id,
    a.function_type,
    a.the_geom,
    a.code,
    a.expl_id,
    a.dma_id,
    a.press1,
    n2.press_avg AS press2,
    arc_add.flow_avg
   FROM arcs a
     JOIN nodes n2 ON n2.node_id = a.node_2
     JOIN PARENT_SCHEMA.vf_arc vf ON vf.arc_id = a.arc_id
     JOIN PARENT_SCHEMA.sector s ON s.sector_id = a.sector_id
     JOIN PARENT_SCHEMA.cat_arc cat ON cat.id::text = a.arccat_id::text
     JOIN PARENT_SCHEMA.arc_add ON arc_add.arc_id = a.arc_id
  WHERE a.state = 1;
