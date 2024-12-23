/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 23/12/2024
CREATE INDEX arc_streetname ON arc USING btree (streetname);
CREATE INDEX arc_streetname2 ON arc USING btree (streetname2);

CREATE INDEX node_streetname ON node USING btree (streetname);
CREATE INDEX node_streetname2 ON node USING btree (streetname2);

CREATE INDEX connec_streetname ON conec USING btree (streetname);
CREATE INDEX connec_streetname2 ON connec USING btree (streetname2);


