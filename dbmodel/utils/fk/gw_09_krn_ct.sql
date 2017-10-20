/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP CONSTRAINT



--ADD CONSTRAINT 
/*
ALTER TABLE node ADD CONSTRAINT node_function_type_feature_type_unique UNIQUE(function_type, feature_type);
ALTER TABLE node ADD CONSTRAINT node_category_type_feature_type_unique UNIQUE(category_type, feature_type);
ALTER TABLE node ADD CONSTRAINT node_fluid_type_feature_type_unique UNIQUE(fluid_type, feature_type);
ALTER TABLE node ADD CONSTRAINT node_location_type_feature_type_unique UNIQUE(location_type, feature_type);

ALTER TABLE arc ADD CONSTRAINT arc_function_type_feature_type_unique UNIQUE(function_type, feature_type);
ALTER TABLE arc ADD CONSTRAINT arc_category_type_feature_type_unique UNIQUE(category_type, feature_type);
ALTER TABLE arc ADD CONSTRAINT arc_fluid_type_feature_type_unique UNIQUE(fluid_type, feature_type);
ALTER TABLE arc ADD CONSTRAINT arc_location_type_feature_type_unique UNIQUE(location_type, feature_type);

ALTER TABLE connec ADD CONSTRAINT connec_function_type_feature_type_unique UNIQUE(function_type, feature_type);
ALTER TABLE connec ADD CONSTRAINT connec_category_type_feature_type_unique UNIQUE(category_type, feature_type);
ALTER TABLE connec ADD CONSTRAINT connec_fluid_type_feature_type_unique UNIQUE(fluid_type, feature_type);
ALTER TABLE connec ADD CONSTRAINT connec_location_type_feature_type_unique UNIQUE(location_type, feature_type);

ALTER TABLE element ADD CONSTRAINT element_function_type_feature_type_unique UNIQUE(function_type, feature_type);
ALTER TABLE element ADD CONSTRAINT element_category_type_feature_type_unique UNIQUE(category_type, feature_type);
ALTER TABLE element ADD CONSTRAINT element_fluid_type_feature_type_unique UNIQUE(fluid_type, feature_type);
ALTER TABLE element ADD CONSTRAINT element_location_type_feature_type_unique UNIQUE(location_type, feature_type);

ALTER TABLE man_addfields_value ADD CONSTRAINT mav_feature_id_parameter_id_feature_type_unique UNIQUE(feature_id, parameter_id, feature_type);

*/