/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE INDEX gully_minsector_id_idx ON gully USING btree (minsector_id);

ALTER TABLE gully ADD CONSTRAINT gully_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id);

CREATE INDEX IF NOT EXISTS node_omunit_id_idx ON node USING btree (omunit_id);
CREATE INDEX IF NOT EXISTS arc_omunit_id_idx ON arc USING btree (omunit_id);
CREATE INDEX IF NOT EXISTS connec_omunit_id_idx ON connec USING btree (omunit_id);
CREATE INDEX IF NOT EXISTS link_omunit_id_idx ON link USING btree (omunit_id);
CREATE INDEX IF NOT EXISTS gully_omunit_id_idx ON gully USING btree (omunit_id);

CREATE INDEX IF NOT EXISTS gully_dma_id_idx ON gully USING btree (dma_id);

ALTER TABLE node ADD CONSTRAINT node_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id);
ALTER TABLE arc ADD CONSTRAINT arc_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id);
ALTER TABLE connec ADD CONSTRAINT connec_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id);
ALTER TABLE link ADD CONSTRAINT link_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id);
ALTER TABLE gully ADD CONSTRAINT gully_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id);

ALTER TABLE anl_arc ADD COLUMN omunit_id INTEGER;