/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO om_visit_cat VALUES (1, 'Test num.1','2017-1-1', '2017-3-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (2, 'Test num.2','2017-4-1', '2017-7-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (3, 'Test num.3','2017-8-1', '2017-9-30', NULL, TRUE);
INSERT INTO om_visit_cat VALUES (4, 'Test num.4','2017-10-1', '2017-12-31', NULL, TRUE);

INSERT INTO config_visit_class VALUES (6, 'Inspection and clean arc', NULL, true, false, true, 'ARC', 'role_om', 1, null, 'visit_arc_insp', 've_visit_arc_insp');
INSERT INTO config_visit_class VALUES (5, 'Inspection and clean node', NULL, true, false, true, 'NODE', 'role_om', 1, null, 'visit_node_insp', 've_visit_node_insp');
INSERT INTO config_visit_class VALUES (7, 'Inspection and clean gully', NULL, true, false, true, 'GULLY', 'role_om', 1, null, 'visit_emb_insp', 'visit_emb_insp');
INSERT INTO config_visit_class VALUES (1, 'Leak on pipe', NULL, true, false, false, 'ARC', 'role_om', 1, null, 'visit_arc_leak', 've_visit_arc_singlevent');
INSERT INTO config_visit_class VALUES (0, 'Open visit', NULL, true, true, false, NULL, 'role_om',  null,  null, 'visit_class_0', 'om_visit');
INSERT INTO config_visit_class VALUES (2, 'Inspection and clean connec', NULL, true, false, true, 'CONNEC', 'role_om', 1, null, 'visit_connec_insp', 've_visit_connec_insp');
INSERT INTO config_visit_class VALUES (4, 'Leak on connec', NULL, true, false, false, 'CONNEC', 'role_om', 1, null, 'visit_connec_leak', 've_visit_connec_singlevent');
INSERT INTO config_visit_class VALUES (3, 'Leak on node', NULL, true, false, false, 'NODE', 'role_om', 1, null, 'visit_node_leak', 've_visit_node_singlevent');
INSERT INTO config_visit_class VALUES (8, 'Incident', NULL, true, false, true, null, 'role_om', 2, null, 'unspected_noinfra', 've_visit_noinfra');
INSERT INTO config_visit_class VALUES (9, 'Rehabilitation arc', NULL, true, false, true, 'ARC', 'role_om', 1, null, 've_visit_arc_rehabit', 've_visit_arc_rehabit');

SELECT setval('SCHEMA_NAME.om_visit_class_id_seq', (SELECT max(id) FROM config_visit_class), true);

INSERT INTO config_visit_parameter VALUES ('arc_rehabit_1', NULL, 'REHABIT', 'ARC', 'text', NULL, 'Rehabilitation arc parameter 1', 'event_ud_arc_rehabit', NULL, 'FALSE');
INSERT INTO config_visit_parameter VALUES ('arc_rehabit_2', NULL, 'REHABIT', 'ARC', 'text', NULL, 'Rehabilitation arc parameter 2', 'event_ud_arc_rehabit', NULL, 'FALSE');

INSERT INTO config_visit_parameter VALUES ('leak_connec', NULL, 'INSPECTION', 'CONNEC', 'text', NULL, 'leak on connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_des');
INSERT INTO config_visit_parameter VALUES ('leak_arc', NULL, 'INSPECTION', 'ARC', 'text', NULL, 'leak on arc', 'event_ud_arc_standard', 'defaultvalue', FALSE, 'arc_insp_des');
INSERT INTO config_visit_parameter VALUES ('leak_node', NULL, 'INSPECTION', 'NODE', 'text', NULL, 'leak on node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_des');

INSERT INTO config_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECTION', 'ARC', 'text', NULL, 'Sediments in arc', 'event_ud_arc_standard', 'defaultvalue',FALSE, 'arc_insp_sed');
INSERT INTO config_visit_parameter VALUES ('clean_arc', NULL, 'INSPECTION', 'ARC', 'text', NULL, 'Clean of arc', 'event_ud_arc_standard', 'defaultvalue', FALSE, 'arc_cln_exec');
INSERT INTO config_visit_parameter VALUES ('defect_arc', NULL, 'INSPECTION', 'ARC', 'text', NULL, 'Defects of arc', 'event_ud_arc_standard', 'defaultvalue', FALSE, 'arc_defect');

INSERT INTO config_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECTION', 'CONNEC', 'text', NULL, 'Sediments in connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_sed');
INSERT INTO config_visit_parameter VALUES ('clean_connec', NULL, 'INSPECTION', 'CONNEC', 'text', NULL, 'Clean of connec', 'event_standard', 'defaultvalue',FALSE, 'con_cln_exec');
INSERT INTO config_visit_parameter VALUES ('defect_connec', NULL, 'INSPECTION', 'CONNEC', 'text', NULL, 'Defects of connec', 'event_standard', 'defaultvalue', FALSE, 'connec_defect');

INSERT INTO config_visit_parameter VALUES ('sediments_node', NULL, 'INSPECTION', 'NODE', 'text', NULL, 'Sediments in node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_sed');
INSERT INTO config_visit_parameter VALUES ('clean_node', NULL, 'INSPECTION', 'NODE', 'text', NULL, 'Clean of node', 'event_standard', 'defaultvalue',FALSE, 'node_cln_exec');
INSERT INTO config_visit_parameter VALUES ('defect_node', NULL, 'INSPECTION', 'NODE', 'text', NULL, 'Defects of node', 'event_standard', 'defaultvalue', FALSE, 'node_defect');

INSERT INTO config_visit_parameter VALUES ('incident_comment', NULL, 'INSPECTION', 'ALL', 'text', NULL, 'incident_comment', 'event_standard', 'defaultvalue', FALSE, 'incident_comment');
INSERT INTO config_visit_parameter VALUES ('incident_type', NULL, 'INSPECTION', 'ALL', 'text', NULL, 'incident type', 'event_standard', 'defaultvalue', FALSE, 'incident_type');

INSERT INTO config_visit_parameter VALUES ('clean_gully', NULL, 'INSPECTION', 'GULLY', 'text', NULL, 'Clean of gully', 'event_standard', 'defaultvalue',FALSE, 'gully_cln_exec');
INSERT INTO config_visit_parameter VALUES ('smells_gully', NULL, 'INSPECTION', 'GULLY', 'text', NULL, 'Smells of gully', 'event_standard', 'defaultvalue', FALSE, 'smells_gully');


INSERT INTO config_visit_class_x_parameter VALUES (5 , 'sediments_node');
INSERT INTO config_visit_class_x_parameter VALUES (2, 'clean_connec');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'clean_arc');
INSERT INTO config_visit_class_x_parameter VALUES (2, 'sediments_connec');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'sediments_arc');
INSERT INTO config_visit_class_x_parameter VALUES (5, 'defect_node');
INSERT INTO config_visit_class_x_parameter VALUES (5, 'clean_node');
INSERT INTO config_visit_class_x_parameter VALUES (1, 'leak_arc');
INSERT INTO config_visit_class_x_parameter VALUES (3, 'leak_node');
INSERT INTO config_visit_class_x_parameter VALUES (4, 'leak_connec');
INSERT INTO config_visit_class_x_parameter VALUES (8, 'incident_comment');
INSERT INTO config_visit_class_x_parameter VALUES (8, 'incident_type');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'defect_arc');
INSERT INTO config_visit_class_x_parameter VALUES (2, 'defect_arc');
INSERT INTO config_visit_class_x_parameter VALUES (9, 'arc_rehabit_1');
INSERT INTO config_visit_class_x_parameter VALUES (9, 'arc_rehabit_2');
INSERT INTO config_visit_class_x_parameter VALUES (7, 'clean_gully');
INSERT INTO config_visit_class_x_parameter VALUES (7, 'smells_gully');


truncate config_visit_class_x_feature;
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_arc', 1);
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_node', 5);
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_arc', 6);
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_node', 3);
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_connec', 4);
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_connec', 2);
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_gully', 8);
INSERT INTO config_visit_class_x_feature VALUES ('v_edit_arc', 9);


CREATE OR REPLACE VIEW ve_visit_noinfra AS 
 SELECT om_visit.id AS visit_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19) AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19) AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS incident_type,
    a.param_2 AS incident_comment
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''incident_type''),(''incident_comment'')'::text) ct(visit_id integer, param_1 text, param_2 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true;



DROP VIEW IF EXISTS ve_visit_arc_insp;
CREATE OR REPLACE VIEW ve_visit_arc_insp AS 
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
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS sediments_arc,
    a.param_2 AS defect_arc,
    a.param_3 AS clean_arc
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_arc''),(''defect_arc''),(''clean_arc'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true;


DROP VIEW IF EXISTS ve_visit_arc_rehabit;
CREATE OR REPLACE VIEW ve_visit_arc_rehabit AS 
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
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS arc_rehabit_1,
    a.param_2 AS arc_rehabit_2
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''arc_rehabit_1''),(''arc_rehabit_2'')'::text) ct(visit_id integer, param_1 text, param_2 text)) a 
     ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true;

DROP VIEW IF EXISTS ve_visit_node_insp;
CREATE OR REPLACE VIEW ve_visit_node_insp AS 
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
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS sediments_node,
    a.param_2 AS defect_node,
    a.param_3 AS clean_node
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_node''),(''defect_node''),(''clean_node'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true;


DROP VIEW IF EXISTS ve_visit_connec_insp;
CREATE OR REPLACE VIEW ve_visit_connec_insp AS 
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
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS sediments_connec,
    a.param_2 AS defect_connec,
    a.param_3 AS clean_connec
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_connec''),(''defect_connec''),(''clean_connec'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true;


DROP VIEW IF EXISTS ve_visit_gully_insp;
CREATE OR REPLACE VIEW ve_visit_gully_insp AS 
 SELECT om_visit_x_gully.id,
    om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
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
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS clean_gully,
    a.param_2 AS smells_gully
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      LEFT JOIN config_visit_class_x_parameter on config_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id
      where config_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''clean_gully''),(''smells_gully'')'::text) ct(visit_id integer, param_1 text, param_2 text)) a 
     ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true;


INSERT INTO om_typevalue VALUES ('visit_cleaned', 1, 'Yes', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_cleaned', 2, 'No', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_cleaned', 3, 'Half', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_defect', 1, 'Good state', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_defect', 2, 'Some defects', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_defect', 3, 'Bad state', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 1, 'Broken cover', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 2, 'Water on the street', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 3, 'Smells', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 4, 'Noisy cover', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 5, 'Others', NULL, NULL);