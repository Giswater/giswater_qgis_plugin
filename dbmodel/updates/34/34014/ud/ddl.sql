/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/05
-- moving data from gully_type
UPDATE cat_feature f SET code_autofill = c.code_autofill, descript = c.descript, link_path = c.link_path, active = c.active
FROM gully_type c WHERE f.id=c.id;

ALTER TABLE gully_type RENAME to cat_feature_gully;


ALTER TABLE cat_feature_gully DROP COLUMN active;
ALTER TABLE cat_feature_gully DROP COLUMN code_autofill;
ALTER TABLE cat_feature_gully DROP COLUMN descript;
ALTER TABLE cat_feature_gully DROP COLUMN link_path;