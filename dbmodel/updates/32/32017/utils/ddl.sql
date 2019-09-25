/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE old_temp_csv2pg RENAME TO _temp_csv2pg_;

ALTER TABLE man_addfields_cat_combo RENAME TO _man_addfields_cat_combo_;
ALTER TABLE man_addfields_cat_datatype RENAME TO _man_addfields_cat_datatype_;
ALTER TABLE man_addfields_cat_widgettype RENAME TO _man_addfields_cat_widgettype_;