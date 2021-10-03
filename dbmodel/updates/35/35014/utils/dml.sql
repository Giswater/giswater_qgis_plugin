/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_param_system SET value =
'{"status":"true", "values":[
{"sourceTable":"ve_node_deposito", "query":"UPDATE inp_tank t SET minlevel = h_min, maxlevel = h_max, diameter  = diametro FROM ve_node_deposito s WHERE t.node_id = s.node_id"},
{"sourceTable":"ve_node_valvula_reductora_pres", "query":"UPDATE inp_valve t SET pressure = pression_exit FROM ve_node_valvula_reductora_pres s WHERE t.node_id = s.node_id"}]}'
WHERE parameter = 'epa_automatic_man2inp_values';