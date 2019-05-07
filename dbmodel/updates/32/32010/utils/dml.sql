/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--04/05/2019
INSERT INTO sys_csv2pg_cat VALUES (13, 'Import arc visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat VALUES (14, 'Import arc visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat VALUES (15, 'Import connec visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat VALUES (16, 'Import gully visits', 'Import om visit for arc', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');

INSERT INTO sys_csv2pg_cat VALUES (17, 'Import pattern values from dma flowmeter', 'Import pattern values from dma flowmeter', 
'The csv template is defined on the same function. Open pgadmin to more details', 'role_epa', 'importcsv', 'gw_fct_utils_csv2pg_import_patterns',false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_csv2pg_cat VALUES (18, 'Import om visit', 'Import om visit', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisit');



UPDATE sys_csv2pg_cat SET csv_structure=replace (csv_structure, '- Be careful, csv file needs a header line', '') WHERE id=1;
UPDATE sys_csv2pg_cat SET csv_structure=replace (csv_structure, '- Be careful, csv file needs a header line', '') WHERE id=3;
UPDATE sys_csv2pg_cat SET csv_structure=replace (csv_structure, '- Be careful, csv file needs a header line', '') WHERE id=4;

