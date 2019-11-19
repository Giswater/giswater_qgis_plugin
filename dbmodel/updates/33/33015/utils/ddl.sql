/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--18/11/2019
ALTER TABLE man_addfields_parameter RENAME default_value TO _default_value_ ;
ALTER TABLE man_addfields_parameter RENAME form_label TO _form_label_ ;
ALTER TABLE man_addfields_parameter RENAME widgettype_id TO _widgettype_id_ ;
ALTER TABLE man_addfields_parameter RENAME dv_table TO _dv_table_ ;
ALTER TABLE man_addfields_parameter RENAME dv_key_column TO _dv_key_column_ ;
ALTER TABLE man_addfields_parameter RENAME sql_text TO _sql_text_ ;