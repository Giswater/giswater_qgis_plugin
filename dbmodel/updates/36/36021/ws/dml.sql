/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'deleteUsers', 'creator'::text),
descript='Mincut settings. valveStatus - Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status ; redoOnStart - If true, on starting the mincut the process will be recalculated if the indicated number of days since receving the mincut has passed; deleteUsers - Choose if mincuts could be only deleted by its creator or by all users. Set value ''creator'' or ''all''.' where parameter = 'om_mincut_settings';
