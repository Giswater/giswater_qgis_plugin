/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE config_api_visit RENAME TO _config_api_visit_;

UPDATE om_visit_class SET formname = a.formname, tablename = a.tablename FROM _config_api_visit_ a WHERE om_visit_class.id = a.visitclass_id;

--update audit_cat_param_user with cat_feature vdefaults
UPDATE cat_feature SET id=id;
