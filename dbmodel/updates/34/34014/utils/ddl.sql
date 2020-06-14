/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/02
-- moving data from connec_type
UPDATE cat_feature f SET code_autofill = c.code_autofill, descript = c.descript, link_path = c.link_path, active = c.active
FROM connec_type c WHERE f.id=c.id;
ALTER TABLE connec_type ADD COLUMN addparam json;
ALTER TABLE connec_type RENAME to cat_feature_connec;

-- moving data from arc_type
UPDATE cat_feature f SET code_autofill = c.code_autofill, descript = c.descript, link_path = c.link_path, active = c.active 
FROM arc_type c WHERE f.id=c.id;

ALTER TABLE arc_type ADD COLUMN addparam json;
ALTER TABLE arc_type RENAME to cat_feature_arc;


-- moving data from node_type
UPDATE cat_feature f SET code_autofill = c.code_autofill, descript = c.descript, link_path = c.link_path, active = c.active 
FROM node_type c WHERE f.id=c.id;

ALTER TABLE node_type RENAME to cat_feature_node;

ALTER TABLE cat_feature_arc DROP COLUMN active;
ALTER TABLE cat_feature_arc DROP COLUMN code_autofill;
ALTER TABLE cat_feature_arc DROP COLUMN descript;
ALTER TABLE cat_feature_arc DROP COLUMN link_path;

ALTER TABLE cat_feature_node DROP COLUMN active;
ALTER TABLE cat_feature_node DROP COLUMN code_autofill;
ALTER TABLE cat_feature_node DROP COLUMN descript;
ALTER TABLE cat_feature_node DROP COLUMN link_path;

ALTER TABLE cat_feature_connec DROP COLUMN active;
ALTER TABLE cat_feature_connec DROP COLUMN code_autofill;
ALTER TABLE cat_feature_connec DROP COLUMN descript;
ALTER TABLE cat_feature_connec DROP COLUMN link_path;