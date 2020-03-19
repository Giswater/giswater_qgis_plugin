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


UPDATE config_api_form_fields SET widgettype ='typeahead',
dv_querytext= 'select id as id, postnumber as idval from ext_address WHERE id IS NOT NULL ',
dv_querytext_filterc = ' AND ext_address.streetaxis_id ',
dv_parent_id = 'streetaxis_id'
WHERE column_id = 'postnumber';


UPDATE config_api_form_fields SET widgettype ='typeahead',
dv_querytext= 'select id as id, postnumber as idval from ext_address WHERE id IS NOT NULL ',
dv_querytext_filterc = ' AND ext_address2.streetaxis_id ',
dv_parent_id = 'streetaxis_id'
WHERE column_id = 'postnumber2';

-- 2020/03/19
UPDATE config_param_system SET value = '{"sys_table_id":"v_ui_workcat_polygon_aux", "sys_id_field":"workcat_id", "sys_search_field":"workcat_id", "sys_geom_field":"the_geom", "filter_text":"code"}' WHERE parameter = 'api_search_workcat';
