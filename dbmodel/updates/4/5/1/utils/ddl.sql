/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_element_x_node;
DROP VIEW IF EXISTS v_element_x_arc;
DROP VIEW IF EXISTS v_element_x_connec; 
DROP VIEW IF EXISTS v_element_x_gully;
DROP VIEW IF EXISTS v_ui_element_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_link;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_element_x_gully;

ALTER TABLE man_type_category DROP CONSTRAINT man_type_category_feature_type_fkey;
ALTER TABLE man_type_function DROP CONSTRAINT man_type_function_feature_type_fkey;
ALTER TABLE man_type_location DROP CONSTRAINT man_type_location_feature_type_fkey;

ALTER TABLE man_type_category
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];

ALTER TABLE man_type_function
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];

ALTER TABLE man_type_location
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];

ALTER TABLE man_type_category DROP CONSTRAINT man_type_category_unique;
ALTER TABLE man_type_function DROP CONSTRAINT man_type_function_unique;
ALTER TABLE man_type_location DROP CONSTRAINT man_type_location_unique;
