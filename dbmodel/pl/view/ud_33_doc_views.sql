/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP VIEW IF EXISTS v_ui_doc_x_gully CASCADE;
CREATE OR REPLACE VIEW v_ui_doc_x_gully AS
SELECT
doc_x_gully.id,
doc_x_gully.gully_id,
doc_x_gully.doc_id,
doc.doc_type,
doc.path,
doc.observ,
doc.date,
doc.user_name
FROM doc_x_gully
JOIN doc ON doc.id = doc_x_gully.doc_id;
