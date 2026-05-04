/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system
	SET value='{"status":true, "values":[
{"sourceTable":"ve_node_pr_reduc_valve", "query":"UPDATE presszone t SET head = CASE WHEN top_elev + pressure_exit IS NOT NULL THEN top_elev + pressure_exit ELSE t.head END FROM ve_node_pr_reduc_valve s "},
{"sourceTable":"ve_node_pump", "query":"UPDATE presszone t SET head = CASE WHEN top_elev + pressure_exit IS NOT NULL THEN top_elev + pressure_exit ELSE t.head END FROM ve_node_pump s "},
{"sourceTable":"ve_node_tank", "query":"UPDATE presszone t SET head= CASE WHEN invert_level + hmax IS NOT NULL THEN invert_level + hmax ELSE t.head END FROM ve_node_tank s "}]}'
	WHERE "parameter"='epa_automatic_man2graph_values';
