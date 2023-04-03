/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"expl_id2", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"expl_id2", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"expl_id2", "dataType":"integer"}}$$);

CREATE INDEX IF NOT EXISTS arc_exploitation2 ON arc USING btree (expl_id2 ASC NULLS LAST) TABLESPACE pg_default;
CREATE INDEX IF NOT EXISTS node_exploitation2 ON node USING btree (expl_id2 ASC NULLS LAST) TABLESPACE pg_default;
CREATE INDEX IF NOT EXISTS connec_exploitation2 ON connec USING btree (expl_id2 ASC NULLS LAST) TABLESPACE pg_default;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"expl_id2", "dataType":"integer"}}$$);

CREATE INDEX IF NOT EXISTS link_exploitation2 ON link USING btree (expl_id2 ASC NULLS LAST) TABLESPACE pg_default;
