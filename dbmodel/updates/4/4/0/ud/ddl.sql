/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 17/09/2025
ALTER TABLE element_x_gully DROP CONSTRAINT IF EXISTS element_x_gully_element_id_fkey;
ALTER TABLE element_x_gully DROP CONSTRAINT IF EXISTS element_x_gully_gully_id_fkey;
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;

-- 25/09/2025 add uuid to tables
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element_x_gully", "column":"gully_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_x_gully", "column":"gully_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"doc_x_gully", "column":"gully_uuid", "dataType":"uuid"}}$$);