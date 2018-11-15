/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE VIEW v_web_composer AS 
SELECT ct.user_name,
    ct.composer,
    ct.scale,
    ct.title,
    ct.date,
    ct.descript
   FROM crosstab('SELECT user_name, field_id, field_value FROM selector_composer where user_name=''qgisserver''
			ORDER  BY 1,2'::text, ' VALUES (''composer''),(''scale''),(''title''),(''date''),(''descript'')'::text) ct(user_name text, composer text, scale numeric, title text, date date, descript text);

 