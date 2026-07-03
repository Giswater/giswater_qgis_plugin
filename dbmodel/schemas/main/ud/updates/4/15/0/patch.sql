/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- pg2epa geographic SRID validation: gw_fct_pg2epa_main (step 1), gw_fct_pg2epa_export_inp and gw_fct_pg2epa_dump_subcatch (base/fct, applied via load_base / reload_fct_ftrg).

INSERT INTO config_mapzones (id, abrevation, descript, fid, code_autofill, active, is_dynamic) VALUES
('DWFZONE', 'DWF', 'Drainage Water Flow Zone', 481, true, true, true),
('DRAINZONE', 'DRA', 'Drainage Zone', 481, true, true, false),
