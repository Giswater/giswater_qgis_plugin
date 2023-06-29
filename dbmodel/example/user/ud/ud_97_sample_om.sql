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
INSERT INTO om_typevalue VALUES('visit_param_type', 'INCIDENCE', 'INCIDENCE', NULL, NULL);


-- config_visit_class
INSERT INTO config_visit_class VALUES(1, 'Inspection and clean arc', NULL, true, false, true, 'ARC', 'role_om', 1, NULL, 'visit_arc_insp', 've_visit_arc_insp', 'v_ui_visit_arc_insp');
INSERT INTO config_visit_class VALUES(2, 'Inspection and clean node', NULL, true, false, true, 'NODE', 'role_om', 1, NULL, 'visit_node_insp', 've_visit_node_insp', 'v_ui_visit_node_insp');
INSERT INTO config_visit_class VALUES(3, 'Inspection and clean connec', NULL, true, false, true, 'CONNEC', 'role_om', 1, NULL, 'visit_connec_insp', 've_visit_connec_insp', 'v_ui_visit_connec_insp');
INSERT INTO config_visit_class VALUES(4, 'Inspection and clean gully', NULL, true, false, true, 'GULLY', 'role_om', 1, NULL, 'visit_gully_insp', 've_visit_gully_insp', 'v_ui_visit_gully_insp');
INSERT INTO config_visit_class VALUES(5, 'Incident arc', NULL, true, false, true, 'ARC', 'role_om', 2, NULL, 'incident_arc', 've_visit_incid_arc', 'v_ui_visit_incid_arc');
INSERT INTO config_visit_class VALUES(6, 'Incident node', NULL, true, false, true, 'NODE', 'role_om', 2, NULL, 'incident_node', 've_visit_incid_node', 'v_ui_visit_incid_node');
INSERT INTO config_visit_class VALUES(7, 'Incident connec', NULL, true, false, true, 'CONNEC', 'role_om', 2, NULL, 'incident_connec', 've_visit_incid_connec', 'v_ui_visit_incid_connec');
INSERT INTO config_visit_class VALUES(8, 'Incident gully', NULL, true, false, true, 'GULLY', 'role_om', 2, NULL, 'incident_gully', 've_visit_incid_gully', 'v_ui_visit_incid_gully');


-- config_visit_parameter
INSERT INTO config_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECTION', 'ARC', 'text', NULL, 'Sediments in arc', 'event_ud_arc_standard', 'defaultvalue',FALSE, 'arc_insp_sed');
INSERT INTO config_visit_parameter VALUES ('clean_arc', NULL, 'INSPECTION', 'ARC', 'text', NULL, 'Clean of arc', 'event_ud_arc_standard', 'defaultvalue', FALSE, 'arc_cln_exec');
INSERT INTO config_visit_parameter VALUES ('defect_arc', NULL, 'INSPECTION', 'ARC', 'text', NULL, 'Defects of arc', 'event_ud_arc_standard', 'defaultvalue', FALSE, 'arc_defect');

INSERT INTO config_visit_parameter VALUES ('sediments_node', NULL, 'INSPECTION', 'NODE', 'text', NULL, 'Sediments in node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_sed');
INSERT INTO config_visit_parameter VALUES ('clean_node', NULL, 'INSPECTION', 'NODE', 'text', NULL, 'Clean of node', 'event_standard', 'defaultvalue',FALSE, 'node_cln_exec');
INSERT INTO config_visit_parameter VALUES ('defect_node', NULL, 'INSPECTION', 'NODE', 'text', NULL, 'Defects of node', 'event_standard', 'defaultvalue', FALSE, 'node_defect');

INSERT INTO config_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECTION', 'CONNEC', 'text', NULL, 'Sediments in connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_sed');
INSERT INTO config_visit_parameter VALUES ('clean_connec', NULL, 'INSPECTION', 'CONNEC', 'text', NULL, 'Clean of connec', 'event_standard', 'defaultvalue',FALSE, 'con_cln_exec');
INSERT INTO config_visit_parameter VALUES ('defect_connec', NULL, 'INSPECTION', 'CONNEC', 'text', NULL, 'Defects of connec', 'event_standard', 'defaultvalue', FALSE, 'con_defect');

INSERT INTO config_visit_parameter VALUES ('sediments_gully', NULL, 'INSPECTION', 'GULLY', 'text', NULL, 'Sediments in gully', 'event_standard', 'defaultvalue',FALSE, 'gully_insp_sed');
INSERT INTO config_visit_parameter VALUES ('clean_gully', NULL, 'INSPECTION', 'GULLY', 'text', NULL, 'Clean of gully', 'event_standard', 'defaultvalue',FALSE, 'gully_cln_exec');
INSERT INTO config_visit_parameter VALUES ('defect_gully', NULL, 'INSPECTION', 'GULLY', 'text', NULL, 'Defects of gully', 'event_standard', 'defaultvalue', FALSE, 'gully_defect');
INSERT INTO config_visit_parameter VALUES ('smells_gully', NULL, 'INSPECTION', 'GULLY', 'boolean', NULL, 'Smells of gully', 'event_standard', 'defaultvalue', FALSE, 'gully_smells');



INSERT INTO config_visit_parameter VALUES ('incident_comment', NULL, 'INCIDENCE', 'ALL', 'text', NULL, 'incident_comment', 'event_standard', 'defaultvalue', FALSE, 'incident_comment');
INSERT INTO config_visit_parameter VALUES ('incident_type', NULL, 'INCIDENCE', 'ALL', 'text', NULL, 'incident type', 'event_standard', 'defaultvalue', FALSE, 'incident_type');

INSERT INTO config_visit_parameter VALUES ('insp_observ', NULL, 'INSPECTION', 'ALL', 'text', NULL, 'Inspection observations', 'event_standard', 'defaultvalue', FALSE, 'insp_observ');
INSERT INTO config_visit_parameter VALUES ('photo', NULL, 'INSPECTION', 'ALL', 'boolean', NULL, 'Photography', 'event_standard', 'defaultvalue', FALSE, 'photo');


-- config_visit_class_x_parameter
INSERT INTO config_visit_class_x_parameter VALUES (1 , 'sediments_arc');
INSERT INTO config_visit_class_x_parameter VALUES (1 , 'clean_arc');
INSERT INTO config_visit_class_x_parameter VALUES (1 , 'defect_arc');
INSERT INTO config_visit_class_x_parameter VALUES (1 , 'insp_observ');
INSERT INTO config_visit_class_x_parameter VALUES (1 , 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (2 , 'sediments_node');
INSERT INTO config_visit_class_x_parameter VALUES (2 , 'clean_node');
INSERT INTO config_visit_class_x_parameter VALUES (2 , 'defect_node');
INSERT INTO config_visit_class_x_parameter VALUES (2 , 'insp_observ');
INSERT INTO config_visit_class_x_parameter VALUES (2 , 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (3 , 'sediments_connec');
INSERT INTO config_visit_class_x_parameter VALUES (3 , 'clean_connec');
INSERT INTO config_visit_class_x_parameter VALUES (3 , 'defect_connec');
INSERT INTO config_visit_class_x_parameter VALUES (3 , 'insp_observ');
INSERT INTO config_visit_class_x_parameter VALUES (3 , 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (4 , 'sediments_gully');
INSERT INTO config_visit_class_x_parameter VALUES (4 , 'clean_gully');
INSERT INTO config_visit_class_x_parameter VALUES (4 , 'defect_gully');
INSERT INTO config_visit_class_x_parameter VALUES (4 , 'smells_gully');
INSERT INTO config_visit_class_x_parameter VALUES (4 , 'insp_observ');
INSERT INTO config_visit_class_x_parameter VALUES (4 , 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (5, 'incident_type');
INSERT INTO config_visit_class_x_parameter VALUES (5, 'incident_comment');
INSERT INTO config_visit_class_x_parameter VALUES (5, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'incident_type');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'incident_comment');
INSERT INTO config_visit_class_x_parameter VALUES (6, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (7, 'incident_type');
INSERT INTO config_visit_class_x_parameter VALUES (7, 'incident_comment');
INSERT INTO config_visit_class_x_parameter VALUES (7, 'photo');
INSERT INTO config_visit_class_x_parameter VALUES (8, 'incident_type');
INSERT INTO config_visit_class_x_parameter VALUES (8, 'incident_comment');
INSERT INTO config_visit_class_x_parameter VALUES (8, 'photo');



-- editable views with trigger
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
    arc.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS sediments_arc,
    a.param_2 AS defect_arc,
    a.param_3 AS clean_arc,
    a.param_4 AS insp_observ,
    a.param_5 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN arc USING (arc_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 1 ORDER  BY 1,2'::text, 
      ' VALUES (''sediments_arc''),(''defect_arc''),(''clean_arc''),(''insp_observ''),(''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 text, param_5 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 1;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_arc_insp 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('1');



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
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS sediments_node,
    a.param_2 AS defect_node,
    a.param_3 AS clean_node,
    a.param_4 AS insp_observ,
    a.param_5 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 2 ORDER  BY 1,2'::text, 
      ' VALUES (''sediments_node''),(''defect_node''),(''clean_node''),(''insp_observ''),(''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 text, param_5 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 2;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_node_insp 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('2');



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
    connec.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS sediments_connec,
    a.param_2 AS defect_connec,
    a.param_3 AS clean_connec,
    a.param_4 AS insp_observ,
    a.param_5 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN connec USING (connec_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 3 ORDER  BY 1,2'::text, 
      ' VALUES (''sediments_connec''),(''defect_connec''),(''clean_connec''),(''insp_observ''),(''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 text, param_5 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 3;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_connec_insp 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('3');



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
    gully.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS sediments_gully,
    a.param_2 AS defect_gully,
    a.param_3 AS clean_gully,
    a.param_4 AS smells_gully,
    a.param_5 AS insp_observ,
    a.param_6 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN gully USING (gully_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3,
            ct.param_4,
            ct.param_5,
            ct.param_6
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 4 ORDER  BY 1,2'::text, 
      ' VALUES (''sediments_gully''),(''defect_gully''),(''clean_gully''),(''smells_gully''),(''insp_observ''),(''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 text, param_4 boolean, param_5 text, param_6 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 4;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_gully_insp 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('4');




DROP VIEW IF EXISTS ve_visit_incid_arc;
CREATE OR REPLACE VIEW ve_visit_incid_arc AS 
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
    arc.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS incident_type,
    a.param_2 AS incident_comment,
    a.param_3 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN arc USING (arc_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 5 ORDER  BY 1,2'::text, 
      ' VALUES (''incident_type''), (''incident_comment''), (''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 5;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_incid_arc 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('5');



DROP VIEW IF EXISTS ve_visit_incid_node;
CREATE OR REPLACE VIEW ve_visit_incid_node AS 
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
    node.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS incident_type,
    a.param_2 AS incident_comment,
    a.param_3 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN node USING (node_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 6 ORDER  BY 1,2'::text, 
      ' VALUES (''incident_type''), (''incident_comment''), (''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 6;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_incid_node 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('6');



DROP VIEW IF EXISTS ve_visit_incid_connec;
CREATE OR REPLACE VIEW ve_visit_incid_connec AS 
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
    connec.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS incident_type,
    a.param_2 AS incident_comment,
    a.param_3 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN connec USING (connec_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 7 ORDER  BY 1,2'::text, 
      ' VALUES (''incident_type''), (''incident_comment''), (''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 7;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_incid_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('7');



DROP VIEW IF EXISTS ve_visit_incid_gully;
CREATE OR REPLACE VIEW ve_visit_incid_gully AS 
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
    gully.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    a.param_1 AS incident_type,
    a.param_2 AS incident_comment,
    a.param_3 AS photo
   FROM om_visit
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN gully USING (gully_id)
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN config_visit_class on config_visit_class.id=om_visit.class_id
      where config_visit_class.ismultievent = TRUE and om_visit.class_id = 8 ORDER  BY 1,2'::text, 
      ' VALUES (''incident_type''), (''incident_comment''), (''photo'')'::text) 
      ct(visit_id integer, param_1 text, param_2 text, param_3 boolean)) a ON a.visit_id = om_visit.id
  WHERE config_visit_class.ismultievent = true AND config_visit_class.id = 8;
  
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF
INSERT OR DELETE OR UPDATE ON ve_visit_incid_gully 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('8');



-- UI views
CREATE OR REPLACE VIEW v_ui_visit_arc_insp
AS SELECT ve_visit_arc_insp.visit_id,
    ve_visit_arc_insp.arc_id,
    ve_visit_arc_insp.startdate AS "Start date",
    ve_visit_arc_insp.enddate AS "End date",
    ve_visit_arc_insp.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    ve_visit_arc_insp.sediments_arc AS "Sediments",
    u.idval AS "Defects",
    y.idval AS "Cleaned",
    ve_visit_arc_insp.insp_observ AS "Observation",
    ve_visit_arc_insp.photo AS "Photo",
    ve_visit_arc_insp.the_geom
   FROM ve_visit_arc_insp
     JOIN config_visit_class c ON c.id = ve_visit_arc_insp.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_arc_insp.status AND t.typevalue = 'visit_status'::text
     LEFT JOIN om_typevalue y ON y.id::integer = ve_visit_arc_insp.clean_arc::integer AND y.typevalue = 'visit_cleaned'::text
     LEFT JOIN om_typevalue u ON u.id::integer = ve_visit_arc_insp.defect_arc::integer AND u.typevalue = 'visit_defect'::text;
     
     
     
CREATE OR REPLACE VIEW v_ui_visit_node_insp
AS SELECT ve_visit_node_insp.visit_id,
    ve_visit_node_insp.node_id,
    ve_visit_node_insp.startdate AS "Start date",
    ve_visit_node_insp.enddate AS "End date",
    ve_visit_node_insp.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    ve_visit_node_insp.sediments_node AS "Sediments",
    u.idval AS "Defects",
    y.idval AS "Cleaned",
    ve_visit_node_insp.insp_observ AS "Observation",
    ve_visit_node_insp.photo AS "Photo",
    ve_visit_node_insp.the_geom
   FROM ve_visit_node_insp
     JOIN config_visit_class c ON c.id = ve_visit_node_insp.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_node_insp.status AND t.typevalue = 'visit_status'::text
     LEFT JOIN om_typevalue y ON y.id::integer = ve_visit_node_insp.clean_node::integer AND y.typevalue = 'visit_cleaned'::text
     LEFT JOIN om_typevalue u ON u.id::integer = ve_visit_node_insp.defect_node::integer AND u.typevalue = 'visit_defect'::text;
     
     
     
CREATE OR REPLACE VIEW v_ui_visit_connec_insp
AS SELECT ve_visit_connec_insp.visit_id,
    ve_visit_connec_insp.connec_id,
    ve_visit_connec_insp.startdate AS "Start date",
    ve_visit_connec_insp.enddate AS "End date",
    ve_visit_connec_insp.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    ve_visit_connec_insp.sediments_connec AS "Sediments",
    u.idval AS "Defects",
    y.idval AS "Cleaned",
    ve_visit_connec_insp.insp_observ AS "Observation",
    ve_visit_connec_insp.photo AS "Photo",
    ve_visit_connec_insp.the_geom
   FROM ve_visit_connec_insp
     JOIN config_visit_class c ON c.id = ve_visit_connec_insp.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_connec_insp.status AND t.typevalue = 'visit_status'::text
     LEFT JOIN om_typevalue y ON y.id::integer = ve_visit_connec_insp.clean_connec::integer AND y.typevalue = 'visit_cleaned'::text
     LEFT JOIN om_typevalue u ON u.id::integer = ve_visit_connec_insp.defect_connec::integer AND u.typevalue = 'visit_defect'::text;
     
     
     
CREATE OR REPLACE VIEW v_ui_visit_gully_insp
AS SELECT ve_visit_gully_insp.visit_id,
    ve_visit_gully_insp.gully_id,
    ve_visit_gully_insp.startdate AS "Start date",
    ve_visit_gully_insp.enddate AS "End date",
    ve_visit_gully_insp.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    ve_visit_gully_insp.sediments_gully AS "Sediments",
    u.idval AS "Defects",
    y.idval AS "Cleaned",
    ve_visit_gully_insp.smells_gully AS "Smells",
    ve_visit_gully_insp.insp_observ AS "Observation",
    ve_visit_gully_insp.photo AS "Photo",
    ve_visit_gully_insp.the_geom
   FROM ve_visit_gully_insp
     JOIN config_visit_class c ON c.id = ve_visit_gully_insp.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_gully_insp.status AND t.typevalue = 'visit_status'::text
     LEFT JOIN om_typevalue y ON y.id::integer = ve_visit_gully_insp.clean_gully::integer AND y.typevalue = 'visit_cleaned'::text
     LEFT JOIN om_typevalue u ON u.id::integer = ve_visit_gully_insp.defect_gully::integer AND u.typevalue = 'visit_defect'::text;
     
     
     
CREATE OR REPLACE VIEW v_ui_visit_incid_arc
AS SELECT ve_visit_incid_arc.visit_id,
    ve_visit_incid_arc.arc_id,
    ve_visit_incid_arc.startdate AS "Start date",
    ve_visit_incid_arc.enddate AS "End date",
    ve_visit_incid_arc.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    y.idval AS "Incident type",
    ve_visit_incid_arc.incident_comment AS "Comment",
    ve_visit_incid_arc.photo AS "Photo",
    ve_visit_incid_arc.the_geom
   FROM ve_visit_incid_arc
     JOIN config_visit_class c ON c.id = ve_visit_incid_arc.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_incid_arc.status AND t.typevalue = 'visit_status'::text
     JOIN om_typevalue y ON y.id::integer = ve_visit_incid_arc.incident_type::integer AND y.typevalue = 'incident_type'::text;
     
     
     
CREATE OR REPLACE VIEW v_ui_visit_incid_node
AS SELECT ve_visit_incid_node.visit_id,
    ve_visit_incid_node.node_id,
    ve_visit_incid_node.startdate AS "Start date",
    ve_visit_incid_node.enddate AS "End date",
    ve_visit_incid_node.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    y.idval AS "Incident type",
    ve_visit_incid_node.incident_comment AS "Comment",
    ve_visit_incid_node.photo AS "Photo",
    ve_visit_incid_node.the_geom
   FROM ve_visit_incid_node
     JOIN config_visit_class c ON c.id = ve_visit_incid_node.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_incid_node.status AND t.typevalue = 'visit_status'::text
     JOIN om_typevalue y ON y.id::integer = ve_visit_incid_node.incident_type::integer AND y.typevalue = 'incident_type'::text;
     
     
     
CREATE OR REPLACE VIEW v_ui_visit_incid_connec
AS SELECT ve_visit_incid_connec.visit_id,
    ve_visit_incid_connec.connec_id,
    ve_visit_incid_connec.startdate AS "Start date",
    ve_visit_incid_connec.enddate AS "End date",
    ve_visit_incid_connec.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    y.idval AS "Incident type",
    ve_visit_incid_connec.incident_comment AS "Comment",
    ve_visit_incid_connec.photo AS "Photo",
    ve_visit_incid_connec.the_geom
   FROM ve_visit_incid_connec
     JOIN config_visit_class c ON c.id = ve_visit_incid_connec.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_incid_connec.status AND t.typevalue = 'visit_status'::text
     JOIN om_typevalue y ON y.id::integer = ve_visit_incid_connec.incident_type::integer AND y.typevalue = 'incident_type'::text;
     
     
     
CREATE OR REPLACE VIEW v_ui_visit_incid_gully
AS SELECT ve_visit_incid_gully.visit_id,
    ve_visit_incid_gully.gully_id,
    ve_visit_incid_gully.startdate AS "Start date",
    ve_visit_incid_gully.enddate AS "End date",
    ve_visit_incid_gully.user_name AS "User",
    c.idval AS "Visit class",
    t.idval AS "Status",
    y.idval AS "Incident type",
    ve_visit_incid_gully.incident_comment AS "Comment",
    ve_visit_incid_gully.photo AS "Photo",
    ve_visit_incid_gully.the_geom
   FROM ve_visit_incid_gully
     JOIN config_visit_class c ON c.id = ve_visit_incid_gully.class_id
     JOIN om_typevalue t ON t.id::integer = ve_visit_incid_gully.status AND t.typevalue = 'visit_status'::text
     JOIN om_typevalue y ON y.id::integer = ve_visit_incid_gully.incident_type::integer AND y.typevalue = 'incident_type'::text;
     
     
     
/*
visit_arc_insp - visitclass=1
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'arc_id', 'lyt_data_1', NULL, 'double', 'text', 'Arc id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'sediments_arc', 'lyt_data_1', NULL, 'string', 'text', 'Sediments arc:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'defect_arc', 'lyt_data_1', NULL, 'string', 'combo', 'Defect arc:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'clean_arc', 'lyt_data_1', NULL, 'integer', 'combo', 'Clean arc:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'insp_observ', 'lyt_data_1', NULL, 'string', 'text', 'Observations:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 8);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 9);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);


-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_arc_insp', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);



/*
visit_node_insp - visitclass=2
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'node_id', 'lyt_data_1', NULL, 'double', 'text', 'Node id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'sediments_node', 'lyt_data_1', NULL, 'string', 'text', 'Sediments node:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'defect_node', 'lyt_data_1', NULL, 'string', 'combo', 'Defect node:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'clean_node', 'lyt_data_1', NULL, 'integer', 'combo', 'Clean node:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'insp_observ', 'lyt_data_1', NULL, 'string', 'text', 'Observations:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 8);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 9);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);


-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_node_insp', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);



/*
visit_connec_insp - visitclass=3
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'connec_id', 'lyt_data_1', NULL, 'double', 'text', 'Connec id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'sediments_connec', 'lyt_data_1', NULL, 'string', 'text', 'Sediments connec:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'defect_connec', 'lyt_data_1', NULL, 'string', 'combo', 'Defect connec:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'clean_connec', 'lyt_data_1', NULL, 'integer', 'combo', 'Clean connec:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'insp_observ', 'lyt_data_1', NULL, 'string', 'text', 'Observations:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 8);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 9);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);


-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_connec_insp', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);
     


/*
visit_gully_insp - visitclass=4
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''GULLY'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'gully_id', 'lyt_data_1', NULL, 'double', 'text', 'Gully id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'sediments_gully', 'lyt_data_1', NULL, 'string', 'text', 'Sediments gully:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'defect_gully', 'lyt_data_1', NULL, 'string', 'combo', 'Defect gully:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'clean_gully', 'lyt_data_1', NULL, 'integer', 'combo', 'Clean gully:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'smells_gully', 'lyt_data_1', NULL, 'boolean', 'check', 'Smells gully:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 8);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'insp_observ', 'lyt_data_1', NULL, 'string', 'text', 'Observations:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 9);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 10);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);


-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('visit_gully_insp', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);
     


/*
incident_arc - visitclass=5
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'arc_id', 'lyt_data_1', NULL, 'double', 'text', 'Arc id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'incident_type', 'lyt_data_1', NULL, 'integer', 'combo', 'Incident type:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'incident_comment', 'lyt_data_1', NULL, 'string', 'text', 'Comment:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);

-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_arc', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);



/*
incident_node - visitclass=6
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'node_id', 'lyt_data_1', NULL, 'double', 'text', 'Node id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'incident_type', 'lyt_data_1', NULL, 'integer', 'combo', 'Incident type:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'incident_comment', 'lyt_data_1', NULL, 'string', 'text', 'Comment:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);

-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_node', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);



/*
incident_connec - visitclass=7
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'connec_id', 'lyt_data_1', NULL, 'double', 'text', 'Connec id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'incident_type', 'lyt_data_1', NULL, 'integer', 'combo', 'Incident type:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'incident_comment', 'lyt_data_1', NULL, 'string', 'text', 'Comment:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);

-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_connec', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);



/*
incident_gully - visitclass=8
*/
-- lyt_data_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'class_id', 'lyt_data_1', NULL, 'integer', 'combo', 'Visit class:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM config_visit_class WHERE feature_type=''GULLY'' AND  active IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "get_visit"}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'gully_id', 'lyt_data_1', NULL, 'double', 'text', 'Gully id:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'startdate', 'lyt_data_1', NULL, 'date', 'datetime', 'Date:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'incident_type', 'lyt_data_1', NULL, 'integer', 'combo', 'Incident type:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''incident_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'incident_comment', 'lyt_data_1', NULL, 'string', 'text', 'Comment:', NULL, NULL, false, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'status', 'lyt_data_1', NULL, 'integer', 'combo', 'Status:', NULL, NULL, false, false, true, NULL, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_status'' and id =''4''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 7);

-- lyt_data_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_data', 'acceptbutton', 'lyt_data_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Accept"}'::json, '{
  "functionName": "set_visit"
}'::json, NULL, false, 1);

-- lyt_files_1
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_file', 'addfile', 'lyt_files_1', NULL, NULL, 'fileselector', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Add File"}'::json, '{
  "functionName": "add_file"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_file', 'tbl_files', 'lyt_files_1', NULL, NULL, 'tableview', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'om_visit_event_photo', false, 2);

-- lyt_files_2
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('incident_gully', 'form_visit', 'tab_file', 'backbutton', 'lyt_files_2', NULL, NULL, 'button', '', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "text":"Back"}'::json, '{
  "functionName": "set_previous_form_back"
}'::json, NULL, false, 1);



-- config_form_tabs
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_arc_insp', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_arc_insp', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_node_insp', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_node_insp', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_connec_insp', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_connec_insp', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_gully_insp', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('visit_gully_insp', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_arc', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_arc', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_node', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_node', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_connec', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_connec', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_gully', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":true}, "tabFiles":{"active":false}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false}]'::json, 1, '{5}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('incident_gully', 'tab_file', 'Files', 'Files', 'role_om', '{"name":"gwGetVisit", "parameters":{"form":{"tabData":{"active":false},"tabFiles":{"active":true, "feature":{"tableName":"om_visit_event_photo"}}}}}'::json, '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add file", "disabled":false},{"actionName":"actionDeleteFile", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "disabled":false}]'::json, 2, '{5}');

GRANT ALL ON TABLE ve_visit_arc_insp TO role_om;
GRANT ALL ON TABLE ve_visit_connec_insp TO role_om;
GRANT ALL ON TABLE ve_visit_node_insp TO role_om;
GRANT ALL ON TABLE ve_visit_gully_insp TO role_om;

GRANT ALL ON TABLE ve_visit_incid_arc TO role_om;
GRANT ALL ON TABLE ve_visit_incid_node TO role_om;
GRANT ALL ON TABLE ve_visit_incid_connec TO role_om;
GRANT ALL ON TABLE ve_visit_incid_gully TO role_om;

GRANT ALL ON TABLE v_ui_visit_arc_insp TO role_om;
GRANT ALL ON TABLE v_ui_visit_connec_insp TO role_om;
GRANT ALL ON TABLE v_ui_visit_node_insp TO role_om;
GRANT ALL ON TABLE v_ui_visit_gully_insp TO role_om;

GRANT ALL ON TABLE v_ui_visit_incid_arc TO role_om;
GRANT ALL ON TABLE v_ui_visit_incid_node TO role_om;
GRANT ALL ON TABLE v_ui_visit_incid_connec TO role_om;
GRANT ALL ON TABLE v_ui_visit_incid_gully TO role_om;
