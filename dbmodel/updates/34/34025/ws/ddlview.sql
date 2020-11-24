/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20
CREATE OR REPLACE VIEW v_edit_inp_valve AS 
 SELECT DISTINCT ON (a.node_id) a.node_id,
    a.elevation,
    a.depth,
    a.nodecat_id,
    a.sector_id,
    a.macrosector_id,
    a.state,
    a.state_type,
    a.annotation,
    a.expl_id,
    a.valv_type,
    a.pressure,
    a.flow,
    a.coef_loss,
    a.curve_id,
    a.minorloss,
    a.to_arc,
    a.status,
    a.the_geom,
	a.custom_dint
   FROM ( SELECT v_node.node_id,
            v_node.elevation,
            v_node.depth,
            v_node.nodecat_id,
            v_node.sector_id,
            v_node.macrosector_id,
            v_node.state,
            v_node.state_type,
            v_node.annotation,
            v_node.expl_id,
            inp_valve.valv_type,
            inp_valve.pressure,
            inp_valve.flow,
            inp_valve.coef_loss,
            inp_valve.curve_id,
            inp_valve.minorloss,
            inp_valve.to_arc,
            inp_valve.status,
            v_node.the_geom,
            inp_valve.custom_dint
           FROM v_node
             JOIN inp_valve USING (node_id)
             JOIN vi_parent_arc a_1 ON a_1.node_1::text = v_node.node_id::text
        UNION
         SELECT v_node.node_id,
            v_node.elevation,
            v_node.depth,
            v_node.nodecat_id,
            v_node.sector_id,
            v_node.macrosector_id,
            v_node.state,
            v_node.state_type,
            v_node.annotation,
            v_node.expl_id,
            inp_valve.valv_type,
            inp_valve.pressure,
            inp_valve.flow,
            inp_valve.coef_loss,
            inp_valve.curve_id,
            inp_valve.minorloss,
            inp_valve.to_arc,
            inp_valve.status,
            v_node.the_geom,
            inp_valve.custom_dint
           FROM v_node
             JOIN inp_valve USING (node_id)
             JOIN vi_parent_arc a_1 ON a_1.node_2::text = v_node.node_id::text) a;