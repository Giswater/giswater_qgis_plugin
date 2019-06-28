/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE OR REPLACE VIEW v_state_connec AS 
(
         SELECT connec.connec_id::varchar(30), arc_id
           FROM selector_state,
            selector_expl,
            connec
          WHERE connec.state = selector_state.state_id AND connec.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
        EXCEPT
         SELECT plan_psector_x_connec.connec_id::varchar(30), plan_psector_x_connec.arc_id
           FROM selector_psector,
            selector_expl,
            plan_psector_x_connec
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
          WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
) UNION
 SELECT plan_psector_x_connec.connec_id::varchar(30), plan_psector_x_connec.arc_id
   FROM selector_psector,
    selector_expl,
    plan_psector_x_connec
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

  
  
CREATE OR REPLACE VIEW v_price_compost AS
SELECT price_compost.id,
   price_compost.unit,
   price_compost.descript,
       CASE
           WHEN price_compost.price IS NOT NULL THEN price_compost.price::numeric(14,2)
           ELSE  sum(a.price * price_compost_value.value)::numeric(14,2)
       END AS price
  FROM price_compost
    LEFT JOIN price_compost_value ON price_compost.id::text = price_compost_value.compost_id::text
    LEFT JOIN price_compost a ON a.id::text = price_compost_value.simple_id::text
 GROUP BY price_compost.id, price_compost.unit, price_compost.descript;
 
 --28/06/2019
 CREATE OR REPLACE VIEW v_ui_event_x_arc AS 
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    om_visit_parameter.parameter_type,
    om_visit_parameter.feature_type,
    om_visit_parameter.form_type,
    om_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
     LEFT JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;
  
  
CREATE OR REPLACE VIEW v_ui_event_x_connec AS 
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    om_visit_parameter.parameter_type,
    om_visit_parameter.feature_type,
    om_visit_parameter.form_type,
    om_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;
 
 
 CREATE OR REPLACE VIEW v_ui_event_x_node AS 
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    om_visit_parameter.parameter_type,
    om_visit_parameter.feature_type,
    om_visit_parameter.form_type,
    om_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
     LEFT JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_node.node_id;