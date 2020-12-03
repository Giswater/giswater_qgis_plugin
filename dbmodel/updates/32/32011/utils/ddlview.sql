/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


 
CREATE OR REPLACE VIEW v_visit_lot_user_manager AS 
 SELECT om_visit_lot_x_user.id,
    om_visit_lot_x_user.user_id,
    om_visit_lot_x_user.team_id,
    om_visit_lot_x_user.lot_id,
    om_visit_lot_x_user.starttime,
    om_visit_lot_x_user.endtime
  FROM om_visit_lot_x_user
  WHERE om_visit_lot_x_user.user_id::name = "current_user"()
  ORDER BY om_visit_lot_x_user.id DESC
 LIMIT 1;
 
  
CREATE OR REPLACE VIEW ve_visit_arc_singlevent AS 
 SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    left (date_trunc('second', startdate)::text, 19)::timestamp as startdate,
    left (date_trunc('second', enddate)::text, 19)::timestamp as enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    om_visit_event.id AS event_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;
  
  
  
CREATE OR REPLACE VIEW ve_visit_connec_singlevent AS 
 SELECT om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    left (date_trunc('second', startdate)::text, 19)::timestamp as startdate,
    left (date_trunc('second', enddate)::text, 19)::timestamp as enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;
  
   
  
  
CREATE OR REPLACE VIEW ve_visit_node_singlevent AS 
 SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    left (date_trunc('second', startdate)::text, 19)::timestamp as startdate,
    left (date_trunc('second', enddate)::text, 19)::timestamp as enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;
  
   
  
CREATE OR REPLACE VIEW v_edit_dma AS 
 SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
    dma.pattern_id,
    dma.link,
    dma.minc,
    dma.maxc,
    dma.effc
   FROM selector_expl,
    dma
  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
