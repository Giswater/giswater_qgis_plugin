/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- refactor constraints bad named
ALTER TABLE cat_grate DROP CONSTRAINT IF EXISTS cat_connec_cost_ut_fkey;
ALTER TABLE cat_grate ADD CONSTRAINT cat_grate_cost_ut_fkey FOREIGN KEY (cost_ut)
REFERENCES price_compost (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_type_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_gullytype_id_fkey FOREIGN KEY (gully_type)
REFERENCES gully_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_type_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_connectype_id_fkey FOREIGN KEY (connec_type)
REFERENCES connec_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


