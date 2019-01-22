/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--DROP CONSTRAINT
ALTER TABLE config_api_form_fields DROP CONSTRAINT config_api_form_fields_pkey2;

ALTER TABLE config_api_visit DROP CONSTRAINT config_api_visit_fkey;
ALTER TABLE config_api_visit DROP CONSTRAINT config_api_visit_formname_key;

--ADD CONSTRAINT
ALTER TABLE config_api_form_fields ADD CONSTRAINT config_api_form_fields_pkey2 UNIQUE(formname, formtype, column_id);

ALTER TABLE config_api_visit ADD CONSTRAINT config_api_visit_formname_key UNIQUE(formname);
ALTER TABLE config_api_visit  ADD CONSTRAINT config_api_visit_fkey FOREIGN KEY (visitclass_id) 