/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE om_visit ALTER COLUMN is_done SET DEFAULT TRUE;

ALTER TABLE value_state_type ALTER COLUMN is_operative SET DEFAULT TRUE;
ALTER TABLE value_state_type ALTER COLUMN is_doable SET DEFAULT TRUE;

