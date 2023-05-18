/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog,

-- update for tstep variables
UPDATE sys_param_user SET vdefault = '0.75', layoutname = 'lyt_hydraulics_1', layoutorder = 99, widgettype = 'linetext' WHERE id = 'inp_options_variable_step';
UPDATE config_param_user SET value = '0.75' WHERE parameter = 'inp_options_variable_step';

INSERT INTO sys_param_user VALUES ('inp_options_minimum_step', 'epaoptions', 'Value of minimum step for routing timestep.', 'role_epa','MINIMUM_STEP','Minimum step:',null,null,TRUE,99,
'ud',FALSE,null,null,null,FALSE,'integer','linetext',TRUE,null,'0.5','lyt_hydraulics_2',TRUE,null,null,null,null,'core');