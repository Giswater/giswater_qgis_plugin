/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE INDEX node_minsector_id_idx ON node USING btree (minsector_id);
CREATE INDEX arc_minsector_id_idx ON arc USING btree (minsector_id);
CREATE INDEX connec_minsector_id_idx ON connec USING btree (minsector_id);

CREATE INDEX node_supplyzone_id_idx ON node USING btree (supplyzone_id);
CREATE INDEX arc_supplyzone_id_idx ON arc USING btree (supplyzone_id);
CREATE INDEX connec_supplyzone_id_idx ON connec USING btree (supplyzone_id);