/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"expl_id2", "dataType":"integer"}}$$);

CREATE INDEX IF NOT EXISTS gully_exploitation2 ON gully USING btree (expl_id2 ASC NULLS LAST) TABLESPACE pg_default;