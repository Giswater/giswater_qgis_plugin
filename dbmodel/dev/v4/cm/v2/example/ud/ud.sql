/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO ext_workorder_type VALUES ('CINSP', 'Connec Inspection', NULL);
INSERT INTO ext_workorder_type VALUES ('GINSP', 'Gully Inspection', NULL);
INSERT INTO ext_workorder_type VALUES ('NINSP', 'Node Inspection', NULL);
INSERT INTO ext_workorder_type VALUES ('AINSP', 'Arc Inspection', NULL);
INSERT INTO ext_workorder_type VALUES ('MINSP', 'Manhole Inspection', NULL);

INSERT INTO cat_team VALUES ('1', 'Test team', 'Test team', TRUE);

INSERT INTO cat_users VALUES ('test', 'test')ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_users VALUES ('postgres', 'postgres')ON CONFLICT (id) DO NOTHING;

INSERT INTO config_visit_class VALUES (10, 'Gully Incident', NULL, true, false, true, 'GULLY', 'role_om', 2, '{"offlineDefault":"true"}', 'visit_gully_incid', 've_visit_gully_incid', 'v_ui_visit_gully_incid');
INSERT INTO config_visit_class VALUES (11, 'Generic Incident', NULL, true, false, true, NULL, 'role_om', 2, '{"offlineDefault":"true"}', 'visit_incident', 've_visit_incident', 'v_ui_visit_incident');
INSERT INTO config_visit_class VALUES (12, 'Inspection Manhole', NULL, true, false, true, 'NODE', 'role_om', 1, '{"offlineDefault":"true", "sysType":"MANHOLE"}', 'visit_manhole_insp', 've_visit_manhole_insp', 'v_ui_visit_manhole_insp');

UPDATE config_visit_class SET param_options='{"offlineDefault":"true"}' WHERE id IN (2, 5, 6, 7);
UPDATE config_visit_class SET ui_tablename='v_ui_visit_connec_insp' WHERE id=2;
UPDATE config_visit_class SET ui_tablename='v_ui_visit_node_insp' WHERE id=5;
UPDATE config_visit_class SET ui_tablename='v_ui_visit_arc_insp' WHERE id=6;
UPDATE config_visit_class SET formname='visit_gully_insp', tablename='ve_visit_gully_insp', ui_tablename='v_ui_visit_gully_insp' WHERE id=7;


INSERT INTO config_visit_class_x_workorder VALUES (2, 'CINSP');
INSERT INTO config_visit_class_x_workorder VALUES (5, 'NINSP');
INSERT INTO config_visit_class_x_workorder VALUES (6, 'AINSP');
INSERT INTO config_visit_class_x_workorder VALUES (7, 'GINSP');
INSERT INTO config_visit_class_x_workorder VALUES (12, 'MINSP');

INSERT INTO config_visit_parameter VALUES ('photo', NULL, 'INSPECTION', 'ALL', 'TEXT', NULL, 'Photo related to visit', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('observ_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Observ on connec', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('observ_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Observ on node', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('observ_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Observ on arc', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('observ_gully', NULL, 'INSPECTION', 'GULLY', 'TEXT', NULL, 'Observ on gully', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('incident_location', NULL, 'INSPECTION', 'ALL', 'TEXT', NULL, 'incident location', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('clean_manhole', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Clean manhole', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('defect_manhole', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Defect on manhole', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('cover_manhole', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'cover manhole', 'event_standard', NULL, TRUE, NULL, TRUE);
INSERT INTO config_visit_parameter VALUES ('observ_manhole', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Observ on manhole', 'event_standard', NULL, TRUE, NULL, TRUE);

DELETE FROM config_visit_parameter WHERE id IN ('sediments_arc', 'sediments_node', 'sediments_connec');


DELETE FROM config_visit_class_x_parameter WHERE parameter_id IN ('sediments_arc', 'sediments_node', 'sediments_connec');

INSERT INTO config_visit_class_x_parameter VALUES (2, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (5, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (7, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (2, 'observ_connec');
INSERT INTO config_visit_class_x_parameter VALUES (5, 'observ_node');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'observ_arc');
INSERT INTO config_visit_class_x_parameter VALUES (7, 'observ_arc');
INSERT INTO config_visit_class_x_parameter VALUES (10, 'incident_type');
INSERT INTO config_visit_class_x_parameter VALUES (10, 'incident_comment');
INSERT INTO config_visit_class_x_parameter VALUES (10, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (11, 'incident_type');
INSERT INTO config_visit_class_x_parameter VALUES (11, 'incident_comment');
INSERT INTO config_visit_class_x_parameter VALUES (11, 'incident_location');
INSERT INTO config_visit_class_x_parameter VALUES (11, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (12, 'clean_manhole');
INSERT INTO config_visit_class_x_parameter VALUES (12, 'defect_manhole');
INSERT INTO config_visit_class_x_parameter VALUES (12, 'cover_manhole');
INSERT INTO config_visit_class_x_parameter VALUES (12, 'observ_manhole');
INSERT INTO config_visit_class_x_parameter VALUES (12, 'photo');

INSERT INTO om_typevalue VALUES ('incident_location', 1, 'Sidewalk');
INSERT INTO om_typevalue VALUES ('incident_location', 2, 'Road');
INSERT INTO om_typevalue VALUES ('incident_location', 3, 'Facade');
INSERT INTO om_typevalue VALUES ('incident_location', 4, 'Garden area');

INSERT INTO om_team_x_user (user_id, team_id) VALUES ('test', 1) ON CONFLICT (user_id, team_id) DO NOTHING;
INSERT INTO om_team_x_user (user_id, team_id) VALUES ('postgres', 1) ON CONFLICT (user_id, team_id) DO NOTHING;

INSERT INTO om_team_x_visitclass (team_id, visitclass_id) VALUES (1, 6) ON CONFLICT (team_id, visitclass_id) DO NOTHING;
INSERT INTO om_team_x_visitclass (team_id, visitclass_id) VALUES (1, 5) ON CONFLICT (team_id, visitclass_id) DO NOTHING;
INSERT INTO om_team_x_visitclass (team_id, visitclass_id) VALUES (1, 2) ON CONFLICT (team_id, visitclass_id) DO NOTHING;
INSERT INTO om_team_x_visitclass (team_id, visitclass_id) VALUES (1, 7) ON CONFLICT (team_id, visitclass_id) DO NOTHING;
INSERT INTO om_team_x_visitclass (team_id, visitclass_id) VALUES (1, 12) ON CONFLICT (team_id, visitclass_id) DO NOTHING;

INSERT INTO config_web_layer VALUES ('ve_visit_incident', FALSE, NULL, 'v_ui_visit_incident', NULL, 'Incident generic', 1) ON CONFLICT (layer_id) DO NOTHING;
INSERT INTO config_web_tableinfo_x_inforole (tableinfo_id, inforole_id, tableinforole_id) VALUES ('v_ui_visit_incident', 0, 'v_ui_visit_incident');



-- ve_visit_connec_insp
INSERT INTO sys_table VALUES ('ve_visit_connec_insp', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS ve_visit_connec_insp;
CREATE OR REPLACE VIEW ve_visit_connec_insp AS 
 SELECT om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    connec.code, 
    cat_connec.connectype_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
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
    a.param_1 AS defect_connec,
    d.idval AS defect_connec_v,
    a.param_2 AS clean_connec,
    c.idval AS clean_connec_v,
    a.param_3 AS observ_connec,
    a.param_4 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     JOIN cat_connec ON cat_connec.id=connec.connecat_id
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM ud_sample.om_visit JOIN ud_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
      JOIN ud_sample.config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id=2 ORDER  BY 1,2'::text, ' VALUES (''defect_connec''),(''clean_connec''),(''observ_connec''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue d ON d.id::text = a.param_1 AND d.typevalue = 'visit_defect'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'visit_cleaned'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 2;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_connec_insp
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(2);

--v_lot_x_connec_web
INSERT INTO sys_table VALUES ('v_lot_x_connec_web', 'View to publish on the web to visit connecs', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

CREATE OR REPLACE VIEW v_lot_x_connec_web AS 
 SELECT row_number() OVER () AS rid,
    om_visit_lot_x_connec.connec_id,
    connec.code,
    om_visit_lot_x_connec.lot_id,
    om_visit_lot_x_connec.status,
    connec.the_geom,
    'connec'::text AS sys_type
 FROM om_visit_lot_x_connec
    JOIN connec USING (connec_id)
    JOIN om_visit_lot_x_user USING (lot_id)
    WHERE om_visit_lot_x_user.endtime IS NULL;


  
-- ve_visit_node_insp
INSERT INTO sys_table VALUES ('ve_visit_node_insp', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS ve_visit_node_insp;
CREATE OR REPLACE VIEW ve_visit_node_insp AS 
 SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    cat_node.nodetype_id,
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
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS defect_node,
    d.idval AS defect_node_v,
    a.param_2 AS clean_node,
    c.idval AS clean_node_v,
    a.param_3 AS observ_node,
    a.param_4 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
     JOIN cat_node ON cat_node.id=node.nodecat_id
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM ud_sample.om_visit JOIN ud_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
      JOIN ud_sample.config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id=5 ORDER  BY 1,2'::text, ' VALUES (''defect_node''),(''clean_node''),(''observ_node''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue d ON d.id::text = a.param_1 AND d.typevalue = 'visit_defect'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'visit_cleaned'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 5;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_node_insp
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(5);

--v_lot_x_node_web
INSERT INTO sys_table VALUES ('v_lot_x_node_web', 'View to publish on the web to visit nodes', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

CREATE OR REPLACE VIEW v_lot_x_node_web AS 
 SELECT row_number() OVER () AS rid,
    om_visit_lot_x_node.node_id,
    node.code,
    om_visit_lot_x_node.lot_id,
    om_visit_lot_x_node.status,
    node.the_geom,
    'node'::text AS sys_type
 FROM om_visit_lot_x_node
    JOIN node USING (node_id)
    JOIN om_visit_lot_x_user USING (lot_id)
    WHERE om_visit_lot_x_user.endtime IS NULL;



-- ve_visit_arc_insp  
INSERT INTO sys_table VALUES ('ve_visit_arc_insp', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS ve_visit_arc_insp;
CREATE OR REPLACE VIEW ve_visit_arc_insp AS 
 SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    arc.code,
    cat_arc.arctype_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
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
    a.param_1 AS defect_arc,
    d.idval AS defect_arc_v,
    a.param_2 AS clean_arc,
    c.idval AS clean_arc_v,
    a.param_3 AS observ_arc,
    a.param_4 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
     JOIN cat_arc ON cat_arc.id=arc.arccat_id
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM ud_sample.om_visit JOIN ud_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
      JOIN ud_sample.config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id=6 ORDER  BY 1,2'::text, ' VALUES (''defect_arc''),(''clean_arc''),(''observ_arc''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue d ON d.id::text = a.param_1 AND d.typevalue = 'visit_defect'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'visit_cleaned'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 6;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_arc_insp
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(6);

--v_lot_x_arc_web
INSERT INTO sys_table VALUES ('v_lot_x_arc_web', 'View to publish on the web to visit arcs', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

CREATE OR REPLACE VIEW v_lot_x_arc_web AS 
 SELECT row_number() OVER () AS rid,
    om_visit_lot_x_arc.arc_id,
    arc.code,
    om_visit_lot_x_arc.lot_id,
    om_visit_lot_x_arc.status,
    arc.the_geom,
    'arc'::text AS sys_type
 FROM om_visit_lot_x_arc
    JOIN arc USING (arc_id)
    JOIN om_visit_lot_x_user USING (lot_id)
    WHERE om_visit_lot_x_user.endtime IS NULL;

-- v_lot
INSERT INTO sys_table VALUES ('v_lot', 'View with the information about lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

 CREATE OR REPLACE VIEW v_lot AS 
 SELECT om_visit_lot.id,
    om_visit_lot.startdate,
    om_visit_lot.enddate,
    om_visit_lot.visitclass_id,
    om_visit_lot.descript,
    om_visit_lot.team_id,
    om_visit_lot.duration,
    om_visit_lot.feature_type,
    om_typevalue.idval AS status,
    om_visit_lot.the_geom
   FROM selector_lot,
    om_visit_lot
     JOIN om_typevalue ON om_visit_lot.status = om_typevalue.id::integer AND om_typevalue.typevalue = 'lot_cat_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


-- ve_visit_gully_incid
INSERT INTO sys_table VALUES ('ve_visit_gully_incid', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS ve_visit_gully_incid;
CREATE OR REPLACE VIEW ve_visit_gully_incid AS 
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
    config_visit_class.idval AS class_name,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS incident_type,
    p.idval AS incident_type_v,
    a.param_2 AS incident_comment,
    a.param_3 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM ud_sample.om_visit JOIN ud_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
			LEFT JOIN ud_sample.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE AND config_visit_class.id=7 ORDER  BY 1,2'::text, ' VALUES (''incident_type''),(''incident_comment''),(''photo'')
			'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'incident_type'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 7;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_gully_incid
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(7);


-- ve_visit_incident
INSERT INTO sys_table VALUES ('ve_visit_incident', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
    config_visit_class.idval AS class_name,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS incident_type,
    p.idval AS incident_type_v,
    a.param_2 AS incident_location,
    c.idval AS incident_location_v,
    a.param_3 AS incident_comment,
    a.param_4 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM ud_sample.om_visit JOIN ud_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
			LEFT JOIN ud_sample.config_visit_class on config_visit_class.id=om_visit.class_id
			where config_visit_class.ismultievent = TRUE AND config_visit_class.id=8 ORDER  BY 1,2'::text, ' VALUES (''incident_type''),(''incident_location''),(''incident_comment''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue p ON p.id::text = a.param_1 AND p.typevalue = 'incident_type'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'incident_location'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 8;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_incident
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(8);

-- ve_visit_manhole_insp
INSERT INTO sys_table VALUES ('ve_visit_manhole_insp', 'View related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS ve_visit_manhole_insp;
CREATE OR REPLACE VIEW ve_visit_manhole_insp AS 
 SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    node.code,
    cat_node.nodetype_id,
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
    config_visit_class.idval AS class_name,
    om_visit.lot_id,
    om_visit.status,
    s.idval AS status_name,
    a.param_1 AS defect_manhole,
    d.idval AS defect_manhole_v,
    a.param_2 AS clean_manhole,
    c.idval AS clean_manhole_v,
    a.param_3 AS cover_manhole,
    a.param_4 AS observ_manhole,
    a.param_5 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
     JOIN cat_node ON cat_node.id=node.nodecat_id
     LEFT JOIN om_typevalue s ON om_visit.status = s.id::integer AND s.typevalue = 'visit_status'::text
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM ud_sample.om_visit JOIN ud_sample.om_visit_event ON om_visit.id= om_visit_event.visit_id 
      JOIN ud_sample.config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE AND config_visit_class.id=9 ORDER  BY 1,2'::text, ' VALUES (''defect_manhole''),(''clean_manhole''),(''cover_manhole''),(''observ_manhole''), (''photo'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 boolean, param_4 text, param_5 boolean)) a ON a.visit_id = om_visit.id
     LEFT JOIN om_typevalue d ON d.id::text = a.param_1 AND d.typevalue = 'visit_defect'::text
     LEFT JOIN om_typevalue c ON c.id::text = a.param_2 AND c.typevalue = 'visit_cleaned'::text
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 9;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_visit_manhole_insp
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_om_visit_multievent(9);
  


--ve_visit_connec_insp
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'class_id', 1,  NULL, 'combo', 'Visit class:', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM config_visit_class WHERE id=2', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'startdate', 2, NULL, 'text', 'Date:', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'connec_id', 4, 'double', 'text', 'Connec id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'lot_id', 5, 'double', 'text', 'Lot id:', NULL, NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'defect_connec', 6, NULL, 'combo', 'Defects:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'clean_connec', 7, NULL, 'combo', 'Clean:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'observ_connec', 8, NULL, 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'status', 9, NULL, 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_connec_insp', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

--ve_visit_node_insp
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'class_id', 1,  NULL, 'combo', 'Visit class:', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM config_visit_class WHERE id=5', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'startdate', 2, NULL, 'text', 'Date:', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'node_id', 4, 'double', 'text', 'Node id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'lot_id', 5, 'double', 'text', 'Lot id:', NULL, NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'defect_node', 6, NULL, 'combo', 'Defects:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'clean_node', 7, NULL, 'combo', 'Clean:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'observ_node', 8, NULL, 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'status', 9, NULL, 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_node_insp', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

--ve_visit_arc_insp
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'class_id', 1,  NULL, 'combo', 'Visit class:', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM config_visit_class WHERE id=6', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'startdate', 2, NULL, 'text', 'Date:', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'arc_id', 4, 'double', 'text', 'Arc id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'lot_id', 5, 'double', 'text', 'Lot id:', NULL, NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'defect_arc', 6, NULL, 'combo', 'Defects:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'clean_arc', 7, NULL, 'combo', 'Clean:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'observ_arc', 8, NULL, 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'status', 9, NULL, 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_arc_insp', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

--ve_visit_gully_incid
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'class_id', 1,  NULL, 'combo', 'Visit class:', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM config_visit_class WHERE id=7', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'startdate', 2, NULL, 'text', 'Date:', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'connec_id', 4, 'double', 'text', 'Connec id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'incident_type', 5, NULL, 'combo', 'Incident:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'incident_comment', 6, NULL, 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'status', 7, NULL, 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_gully_incid', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

--ve_visit_incident
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'class_id', 1,  'text', 'combo', 'Visit class', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM config_visit_class WHERE id=8', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'startdate', 2, 'date', 'datetime', 'Date', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'incident_type', 4, 'text', 'combo', 'Incident:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'incident_location', 5, 'text', 'combo', 'Location:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''incident_location''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'incident_comment', 6, 'text', 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'status', 7, 'text', 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_incident', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

--ve_visit_manhole_insp
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'class_id', 1,  NULL, 'combo', 'Visit class:', NULL, NULL, NULL, true, false, false, false, 'SELECT id, idval FROM config_visit_class WHERE id=9', NULL, NULL, NULL, NULL, 'get_visit', NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'startdate', 2, NULL, 'text', 'Date:', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'visit_id', 3, 'double', 'text', 'Visit id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'node_id', 4, 'double', 'text', 'Node id', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'lot_id', 5, 'double', 'text', 'Lot id:', NULL, NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'defect_manhole', 6, NULL, 'combo', 'Defects:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'clean_manhole', 7, NULL, 'combo', 'Clean:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'cover_manhole', 8, 'boolean', 'check', 'Can maniuplate manhole:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'observ_manhole', 9, NULL, 'text', 'Observations:', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'status', 10, NULL, 'combo', 'Status:', NULL, NULL, NULL, false, false, true, false, 'SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_status'' AND id::integer IN (2,3,4)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'acceptbutton', 1, NULL, 'button', 'Accept', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_visit', NULL, NULL, NULL, 'lyt_data_3', NULL, false);
INSERT INTO config_form_fields VALUES ('visit_manhole_insp', 'form_visit', 'backbutton', 2, NULL, 'button', 'Back', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'set_previous_form_back', NULL, NULL, NULL, 'lyt_data_3', NULL, false);

-- v_ui_visit_connec_insp
INSERT INTO sys_table VALUES ('v_ui_visit_connec_insp', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS v_ui_visit_connec_insp;
CREATE OR REPLACE VIEW v_ui_visit_connec_insp AS 
 SELECT visit_id,
    startdate,
    defect_connec_v AS "Defects",
    clean_connec_v AS "Cleaned",
    observ_connec AS "Observ",
    user_name,
    connec_id,
    enddate,
    class_id,
    photo
   FROM ve_visit_connec_insp;


-- v_ui_visit_node_insp
INSERT INTO sys_table VALUES ('v_ui_visit_node_insp', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS v_ui_visit_node_insp;
CREATE OR REPLACE VIEW v_ui_visit_node_insp AS 
 SELECT visit_id,
    startdate,
    defect_node_v AS "Defects",
    clean_node_v AS "Cleaned",
    observ_node AS "Observ",
    user_name,
    node_id,
    enddate,
    class_id,
    photo
   FROM ve_visit_node_insp;


-- v_ui_visit_arc_insp
INSERT INTO sys_table VALUES ('v_ui_visit_arc_insp', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS v_ui_visit_arc_insp;
CREATE OR REPLACE VIEW v_ui_visit_arc_insp AS 
 SELECT visit_id,
    startdate,
    defect_arc_v AS "Defects",
    clean_arc_v AS "Cleaned",
    observ_arc AS "Observ",
    user_name,
    arc_id,
    enddate,
    class_id,
    photo
   FROM ve_visit_arc_insp;


-- v_ui_visit_gully_incid
INSERT INTO sys_table VALUES ('v_ui_visit_gully_incid', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS v_ui_visit_gully_incid;
CREATE OR REPLACE VIEW v_ui_visit_gully_incid AS 
 SELECT visit_id,
    startdate,
    incident_type_v AS "Incident type",
    incident_comment AS "Comment",
    user_name,
    connec_id,
    enddate,
    class_id,
    photo
   FROM ve_visit_gully_incid;


-- v_ui_visit_manhole_insp
INSERT INTO sys_table VALUES ('v_ui_visit_manhole_insp', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP VIEW IF EXISTS v_ui_visit_manhole_insp;
CREATE OR REPLACE VIEW v_ui_visit_manhole_insp AS 
 SELECT visit_id,
    startdate,
    defect_manhole_v AS "Defects",
    clean_manhole_v AS "Cleaned",
    cover_manhole AS "Cover",
    observ_manhole AS "Observ",
    user_name,
    node_id,
    enddate,
    class_id,
    photo
   FROM ve_visit_manhole_insp;



-- v_ui_visit_incident
INSERT INTO sys_table VALUES ('v_ui_visit_incident', 'User interface view related to specific visit class', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

CREATE OR REPLACE VIEW v_ui_visit_incident AS 
 SELECT ve_visit_incident.visit_id,
    ve_visit_incident.startdate AS "Date",
    config_visit_class.idval AS "Visit class",
    ve_visit_incident.incident_type_v AS "Incident type",
    ve_visit_incident.incident_location_v AS "Incident location",
    ve_visit_incident.incident_comment AS "Comment",
    ve_visit_incident.user_name
   FROM ve_visit_incident
   JOIN config_visit_class ON config_visit_class.id=class_id;