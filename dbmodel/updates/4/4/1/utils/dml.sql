/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='sector_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='active';
UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='id';
UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='text';

UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='log';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='id';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='curve_type';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='expl_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='descript';
UPDATE config_form_tableview
	SET alias='active',columnname='active'
	WHERE objectname='ve_inp_curve' AND columnname='log';

-- Mincut stats messages
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4362, 'MINCUT STATS', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4364, 'Number of arcs: %number%', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4366, 'Length of affected network: %length% mts', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4368, 'Total water volume: %volume% m3', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4370, 'Number of connecs affected: %number%', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4372, 'Total of hydrometers affected: %total%', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4374, 'Hydrometers classification: %classified%', '', 0, true, 'ws', 'core', 'AUDIT');

-- Mincut overlap analysis messages
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4376, 'MINCUT ANALYSIS', '', 3, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4378, 'Minimun cut have been checked looking for overlaps against other mincuts', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4380, 'Psectors have been used to execute this mincut in order to calculate mincut affectations with planned network.', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4382, '%count% Psectors have been unselected on current exploitation in order to execute this mincut without planned network.', '', 2, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4384, 'Mincut have been executed without planned network.', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4386, 'There are not values selected for hydrometer''s state with is_operative True. As result no hydrometer have been attached to this mincut', '', 2, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4388, 'There is one value for hydrometer''s state selected with is_operative True: %selected%.', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4390, 'There are more than one hydrometer''s state selected with is_operative True: %selected%.', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4392, 'There is a temporal overlap with spatial intersection on the same macroexploitation with: %conflictmsg%', '', 2, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4394, 'additional pipes are involved and more connecs are affected ( %addaffconnecs% units. )', '', 2, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4396, 'additional pipes are involved', '', 2, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4398, 'No more connecs are affected', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4400, 'There is a temporal overlap without spatial intersection on the same macroexploitation with: %conflictmsg%', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4402, 'No additional pipes are involved and no more connecs are affected', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4404, 'There are no more mincuts on the same macroexploitation on planned on the same date-time', '', 1, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4406, 'Mincut have been executed with conflicts. All additional affetations have been joined to present mincut', '', 2, true, 'ws', 'core', 'AUDIT');
