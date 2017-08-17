/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_valve_unaccess('valve_id_var', 'result_id_var')

if (SELECT valve_id FROM anl_mincut_result_valve_unaccess WHERE valve_id=valve_id_var and result_id=result_id_var) is not null
		INSERT INTO anl_mincut_result_valve_unaccess (result_id, valve_id) VALUES (result_id_var, valve_id_var)
else
		DELETE FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_var AND valve_id=valve_id_var
end if;
