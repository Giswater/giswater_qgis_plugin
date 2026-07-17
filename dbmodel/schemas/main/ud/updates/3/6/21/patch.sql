/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_ui_doc_x_arc;
CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT doc_x_arc.doc_id,
    doc_x_arc.id,
    doc_x_arc.arc_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;

DROP VIEW IF EXISTS v_ui_doc_x_connec;
CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT doc_x_connec.doc_id,
    doc_x_connec.id,
    doc_x_connec.connec_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;

DROP VIEW IF EXISTS v_ui_doc_x_gully;
CREATE OR REPLACE VIEW v_ui_doc_x_gully
AS SELECT doc_x_gully.doc_id,
    doc_x_gully.id,
    doc_x_gully.gully_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_gully
     JOIN doc ON doc.id::text = doc_x_gully.doc_id::text;

DROP VIEW IF EXISTS v_ui_doc_x_node;
CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT doc_x_node.doc_id,
    doc_x_node.id,
    doc_x_node.node_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;

DROP VIEW IF EXISTS v_ui_doc_x_psector;
CREATE OR REPLACE VIEW v_ui_doc_x_psector
AS SELECT doc_x_psector.doc_id,
    doc_x_psector.id,
    doc_x_psector.psector_id,
    plan_psector.name AS psector_name,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_psector
     JOIN doc ON doc.id::text = doc_x_psector.doc_id::text
     JOIN plan_psector ON plan_psector.psector_id::text = doc_x_psector.psector_id::text;

DROP VIEW IF EXISTS v_ui_doc_x_visit;
CREATE OR REPLACE VIEW v_ui_doc_x_visit
AS SELECT doc_x_visit.doc_id,
    doc_x_visit.id,
    doc_x_visit.visit_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;

DROP VIEW IF EXISTS v_ui_doc_x_workcat;
CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.doc_id,
    doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;

UPDATE config_csv SET descript='Function to assist the import of timeseries for inp models. The csv file must containts next columns on same position: timseries, timser_type, times_type, idval, expl_id, date, hour, time, value (fill date/hour for ABSOLUTE or time for RELATIVE)' WHERE fid=385;

UPDATE sys_function set sys_role = 'role_epa', source = 'core' where id = 3242;

UPDATE config_toolbox set functionparams = '{"featureType":["node"]}',
inputparams = '[{"widgetname":"buffer", "label":"Buffer (meters):","widgettype":"text","datatype":"float", "layoutname":"grl_option_parameters","layoutorder":3, "isMandatory":true, "value":null}]'
where id = 3242;

CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_connec');

CREATE TRIGGER gw_trg_ui_doc_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_gully');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_node');

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_visit');
