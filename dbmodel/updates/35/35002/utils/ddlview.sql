/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


set search_path = 'SCHEMA_NAME';

--2020/11/25

CREATE OR REPLACE VIEW v_plan_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector, plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma, v_plan_psector_x_arc.psector_id FROM (
        SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,v_plan_arc.*, plan_psector_x_arc.* FROM v_plan_arc JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text 
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id ORDER BY plan_psector_x_arc.psector_id) 
        v_plan_psector_x_arc GROUP BY v_plan_psector_x_arc.psector_id) a 
        ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma, v_plan_psector_x_node.psector_id FROM (
        SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid, v_plan_node.*, plan_psector_x_node.* FROM v_plan_node JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id ORDER BY plan_psector_x_node.psector_id
        ) v_plan_psector_x_node GROUP BY v_plan_psector_x_node.psector_id) b 
        ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma, v_plan_psector_x_other.psector_id FROM ( 
        SELECT plan_psector_x_other.id, plan_psector_x_other.psector_id,  plan_psector.psector_type, v_price_compost.id AS price_id, v_price_compost.descript, v_price_compost.price, plan_psector_x_other.measurement,
        (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget FROM plan_psector_x_other JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text 
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id ORDER BY plan_psector_x_other.psector_id
        ) v_plan_psector_x_other GROUP BY v_plan_psector_x_other.psector_id) c 
        ON c.psector_id = plan_psector.psector_id
     WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_ui_plan_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active
   FROM selector_expl,
    plan_psector
     JOIN exploitation USING (expl_id)
     LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
     LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
     LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE TRIGGER gw_trg_ui_plan_psector
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_ui_plan_psector
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_ui_plan_psector();




CREATE OR REPLACE VIEW v_plan_psector_all AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
    FROM selector_psector, plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma, v_plan_psector_x_arc.psector_id FROM (
        SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,v_plan_arc.*, plan_psector_x_arc.* FROM v_plan_arc JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text 
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id ORDER BY plan_psector_x_arc.psector_id) 
        v_plan_psector_x_arc GROUP BY v_plan_psector_x_arc.psector_id) a 
        ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma, v_plan_psector_x_node.psector_id FROM (
        SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid, v_plan_node.*, plan_psector_x_node.* FROM v_plan_node JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id ORDER BY plan_psector_x_node.psector_id
        ) v_plan_psector_x_node GROUP BY v_plan_psector_x_node.psector_id) b 
        ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma, v_plan_psector_x_other.psector_id FROM ( 
        SELECT plan_psector_x_other.id, plan_psector_x_other.psector_id,  plan_psector.psector_type, v_price_compost.id AS price_id, v_price_compost.descript, v_price_compost.price, plan_psector_x_other.measurement,
        (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget FROM plan_psector_x_other JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text 
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id ORDER BY plan_psector_x_other.psector_id
        ) v_plan_psector_x_other GROUP BY v_plan_psector_x_other.psector_id) c 
        ON c.psector_id = plan_psector.psector_id;




CREATE OR REPLACE VIEW v_edit_plan_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.ext_code,
    plan_psector.status,
    plan_psector.text3,
    plan_psector.text4,
    plan_psector.text5,
    plan_psector.text6,
    plan_psector.num_value
   FROM selector_expl,
    plan_psector
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE TRIGGER gw_trg_edit_psector
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_plan_psector
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_psector('plan');




CREATE OR REPLACE VIEW v_plan_current_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom
    FROM plan_psector
    JOIN selector_plan_psector ON plan_psector.psector_id = selector_plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma, v_plan_psector_x_arc.psector_id FROM (
        SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,v_plan_arc.*, plan_psector_x_arc.* FROM v_plan_arc JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text 
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id ORDER BY plan_psector_x_arc.psector_id) 
        v_plan_psector_x_arc GROUP BY v_plan_psector_x_arc.psector_id) a 
        ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma, v_plan_psector_x_node.psector_id FROM (
        SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid, v_plan_node.*, plan_psector_x_node.* FROM v_plan_node JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id ORDER BY plan_psector_x_node.psector_id
        ) v_plan_psector_x_node GROUP BY v_plan_psector_x_node.psector_id) b 
        ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma, v_plan_psector_x_other.psector_id FROM ( 
        SELECT plan_psector_x_other.id, plan_psector_x_other.psector_id,  plan_psector.psector_type, v_price_compost.id AS price_id, v_price_compost.descript, v_price_compost.price, plan_psector_x_other.measurement,
        (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget FROM plan_psector_x_other JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text 
        JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id ORDER BY plan_psector_x_other.psector_id
        ) v_plan_psector_x_other GROUP BY v_plan_psector_x_other.psector_id) c 
        ON c.psector_id = plan_psector.psector_id
    WHERE selector_plan_psector.cur_user = "current_user"()::text;

--2021/01/12
CREATE OR REPLACE VIEW v_edit_cad_auxpoint AS 
 SELECT temp_table.id,
    temp_table.geom_point
   FROM SCHEMA_NAME.temp_table
  WHERE temp_table.cur_user = "current_user"()::text AND temp_table.fid = 127;


 --2021/01/18  
DROP VIEW ve_visit_arc_singlevent;
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
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;
  
  
DROP VIEW ve_visit_connec_singlevent;
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
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;
  
   
  
DROP VIEW ve_visit_node_singlevent; 
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
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;


DROP VIEW v_ui_hydrometer;
CREATE OR REPLACE VIEW v_ui_hydrometer AS 
 SELECT v_rtc_hydrometer.hydrometer_id,
    v_rtc_hydrometer.connec_id,
    v_rtc_hydrometer.hydrometer_customer_code,
    v_rtc_hydrometer.connec_customer_code,
    v_rtc_hydrometer.state,
    v_rtc_hydrometer.expl_name,
    v_rtc_hydrometer.hydrometer_link
   FROM v_rtc_hydrometer;
