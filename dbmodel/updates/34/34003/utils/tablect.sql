/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE man_addfields_parameter DROP CONSTRAINT IF EXISTS man_addfields_parameter_unique;
ALTER TABLE man_addfields_parameter ADD CONSTRAINT man_addfields_parameter_unique UNIQUE(param_name, cat_feature_id);


ALTER TABLE link DROP CONSTRAINT IF EXISTS link_unique;
ALTER TABLE link ADD CONSTRAINT link_unique UNIQUE(feature_id, feature_type, state);


ALTER TABLE om_visit_parameter DROP CONSTRAINT IF EXISTS om_visit_parameter_feature_type_fkey;

UPDATE om_visit_parameter SET feature_type='ALL' WHERE feature_type IS NULL OR feature_type='UNDEFINED';

ALTER TABLE om_visit_parameter DROP CONSTRAINT IF EXISTS om_visit_parameter_feature_type_check;
ALTER TABLE om_visit_parameter ADD CONSTRAINT om_visit_parameter_feature_type_check CHECK (feature_type::text=ANY 
(ARRAY['ARC', 'NODE', 'CONNEC', 'GULLY', 'ALL']));