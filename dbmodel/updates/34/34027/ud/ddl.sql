/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/22
ALTER TABLE cat_feature_gully DROP CONSTRAINT IF EXISTS gully_type_id_fkey;
ALTER TABLE cat_feature_gully  ADD CONSTRAINT cat_feature_arc_fkey FOREIGN KEY (id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE cat_feature_connec DROP CONSTRAINT IF EXISTS  connec_type_id_fkey;
ALTER TABLE cat_feature_connec  ADD CONSTRAINT cat_feature_connec_fkey FOREIGN KEY (id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_feature_node DROP CONSTRAINT IF EXISTS  node_type_id_fkey;
ALTER TABLE cat_feature_node ADD CONSTRAINT cat_feature_node_fkey FOREIGN KEY (id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
