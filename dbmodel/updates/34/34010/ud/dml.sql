/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_typevalue_fk(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue','value_verified', 'gully', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;	