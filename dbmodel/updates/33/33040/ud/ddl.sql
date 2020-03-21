/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/18
CREATE INDEX gully_sector ON gully USING btree (sector_id);
CREATE INDEX gully_gullyat ON gully USING btree (gratecat_id);
CREATE INDEX gully_exploitation ON gully USING btree (expl_id);
CREATE INDEX gully_dma ON gully USING btree (dma_id);
CREATE INDEX gully_dqa ON gully USING btree (dqa_id);
CREATE INDEX gully_street1 ON gully USING btree (streetaxis_id);
CREATE INDEX gully_street2 ON gully USING btree (streetaxis2_id);