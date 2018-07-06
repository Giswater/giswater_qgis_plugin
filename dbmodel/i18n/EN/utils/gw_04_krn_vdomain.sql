/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO sys_csv2pg_cat VALUES (1, 'Import db prices', 'Import db prices', 
'The csv file must contains next columns on same position: id, unit, descript, text, price. 
- The column price must be numeric with two decimals. 
- You can choose a catalog name for these prices setting an import label. 
- Be careful, csv file needs a header line', 'role_master');
INSERT INTO sys_csv2pg_cat VALUES (2, 'Import om visit table', 'Import om visit table', 'The csv file must contains next columns on same position: node_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (3, 'Import elements', 'Import elements', 
'The csv file must containts next columns on same position: feature_id, elementcat_id, observ, comment, num_elements. 
- You have to fill Import label with the element type you need to import (node, arc, connec, gully).
- Observ and Comment fields are opcional.
- Be careful, csv file needs a header line', 'role_admin');
INSERT INTO sys_csv2pg_cat VALUES (4, 'Import addfields', 'Import addfields', 'The csv file must containts next columns on same position: 
feature_id (can be arc, node or connec), parameter_id (choose from man_addfields_parameter), value_param. 
- Import label is mandatory, but you can put whatever you what in this option. 
- Be careful, csv file needs a header line', 'role_admin');

