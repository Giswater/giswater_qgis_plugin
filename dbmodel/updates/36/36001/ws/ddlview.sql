/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/01/03
DROP VIEW v_edit_inp_junction;
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
	-- macrosector
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    demand,
    pattern_id,
    peak_factor,
	emitter_coef,
    initial_quality,
    source_type,
    source_quality,
    source_pattern,
	n.the_geom
   FROM selector_sector, v_edit_node n
   JOIN inp_junction USING (node_id)
   WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


/*

DROP VIEW v_edit_inp_pipe;
CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    --arc.macrosector_id,
    arc.dma_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    --arc.expl_id,
    arc.custom_length,
    minorloss,
    status,
    custom_roughness,
    custom_dint,


    arc.the_geom
   FROM selector_sector,v_arc arc
   JOIN inp_pipe USING (arc_id)
   WHERE arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



DROP VIEW v_edit_inp_pump;
CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
	n.dma_id,
    --n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    --n.expl_id,
	nodarc_id,
    power,
    curve_id,
    speed,
    pattern,
    to_arc,
    status,
    pump_type,
	
	
    n.the_geom
   FROM selector_sector, v_node n
   JOIN inp_pump USING (node_id)
   WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



DROP VIEW v_edit_inp_reservoir;
CREATE OR REPLACE VIEW ve_inp_reservoir AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    --n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    --n.expl_id,
    pattern_id,
    head,
		
		
    n.the_geom
   FROM selector_sector,v_node n
   JOIN inp_reservoir USING (node_id)
   WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



DROP VIEW v_edit_inp_shortpipe;
CREATE OR REPLACE VIEW ve_inp_shortpipe AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    --n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    --n.expl_id,
	nodarc_id,
    minorloss,
    to_arc,
    status,
	
	
    n.the_geom
   FROM selector_sector, v_node n
   JOIN inp_shortpipe USING (node_id)
   WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  
  
  
DROP VIEW v_edit_inp_tank;
CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    --n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    --n.expl_id,
    initlevel,
    minlevel,
    maxlevel,
    diameter,
    minvol,
    curve_id,
	
	
    n.the_geom
   FROM selector_sector, v_node n
   JOIN inp_tank USING (node_id)
   WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
    
  
  
DROP VIEW v_edit_inp_valve;
CREATE OR REPLACE VIEW v_edit_inp_valve AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
	v_node.dma_id,
    --v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    --v_node.expl_id,
	nodarc_id,
    valv_type,
    pressure,
    flow,
    coef_loss,
    curve_id,
    minorloss,
    to_arc,
    status,
	custom_dint,
    add_settings,
	
	v_node.the_geom,
    FROM selector_sector, v_node
    JOIN inp_valve USING (node_id)
    WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  
  
DROP VIEW v_edit_inp_virtualvalve;
CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    (v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
    (v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
    v_arc.arccat_id,
    v_arc.sector_id,
    --v_arc.macrosector_id,
    v_arc.dma_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    --v_arc.expl_id,
    valv_type,
    pressure,
    flow,
    coef_loss,
    curve_id,
    minorloss,
    to_arc,
    status,
	
    v_arc.the_geom
   FROM selector_sector,v_arc
   JOIN inp_virtualvalve USING (arc_id)
   WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  
  
DROP VIEW v_edit_inp_inlet;
CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    --n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    --n.expl_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
	
	
    n.the_geom
   FROM selector_sector,v_node n
   JOIN inp_inlet USING (node_id)
   WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
 
 
DROP VIEW v_edit_inp_connec;
CREATE OR REPLACE VIEW v_edit_inp_connec AS 
 SELECT connec.connec_id,
    connec.elevation,
    connec.depth,
    connec.connecat_id,
    connec.arc_id,
    connec.sector_id,
    connec.dma_id,
    connec.state,
    connec.state_type,
    --connec.expl_id,
    connec.pjoint_type,
    connec.pjoint_id,
    connec.annotation,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    --connec.epa_type
	
	
	connec.the_geom	
   FROM selector_sector,v_connec connec
   JOIN inp_connec USING (connec_id)
   WHERE connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  
*/