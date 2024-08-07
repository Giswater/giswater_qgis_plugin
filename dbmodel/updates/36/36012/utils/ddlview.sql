/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW if EXISTS v_ui_doc;
CREATE OR REPLACE VIEW v_ui_doc
AS SELECT doc.id,
    doc.name,
    doc.observ,
    doc.doc_type,
    doc.path,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;

--29/07/2024
DROP VIEW if EXISTS v_ui_doc_x_workcat;
CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;

CREATE OR REPLACE VIEW v_ext_municipality AS
SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
   FROM v_ext_streetaxis s
     JOIN ext_municipality m USING (muni_id);

--02/08/2024
DROP VIEW if EXISTS v_ui_doc_x_psector;
CREATE OR REPLACE VIEW v_ui_doc_x_psector AS
SELECT
    doc_x_psector.id,
    plan_psector."name" AS psector_name,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
FROM
    doc_x_psector
JOIN
    doc ON doc.id::text = doc_x_psector.doc_id::text
JOIN
    plan_psector ON plan_psector.psector_id ::text = doc_x_psector.psector_id::text;

--05/08/2024
DROP VIEW if EXISTS v_ui_doc_x_visit;
CREATE OR REPLACE VIEW v_ui_doc_x_visit
AS SELECT doc_x_visit.id,
    doc_x_visit.visit_id,
    doc. "name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;

DROP VIEW if EXISTS v_ui_doc_x_arc;
CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT doc_x_arc.id,
    doc_x_arc.arc_id,
    doc."name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;

DROP VIEW if EXISTS v_ui_doc_x_connec;
CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT doc_x_connec.id,
    doc_x_connec.connec_id,
    doc."name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;

DROP VIEW if EXISTS v_ui_doc_x_node;
CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT doc_x_node.id,
    doc_x_node.node_id,
    doc."name" AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;


--06/08/2024
CREATE OR REPLACE VIEW v_temp_anlgraph AS
SELECT distinct on (arc_id) arc_id, a.node_1, a.node_2, arccat_id, arc_type, state, state_type, is_operative, 
(concat('2001-01-01 01:',checkf/60,':',checkf%60))::timestamp as timestep, trace, the_geom 
FROM temp_anlgraph JOIN v_edit_arc a USING (arc_id) 
WHERE cur_user = current_user;
