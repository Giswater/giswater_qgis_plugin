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
VALUES (3898, 'Dwf scenario named "%v_idval%" created with values from Dwf scenario ( %v_copyfrom% ).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3900, 'Copied values from Dwf scenario ( %v_copyfrom% ) to new Dwf scenario ( %v_scenarioid% ).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4302, 'This DWF scenario is now your current scenario.', null, 0, true, 'utils', 'core', 'AUDIT');

--27/06/2025

UPDATE sys_function SET function_alias = 'MANAGE DWF VALUES' WHERE function_name = 'gw_fct_manage_dwf_values';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4028, 'Sector: %v_sector_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4030, '%v_count% row(s) have been keep from inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4032, 'No rows have been inserted on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4034, '%v_count2% row(s) have been inserted on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4036, '%v_count% row(s) have been removed from inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4038, '%v_count% row(s) have been inserted into inp_dwf table from v_edit_inp_junction table.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'MANAGE HYDROLOGY VALUES' WHERE function_name = 'gw_fct_manage_hydrology_values';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4040, 'Infiltration method for (%v_source_name%) and (%v_target_name%) are not the same.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4042, '%v_count% row(s) have been removed from inp_subcathment table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4044, '%v_count% row(s) have been removed from inp_loadings table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4046, '%v_count% row(s) have been removed from inp_groundwater table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4048, '%v_count% row(s) have been removed from inp_coverage table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4050, 'Target and source have same infiltration method.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4052, 'No rows have been inserted for sector %v_sector% on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4054, '%v_count2% row(s) have been inserted for sector %v_sector% on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

--27/06/2025
UPDATE sys_function SET function_alias = 'SET JUNCTIONS OUTLET' WHERE function_name = 'gw_fct_epa_setjunctionsoutlet';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4306, 'Minimun distance used: %v_mindistance%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4308, 'Initial junctions: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4310, 'Total junctions after process: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

--27/06/2025
UPDATE sys_function SET function_alias = 'DUPLICATE HYDROLOGY SCENARIO' WHERE function_name = 'gw_fct_duplicatehydroscenario';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4312, 'Source scenario: %v_sourcename%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4314, 'New scenario: %v_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4316, 'Hydrology scenario named (%v_name%) have been created with values from hydrology scenario (%v_sourcename%).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4318, 'The new hydrology scenario (%v_name%) is now your current scenario.', null, 0, true, 'utils', 'core', 'AUDIT');

