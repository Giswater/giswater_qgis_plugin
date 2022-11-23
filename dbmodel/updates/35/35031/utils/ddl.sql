/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch SCHEMA "public";

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"field_date", "dataType":"timestamp(6) without time zone", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_arc", "column":"field_date", "dataType":"timestamp(6) without time zone", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_connec", "column":"field_date", "dataType":"timestamp(6) without time zone", "isUtils":"False"}}$$);