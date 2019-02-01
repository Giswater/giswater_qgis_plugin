/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- incorporate constraints not defined on 31
--------------------------------------------
ALTER TABLE node ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE arc ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE connec ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE element ALTER COLUMN state_type SET NOT NULL;

ALTER TABLE node ALTER COLUMN state SET NOT NULL;
ALTER TABLE arc ALTER COLUMN state SET NOT NULL;
ALTER TABLE connec ALTER COLUMN state SET NOT NULL;
ALTER TABLE element ALTER COLUMN state SET NOT NULL;

