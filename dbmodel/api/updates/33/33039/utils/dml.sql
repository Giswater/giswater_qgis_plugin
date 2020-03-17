/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/13
UPDATE config_api_form_fields SET dv_querytext_filterc = replace(dv_querytext_filterc,'=','') WHERE dv_querytext_filterc is not null;

-- 2020/03/16
UPDATE config_api_form_fields SET layoutname = 'lyt_data_1' WHERE layoutname = 'layout_data_1';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2' WHERE layoutname = 'layout_data_2';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3' WHERE layoutname = 'layout_data_3';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1' WHERE layoutname = 'bot_layout_1';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_2' WHERE layoutname = 'bot_layout_2';
UPDATE config_api_form_fields SET layoutname = 'lyt_top_1' WHERE layoutname = 'top_layout';

UPDATE config_api_form_fields SET layoutname = 'lyt_top_1' WHERE formtype='catalog' AND layoutname = 'top_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_distance' WHERE formtype='catalog' AND layoutname = 'distance_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_depth' WHERE formtype='catalog' AND layoutname = 'depth_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_symbology' WHERE formtype='catalog' AND layoutname = 'symbology_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_other' WHERE formtype='catalog' AND layoutname = 'other_layout';
