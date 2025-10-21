/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE man_type_fluid DROP CONSTRAINT man_type_fluid_feature_type_fkey;

ALTER TABLE man_type_fluid
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];

ALTER TABLE man_type_fluid DROP CONSTRAINT man_type_fluid_unique;
