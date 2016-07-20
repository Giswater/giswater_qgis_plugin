/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_doc_x_node AS 
SELECT
doc_x_node.id,
doc_x_node.node_id,
doc.doc_type,
doc_x_node.doc_id,
doc.path,
doc.observ,
doc.tagcat_id,
doc.date,
doc.user
FROM SCHEMA_NAME.doc_x_node
JOIN SCHEMA_NAME.doc ON doc.id::text = doc_x_node.doc_id::text;





CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_doc_x_arc AS
SELECT 
doc_x_arc.id,
doc_x_arc.arc_id,
doc.doc_type,
doc_x_arc.doc_id,
doc.path,
doc.observ,
doc.tagcat_id,
doc.date,
doc.user
FROM SCHEMA_NAME.doc_x_arc
JOIN SCHEMA_NAME.doc ON doc.id::text = doc_x_arc.doc_id::text;




CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_doc_x_connec AS
SELECT
doc_x_connec.id,
doc_x_connec.connec_id,
doc.doc_type,
doc_x_connec.doc_id,
doc.path,
doc.observ,
doc.tagcat_id,
doc.date,
doc.user
FROM SCHEMA_NAME.doc_x_connec
JOIN SCHEMA_NAME.doc ON doc.id::text = doc_x_connec.doc_id::text;