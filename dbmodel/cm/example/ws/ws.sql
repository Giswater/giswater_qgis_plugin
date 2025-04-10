/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO cat_organization VALUES ('1', 'Test Organization', 'Test nova creació', True);
INSERT INTO cat_team VALUES ('1', '123456', 'Team test',1, null, null, TRUE);

INSERT INTO PARENT_SCHEMA.config_visit_class VALUES (10, 'Connec Incident', NULL, true, false, true, 'CONNEC', 'role_om', 2, '{"offlineDefault":"true"}', 'visit_connec_incid', 've_visit_connec_incid', 'v_ui_visit_connec_incid');
INSERT INTO PARENT_SCHEMA.config_visit_class VALUES (11, 'Generic Incident', NULL, true, false, true, NULL, 'role_om', 2, '{"offlineDefault":"true"}', 'visit_incident', 've_visit_incident', 'v_ui_visit_incident');
INSERT INTO PARENT_SCHEMA.config_visit_class VALUES (12, 'Inspection Valves', NULL, true, false, true, 'NODE', 'role_om', 1, '{"offlineDefault":"true", "sysType":"VALVE"}', 'visit_valve_insp', 've_visit_valve_insp', 'v_ui_visit_valve_insp');


INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('observ_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Observ on connec', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('observ_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Observ on node', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('observ_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Observ on arc', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('incident_location', NULL, 'INSPECTION', 'ALL', 'TEXT', NULL, 'incident location', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('clean_valve', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Clean valve', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('defect_valve', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Defect on valve', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('manipulate_valve', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Manipulate valve', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO PARENT_SCHEMA.config_visit_parameter VALUES ('observ_valve', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Observ on valve', 'event_standard', NULL, TRUE, NULL, TRUE);

INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (10, 'incident_type');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (10, 'incident_comment');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (10, 'photo');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (11, 'incident_type');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (11, 'incident_comment');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (11, 'incident_location');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (11, 'photo');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (12, 'clean_valve');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (12, 'defect_valve');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (12, 'manipulate_valve');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (12, 'observ_valve');
INSERT INTO PARENT_SCHEMA.config_visit_class_x_parameter VALUES (12, 'photo');

INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('incident_location', 1, 'Sidewalk');
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('incident_location', 2, 'Road');
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('incident_location', 3, 'Facade');
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('incident_location', 4, 'Garden area');

--INSERT INTO SCHEMA_NAME.om_team_x_user (user_id, team_id) VALUES ('test', 1) ON CONFLICT (user_id, team_id) DO NOTHING;
--INSERT INTO SCHEMA_NAME.om_team_x_user (user_id, team_id) VALUES ('postgres', 1) ON CONFLICT (user_id, team_id) DO NOTHING;

--INSERT INTO SCHEMA_NAME.om_team_x_visitclass (team_id, visitclass_id) VALUES (1, 12) ON CONFLICT (team_id, visitclass_id) DO NOTHING;



--v_lot_x_connec_web
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_lot_x_connec_web', 'View to publish on the web to visit connecs', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

CREATE OR REPLACE VIEW v_lot_x_connec_web AS 
 SELECT row_number() OVER () AS rid,
    om_campaign_lot_x_connec.connec_id,
    connec.code,
    om_campaign_lot_x_connec.lot_id,
    om_campaign_lot_x_connec.status,
    connec.the_geom,
    'connec'::text AS sys_type
 FROM SCHEMA_NAME.om_campaign_lot_x_connec
    JOIN connec USING (connec_id);
    --JOIN SCHEMA_NAME.om_visit_lot_x_user USING (lot_id)
    --WHERE om_visit_lot_x_user.endtime IS NULL;


 

--v_lot_x_node_web
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_lot_x_node_web', 'View to publish on the web to visit nodes', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

CREATE OR REPLACE VIEW v_lot_x_node_web AS 
 SELECT row_number() OVER () AS rid,
    om_campaign_lot_x_node.node_id,
    node.code,
    om_campaign_lot_x_node.lot_id,
    om_campaign_lot_x_node.status,
    node.the_geom,
    'node'::text AS sys_type
 FROM SCHEMA_NAME.om_campaign_lot_x_node
    JOIN node USING (node_id);
    --JOIN SCHEMA_NAME.om_visit_lot_x_user USING (lot_id)
    --WHERE om_visit_lot_x_user.endtime IS NULL;


--v_lot_x_arc_web
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_lot_x_arc_web', 'View to publish on the web to visit arcs', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

CREATE OR REPLACE VIEW v_lot_x_arc_web AS 
 SELECT row_number() OVER () AS rid,
    om_campaign_lot_x_arc.arc_id,
    arc.code,
    om_campaign_lot_x_arc.lot_id,
    om_campaign_lot_x_arc.status,
    arc.the_geom,
    'arc'::text AS sys_type
 FROM SCHEMA_NAME.om_campaign_lot_x_arc
    JOIN arc USING (arc_id);
    --JOIN SCHEMA_NAME.om_visit_lot_x_user USING (lot_id)
    --WHERE om_visit_lot_x_user.endtime IS NULL;

-- v_lot
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_lot', 'View with the information about lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

 CREATE OR REPLACE VIEW v_lot AS 
 SELECT om_campaign_lot.id,
    om_campaign_lot.startdate,
    om_campaign_lot.enddate,
    om_campaign_lot.descript,
    om_campaign_lot.team_id,
    om_campaign_lot.duration,
    PARENT_SCHEMA.om_typevalue.idval AS status,
    om_campaign_lot.the_geom
   FROM SCHEMA_NAME.selector_lot,
    SCHEMA_NAME.om_campaign_lot
     JOIN PARENT_SCHEMA.om_typevalue ON om_campaign_lot.status = PARENT_SCHEMA.om_typevalue.id::integer AND PARENT_SCHEMA.om_typevalue.typevalue = 'lot_cat_status'::text
  WHERE om_campaign_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


-- ve_visit_connec_incid
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_visit_connec_incid', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

-- DROP VIEW IF EXISTS ve_visit_connec_incid;
CREATE OR REPLACE VIEW ve_visit_connec_incid AS 
 SELECT om_visit_x_connec.visit_id,
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
    PARENT_SCHEMA.config_visit_class.idval AS class_name,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS incident_type,
    p.idval AS incident_type_v,
    a.param_2 AS incident_comment,
    a.param_3 AS photo
   FROM om_visit
     JOIN PARENT_SCHEMA.config_visit_class ON PARENT_SCHEMA.config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     LEFT JOIN PARENT_SCHEMA.om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
			LEFT JOIN PARENT_SCHEMA.config_visit_class on PARENT_SCHEMA.config_visit_class.id=om_visit.class_id
			where PARENT_SCHEMA.config_visit_class.ismultievent = TRUE AND PARENT_SCHEMA.config_visit_class.id=7 ORDER  BY 1,2'::text, ' VALUES (''incident_type''),(''incident_comment''),(''photo'')
			'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN PARENT_SCHEMA.om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'incident_type'::text
  WHERE PARENT_SCHEMA.config_visit_class.ismultievent = true AND PARENT_SCHEMA.config_visit_class.id = 7;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_connec_incid
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(7);


-- ve_visit_incident
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_visit_incident', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

-- DROP VIEW IF EXISTS ve_visit_incident;
CREATE OR REPLACE VIEW ve_visit_incident AS 
 SELECT om_visit.id AS visit_id,
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
    PARENT_SCHEMA.config_visit_class.idval AS class_name,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS incident_type,
    p.idval AS incident_type_v,
    a.param_2 AS incident_location,
    c.idval AS incident_location_v,
    a.param_3 AS incident_comment,
    a.param_4 AS photo
   FROM om_visit
     JOIN PARENT_SCHEMA.config_visit_class ON PARENT_SCHEMA.config_visit_class.id = om_visit.class_id
     LEFT JOIN PARENT_SCHEMA.om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
			LEFT JOIN PARENT_SCHEMA.config_visit_class on PARENT_SCHEMA.config_visit_class.id=om_visit.class_id
			where PARENT_SCHEMA.config_visit_class.ismultievent = TRUE AND PARENT_SCHEMA.config_visit_class.id=8 ORDER  BY 1,2'::text, ' VALUES (''incident_type''),(''incident_location''),(''incident_comment''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN PARENT_SCHEMA.om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'incident_type'::text
     LEFT JOIN PARENT_SCHEMA.om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'incident_location'::text
  WHERE PARENT_SCHEMA.config_visit_class.ismultievent = true AND PARENT_SCHEMA.config_visit_class.id = 8;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_incident
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(8);

-- ve_visit_valve_insp
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_visit_valve_insp', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

-- DROP VIEW IF EXISTS ve_visit_valve_insp;
CREATE OR REPLACE VIEW ve_visit_valve_insp AS 
 SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    cat_node.node_type,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    PARENT_SCHEMA.config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS defect_valve,
    d.idval AS defect_valve_v,
    a.param_2 AS clean_valve,
    c.idval AS clean_valve_v,
    a.param_3 AS manipulate_valve,
    a.param_4 AS observ_valve,
    a.param_5 AS photo
   FROM om_visit
     JOIN PARENT_SCHEMA.config_visit_class ON PARENT_SCHEMA.config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
     JOIN cat_node ON cat_node.id=node.nodecat_id
     LEFT JOIN PARENT_SCHEMA.om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      JOIN PARENT_SCHEMA.config_visit_class on PARENT_SCHEMA.config_visit_class.id=om_visit.class_id
      where PARENT_SCHEMA.config_visit_class.ismultievent = TRUE AND PARENT_SCHEMA.config_visit_class.id=9 ORDER  BY 1,2'::text, ' VALUES (''defect_valve''),(''clean_valve''),(''manipulate_valve''),(''observ_valve''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 boolean, param_4 text, param_5 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN PARENT_SCHEMA.om_typevalue d ON d.id::text = a.param_1 AND d.typevalue = 'visit_defect'::text
     LEFT JOIN PARENT_SCHEMA.om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'visit_cleaned'::text
  WHERE PARENT_SCHEMA.config_visit_class.ismultievent = true AND PARENT_SCHEMA.config_visit_class.id = 9;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_valve_insp
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(9);
  


/*
--ve_visit_connec_incid
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'class_id', 1,  NULL, 'combo', 'Visit class:', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM PARENT_SCHEMA.config_visit_class WHERE id=7', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'startdate', 2, NULL, 'text', 'Date:', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'connec_id', 4, 'double', 'text', 'Connec id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'incident_type', 5, NULL, 'combo', 'Incident:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'incident_comment', 6, NULL, 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'status', 7, NULL, 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_incid', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

--ve_visit_incident
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'class_id', 1,  'text', 'combo', 'Visit class', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM PARENT_SCHEMA.config_visit_class WHERE id=8', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'startdate', 2, 'date', 'datetime', 'Date', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'incident_type', 4, 'text', 'combo', 'Incident:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'incident_location', 5, 'text', 'combo', 'Location:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''incident_location''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'incident_comment', 6, 'text', 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'status', 7, 'text', 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

--ve_visit_valve_insp
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'class_id', 1,  NULL, 'combo', 'Visit class:', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM PARENT_SCHEMA.config_visit_class WHERE id=9', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'startdate', 2, NULL, 'text', 'Date:', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'node_id', 4, 'double', 'text', 'Node id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'lot_id', 5, 'double', 'text', 'Lot id:', NULL, NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'defect_valve', 6, NULL, 'combo', 'Defects:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'clean_valve', 7, NULL, 'combo', 'Clean:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'manipulate_valve', 8, 'boolean', 'check', 'Can maniuplate valve:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'observ_valve', 9, NULL, 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'status', 10, NULL, 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_valve_insp', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
*/


-- v_ui_visit_connec_incid
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_ui_visit_connec_incid', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

-- DROP VIEW IF EXISTS v_ui_visit_connec_incid;
CREATE OR REPLACE VIEW v_ui_visit_connec_incid AS 
 SELECT visit_id,
    startdate,
    incident_type_v AS "Incident type",
    incident_comment AS "Comment",
    user_name,
    connec_id,
    enddate,
    class_id,
    photo
   FROM ve_visit_connec_incid;


-- v_ui_visit_valve_insp
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_ui_visit_valve_insp', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

-- DROP VIEW IF EXISTS v_ui_visit_valve_insp;
CREATE OR REPLACE VIEW v_ui_visit_valve_insp AS 
 SELECT visit_id,
    startdate,
    defect_valve_v AS "Defects",
    clean_valve_v AS "Cleaned",
    manipulate_valve AS "Manipulable",
    observ_valve AS "Observ",
    user_name,
    node_id,
    enddate,
    class_id,
    photo
   FROM ve_visit_valve_insp;



-- v_ui_visit_incident
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_ui_visit_incident', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin');

CREATE OR REPLACE VIEW v_ui_visit_incident AS 
 SELECT ve_visit_incident.visit_id,
    ve_visit_incident.startdate AS "Date",
    PARENT_SCHEMA.config_visit_class.idval AS "Visit class",
    ve_visit_incident.incident_type_v AS "Incident type",
    ve_visit_incident.incident_location_v AS "Incident location",
    ve_visit_incident.incident_comment AS "Comment",
    ve_visit_incident.user_name
   FROM ve_visit_incident
   JOIN PARENT_SCHEMA.config_visit_class ON PARENT_SCHEMA.config_visit_class.id=class_id;

INSERT INTO cat_organization (organization_id, code, "name", descript, active) VALUES(1, '123123', 'OWNER', 'PROPIETARIS', true);
INSERT INTO cat_organization (organization_id, code, "name", descript, active) VALUES(2, '123123', 'O1', 'O1', true);
INSERT INTO cat_organization (organization_id, code, "name", descript, active) VALUES(3, '123123', 'O2', 'O2', true);

INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(1, '1234512345', 'ADMIN', 1, 'equip administratiu', 'role_admin', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(2, '1234512345', 'o1_manager', 2, 'equip administratiu', 'role_manager', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(3, '1234512345', 'o2_manager', 3, 'equip administratiu', 'role_manager', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(4, '1234512345', 'o1_field1', 2, 'equip camp', 'role_field', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(5, '1234512345', 'o1_field2', 2, 'equip camp', 'role_field', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(6, '1234512345', 'o2_field1', 3, 'equip camp', 'role_field', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(7, '1234512345', 'o2_field2', 3, 'equip camp', 'role_field', true);

-- Team administrator
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('ferran', 'ferran@gmail.com', '48178923Z', 'ferran martinez lopez', 'administrador1', 1, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('daniel', 'daniel@gmail.com', '38145678P', 'daniel marin bocanegra', 'administrador2', 1, true);

-- Team: Manager o1
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('juan', 'juan@gmail.com', '79234561A', 'juan peris gallego', 'manager o1', 2, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('marta', 'marta.o1@gmail.com', '10923456H', 'marta sierra roca', 'manager o1', 2, true);

-- Team: Manager o2
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('ana', 'ana.o2@gmail.com', '52013478Y', 'ana torres delgado', 'manager o2', 3, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('carlos', 'carlos.manager@gmail.com', '64823109F', 'carlos fuentes mora', 'manager o2', 3, true);

-- Team: o1 field 1
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('laura', 'laura.field1@gmail.com', '78124567Q', 'laura blanco martí', 'o1 field 1', 4, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('david', 'david.o1f1@gmail.com', '34567012K', 'david ferrer romeu', 'o1 field 1', 4, true);

-- Team: o1 field 2
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('nuria', 'nuria.o1f2@gmail.com', '46283910L', 'nuria gallart costa', 'o1 field 2', 5, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('oscar', 'oscar.field2@gmail.com', '57201894W', 'oscar martin serra', 'o1 field 2', 5, true);

-- Team: o2 field 1
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('ines', 'ines.o2f1@gmail.com', '68391740T', 'ines ramos vega', 'o2 field 1', 6, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('pablo', 'pablo.o2f1@gmail.com', '78291034X', 'pablo nuñez bravo', 'o2 field 1', 6, true);

-- Team: o2 field 2
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('carla', 'carla.o2f2@gmail.com', '84023910S', 'carla gil torras', 'o2 field 2', 7, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('raul', 'raul.o2f2@gmail.com', '92034185M', 'raul bueno soler', 'o2 field 2', 7, true);

INSERT INTO om_reviewclass (id, idval, descript, active) VALUES(1, 'DEPOSITOS', 'TEST INSERT', true);
INSERT INTO om_reviewclass (id, idval, descript, active) VALUES(2, 'VALVULAS HIDRAULICAS', 'TEST INSERT', true);
INSERT INTO om_reviewclass (id, idval, descript, active) VALUES(3, 'CAPAS PADRE', 'TEST INSERT', true);

