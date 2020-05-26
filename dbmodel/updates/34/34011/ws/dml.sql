/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
UPDATE config_form_fields set column_id = 'presszone_id' WHERE column_id ='presszonecat_id';
UPDATE config_form_fields set formname = 'presszone' WHERE formname ='cat_presszone';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, 'cat_presszone', 'presszone') WHERE column_id like '%press%';
UPDATE config_form_fields SET dv_querytext_filterc = replace (dv_querytext_filterc, 'cat_presszone', 'presszone') WHERE column_id like '%press%';

