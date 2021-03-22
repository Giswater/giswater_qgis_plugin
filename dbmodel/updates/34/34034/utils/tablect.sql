/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/17
ALTER TABLE plan_psector DROP CONSTRAINT IF EXISTS plan_psector_sector_id_fkey;

-- 2021/03/22
ALTER TABLE cat_feature_node DROP CONSTRAINT cat_feature_node_fkey;
ALTER TABLE cat_feature_node ADD CONSTRAINT cat_feature_node_fkey FOREIGN KEY (id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE cat_feature_connec DROP CONSTRAINT cat_feature_connec_fkey;
ALTER TABLE cat_feature_connec ADD CONSTRAINT cat_feature_connec_fkey FOREIGN KEY (id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
	  
ALTER TABLE cat_feature_arc DROP CONSTRAINT cat_feature_arc_fkey;
ALTER TABLE cat_feature_arc ADD CONSTRAINT cat_feature_arc_fkey FOREIGN KEY (id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;