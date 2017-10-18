/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

/*
ALTER TABLE gully ADD CONSTRAINT gully_id_feature_type_unique UNIQUE(gully_id, feature_type);
ALTER TABLE gully ADD CONSTRAINT gully_function_type_feature_type_unique UNIQUE(function_type, feature_type);
ALTER TABLE gully ADD CONSTRAINT gully_category_type_feature_type_unique UNIQUE(category_type, feature_type);
ALTER TABLE gully ADD CONSTRAINT gully_fluid_type_feature_type_unique UNIQUE(fluid_type, feature_type);
ALTER TABLE gully ADD CONSTRAINT gully_location_type_feature_type_unique UNIQUE(location_type, feature_type);


ALTER TABLE man_addfields_value ADD CONSTRAINT man_addfields_value_gully_fkey FOREIGN KEY (feature_id, feature_type) 
REFERENCES SCHEMA_NAME.gully (gully_id, feature_type) ON UPDATE NO CASCADE ON DELETE CASCADE;
*/
