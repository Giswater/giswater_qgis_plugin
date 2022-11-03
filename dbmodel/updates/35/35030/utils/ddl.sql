/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/26
CREATE INDEX plan_psector_psector_id
  ON plan_psector
  USING btree (psector_id);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_fields", "column":"web_layoutorder", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_workspace", "column":"iseditable", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE cat_workspace ALTER COLUMN iseditable SET DEFAULT TRUE;