/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/03
ALTER TABLE man_type_location DROP CONSTRAINT IF EXISTS man_type_location_featurecat_id_fkey;
ALTER TABLE man_type_location ADD CONSTRAINT man_type_location_featurecat_id_fkey FOREIGN KEY (featurecat_id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE man_type_fluid DROP CONSTRAINT IF EXISTS man_type_fluid_featurecat_id_fkey;
ALTER TABLE man_type_fluid ADD CONSTRAINT man_type_fluid_featurecat_id_fkey FOREIGN KEY (featurecat_id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE man_type_category DROP CONSTRAINT IF EXISTS man_type_category_featurecat_id_fkey;
ALTER TABLE man_type_category ADD CONSTRAINT man_type_category_featurecat_id_fkey FOREIGN KEY (featurecat_id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE man_type_function DROP CONSTRAINT IF EXISTS man_type_function_featurecat_id_fkey;
ALTER TABLE man_type_function ADD CONSTRAINT man_type_function_featurecat_id_fkey FOREIGN KEY (featurecat_id)
REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE SET NULL;