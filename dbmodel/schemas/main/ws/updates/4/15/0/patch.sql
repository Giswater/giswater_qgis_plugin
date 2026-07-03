/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- pg2epa geographic SRID validation: gw_fct_pg2epa_main (step 1) and gw_fct_pg2epa_export_inp (base/fct, applied via load_base / reload_fct_ftrg).

INSERT INTO config_mapzones (id, abrevation, descript, fid, code_autofill, active, is_dynamic) VALUES
('MACROCRMZONE', 'MAC', 'Macrocrmzone', NULL, false, false, false),
('MACRODQA', 'MAC', 'Macrodqa', NULL, true, true, true),
('CRMZONE', 'CRM', 'Crmzone', NULL, false, false, false),
('PRESSZONE', 'PZ', 'Pressure Zone', 146, true, true, true),
('DQA', 'DQA', 'Distribution Quality Area', 144, true, true, true),
('SUPPLYZONE', 'SUP', 'Supply Zone', 712, true, true, true)
ON CONFLICT (id) DO NOTHING;
