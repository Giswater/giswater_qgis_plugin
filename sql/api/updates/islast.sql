/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


--2018/10/27
ALTER TABLE config_web_fields ADD COLUMN table_type text;
ALTER TABLE config_web_fields ADD COLUMN iseditable boolean;
ALTER TABLE config_web_fields ADD COLUMN sys_api_cat_datatype_id integer;
ALTER TABLE config_web_fields ADD COLUMN sys_api_cat_widgettype_id integer;
ALTER TABLE config_web_fields ADD COLUMN dv_querytext text;
ALTER TABLE config_web_fields ADD COLUMN dv_querytext_filterc text;
ALTER TABLE config_web_fields ADD COLUMN dv_parent_id text;
ALTER TABLE config_web_fields ADD COLUMN isenabled boolean;
ALTER TABLE config_web_fields ADD COLUMN button_function text;
ALTER TABLE config_web_fields ADD COLUMN isautoupdate boolean;
ALTER TABLE config_web_fields ADD COLUMN action_function text;
ALTER TABLE config_web_fields ADD COLUMN tooltip text;
ALTER TABLE config_web_fields ADD COLUMN layout_id integer;
ALTER TABLE config_web_fields ADD COLUMN layout_order integer;
ALTER TABLE config_web_fields ADD COLUMN isparent boolean;
ALTER TABLE config_web_fields ADD COLUMN form_label text;
ALTER TABLE config_web_fields ADD COLUMN column_id character varying(30);


