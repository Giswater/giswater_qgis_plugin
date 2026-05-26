/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--23/12/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"streetname2", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"link", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_gully_traceability", "column":"streetname", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_gully_traceability", "column":"streetname2", "dataType":"varchar(100)"}}$$);
