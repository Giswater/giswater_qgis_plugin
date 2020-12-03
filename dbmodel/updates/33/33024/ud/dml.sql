/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/01/21
UPDATE config_api_form_fields SET hidden = 'TRUE' WHERE column_id='elev' and formtype='feature';
UPDATE config_api_form_fields SET hidden = 'TRUE' WHERE column_id='elev1' and formtype='feature';
UPDATE config_api_form_fields SET hidden = 'TRUE' WHERE column_id='elev2' and formtype='feature';