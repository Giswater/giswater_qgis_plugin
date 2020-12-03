/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--17/02/2020
ALTER TABLE arc_type ALTER COLUMN epa_table SET NOT NULL;
ALTER TABLE arc_type ALTER COLUMN active SET NOT NULL;
ALTER TABLE arc_type ALTER COLUMN code_autofill SET NOT NULL;

ALTER TABLE connec_type ALTER COLUMN active SET NOT NULL;
ALTER TABLE connec_type ALTER COLUMN code_autofill SET NOT NULL;

ALTER TABLE node_type ALTER COLUMN epa_table SET NOT NULL;
ALTER TABLE node_type ALTER COLUMN active SET NOT NULL;
ALTER TABLE node_type ALTER COLUMN code_autofill SET NOT NULL;
ALTER TABLE node_type ALTER COLUMN choose_hemisphere SET NOT NULL;
ALTER TABLE node_type ALTER COLUMN isarcdivide SET NOT NULL;