/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/02
DROP INDEX IF EXISTS arc_presszone;
CREATE INDEX arc_presszone ON arc USING btree (presszone_id);
DROP INDEX IF EXISTS node_presszone;
CREATE INDEX node_presszone ON node USING btree (presszone_id);
DROP INDEX IF EXISTS connec_presszone;
CREATE INDEX connec_presszone ON connec USING btree (presszone_id);