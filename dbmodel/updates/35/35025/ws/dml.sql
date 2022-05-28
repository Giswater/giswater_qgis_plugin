/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/05/23
UPDATE config_param_system set layoutorder = layoutorder + 10 WHERE parameter in ('om_profile_guitarlegend','om_profile_guitartext','om_profile_vdefault');

UPDATE sys_table set alias = 'Pattern values' WHERE id = 'v_edit_inp_pattern_value';
UPDATE sys_table set alias = 'Curve values' WHERE id = 'v_edit_inp_curve_value';
