/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/05/27
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_fields", "column":"editability", "dataType":"json"}}$$);

-- 2019/07/02
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_fields", "column":"widgetcontrols", "dataType":"json"}}$$);


ALTER TABLE config_api_cat_widgettype RENAME TO _config_api_cat_widgettype_;
ALTER TABLE config_api_cat_formtemplate RENAME TO _config_api_cat_formtemplate_;
ALTER TABLE config_api_cat_datatype RENAME TO _config_api_cat_datatype_;