/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE arc ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE arc ALTER COLUMN workcat_id SET NOT NULL;
--ALTER TABLE arc ALTER COLUMN builtdate SET NOT NULL;
ALTER TABLE arc ALTER COLUMN verified SET NOT NULL;
ALTER TABLE arc ALTER COLUMN code SET NOT NULL;
--ALTER TABLE arc ALTER COLUMN node_1 SET NOT NULL;
--ALTER TABLE arc ALTER COLUMN node_2 SET NOT NULL;
ALTER TABLE arc ALTER COLUMN the_geom SET NOT NULL;

ALTER TABLE connec ALTER COLUMN inventory SET NOT NULL;
ALTER TABLE connec ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE connec ALTER COLUMN workcat_id SET NOT NULL;
--ALTER TABLE connec ALTER COLUMN builtdate SET NOT NULL;
ALTER TABLE connec ALTER COLUMN verified SET NOT NULL;
ALTER TABLE connec ALTER COLUMN code SET NOT NULL;
ALTER TABLE connec ALTER COLUMN the_geom SET NOT NULL;

ALTER TABLE element ALTER COLUMN inventory SET NOT NULL;
ALTER TABLE element ALTER COLUMN workcat_id SET NOT NULL;
--ALTER TABLE element ALTER COLUMN builtdate SET NOT NULL;
ALTER TABLE element ALTER COLUMN verified SET NOT NULL;
ALTER TABLE element ALTER COLUMN code SET NOT NULL;
