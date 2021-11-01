/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/30
ALTER TABLE cat_arc ALTER COLUMN shape SET DEFAULT 'CIRCULAR';

ALTER TABLE inp_tags DROP CONSTRAINT inp_tags_pkey;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_tags", "column":"object", "newName":"feature_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_tags", "column":"node_id", "newName":"feature_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_tags", "column":"id"}}$$);

ALTER TABLE inp_tags ADD CONSTRAINT inp_tags_pkey PRIMARY KEY(feature_type, feature_id);


