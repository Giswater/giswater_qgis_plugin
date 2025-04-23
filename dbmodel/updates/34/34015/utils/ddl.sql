/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/06/21
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_function", "column":"layermanager", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_function", "column":"sytle", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_function", "column":"actions", "dataType":"json"}}$$);


CREATE TABLE sys_style (
id serial PRIMARY KEY,
idval text,
styletype varchar(24),
stylevalue text,
active boolean);

ALTER TABLE config_form_tabs ADD COLUMN orderby integer;