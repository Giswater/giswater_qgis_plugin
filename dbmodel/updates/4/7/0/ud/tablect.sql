/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE INDEX gully_minsector_id_idx ON gully USING btree (minsector_id);

ALTER TABLE gully ADD CONSTRAINT gully_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id);