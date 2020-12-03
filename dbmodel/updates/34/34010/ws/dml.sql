/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/05/24
UPDATE config_form_fields SET formname = 'v_om_mincut_arc' WHERE formname = 'v_anl_mincut_result_arc';
UPDATE config_form_fields SET formname = 'v_om_mincut_node' WHERE formname = 'v_anl_mincut_result_node';
UPDATE config_form_fields SET formname = 'v_om_mincut_connec' WHERE formname = 'v_anl_mincut_result_connec';
UPDATE config_form_fields SET formname = 'v_om_mincut' WHERE formname = 'v_anl_mincut_result_cat';
UPDATE config_form_fields SET formname = 'v_om_mincut_valve' WHERE formname = 'v_anl_mincut_result_valve';