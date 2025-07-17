/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/07/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_valve", "column":"pression_exit", "newName":"pressure_exit"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_valve", "column":"pression_entry", "newName":"pressure_entry"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"man_pump", "column":"pressure", "newName":"pressure_exit"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc", "column":"staticpress1", "newName":"staticpressure1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc", "column":"staticpress2", "newName":"staticpressure2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"staticpressure", "newName":"staticpressure1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"staticpressure2", "dataType":"numeric(12,3)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_arc_traceability", "column":"staticpress1", "newName":"staticpressure1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"archived_psector_arc_traceability", "column":"staticpress2", "newName":"staticpressure2"}}$$);

-- 15/07/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc_add", "column":"mincut_impact", "newName":"mincut_impact_topo"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc_add", "column":"mincut_affectation", "newName":"mincut_impact_hydro"}}$$);
