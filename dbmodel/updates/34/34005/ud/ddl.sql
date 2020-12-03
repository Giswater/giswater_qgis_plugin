/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/18
CREATE INDEX gully_sector ON gully USING btree (sector_id);
CREATE INDEX gully_gratecat ON gully USING btree (gratecat_id);
CREATE INDEX gully_exploitation ON gully USING btree (expl_id);
CREATE INDEX gully_dma ON gully USING btree (dma_id);
CREATE INDEX gully_street1 ON gully USING btree (streetaxis_id);
CREATE INDEX gully_street2 ON gully USING btree (streetaxis2_id);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"matcat_id", "dataType":"varchar(30)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"matcat_id", "dataType":"varchar(30)"}}$$);

--2020/06/04
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"district_id", "dataType":"integer", "isUtils":"False"}}$$);