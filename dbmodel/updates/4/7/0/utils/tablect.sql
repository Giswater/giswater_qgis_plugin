/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE INDEX IF NOT EXISTS node_minsector_id_idx ON node USING btree (minsector_id);
CREATE INDEX IF NOT EXISTS arc_minsector_id_idx ON arc USING btree (minsector_id);
CREATE INDEX IF NOT EXISTS connec_minsector_id_idx ON connec USING btree (minsector_id);

ALTER TABLE node ADD CONSTRAINT node_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id);
ALTER TABLE arc ADD CONSTRAINT arc_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id);
ALTER TABLE connec ADD CONSTRAINT connec_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id);

CREATE INDEX IF NOT EXISTS node_dma_id_idx ON node USING btree (dma_id);
CREATE INDEX IF NOT EXISTS arc_dma_id_idx ON arc USING btree (dma_id);
CREATE INDEX IF NOT EXISTS connec_dma_id_idx ON connec USING btree (dma_id);
CREATE INDEX IF NOT EXISTS link_dma_id_idx ON link USING btree (dma_id);
CREATE INDEX IF NOT EXISTS gully_dma_id_idx ON gully USING btree (dma_id);
