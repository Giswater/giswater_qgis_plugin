/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_ui_om_event AS 
 SELECT *     
   FROM om_visit_event;
 
create view v_ui_om_lot AS
select * FROM om_visit_lot;

create view v_ui_om_visit_x_doc
as 
SELECT * FROM doc_x_visit;

CREATE OR REPLACE VIEW ve_lot_x_arc AS 
 SELECT arc.arc_id,
    om_visit_lot_x_arc.lot_id,
    status,
    the_geom
    FROM selector_lot, om_visit_lot
     JOIN om_visit_lot_x_arc ON lot_id=id
     JOIN arc ON arc.arc_id=om_visit_lot_x_arc.arc_id
     WHERE selector_lot.lot_id = om_visit_lot.id AND cur_user=current_user;

CREATE OR REPLACE VIEW ve_visit_arc_insp AS 
 SELECT 
    om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    a.param_1 AS sediments_arc,
    a.param_2 AS desperfectes_arc,
    a.param_3 AS neteja_arc
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
			JOIN om_visit_class on om_visit_class.id=om_visit.class_id
			JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
			where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_arc''),(''desperfectes_arc''),(''neteja_arc'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;


CREATE OR REPLACE VIEW ve_visit_node_insp AS 
 SELECT 
    om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    a.param_1 AS sediments_node,
    a.param_2 AS desperfectes_node,
    a.param_3 AS neteja_node
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
			JOIN om_visit_class on om_visit_class.id=om_visit.class_id
			JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
			where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_node''),(''desperfectes_node''),(''neteja_node'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;


CREATE OR REPLACE VIEW ve_visit_connec_insp AS 
 SELECT 
    om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
    a.param_1 AS sediments_connec,
    a.param_2 AS desperfectes_connec,
    a.param_3 AS neteja_connec
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
			JOIN om_visit_class on om_visit_class.id=om_visit.class_id
			JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
			where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_connec''),(''desperfectes_connec''),(''neteja_connec'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;



CREATE OR REPLACE VIEW ve_visit_singlevent_x_arc AS 
 SELECT 
    om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
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



CREATE OR REPLACE VIEW ve_visit_singlevent_x_connec AS 
 SELECT 
    om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
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
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;


CREATE OR REPLACE VIEW ve_visit_singlevent_x_node AS 
 SELECT 
    om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.suspendendcat_id,
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
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
  WHERE om_visit_class.ismultievent = false;