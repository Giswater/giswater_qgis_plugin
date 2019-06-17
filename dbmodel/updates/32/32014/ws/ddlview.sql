DROP VIEW SCHEMA_NAME.v_edit_inp_pipe;
CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_pipe AS 
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
   FROM SCHEMA_NAME.inp_selector_sector,
    SCHEMA_NAME.arc
     JOIN SCHEMA_NAME.v_arc ON v_arc.arc_id::text = arc.arc_id::text
     JOIN SCHEMA_NAME.inp_pipe ON inp_pipe.arc_id::text = arc.arc_id::text
  WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_junction AS 
 SELECT DISTINCT ON (node_id) node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_junction.demand,
    inp_junction.pattern_id
   FROM SCHEMA_NAME.node
     JOIN SCHEMA_NAME.v_node ON v_node.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.inp_junction ON inp_junction.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.v_edit_inp_pipe a ON node_1=node.node_id
     JOIN SCHEMA_NAME.v_edit_inp_pipe b ON b.node_2=node.node_id;

   CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_pump AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status
   FROM SCHEMA_NAME.node
     JOIN SCHEMA_NAME.v_node ON v_node.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.inp_pump ON node.node_id::text = inp_pump.node_id::text
     JOIN SCHEMA_NAME.v_edit_inp_pipe a ON node_1=node.node_id
     JOIN SCHEMA_NAME.v_edit_inp_pipe b ON b.node_2=node.node_id;



CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_reservoir AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_reservoir.pattern_id
   FROM SCHEMA_NAME.node
     JOIN SCHEMA_NAME.v_node ON v_node.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.inp_reservoir ON inp_reservoir.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.v_edit_inp_pipe a ON node_1=node.node_id
     JOIN SCHEMA_NAME.v_edit_inp_pipe b ON b.node_2=node.node_id;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_shortpipe AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status
   FROM SCHEMA_NAME.node
     JOIN SCHEMA_NAME.v_node ON v_node.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.inp_shortpipe ON inp_shortpipe.node_id::text = node.node_id::text
   JOIN SCHEMA_NAME.v_edit_inp_pipe a ON node_1=node.node_id
     JOIN SCHEMA_NAME.v_edit_inp_pipe b ON b.node_2=node.node_id;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_tank AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM SCHEMA_NAME.node
     JOIN SCHEMA_NAME.v_node ON v_node.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.inp_tank ON inp_tank.node_id::text = node.node_id::text
   JOIN SCHEMA_NAME.v_edit_inp_pipe a ON node_1=node.node_id
     JOIN SCHEMA_NAME.v_edit_inp_pipe b ON b.node_2=node.node_id;

   
CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_valve AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status
   FROM SCHEMA_NAME.node
     JOIN SCHEMA_NAME.v_node ON v_node.node_id::text = node.node_id::text
     JOIN SCHEMA_NAME.inp_valve ON node.node_id::text = inp_valve.node_id::text
   JOIN SCHEMA_NAME.v_edit_inp_pipe a ON node_1=node.node_id
     JOIN SCHEMA_NAME.v_edit_inp_pipe b ON b.node_2=node.node_id;

 CREATE TRIGGER gw_trg_edit_inp_arc_pipe
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.v_edit_inp_pipe
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_inp_arc('inp_pipe');
     
