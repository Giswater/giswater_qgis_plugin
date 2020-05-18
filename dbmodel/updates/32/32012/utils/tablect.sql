/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--DROP CONSTRAINT
DROP INDEX IF EXISTS shortcut_unique;
ALTER TABLE config_api_form_fields DROP CONSTRAINT IF EXISTS config_api_form_fields_pkey2;
ALTER TABLE config_api_visit DROP CONSTRAINT IF EXISTS cconfig_api_visit_fkey;
ALTER TABLE config_api_visit DROP CONSTRAINT IF EXISTS cconfig_api_visit_formname_key;

--ADD CONSTRAINT
CREATE UNIQUE INDEX shortcut_unique ON cat_feature USING btree (shortcut_key COLLATE pg_catalog."default");
ALTER TABLE config_api_form_fields ADD CONSTRAINT config_api_form_fields_pkey2 UNIQUE(formname, formtype, column_id);