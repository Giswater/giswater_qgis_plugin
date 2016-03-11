/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE VIEW SCHEMA_NAME.v_doc_x_node AS
SELECT 
doc.id,
doc.doccat_id,
doc.path,
doc.observ,
doc.tag,
node.the_geom
FROM SCHEMA_NAME.doc
JOIN SCHEMA_NAME.doc_x_node ON doc_x_node.doc_id::text = doc.id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = doc_x_node.node_id::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_doc_x_arc AS
SELECT 
doc.id,
doc.doccat_id,
doc.path,
doc.observ,
doc.tag,
arc.the_geom
FROM SCHEMA_NAME.doc
JOIN SCHEMA_NAME.doc_x_arc ON doc_x_arc.doc_id::text = doc.id::text
JOIN SCHEMA_NAME.arc ON arc.arc_id::text = doc_x_arc.arc_id::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_doc_x_connec AS
SELECT 
doc.id,
doc.doccat_id,
doc.path,
doc.observ,
doc.tag,
connec.the_geom
FROM SCHEMA_NAME.doc
JOIN SCHEMA_NAME.doc_x_connec ON doc_x_connec.doc_id::text = doc.id::text
JOIN SCHEMA_NAME.connec ON connec.connec_id::text = doc_x_connec.connec_id::text;

