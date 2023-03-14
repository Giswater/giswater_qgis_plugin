/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"gully", "column":"pol_id", "newName":"_pol_id_"}}$$);

ALTER TABLE cat_arc ALTER COLUMN geom5 DROP DEFAULT;
ALTER TABLE cat_arc ALTER COLUMN geom6 DROP DEFAULT;
ALTER TABLE cat_arc ALTER COLUMN geom7 DROP DEFAULT;
ALTER TABLE cat_arc ALTER COLUMN geom8 DROP DEFAULT;