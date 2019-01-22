/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE TABLE SCHEMA_NAME.config_api_form_fields
(
  id serial NOT NULL,
  formname character varying(50) NOT NULL,
  formtype character varying(50) NOT NULL,
  column_id character varying(30) NOT NULL,
  layout_id integer,
  layout_order integer,
  isenabled boolean,
  datatype character varying(30),
  widgettype character varying(30),
  label text,
  widgetdim integer,
  tooltip text,
  placeholder text,
  field_length integer,
  num_decimals integer,
  ismandatory boolean,
  isparent boolean,
  iseditable boolean,
  isautoupdate boolean,
  dv_querytext text,
  dv_orderby_id boolean,
  dv_isnullvalue boolean,
  dv_parent_id text,
  dv_querytext_filterc text,
  widgetfunction text,
  action_function text,
  isreload boolean,
  stylesheet json,
  isnotupdate boolean,
  threshold integer
  CONSTRAINT config_api_form_fields_pkey PRIMARY KEY (id),
  CONSTRAINT config_api_form_fields_pkey2 UNIQUE (formname, formtype, column_id)
)
WITH (
  OIDS=FALSE
);




INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28220, 'visit_arc_insp', 'visit', 'visit_id', 1, 1, true, NULL, 'linetext', 'Visit id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28230, 'visit_arc_insp', 'visit', 'arc_id', 1, 2, true, NULL, 'linetext', 'Arc_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28250, 'visit_arc_insp', 'visit', 'visit_code', 1, 4, true, NULL, 'linetext', 'visit_code', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28260, 'visit_arc_insp', 'visit', 'sediments_arc', 1, 5, true, NULL, 'linetext', 'Sediments:', NULL, NULL, 'Ex.: 10 (en cmts.)', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28270, 'visit_arc_insp', 'visit', 'desperfectes_arc', 1, 6, true, NULL, 'linetext', 'Despefectes:', NULL, NULL, 'Ex.: 10 (en cmts.)', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28280, 'visit_arc_insp', 'visit', 'neteja_arc', 1, 7, true, NULL, 'combo', 'Netejat:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28070, 'visit_node_insp', 'visit', 'visit_id', 1, 1, true, NULL, 'linetext', 'Visit id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28090, 'visit_node_insp', 'visit', 'visitcat_id', 1, 3, true, NULL, 'combo', 'visitcat_id', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28100, 'visit_node_insp', 'visit', 'visit_code', 1, 4, true, NULL, 'linetext', 'visit_code', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28140, 'visit_connec_leak', 'visit', 'event_id', 1, 1, true, NULL, 'linetext', 'event_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28160, 'visit_connec_leak', 'visit', 'visitcat_id', 1, 3, true, NULL, 'combo', 'visitcat_id', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28170, 'visit_connec_leak', 'visit', 'visit_code', 1, 4, true, NULL, 'linetext', 'visit_code', NULL, NULL, 'Ex.: Work order code', NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28240, 'visit_arc_insp', 'visit', 'visitcat_id', 1, 3, true, NULL, 'combo', 'visitcat_id', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28080, 'visit_node_insp', 'visit', 'node_id', 1, 2, true, NULL, 'linetext', 'Node_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28120, 'visit_node_insp', 'visit', 'desperfectes_node', 1, 6, true, NULL, 'linetext', 'Despefectes:', NULL, NULL, 'Ex.: 10 (en cmts.)', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28218, 'visit_arc_insp', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28138, 'visit_connec_leak', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (28068, 'visit_node_insp', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27988, 'visit_node_leak', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27298, 'visit_connec_insp', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27218, 'visit_arc_leak', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM SCHEMA_NAME.om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27300, 'visit_connec_insp', 'visit', 'visit_id', 1, 1, true, 'integer', 'linetext', 'Visit id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27280, 'visit_arc_leak', 'visit', 'position_value', 1, 7, true, 'integer', 'linetext', 'position_value', NULL, NULL, 'Ex.: 34.57', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27360, 'visit_connec_insp', 'visit', 'neteja_connec', 1, 7, true, 'string', 'combo', 'Netejat:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27220, 'visit_arc_leak', 'visit', 'event_id', 1, 1, true, 'integer', 'linetext', 'event_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SCHEMA_NAME.config_api_form_fields VALUES (27230, 'visit_arc_leak', 'visit', 'visit_id', 1, 2, true, 'integer', 'linetext', 'visit_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
