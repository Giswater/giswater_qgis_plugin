/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--04/05/2019
INSERT INTO sys_csv2pg_cat VALUES (17, 'Import pattern values from dma flowmeter', 'Import pattern values from dma flowmeter', 'The csv template is defined on the same function. Open pgadmin to more details', 'role_epa');
ON CONFLICT (id) DO NOTHING;

