/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-----------------------
-- remove all the views that are refactored in the v3.2
----------------------- 
/*
DROP VIEW IF EXISTS v_ui_doc_x_connec;
DROP VIEW IF EXISTS v_ui_doc_x_arc;
DROP VIEW IF EXISTS v_ui_doc_x_node;
DROP VIEW IF EXISTS v_ui_document;

DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_elemenst_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS v_ui_element_x_gully;
DROP VIEW IF EXISTS v_ui_element;

DROP VIEW IF EXISTS v_ui_om_visit;
DROP VIEW IF EXISTS v_ui_om_visit_x_connec;
DROP VIEW IF EXISTS v_ui_om_visit_x_arc;
DROP VIEW IF EXISTS v_ui_om_visit_x_node;
DROP VIEW IF EXISTS v_ui_om_visit_x_gully;

DROP VIEW IF EXISTS v_ui_om_event_x_connec;
DROP VIEW IF EXISTS v_ui_om_event_x_arc;
DROP VIEW IF EXISTS v_ui_om_event_x_node;
DROP VIEW IF EXISTS v_ui_om_event_x_gully;

DROP VIEW IF EXISTS v_ui_om_visitman_x_node;
DROP VIEW IF EXISTS v_ui_om_visitman_x_arc;
DROP VIEW IF EXISTS v_ui_om_visitman_x_connec;
DROP VIEW IF EXISTS v_ui_om_visitman_x_gully;

DROP VIEW IF EXISTS v_ui_scada_x_node;
DROP VIEW IF EXISTS v_ui_scada_x_node_values;
DROP VIEW IF EXISTS v_ui_arc_x_node;
DROP VIEW IF EXISTS v_ui_rpt_cat_result;
DROP VIEW IF EXISTS v_ui_anl_result_cat;


DROP VIEW IF EXISTS v_anl_mincut_init_point;
DROP VIEW IF EXISTS v_anl_mincut_planified_arc;
DROP VIEW IF EXISTS v_anl_mincut_planified_valve;
DROP VIEW IF EXISTS v_anl_mincut_result_audit;
DROP VIEW IF EXISTS v_anl_mincut_result_conflict_arc;
DROP VIEW IF EXISTS v_anl_mincut_result_conflict_valve;

DROP VIEW IF EXISTS v_edit_cad_auxcircle;
DROP VIEW IF EXISTS v_edit_cad_auxpoint;
DROP VIEW IF EXISTS v_edit_dimensions;
DROP VIEW IF EXISTS v_edit_field_valve;
DROP VIEW IF EXISTS v_edit_om_psector;
DROP VIEW IF EXISTS v_edit_om_psector_x_other;
DROP VIEW IF EXISTS v_edit_plan_psector;
DROP VIEW IF EXISTS v_edit_plan_psector_x_other;
DROP VIEW IF EXISTS v_edit_rtc_hydro_data_x_connec;

DROP VIEW IF EXISTS v_plan_aux_arc_pavement;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_arc;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node_period;
DROP VIEW IF EXISTS v_ui_workcat_polygon_all;

DROP VIEW IF EXISTS vu_arc;
DROP VIEW IF EXISTS vu_connec;
DROP VIEW IF EXISTS vu_node;

DROP VIEW IF EXISTS v_edit_element;
*/



-----------------------
-- create views
-----------------------

--cad view
DROP VIEW IF EXISTS ve_cad_auxcircle;
CREATE OR REPLACE VIEW ve_cad_auxcircle AS 
 SELECT temp_table.id,
    temp_table.geom_polygon
   FROM temp_table
  WHERE temp_table.user_name = "current_user"()::text AND temp_table.fprocesscat_id = 28;

DROP VIEW IF EXISTS ve_cad_auxpoint;
CREATE OR REPLACE VIEW ve_cad_auxpoint AS 
 SELECT temp_table.id,
    temp_table.geom_point
   FROM temp_table
  WHERE temp_table.user_name = "current_user"()::text AND temp_table.fprocesscat_id = 27;


DROP VIEW IF EXISTS ve_dimensions;
CREATE OR REPLACE VIEW ve_dimensions AS 
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
    dimensions.expl_id
   FROM selector_expl,
    dimensions
     JOIN v_state_dimensions ON dimensions.id = v_state_dimensions.id
  WHERE dimensions.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

--element view
DROP VIEW IF EXISTS ve_element;
CREATE OR REPLACE VIEW ve_element AS 
 SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id
   FROM selector_expl,
    element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

--om_psector
DROP VIEW IF EXISTS  ve_om_psector;
CREATE OR REPLACE VIEW ve_om_psector AS 
 SELECT om_psector.psector_id,
    om_psector.name,
    om_psector.result_id,
    om_psector.descript,
    om_psector.priority,
    om_psector.text1,
    om_psector.text2,
    om_psector.observ,
    om_psector.rotation,
    om_psector.scale,
    om_psector.sector_id,
    om_psector.atlas_id,
    om_psector.gexpenses,
    om_psector.vat,
    om_psector.other,
    om_psector.the_geom,
    om_psector.expl_id,
    om_psector.psector_type,
    om_psector.active
   FROM selector_expl,
    om_psector
  WHERE om_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS ve_om_psector_x_other;
CREATE OR REPLACE VIEW ve_om_psector_x_other AS 
 SELECT om_psector_x_other.id,
    om_psector_x_other.psector_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript AS price_descript,
    v_price_compost.price,
    om_psector_x_other.measurement,
    (om_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget,
    om_psector_x_other.descript,
    om_psector.atlas_id
   FROM om_psector_x_other
     JOIN v_price_compost ON v_price_compost.id::text = om_psector_x_other.price_id::text
     JOIN om_psector ON om_psector.psector_id = om_psector_x_other.psector_id
  ORDER BY om_psector_x_other.psector_id;


--plan_psector
DROP VIEW IF EXISTS ve_plan_psector;
CREATE OR REPLACE VIEW ve_plan_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.sector_id,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active
   FROM selector_expl,
    plan_psector
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_plan_psector_x_other;
CREATE OR REPLACE VIEW ve_plan_psector_x_other AS 
 SELECT plan_psector_x_other.id,
    plan_psector_x_other.psector_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript AS price_descript,
    v_price_compost.price,
    plan_psector_x_other.measurement,
    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget,
    plan_psector_x_other.descript,
    plan_psector.atlas_id
   FROM plan_psector_x_other
     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id
  ORDER BY plan_psector_x_other.psector_id;


--rtc
DROP VIEW IF EXISTS ve_rtc_hydro_data_x_connec;
CREATE OR REPLACE VIEW ve_rtc_hydro_data_x_connec AS 
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.cat_hydrometer_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.hydrometer_id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.cat_hydrometer_id
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text;


DROP VIEW IF EXISTS ve_ui_hydroval_x_connec;
CREATE OR REPLACE VIEW ve_ui_hydroval_x_connec AS 
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.cat_hydrometer_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.hydrometer_id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.cat_hydrometer_id
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
  ORDER BY ext_rtc_hydrometer_x_data.id;

--doc
DROP VIEW IF EXISTS ve_ui_doc;
CREATE OR REPLACE VIEW ve_ui_doc AS 
 SELECT doc.id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;

DROP VIEW IF EXISTS ve_ui_doc_x_arc;
CREATE OR REPLACE VIEW ve_ui_doc_x_arc AS 
 SELECT doc_x_arc.id,
    doc_x_arc.arc_id,
    doc_x_arc.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;


DROP VIEW IF EXISTS ve_ui_doc_x_connec;
CREATE OR REPLACE VIEW ve_ui_doc_x_connec AS 
 SELECT doc_x_connec.id,
    doc_x_connec.connec_id,
    doc_x_connec.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;


DROP VIEW IF EXISTS ve_ui_doc_x_node;
CREATE OR REPLACE VIEW ve_ui_doc_x_node AS 
 SELECT doc_x_node.id,
    doc_x_node.node_id,
    doc_x_node.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;


DROP VIEW IF EXISTS ve_ui_doc_x_psector;
CREATE OR REPLACE VIEW ve_ui_doc_x_psector AS 
 SELECT doc_x_psector.id,
    doc_x_psector.psector_id,
    doc_x_psector.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_psector
     JOIN doc ON doc.id::text = doc_x_psector.doc_id::text;

DROP VIEW IF EXISTS ve_ui_doc_x_visit;
CREATE OR REPLACE VIEW ve_ui_doc_x_visit AS 
 SELECT doc_x_visit.id,
    doc_x_visit.visit_id,
    doc_x_visit.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;



--element
DROP VIEW IF EXISTS ve_ui_element;
CREATE OR REPLACE VIEW ve_ui_element AS 
 SELECT element.element_id AS id,
    element.code,
    element.elementcat_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


DROP VIEW IF EXISTS ve_ui_element_x_arc;
CREATE OR REPLACE VIEW ve_ui_element_x_arc AS 
 SELECT element_x_arc.id,
    element_x_arc.arc_id,
    element_x_arc.element_id,
    element.elementcat_id,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_arc
     JOIN element ON element.element_id::text = element_x_arc.element_id::text
  WHERE element.state = 1;


DROP VIEW IF EXISTS ve_ui_element_x_connec;
CREATE OR REPLACE VIEW ve_ui_element_x_connec AS 
 SELECT element_x_connec.id,
    element_x_connec.connec_id,
    element_x_connec.element_id,
    element.elementcat_id,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_connec
     JOIN element ON element.element_id::text = element_x_connec.element_id::text
  WHERE element.state = 1;


DROP VIEW IF EXISTS ve_ui_element_x_node;
CREATE OR REPLACE VIEW ve_ui_element_x_node AS 
 SELECT element_x_node.id,
    element_x_node.node_id,
    element_x_node.element_id,
    element.elementcat_id,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory
   FROM element_x_node
     JOIN element ON element.element_id::text = element_x_node.element_id::text
  WHERE element.state = 1;


--event
DROP VIEW IF EXISTS ve_ui_event;
CREATE OR REPLACE VIEW ve_ui_event AS 
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name AS visitcat_name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
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
     LEFT JOIN om_visit_cat ON om_visit_cat.id = om_visit.visitcat_id
     LEFT JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit.id;

DROP VIEW IF EXISTS ve_ui_event_x_arc;
 CREATE OR REPLACE VIEW ve_ui_event_x_arc AS 
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


DROP VIEW IF EXISTS ve_ui_event_x_connec;
CREATE OR REPLACE VIEW ve_ui_event_x_connec AS 
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


DROP VIEW IF EXISTS ve_ui_event_x_node;
CREATE OR REPLACE VIEW ve_ui_event_x_node AS 
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


--visits
DROP VIEW IF EXISTS ve_ui_visit;
CREATE OR REPLACE VIEW ve_ui_visit AS 
 SELECT om_visit.id,
    om_visit_cat.name AS visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name AS exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done
   FROM om_visit
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
     LEFT JOIN exploitation ON exploitation.expl_id = om_visit.expl_id;



CREATE OR REPLACE VIEW ve_ui_visit_x_arc AS 
 SELECT DISTINCT ON (ve_ui_event_x_arc.visit_id) ve_ui_event_x_arc.visit_id,
    ve_ui_event_x_arc.code,
    om_visit_cat.name AS visitcat_name,
    ve_ui_event_x_arc.arc_id,
    date_trunc('second'::text, ve_ui_event_x_arc.visit_start) AS visit_start,
    date_trunc('second'::text, ve_ui_event_x_arc.visit_end) AS visit_end,
    ve_ui_event_x_arc.user_name,
    ve_ui_event_x_arc.is_done,
    ve_ui_event_x_arc.feature_type,
    ve_ui_event_x_arc.form_type
   FROM ve_ui_event_x_arc
     JOIN om_visit_cat ON om_visit_cat.id = ve_ui_event_x_arc.visitcat_id;


CREATE OR REPLACE VIEW ve_ui_visit_x_connec AS 
 SELECT DISTINCT ON (ve_ui_event_x_connec.visit_id) ve_ui_event_x_connec.visit_id,
    ve_ui_event_x_connec.code,
    om_visit_cat.name AS visitcat_name,
    ve_ui_event_x_connec.connec_id,
    date_trunc('second'::text, ve_ui_event_x_connec.visit_start) AS visit_start,
    date_trunc('second'::text, ve_ui_event_x_connec.visit_end) AS visit_end,
    ve_ui_event_x_connec.user_name,
    ve_ui_event_x_connec.is_done,
    ve_ui_event_x_connec.feature_type,
    ve_ui_event_x_connec.form_type
   FROM ve_ui_event_x_connec
     JOIN om_visit_cat ON om_visit_cat.id = ve_ui_event_x_connec.visitcat_id;

CREATE OR REPLACE VIEW ve_ui_visit_x_node AS 
 SELECT DISTINCT ON (ve_ui_event_x_node.visit_id) ve_ui_event_x_node.visit_id,
    ve_ui_event_x_node.code,
    om_visit_cat.name AS visitcat_name,
    ve_ui_event_x_node.node_id,
    date_trunc('second'::text, ve_ui_event_x_node.visit_start) AS visit_start,
    date_trunc('second'::text, ve_ui_event_x_node.visit_end) AS visit_end,
    ve_ui_event_x_node.user_name,
    ve_ui_event_x_node.is_done,
    ve_ui_event_x_node.feature_type,
    ve_ui_event_x_node.form_type
   FROM ve_ui_event_x_node
     JOIN om_visit_cat ON om_visit_cat.id = ve_ui_event_x_node.visitcat_id;

--multievent
DROP VIEW IF EXISTS ve_visit_multievent_x_arc;
CREATE OR REPLACE VIEW ve_visit_multievent_x_arc AS 
 SELECT om_visit_x_arc.id,
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
    a.param_1 AS sendiments_arc,
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
      where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sendiments_arc''),(''desperfectes_arc''),(''neteja_arc'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;


DROP VIEW IF EXISTS ve_visit_multievent_x_connec;
CREATE OR REPLACE VIEW ve_visit_multievent_x_connec AS 
 SELECT om_visit_x_connec.id,
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


DROP VIEW IF EXISTS ve_visit_multievent_x_node;
CREATE OR REPLACE VIEW ve_visit_multievent_x_node AS 
 SELECT om_visit_x_node.id,
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
    a.param_1 AS sendiments_node,
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
      where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sendiments_node''),(''desperfectes_node''),(''neteja_node'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;

--singlevent
DROP VIEW IF EXISTS ve_visit_singlevent_x_arc;
CREATE OR REPLACE VIEW ve_visit_singlevent_x_arc AS 
 SELECT om_visit_x_arc.id,
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


DROP VIEW IF EXISTS ve_visit_singlevent_x_connec;
CREATE OR REPLACE VIEW ve_visit_singlevent_x_connec AS 
 SELECT om_visit_x_connec.id,
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


DROP VIEW IF EXISTS ve_visit_singlevent_x_node;
CREATE OR REPLACE VIEW ve_visit_singlevent_x_node AS 
 SELECT om_visit_x_node.id,
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



-----------------------
-- plan edit views
-----------------------

DROP VIEW IF EXISTS v_ui_plan_node_cost;
CREATE OR REPLACE VIEW v_ui_plan_node_cost AS 
 SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost
   FROM node
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
     JOIN v_plan_node ON node.node_id::text = v_plan_node.node_id::text;



-----------------------
-- rpt edit views
-----------------------
DROP VIEW IF EXISTS  "ve_ui_rpt_result_cat" CASCADE;
CREATE VIEW "ve_ui_rpt_result_cat" AS 
SELECT *
FROM rpt_cat_result