/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE INDEX IF NOT EXISTS node_supplyzone_id_idx ON node USING btree (supplyzone_id);
CREATE INDEX IF NOT EXISTS arc_supplyzone_id_idx ON arc USING btree (supplyzone_id);
CREATE INDEX IF NOT EXISTS connec_supplyzone_id_idx ON connec USING btree (supplyzone_id);
CREATE INDEX IF NOT EXISTS link_supplyzone_id_idx ON link USING btree (supplyzone_id);
