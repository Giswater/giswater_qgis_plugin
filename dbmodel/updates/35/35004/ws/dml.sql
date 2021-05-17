/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/05
UPDATE sys_param_user SET isenabled = false where id='edit_presszone_vdefault';
UPDATE sys_param_user SET vdefault = gw_fct_json_object_delete_keys(vdefault::json, 'inp_options_debug') WHERE id ='inp_options_debug';
UPDATE config_param_user SET value = gw_fct_json_object_delete_keys(value::json, 'inp_options_debug') WHERE parameter ='inp_options_debug';

