--om_visit_parameter
--------------------
ALTER TABLE ws_sample.om_visit_parameter ADD COLUMN short_descript varchar(30);


INSERT INTO ws_sample.om_visit_parameter VALUES ('desperfectes_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Desperfectes en arc', 'event_standard', 'f', 'arc_insp_des');
INSERT INTO ws_sample.om_visit_parameter VALUES ('desperfectes_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Desperfectes en node', 'event_standard', 'f', 'node_insp_des');
INSERT INTO ws_sample.om_visit_parameter VALUES ('neteja_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Neteja del arc', 'event_standard', 'g', 'arc_cln_exec');
INSERT INTO ws_sample.om_visit_parameter VALUES ('neteja_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Neteja del node', 'event_standard', 'g', 'node_cln_exec');
INSERT INTO ws_sample.om_visit_parameter VALUES ('neteja_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Neteja del connec', 'event_standard', 'g', 'con_cln_exec');
INSERT INTO ws_sample.om_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Sediments en arc', 'event_standard', 'e', 'arc_insp_sed');
INSERT INTO ws_sample.om_visit_parameter VALUES ('desperfectes_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Desperfectes en connec', 'event_standard', 'f', 'con_insp_des');
INSERT INTO ws_sample.om_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Sediments en connec', 'event_standard', 'e', 'con_insp_sed');
INSERT INTO ws_sample.om_visit_parameter VALUES ('sediments_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Sediments en node', 'event_standard', 'e', 'node_insp_sed');


--om_visit_class_x_parameter
----------------------------
drop table if exists ws_sample.om_visit_class_x_parameter;
CREATE TABLE ws_sample.om_visit_class_x_parameter (
    id serial primary key,
    class_id integer NOT NULL,
    parameter_id character varying(50) NOT NULL
);


INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (2, 2, 'neteja_connec');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (3, 2, 'desperfectes_connec');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (5, 5, 'desperfectes_arc');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (6, 5, 'neteja_arc');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (4, 2, 'sediments_connec');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (7, 5, 'sediments_arc');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (8, 6, 'desperfectes_node');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (9, 6, 'neteja_node');
INSERT INTO ws_sample.om_visit_class_x_parameter VALUES (10, 6, 'sediments_node');


ALTER TABLE ONLY ws_sample.om_visit_class_x_parameter
    ADD CONSTRAINT om_visit_class_x_parameter_class_fkey FOREIGN KEY (class_id) REFERENCES ws_sample.om_visit_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY ws_sample.om_visit_class_x_parameter
    ADD CONSTRAINT om_visit_class_x_parameter_parameter_fkey FOREIGN KEY (parameter_id) REFERENCES ws_sample.om_visit_parameter(id) ON UPDATE CASCADE ON DELETE RESTRICT;

