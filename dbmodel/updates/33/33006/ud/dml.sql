/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 17/10/2019
UPDATE audit_cat_param_user SET description = 'If true, link will be automatically generated when inserting a new gully with state=1. For planified gullys, link will always be automatically generated'
WHERE id = 'edit_gully_force_automatic_connect2network';