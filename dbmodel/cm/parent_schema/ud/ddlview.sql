/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;


CREATE OR REPLACE VIEW v_ui_doc_x_gully
AS
SELECT
	doc_x_gully.doc_id,
	doc_x_gully.gully_id,
	doc.name,
	doc.doc_type,
	doc.path,
	doc.observ,
	doc.date,
	doc.user_name,
	doc_x_gully.gully_uuid
FROM cm.doc_x_gully
JOIN cm.doc ON doc.id::text = doc_x_gully.doc_id::text;

GRANT ALL ON TABLE v_ui_doc_x_gully TO role_cm_manager;
GRANT ALL ON TABLE v_ui_doc_x_gully TO role_cm_field;

