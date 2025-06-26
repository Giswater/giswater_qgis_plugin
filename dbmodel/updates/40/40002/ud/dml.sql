/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--26/06/2025

UPDATE sys_function SET function_alias = 'CREATE EMPTY HYDROLOGY SCENARIO' WHERE function_name = 'gw_fct_create_hydrology_scenario_empty';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4020, 'Infiltration: %v_infiltration%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4022, 'Text: %v_text%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4024, 'The hydrology scenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4026, 'This new hydrology scenario is now your current scenario.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CREATE EMPTY DSCENARIO' WHERE function_name = 'gw_fct_create_dwf_scenario_empty';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3880, 'ERROR: The dwf scenario already exists with proposed name (%v_idval%). Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3882, 'Id_val: %v_idval%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3884, 'Descript: %v_startdate%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3886, 'Parent: %v_enddate%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3888, 'Type: %v_observ%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3890, 'active: %v_active%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3892, 'Expl_id: %v_expl_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3894, 'The new dscenario (%v_scenarioid%) have been created sucessfully', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3896, 'The new dscenario is now your current DWF scenario', null, 0, true, 'utils', 'core', 'AUDIT');

--26/06/2025
UPDATE sys_function SET function_alias = 'DUPLICATE DWF SCENARIO' WHERE function_name = 'gw_fct_duplicate_dwf_scenario';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3898, 'Id_val: %v_idval%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3900, 'Descript: %v_startdate%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4302, 'Parent: %v_enddate%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4304, 'Type: %v_observ%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4306, 'active: %v_active%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4308, 'Expl_id: %v_expl_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4310, 'INFO: Dwf scenario named "%v_idval%" created with values from Dwf scenario ( %v_copyfrom% ).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4312, 'INFO: Copied values from Dwf scenario ( %v_copyfrom% ) to new Dwf scenario ( %v_scenarioid% ).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4314, 'This DWF scenario is now your current scenario.', null, 0, true, 'utils', 'core', 'AUDIT');


