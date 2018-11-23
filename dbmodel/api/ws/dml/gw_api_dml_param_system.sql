/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- mincut
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_mincut_parameters', '{"mincut_valve_layer":"v_anl_mincut_result_valve"}', NULL, NULL, NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_mincut_new_vdef', '{"mincut_state":"0", "mincut_type":"Real", "anl_cause":"Accidental", "assigned_to":"1"}', 'json', 'api_mincut', NULL);
