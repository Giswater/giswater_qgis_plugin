/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;


CREATE OR REPLACE VIEW ud.ve_visit_arc_singlevent
AS SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
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


CREATE OR REPLACE VIEW ud.ve_visit_connec_singlevent
AS SELECT om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
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


CREATE OR REPLACE VIEW ud.ve_visit_connexio_neteja
AS SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
    gully.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    gully.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.unit_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_0 AS tram_exec_visit,
    e.idval AS tram_exec_visit_v,
    a.param_1 AS tram_netejat,
    p.idval AS tram_netejat_v,
    a.param_2 AS tram_kg,
    a.param_3 AS tram_cm_sedim,
    a.param_4 AS tram_res_sabo,
    a.param_5 AS tram_res_oli,
    a.param_6 AS tram_res_greix,
    a.param_7 AS tram_res_sorra,
    a.param_8 AS tram_res_brossa,
    a.param_9 AS tram_res_nivell,
    n.idval AS tram_res_nivell_v,
    a.param_10 AS tram_incident,
    i.idval AS tram_incident_v,
    a.param_11 AS tram_inacces,
    c.idval AS tram_inacces_v,
    a.param_12 AS tram_observ,
    a.param_13 AS num_elem_visit,
    a.param_14 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN gully USING (gully_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_0,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5,
            ct.param_6,
            ct.param_7,
            ct.param_8,
            ct.param_9,
            ct.param_10,
            ct.param_11,
            ct.param_12,
            ct.param_13,
            ct.param_14
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE and om_visit.class_id = 17 ORDER  BY 1,2'::text, ' VALUES (''tram_exec_visit''), (''tram_netejat''),(''tram_kg''),(''tram_cm_sedim''),(''tram_res_sabo''),
			(''tram_res_oli''),(''tram_res_greix''),(''tram_res_sorra''),(''tram_res_brossa''),(''tram_res_nivell''),(''tram_incident''),(''tram_inacces''),(''tram_observ''),(''num_elem_visit''),(''photo'')'::text) ct(visit_id integer, param_0 text, param_1 text, param_2 numeric, param_3 text, param_4 boolean, param_5 boolean, param_6 boolean, param_7 boolean, param_8 boolean, param_9 text, param_10 text, param_11 text, param_12 text, param_13 text, param_14 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue e ON e.id::text = a.param_0 AND e.typevalue = 'exec_x_visit'::text
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'emb_clean'::text
     LEFT JOIN om_typevalue n ON n.id::text = a.param_9 AND n.typevalue = 'tram_res_level'::text
     LEFT JOIN om_typevalue i ON i.id::text = a.param_10 AND i.typevalue = 'tram_x_incidence'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_11 AND c.typevalue = 'tram_x_inacces_conn'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 17;


CREATE OR REPLACE VIEW ud.ve_visit_emb_incidencia
AS SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
    gully.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    gully.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS emb_incid_tip,
    p.idval AS emb_incid_tip_v,
    a.param_2 AS emb_incid_grau_urgent,
    g.idval AS emb_incid_grau_urgent_v,
    a.param_3 AS emb_incid_obs,
    a.param_4 AS emb_incid_status,
    i.idval AS emb_incid_status_v,
    a.param_5 AS photo,
    NULL::text AS incid_real_status
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN gully USING (gully_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE and om_visit.class_id = 11 ORDER  BY 1,2'::text, ' VALUES (''emb_incid_tip''),(''emb_incid_grau_urgent''),(''emb_incid_obs''),(''emb_incid_status''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 text, param_5 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'emb_incid_tip'::text
     LEFT JOIN om_typevalue g ON g.id::text = a.param_2 AND g.typevalue = 'emb_incid_grau_urgent'::text
     LEFT JOIN om_typevalue i ON i.id::text = a.param_4 AND i.typevalue = 'incidencia_status'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 11;


CREATE OR REPLACE VIEW ud.ve_visit_emb_incidencia_filter
AS SELECT ve_visit_emb_incidencia.visit_id,
    ve_visit_emb_incidencia.gully_id,
    ve_visit_emb_incidencia.visitcat_id,
    ve_visit_emb_incidencia.ext_code,
    gully.code,
    gully.gully_type,
    gully.state,
    ve_visit_emb_incidencia.startdate,
    ve_visit_emb_incidencia.enddate,
    ve_visit_emb_incidencia.user_name,
    ve_visit_emb_incidencia.webclient_id,
    ve_visit_emb_incidencia.expl_id,
    ve_visit_emb_incidencia.descript,
    ve_visit_emb_incidencia.is_done,
    ve_visit_emb_incidencia.the_geom,
    ve_visit_emb_incidencia.class_id,
    ve_visit_emb_incidencia.class_name,
    ve_visit_emb_incidencia.status,
    ve_visit_emb_incidencia.status_name,
    ve_visit_emb_incidencia.emb_incid_tip,
    ve_visit_emb_incidencia.emb_incid_tip_v,
    ve_visit_emb_incidencia.emb_incid_grau_urgent,
    ve_visit_emb_incidencia.emb_incid_grau_urgent_v,
    ve_visit_emb_incidencia.emb_incid_obs,
    ve_visit_emb_incidencia.emb_incid_status,
    ve_visit_emb_incidencia.photo
   FROM selector_date,
    ve_visit_emb_incidencia
     JOIN gully ON gully.gully_id::text = ve_visit_emb_incidencia.gully_id::text
  WHERE "overlaps"(ve_visit_emb_incidencia.startdate, ve_visit_emb_incidencia.startdate, selector_date.from_date::timestamp without time zone, selector_date.to_date::timestamp without time zone) AND selector_date.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ud.ve_visit_emb_neteja
AS SELECT vm_visit_emb_neteja.visit_id,
    vm_visit_emb_neteja.gully_id,
    vm_visit_emb_neteja.code,
    vm_visit_emb_neteja.gully_type,
    vm_visit_emb_neteja.visitcat_id,
    vm_visit_emb_neteja.ext_code,
    vm_visit_emb_neteja.startdate,
    vm_visit_emb_neteja.enddate,
    vm_visit_emb_neteja.user_name,
    vm_visit_emb_neteja.webclient_id,
    vm_visit_emb_neteja.expl_id,
    vm_visit_emb_neteja.the_geom,
    vm_visit_emb_neteja.descript,
    vm_visit_emb_neteja.is_done,
    vm_visit_emb_neteja.class_id,
    vm_visit_emb_neteja.class_name,
    vm_visit_emb_neteja.lot_id,
    vm_visit_emb_neteja.status,
    vm_visit_emb_neteja.status_name,
    vm_visit_emb_neteja.emb_netejat,
    vm_visit_emb_neteja.emb_netejat_v,
    vm_visit_emb_neteja.emb_res_nivell,
    vm_visit_emb_neteja.emb_res_nivell_v,
    vm_visit_emb_neteja.emb_res_organic,
    vm_visit_emb_neteja.emb_res_ciment,
    vm_visit_emb_neteja.emb_res_sorra,
    vm_visit_emb_neteja.emb_res_quimics,
    vm_visit_emb_neteja.emb_mosquits,
    vm_visit_emb_neteja.emb_rates,
    vm_visit_emb_neteja.emb_paneroles,
    vm_visit_emb_neteja.emb_incident,
    vm_visit_emb_neteja.emb_incident_v,
    vm_visit_emb_neteja.emb_observ,
    vm_visit_emb_neteja.photo
   FROM vm_visit_emb_neteja
UNION
 SELECT ve_visit_emb_neteja_aux.visit_id,
    ve_visit_emb_neteja_aux.gully_id,
    ve_visit_emb_neteja_aux.code,
    ve_visit_emb_neteja_aux.gully_type,
    ve_visit_emb_neteja_aux.visitcat_id,
    ve_visit_emb_neteja_aux.ext_code,
    ve_visit_emb_neteja_aux.startdate,
    ve_visit_emb_neteja_aux.enddate,
    ve_visit_emb_neteja_aux.user_name,
    ve_visit_emb_neteja_aux.webclient_id,
    ve_visit_emb_neteja_aux.expl_id,
    ve_visit_emb_neteja_aux.the_geom,
    ve_visit_emb_neteja_aux.descript,
    ve_visit_emb_neteja_aux.is_done,
    ve_visit_emb_neteja_aux.class_id,
    ve_visit_emb_neteja_aux.class_name,
    ve_visit_emb_neteja_aux.lot_id,
    ve_visit_emb_neteja_aux.status,
    ve_visit_emb_neteja_aux.status_name,
    ve_visit_emb_neteja_aux.emb_netejat,
    ve_visit_emb_neteja_aux.emb_netejat_v,
    ve_visit_emb_neteja_aux.emb_res_nivell,
    ve_visit_emb_neteja_aux.emb_res_nivell_v,
    ve_visit_emb_neteja_aux.emb_res_organic,
    ve_visit_emb_neteja_aux.emb_res_ciment,
    ve_visit_emb_neteja_aux.emb_res_sorra,
    ve_visit_emb_neteja_aux.emb_res_quimics,
    ve_visit_emb_neteja_aux.emb_mosquits,
    ve_visit_emb_neteja_aux.emb_rates,
    ve_visit_emb_neteja_aux.emb_paneroles,
    ve_visit_emb_neteja_aux.emb_incident,
    ve_visit_emb_neteja_aux.emb_incident_v,
    ve_visit_emb_neteja_aux.emb_observ,
    ve_visit_emb_neteja_aux.photo
   FROM ve_visit_emb_neteja_aux;


CREATE OR REPLACE VIEW ud.ve_visit_emb_neteja_aux
AS SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
    gully.code,
    gully.gully_type,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    gully.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS emb_netejat,
    p.idval AS emb_netejat_v,
    a.param_2 AS emb_res_nivell,
    t.idval AS emb_res_nivell_v,
    a.param_3 AS emb_res_organic,
    a.param_4 AS emb_res_ciment,
    a.param_5 AS emb_res_sorra,
    a.param_6 AS emb_res_quimics,
    a.param_10 AS emb_mosquits,
    a.param_11 AS emb_rates,
    a.param_12 AS emb_paneroles,
    a.param_7 AS emb_incident,
    y.idval AS emb_incident_v,
    a.param_8 AS emb_observ,
    a.param_9 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5,
            ct.param_6,
            ct.param_7,
            ct.param_8,
            ct.param_9,
            ct.param_10,
            ct.param_11,
            ct.param_12
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=10 AND startdate >= date(now()) - ''60 day''::interval ORDER BY 1,2'::text, ' VALUES (''emb_netejat''),(''emb_res_nivell''),(''emb_res_organic''),(''emb_res_ciment''),(''emb_res_sorra''),(''emb_res_quimics''),
			(''emb_incident''),(''emb_observ''),(''photo''),(''emb_mosquits''),(''emb_rates''),(''emb_paneroles'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 boolean, param_4 boolean, param_5 boolean, param_6 boolean, param_7 text, param_8 text, param_9 boolean, param_10 boolean, param_11 boolean, param_12 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue t ON t.id::text = a.param_2 AND t.typevalue = 'emb_res_level'::text
     LEFT JOIN om_typevalue y ON y.id::text = a.param_7 AND y.typevalue = 'emb_x_incidence'::text
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'emb_clean'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 10 AND om_visit.startdate >= (date(now()) - '60 days'::interval);


CREATE OR REPLACE VIEW ud.ve_visit_emb_neteja_filter
AS SELECT ve_visit_emb_neteja.visit_id,
    ve_visit_emb_neteja.gully_id,
    gully.code,
    gully.gully_type,
    ve_visit_emb_neteja.startdate,
    ve_visit_emb_neteja.user_name,
    ve_visit_emb_neteja.the_geom,
    ve_visit_emb_neteja.class_name,
    ve_visit_emb_neteja.lot_id,
    ve_visit_emb_neteja.status_name,
    ve_visit_emb_neteja.emb_netejat_v,
    ve_visit_emb_neteja.emb_res_nivell_v,
    ve_visit_emb_neteja.emb_res_organic,
    ve_visit_emb_neteja.emb_res_ciment,
    ve_visit_emb_neteja.emb_res_sorra,
    ve_visit_emb_neteja.emb_res_quimics,
    ve_visit_emb_neteja.emb_mosquits,
    ve_visit_emb_neteja.emb_rates,
    ve_visit_emb_neteja.emb_paneroles,
    ve_visit_emb_neteja.emb_incident_v,
    ve_visit_emb_neteja.emb_observ
   FROM selector_lot,
    selector_date,
    ve_visit_emb_neteja
     JOIN gully ON gully.gully_id::text = ve_visit_emb_neteja.gully_id::text
  WHERE "overlaps"(ve_visit_emb_neteja.startdate, ve_visit_emb_neteja.startdate, selector_date.from_date::timestamp without time zone, selector_date.to_date::timestamp without time zone) AND selector_date.cur_user = "current_user"()::text AND ve_visit_emb_neteja.lot_id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ud.ve_visit_emb_neteja_filter_data
AS SELECT ve_visit_emb_neteja.visit_id,
    ve_visit_emb_neteja.gully_id,
    gully.code,
    gully.gully_type,
    ve_visit_emb_neteja.startdate,
    ve_visit_emb_neteja.user_name,
    ve_visit_emb_neteja.the_geom,
    ve_visit_emb_neteja.class_name,
    ve_visit_emb_neteja.lot_id,
    ve_visit_emb_neteja.status_name,
    ve_visit_emb_neteja.emb_netejat_v,
    ve_visit_emb_neteja.emb_res_nivell_v,
    ve_visit_emb_neteja.emb_res_organic,
    ve_visit_emb_neteja.emb_res_ciment,
    ve_visit_emb_neteja.emb_res_sorra,
    ve_visit_emb_neteja.emb_res_quimics,
    ve_visit_emb_neteja.emb_mosquits,
    ve_visit_emb_neteja.emb_rates,
    ve_visit_emb_neteja.emb_paneroles,
    ve_visit_emb_neteja.emb_incident_v,
    ve_visit_emb_neteja.emb_observ
   FROM selector_date,
    ve_visit_emb_neteja
     JOIN gully ON gully.gully_id::text = ve_visit_emb_neteja.gully_id::text
  WHERE ve_visit_emb_neteja.startdate > selector_date.from_date::timestamp without time zone AND ve_visit_emb_neteja.startdate < (selector_date.to_date::timestamp without time zone + '1 day'::interval) AND selector_date.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ud.ve_visit_emb_neteja_filter_lot
AS SELECT ve_visit_emb_neteja.visit_id,
    ve_visit_emb_neteja.gully_id,
    gully.code,
    gully.gully_type,
    ve_visit_emb_neteja.startdate,
    ve_visit_emb_neteja.user_name,
    ve_visit_emb_neteja.the_geom,
    ve_visit_emb_neteja.class_name,
    ve_visit_emb_neteja.lot_id,
    ve_visit_emb_neteja.status_name,
    ve_visit_emb_neteja.emb_netejat_v,
    ve_visit_emb_neteja.emb_res_nivell_v,
    ve_visit_emb_neteja.emb_res_organic,
    ve_visit_emb_neteja.emb_res_ciment,
    ve_visit_emb_neteja.emb_res_sorra,
    ve_visit_emb_neteja.emb_res_quimics,
    ve_visit_emb_neteja.emb_mosquits,
    ve_visit_emb_neteja.emb_rates,
    ve_visit_emb_neteja.emb_paneroles,
    ve_visit_emb_neteja.emb_incident_v,
    ve_visit_emb_neteja.emb_observ
   FROM selector_lot,
    ve_visit_emb_neteja
     JOIN gully ON gully.gully_id::text = ve_visit_emb_neteja.gully_id::text
  WHERE ve_visit_emb_neteja.lot_id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;
AS SELECT ve_visit_emb_neteja.visit_id,
    ve_visit_emb_neteja.gully_id,
    gully.code,
    gully.gully_type,
    ve_visit_emb_neteja.startdate,
    ve_visit_emb_neteja.user_name,
    ve_visit_emb_neteja.the_geom,
    ve_visit_emb_neteja.class_name,
    ve_visit_emb_neteja.lot_id,
    ve_visit_emb_neteja.status_name,
    ve_visit_emb_neteja.emb_netejat_v,
    ve_visit_emb_neteja.emb_res_nivell_v,
    ve_visit_emb_neteja.emb_res_organic,
    ve_visit_emb_neteja.emb_res_ciment,
    ve_visit_emb_neteja.emb_res_sorra,
    ve_visit_emb_neteja.emb_res_quimics,
    ve_visit_emb_neteja.emb_mosquits,
    ve_visit_emb_neteja.emb_rates,
    ve_visit_emb_neteja.emb_paneroles,
    ve_visit_emb_neteja.emb_incident_v,
    ve_visit_emb_neteja.emb_observ
   FROM selector_lot,
    ve_visit_emb_neteja
     JOIN gully ON gully.gully_id::text = ve_visit_emb_neteja.gully_id::text
  WHERE ve_visit_emb_neteja.lot_id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ud.ve_visit_gully_singlevent
AS SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
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
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;


CREATE OR REPLACE VIEW ud.ve_visit_incidencia
AS SELECT om_visit.id AS visit_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS incidencia,
    p.idval AS incidencia_v,
    a.param_2 AS observacions,
    a.param_3 AS incidencia_status
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE and om_visit.class_id = 12 ORDER  BY 1,2'::text, ' VALUES (''incidencia''),(''observacions''),(''incidencia_status'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'incidencia'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 12;

  -- ud.ve_visit_incidencia_filter source

CREATE OR REPLACE VIEW ud.ve_visit_incidencia_filter
AS SELECT ve_visit_incidencia.visit_id,
    ve_visit_incidencia.visitcat_id,
    ve_visit_incidencia.ext_code,
    ve_visit_incidencia.startdate,
    ve_visit_incidencia.enddate,
    ve_visit_incidencia.user_name,
    ve_visit_incidencia.webclient_id,
    ve_visit_incidencia.expl_id,
    ve_visit_incidencia.descript,
    ve_visit_incidencia.is_done,
    ve_visit_incidencia.the_geom,
    ve_visit_incidencia.class_id,
    ve_visit_incidencia.class_name,
    ve_visit_incidencia.lot_id,
    ve_visit_incidencia.status,
    ve_visit_incidencia.status_name,
    ve_visit_incidencia.incidencia,
    ve_visit_incidencia.incidencia_v,
    ve_visit_incidencia.observacions,
    ve_visit_incidencia.incidencia_status
   FROM selector_date,
    ve_visit_incidencia
  WHERE "overlaps"(ve_visit_incidencia.startdate, ve_visit_incidencia.startdate, selector_date.from_date::timestamp without time zone, selector_date.to_date::timestamp without time zone) AND selector_date.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ud.ve_visit_node_incidencia
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS node_incid_tip,
    p.idval AS node_incid_tip_v,
    a.param_5 AS node_incid_grau_urgent,
    g.idval AS node_incid_grau_urgent_v,
    a.param_2 AS node_incid_obs,
    a.param_3 AS node_incid_status,
    i.idval AS node_incid_status_v,
    a.param_4 AS photo,
    NULL::text AS incid_real_status
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE and om_visit.class_id = 18 ORDER  BY 1,2'::text, ' VALUES (''node_incid_tip''),(''node_incid_obs''),(''node_incid_status''), (''photo''), (''node_incid_grau_urgent'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean, param_5 text)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'node_incid_tip'::text
     LEFT JOIN om_typevalue i ON i.id::text = a.param_3 AND i.typevalue = 'incidencia_status'::text
     LEFT JOIN om_typevalue g ON g.id::text = a.param_5 AND g.typevalue = 'emb_incid_grau_urgent'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 18;


CREATE OR REPLACE VIEW ud.ve_visit_node_incidencia_filter
AS SELECT ve_visit_node_incidencia.visit_id,
    ve_visit_node_incidencia.node_id,
    ve_visit_node_incidencia.visitcat_id,
    ve_visit_node_incidencia.ext_code,
    node.code,
    node.node_type,
    node.state,
    ve_visit_node_incidencia.startdate,
    ve_visit_node_incidencia.enddate,
    ve_visit_node_incidencia.user_name,
    ve_visit_node_incidencia.webclient_id,
    ve_visit_node_incidencia.expl_id,
    ve_visit_node_incidencia.descript,
    ve_visit_node_incidencia.is_done,
    ve_visit_node_incidencia.the_geom,
    ve_visit_node_incidencia.class_id,
    ve_visit_node_incidencia.class_name,
    ve_visit_node_incidencia.status,
    ve_visit_node_incidencia.status_name,
    ve_visit_node_incidencia.node_incid_tip,
    ve_visit_node_incidencia.node_incid_tip_v,
    ve_visit_node_incidencia.node_incid_grau_urgent,
    ve_visit_node_incidencia.node_incid_grau_urgent_v,
    ve_visit_node_incidencia.node_incid_obs,
    ve_visit_node_incidencia.node_incid_status,
    ve_visit_node_incidencia.photo
   FROM selector_date,
    ve_visit_node_incidencia
     JOIN node ON node.node_id::text = ve_visit_node_incidencia.node_id::text
  WHERE "overlaps"(ve_visit_node_incidencia.startdate, ve_visit_node_incidencia.startdate, selector_date.from_date::timestamp without time zone, selector_date.to_date::timestamp without time zone) AND selector_date.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ud.ve_visit_node_neteja
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.unit_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_0 AS tram_exec_visit,
    e.idval AS tram_exec_visit_v,
    a.param_1 AS tram_netejat,
    p.idval AS tram_netejat_v,
    a.param_2 AS tram_kg,
    a.param_3 AS tram_cm_sedim,
    a.param_4 AS tram_res_sabo,
    a.param_5 AS tram_res_oli,
    a.param_6 AS tram_res_greix,
    a.param_7 AS tram_res_sorra,
    a.param_8 AS tram_res_brossa,
    a.param_9 AS tram_res_nivell,
    n.idval AS tram_res_nivell_v,
    a.param_10 AS tram_incident,
    i.idval AS tram_incident_v,
    a.param_11 AS tram_inacces,
    c.idval AS tram_inacces_v,
    a.param_12 AS tram_observ,
    a.param_13 AS num_elem_visit,
    a.param_14 AS photo,
    a.param_15 AS tram_paneroles,
    a.param_16 AS tram_rates
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_0,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5,
            ct.param_6,
            ct.param_7,
            ct.param_8,
            ct.param_9,
            ct.param_10,
            ct.param_11,
            ct.param_12,
            ct.param_13,
            ct.param_14,
            ct.param_15,
            ct.param_16
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE and om_visit.class_id = 16 ORDER  BY 1,2'::text, ' VALUES (''tram_exec_visit''), (''tram_netejat''),(''tram_kg''),(''tram_cm_sedim''),(''tram_res_sabo''),
			(''tram_res_oli''),(''tram_res_greix''),(''tram_res_sorra''),(''tram_res_brossa''),(''tram_res_nivell''),(''tram_incident''),(''tram_inacces''),(''tram_observ''),(''num_elem_visit''),(''photo''),(''tram_paneroles''),(''tram_rates'')'::text) ct(visit_id integer, param_0 text, param_1 text, param_2 numeric, param_3 text, param_4 boolean, param_5 boolean, param_6 boolean, param_7 boolean, param_8 boolean, param_9 text, param_10 text, param_11 text, param_12 text, param_13 text, param_14 boolean, param_15 boolean, param_16 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue e ON e.id::text = a.param_0 AND e.typevalue = 'exec_x_visit'::text
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'emb_clean'::text
     LEFT JOIN om_typevalue n ON n.id::text = a.param_9 AND n.typevalue = 'tram_res_level'::text
     LEFT JOIN om_typevalue i ON i.id::text = a.param_10 AND i.typevalue = 'tram_x_incidence'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_11 AND c.typevalue = 'tram_x_inacces'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 16;


CREATE OR REPLACE VIEW ud.ve_visit_node_singlevent
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
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


CREATE OR REPLACE VIEW ud.ve_visit_revisio_chamber
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS pou_con,
    a.param_2 AS tapa_est,
    a.param_3 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=7 ORDER  BY 1,2'::text, ' VALUES (''pou_con''), (''tapa_est''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 7;


CREATE OR REPLACE VIEW ud.ve_visit_revisio_embornal
AS SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
    gully.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    gully.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS revisio_embornal,
    a.param_2 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN gully USING (gully_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=2 ORDER  BY 1,2'::text, ' VALUES (''revisio_embornal''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 2;


CREATE OR REPLACE VIEW ud.ve_visit_revisio_escomesa
AS SELECT om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    connec.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    connec.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS revisio_escomesa,
    a.param_2 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN connec USING (connec_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=1 ORDER  BY 1,2'::text, ' VALUES (''revisio_escomesa''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 1;


CREATE OR REPLACE VIEW ud.ve_visit_revisio_inici
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS pou_con,
    a.param_2 AS tapa_est,
    a.param_3 AS tapa_can,
    a.param_4 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=9 ORDER  BY 1,2'::text, ' VALUES (''pou_con''), (''tapa_est''), (''tapa_can''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 9;


CREATE OR REPLACE VIEW ud.ve_visit_revisio_outfall
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS revisio_outfall,
    a.param_2 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=5 ORDER  BY 1,2'::text, ' VALUES (''revisio_outfall''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 5;


CREATE OR REPLACE VIEW ud.ve_visit_revisio_pou
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS pou_con,
    a.param_2 AS tapa_est,
    a.param_3 AS tapa_can,
    a.param_4 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=8 ORDER  BY 1,2'::text, ' VALUES (''pou_con''),(''tapa_est''),(''tapa_can''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 8;


CREATE OR REPLACE VIEW ud.ve_visit_revisio_tram
AS SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    arc.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    arc.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS revisio_tram,
    a.param_2 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN arc USING (arc_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=3 ORDER  BY 1,2'::text, ' VALUES (''revisio_tram''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 3;


CREATE OR REPLACE VIEW ud.ve_visit_revisio_unio
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS revisio_unio,
    a.param_2 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=4 ORDER  BY 1,2'::text, ' VALUES (''revisio_unio''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 4;

  -- ud.ve_visit_revisio_valve source

CREATE OR REPLACE VIEW ud.ve_visit_revisio_valve
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS revisio_valve,
    a.param_2 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_cat_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			WHERE config_visit_class.ismultievent = TRUE AND config_visit_class.id=6 ORDER  BY 1,2'::text, ' VALUES (''revisio_valve''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 6;


CREATE OR REPLACE VIEW ud.ve_visit_tram_insp
AS SELECT vm_visit_tram_insp.visit_id,
    vm_visit_tram_insp.arc_id,
    vm_visit_tram_insp.code,
    vm_visit_tram_insp.visitcat_id,
    vm_visit_tram_insp.ext_code,
    vm_visit_tram_insp.startdate,
    vm_visit_tram_insp.enddate,
    vm_visit_tram_insp.user_name,
    vm_visit_tram_insp.webclient_id,
    vm_visit_tram_insp.expl_id,
    vm_visit_tram_insp.the_geom,
    vm_visit_tram_insp.descript,
    vm_visit_tram_insp.is_done,
    vm_visit_tram_insp.class_id,
    vm_visit_tram_insp.class_name,
    vm_visit_tram_insp.lot_id,
    vm_visit_tram_insp.status,
    vm_visit_tram_insp.status_name,
    vm_visit_tram_insp.insp_tram_n_inici,
    vm_visit_tram_insp.insp_tram_sino,
    vm_visit_tram_insp.insp_tram_sino_v,
    vm_visit_tram_insp.insp_tram_complet,
    vm_visit_tram_insp.insp_tram_complet_v,
    vm_visit_tram_insp.insp_tram_ml_revisats,
    vm_visit_tram_insp.insp_tram_sedim,
    vm_visit_tram_insp.insp_tram_sedim_v,
    vm_visit_tram_insp.insp_tram_sedim_dada,
    vm_visit_tram_insp.insp_tram_fangs,
    vm_visit_tram_insp.insp_tram_sorra,
    vm_visit_tram_insp.insp_tram_runa,
    vm_visit_tram_insp.insp_tram_greixos,
    vm_visit_tram_insp.insp_tram_estat,
    vm_visit_tram_insp.insp_tram_estat_v,
    vm_visit_tram_insp.insp_tram_paneroles,
    vm_visit_tram_insp.insp_tram_paneroles_v,
    vm_visit_tram_insp.insp_tram_rates,
    vm_visit_tram_insp.insp_tram_rates_v,
    vm_visit_tram_insp.insp_tram_ensorraments,
    vm_visit_tram_insp.insp_tram_esquerdes,
    vm_visit_tram_insp.insp_tram_deforma,
    vm_visit_tram_insp.insp_tram_danys_solera,
    vm_visit_tram_insp.insp_tram_claveg_pen,
    vm_visit_tram_insp.insp_tram_trencaments,
    vm_visit_tram_insp.insp_tram_beurada_cim,
    vm_visit_tram_insp.insp_tram_aboc_formigo,
    vm_visit_tram_insp.insp_tram_filtracio,
    vm_visit_tram_insp.insp_tram_forat,
    vm_visit_tram_insp.insp_tram_entrada_arrels,
    vm_visit_tram_insp.insp_tram_juntes_defec,
    vm_visit_tram_insp.insp_tram_empelt_defec,
    vm_visit_tram_insp.insp_tram_minutatge,
    vm_visit_tram_insp.insp_tram_incident,
    vm_visit_tram_insp.insp_tram_incident_v,
    vm_visit_tram_insp.insp_tram_obs
   FROM vm_visit_tram_insp
UNION
 SELECT ve_visit_tram_insp_aux.visit_id,
    ve_visit_tram_insp_aux.arc_id,
    ve_visit_tram_insp_aux.code,
    ve_visit_tram_insp_aux.visitcat_id,
    ve_visit_tram_insp_aux.ext_code,
    ve_visit_tram_insp_aux.startdate,
    ve_visit_tram_insp_aux.enddate,
    ve_visit_tram_insp_aux.user_name,
    ve_visit_tram_insp_aux.webclient_id,
    ve_visit_tram_insp_aux.expl_id,
    ve_visit_tram_insp_aux.the_geom,
    ve_visit_tram_insp_aux.descript,
    ve_visit_tram_insp_aux.is_done,
    ve_visit_tram_insp_aux.class_id,
    ve_visit_tram_insp_aux.class_name,
    ve_visit_tram_insp_aux.lot_id,
    ve_visit_tram_insp_aux.status,
    ve_visit_tram_insp_aux.status_name,
    ve_visit_tram_insp_aux.insp_tram_n_inici,
    ve_visit_tram_insp_aux.insp_tram_sino,
    ve_visit_tram_insp_aux.insp_tram_sino_v,
    ve_visit_tram_insp_aux.insp_tram_complet,
    ve_visit_tram_insp_aux.insp_tram_complet_v,
    ve_visit_tram_insp_aux.insp_tram_ml_revisats,
    ve_visit_tram_insp_aux.insp_tram_sedim,
    ve_visit_tram_insp_aux.insp_tram_sedim_v,
    ve_visit_tram_insp_aux.insp_tram_sedim_dada,
    ve_visit_tram_insp_aux.insp_tram_fangs,
    ve_visit_tram_insp_aux.insp_tram_sorra,
    ve_visit_tram_insp_aux.insp_tram_runa,
    ve_visit_tram_insp_aux.insp_tram_greixos,
    ve_visit_tram_insp_aux.insp_tram_estat,
    ve_visit_tram_insp_aux.insp_tram_estat_v,
    ve_visit_tram_insp_aux.insp_tram_paneroles,
    ve_visit_tram_insp_aux.insp_tram_paneroles_v,
    ve_visit_tram_insp_aux.insp_tram_rates,
    ve_visit_tram_insp_aux.insp_tram_rates_v,
    ve_visit_tram_insp_aux.insp_tram_ensorraments,
    ve_visit_tram_insp_aux.insp_tram_esquerdes,
    ve_visit_tram_insp_aux.insp_tram_deforma,
    ve_visit_tram_insp_aux.insp_tram_danys_solera,
    ve_visit_tram_insp_aux.insp_tram_claveg_pen,
    ve_visit_tram_insp_aux.insp_tram_trencaments,
    ve_visit_tram_insp_aux.insp_tram_beurada_cim,
    ve_visit_tram_insp_aux.insp_tram_aboc_formigo,
    ve_visit_tram_insp_aux.insp_tram_filtracio,
    ve_visit_tram_insp_aux.insp_tram_forat,
    ve_visit_tram_insp_aux.insp_tram_entrada_arrels,
    ve_visit_tram_insp_aux.insp_tram_juntes_defec,
    ve_visit_tram_insp_aux.insp_tram_empelt_defec,
    ve_visit_tram_insp_aux.insp_tram_minutatge,
    ve_visit_tram_insp_aux.insp_tram_incident,
    ve_visit_tram_insp_aux.insp_tram_incident_v,
    ve_visit_tram_insp_aux.insp_tram_obs
   FROM ve_visit_tram_insp_aux;


CREATE OR REPLACE VIEW ud.ve_visit_tram_insp_aux
AS SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    arc.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    arc.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS insp_tram_n_inici,
    a.param_2 AS insp_tram_sino,
    p.idval AS insp_tram_sino_v,
    a.param_3 AS insp_tram_complet,
    u.idval AS insp_tram_complet_v,
    a.param_4 AS insp_tram_ml_revisats,
    a.param_5 AS insp_tram_sedim,
    w.idval AS insp_tram_sedim_v,
    a.param_6 AS insp_tram_sedim_dada,
    a.param_7 AS insp_tram_fangs,
    a.param_8 AS insp_tram_sorra,
    a.param_9 AS insp_tram_runa,
    a.param_10 AS insp_tram_greixos,
    a.param_11 AS insp_tram_estat,
    n.idval AS insp_tram_estat_v,
    a.param_12 AS insp_tram_paneroles,
    e.idval AS insp_tram_paneroles_v,
    a.param_13 AS insp_tram_rates,
    y.idval AS insp_tram_rates_v,
    a.param_14 AS insp_tram_ensorraments,
    a.param_15 AS insp_tram_esquerdes,
    a.param_16 AS insp_tram_deforma,
    a.param_17 AS insp_tram_danys_solera,
    a.param_18 AS insp_tram_claveg_pen,
    a.param_19 AS insp_tram_trencaments,
    a.param_20 AS insp_tram_beurada_cim,
    a.param_21 AS insp_tram_aboc_formigo,
    a.param_22 AS insp_tram_filtracio,
    a.param_23 AS insp_tram_forat,
    a.param_24 AS insp_tram_entrada_arrels,
    a.param_25 AS insp_tram_juntes_defec,
    a.param_26 AS insp_tram_empelt_defec,
    a.param_27 AS insp_tram_minutatge,
    a.param_28 AS insp_tram_incident,
    r.idval AS insp_tram_incident_v,
    a.param_29 AS insp_tram_obs
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN arc USING (arc_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5,
            ct.param_6,
            ct.param_7,
            ct.param_8,
            ct.param_9,
            ct.param_10,
            ct.param_11,
            ct.param_12,
            ct.param_13,
            ct.param_14,
            ct.param_15,
            ct.param_16,
            ct.param_17,
            ct.param_18,
            ct.param_19,
            ct.param_20,
            ct.param_21,
            ct.param_22,
            ct.param_23,
            ct.param_24,
            ct.param_25,
            ct.param_26,
            ct.param_27,
            ct.param_28,
            ct.param_29
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE and om_visit.class_id = 14 AND startdate >= date(now()) - ''60 day''::interval ORDER  BY 1,2'::text, ' VALUES (''insp_tram_n_inici''),(''insp_tram_sino''),
			(''insp_tram_complet''),(''insp_tram_ml_revisats''),(''insp_tram_sedim''),(''insp_tram_sedim_dada''),(''insp_tram_fangs''),(''insp_tram_sorra''),(''insp_tram_runa''),
			(''insp_tram_greixos''),(''insp_tram_estat''),(''insp_tram_paneroles''),(''insp_tram_rates''),(''insp_tram_ensorraments''),(''insp_tram_esquerdes''),(''insp_tram_deforma''),(''insp_tram_danys_solera''),
			(''insp_tram_claveg_pen''),(''insp_tram_trencaments''),(''insp_tram_beurada_cim''),(''insp_tram_aboc_formigo''),(''insp_tram_filtracio''),(''insp_tram_forat''),(''insp_tram_entrada_arrels''),
			(''insp_tram_juntes_defec''),(''insp_tram_empelt_defec''),(''insp_tram_minutatge''),(''insp_tram_incident''),(''insp_tram_obs'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 text, param_5 text, param_6 text, param_7 boolean, param_8 boolean, param_9 boolean, param_10 boolean, param_11 text, param_12 text, param_13 text, param_14 text, param_15 text, param_16 text, param_17 text, param_18 text, param_19 text, param_20 text, param_21 text, param_22 text, param_23 text, param_24 text, param_25 text, param_26 text, param_27 text, param_28 text, param_29 text)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue n ON n.id::text = a.param_11 AND n.typevalue = 'tram_insp_estat'::text
     LEFT JOIN om_typevalue w ON w.id::text = a.param_5 AND w.typevalue = 'tram_insp_sedim'::text
     LEFT JOIN om_typevalue e ON e.id::text = a.param_12 AND e.typevalue = 'tram_insp_paneroles'::text
     LEFT JOIN om_typevalue r ON r.id::text = a.param_27 AND r.typevalue = 'tram_insp_incid'::text
     LEFT JOIN om_typevalue p ON p.id::text = a.param_2 AND p.typevalue = 'emb_clean'::text
     LEFT JOIN om_typevalue u ON u.id::text = a.param_3 AND u.typevalue = 'emb_clean'::text
     LEFT JOIN om_typevalue y ON y.id::text = a.param_13 AND y.typevalue = 'emb_clean'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 14 AND om_visit.startdate >= (date(now()) - '60 days'::interval);


CREATE OR REPLACE VIEW ud.ve_visit_tram_neteja
AS SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    arc.code,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    arc.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.unit_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_0 AS tram_exec_visit,
    e.idval AS tram_exec_visit_v,
    a.param_1 AS tram_netejat,
    p.idval AS tram_netejat_v,
    a.param_2 AS tram_kg,
    a.param_3 AS tram_cm_sedim,
    a.param_4 AS tram_res_sabo,
    a.param_5 AS tram_res_oli,
    a.param_6 AS tram_res_greix,
    a.param_7 AS tram_res_sorra,
    a.param_8 AS tram_res_brossa,
    a.param_9 AS tram_res_nivell,
    n.idval AS tram_res_nivell_v,
    a.param_10 AS tram_incident,
    i.idval AS tram_incident_v,
    a.param_11 AS tram_inacces,
    c.idval AS tram_inacces_v,
    a.param_12 AS tram_observ,
    a.param_13 AS num_elem_visit,
    a.param_14 AS photo,
    a.param_15 AS tram_kg_estimats,
    a.param_16 AS insp_tram_estat,
    a.param_17 AS tram_res_ciment,
    a.param_18 AS tram_contrapendent,
    q.idval AS tram_contrapendent_v,
    a.param_19 AS tram_regis_no_adj,
    j.idval AS tram_regis_no_adj_v,
    a.param_20 AS tram_paneroles,
    a.param_21 AS tram_rates,
    a.param_22 AS tram_res_colorant,
    a.param_23 AS tram_res_tros_tub
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN arc USING (arc_id)
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_0,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5,
            ct.param_6,
            ct.param_7,
            ct.param_8,
            ct.param_9,
            ct.param_10,
            ct.param_11,
            ct.param_12,
            ct.param_13,
            ct.param_14,
            ct.param_15,
            ct.param_16,
            ct.param_17,
            ct.param_18,
            ct.param_19,
            ct.param_20,
            ct.param_21,
            ct.param_22,
            ct.param_23
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value
			FROM ud.om_visit JOIN ud.om_visit_event ON om_visit.id= om_visit_event.visit_id
			LEFT JOIN ud.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE and om_visit.class_id = 15 ORDER  BY 1,2'::text, ' VALUES (''tram_exec_visit''), (''tram_netejat''),(''tram_kg''),(''tram_cm_sedim''),(''tram_res_sabo''),
			(''tram_res_oli''),(''tram_res_greix''),(''tram_res_sorra''),(''tram_res_brossa''),(''tram_res_nivell''),(''tram_incident''),(''tram_inacces''),(''tram_observ''),
			(''num_elem_visit''),(''photo''),(''tram_kg_estimats''),(''insp_tram_estat''),(''tram_res_ciment''),(''tram_contrapendent''),(''tram_regis_no_adj''),(''tram_paneroles''),
			(''tram_rates''),(''tram_res_colorant''),(''tram_res_tros_tub'')'::text) ct(visit_id integer, param_0 text, param_1 text, param_2 numeric, param_3 text, param_4 boolean, param_5 boolean, param_6 boolean, param_7 boolean, param_8 boolean, param_9 text, param_10 text, param_11 text, param_12 text, param_13 text, param_14 boolean, param_15 numeric, param_16 text, param_17 boolean, param_18 text, param_19 text, param_20 boolean, param_21 boolean, param_22 boolean, param_23 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue e ON e.id::text = a.param_0 AND e.typevalue = 'exec_x_visit'::text
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'emb_clean'::text
     LEFT JOIN om_typevalue n ON n.id::text = a.param_9 AND n.typevalue = 'tram_res_level'::text
     LEFT JOIN om_typevalue i ON i.id::text = a.param_10 AND i.typevalue = 'tram_x_incidence'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_11 AND c.typevalue = 'tram_x_inacces'::text
     LEFT JOIN om_typevalue q ON q.id::text = a.param_18 AND q.typevalue = 'emb_clean'::text
     LEFT JOIN om_typevalue j ON j.id::text = a.param_19 AND j.typevalue = 'emb_clean'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 15;

