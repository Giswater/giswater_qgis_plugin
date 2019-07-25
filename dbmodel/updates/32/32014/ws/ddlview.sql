/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_anl_graf AS
WITH nodes_a AS (SELECT anl_graf.node_1, anl_graf.node_2 FROM anl_graf WHERE water = 1)
SELECT grafclass, anl_graf.arc_id, anl_graf.node_1 FROM anl_graf
LEFT JOIN nodes_a ON anl_graf.node_1::text = nodes_a.node_2::text
WHERE (anl_graf.flag = 0 AND nodes_a.node_1 IS NOT NULL) OR anl_graf.flag = 1 AND anl_graf.user_name::name = "current_user"();



DROP VIEW v_edit_inp_pipe;
CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    v_arc.macrosector_id,
    arc.state,
    arc.annotation,
    arc.custom_length,
    arc.the_geom,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint
   FROM inp_selector_sector,
    arc
     JOIN v_arc ON v_arc.arc_id::text = arc.arc_id::text
     JOIN inp_pipe ON inp_pipe.arc_id::text = arc.arc_id::text
  WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ws_sample.v_edit_inp_junction AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    elevation,
    depth,
    nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_junction.demand,
    inp_junction.pattern_id
   FROM ws_sample.v_node
     JOIN ws_sample.inp_junction USING (node_id)
     JOIN ws_sample.v_edit_inp_pipe a ON a.node_1=v_node.node_id
     JOIN ws_sample.v_edit_inp_pipe b ON b.node_2=v_node.node_id;


   CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status
   FROM ws_sample.v_node
     JOIN ws_sample.inp_pump USING (node_id)
     JOIN ws_sample.v_edit_inp_pipe a ON a.node_1=v_node.node_id
     JOIN ws_sample.v_edit_inp_pipe b ON b.node_2=v_node.node_id;



CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_reservoir.pattern_id
   FROM ws_sample.v_node
     JOIN ws_sample.inp_reservoir USING (node_id)
     JOIN ws_sample.v_edit_inp_pipe a ON a.node_1=v_node.node_id
     JOIN ws_sample.v_edit_inp_pipe b ON b.node_2=v_node.node_id;


CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status
   FROM ws_sample.v_node
     JOIN ws_sample.inp_shortpipe USING (node_id)
     JOIN ws_sample.v_edit_inp_pipe a ON a.node_1=v_node.node_id
     JOIN ws_sample.v_edit_inp_pipe b ON b.node_2=v_node.node_id;


CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM ws_sample.v_node
     JOIN ws_sample.inp_tank USING (node_id)
     JOIN ws_sample.v_edit_inp_pipe a ON a.node_1=v_node.node_id
     JOIN ws_sample.v_edit_inp_pipe b ON b.node_2=v_node.node_id;

   
CREATE OR REPLACE VIEW v_edit_inp_valve AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status
   FROM ws_sample.v_node
     JOIN ws_sample.inp_valve USING (node_id)
     JOIN ws_sample.v_edit_inp_pipe a ON a.node_1=v_node.node_id
     JOIN ws_sample.v_edit_inp_pipe b ON b.node_2=v_node.node_id;
	 

 CREATE OR REPLACE VIEW v_edit_inp_connec AS 
 SELECT connec.connec_id,
    elevation,
    depth,
    connecat_id,
    sector_id,
    connec.state,
    connec.annotation,
    connec.the_geom,
    inp_connec.demand,
    inp_connec.pattern_id
   FROM connec
	JOIN inp_connec USING (connec_id);