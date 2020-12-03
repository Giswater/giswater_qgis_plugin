/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/04
UPDATE config_info_layer SET orderby=2 WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET orderby=3 WHERE layer_id='v_edit_om_visit';
UPDATE config_info_layer SET orderby=4 WHERE layer_id='v_edit_arc';
UPDATE config_info_layer SET orderby=5 WHERE layer_id='v_edit_dimensions';
DELETE FROM config_info_layer WHERE layer_id='v_edit_cad_auxpoint';

-- 2020/11/12
UPDATE sys_function SET (input_params, return_type) = ('json', 'json') WHERE id =2312;
