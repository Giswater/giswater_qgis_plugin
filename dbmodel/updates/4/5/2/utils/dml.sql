/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_message SET error_message = 'Insert old arc as downgraded into current psector: %v_psector%.' WHERE id = 3410;

-- 24/10/2025
INSERT INTO sys_message (id,error_message,log_level,"source",message_type)
	VALUES (5008,'YOU NEED TO SET SOME WORKCATID TO EXECUTE PSECTOR',2,'core','UI');
INSERT INTO sys_message (id,error_message,log_level,"source",message_type)
	VALUES (5006,'A sector cannot go directly to OPERATIONAL; it must first be EXECUTED.',2,'core','UI');
INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
	VALUES (5010,'Cannot restore archived psector due to topology errors','Please fix the topology errors before restoring the psector. Check the log for details.',2,true,'utils','core','UI');

-- 27/10/2025
UPDATE config_form_fields
	SET dv_isnullvalue=true
	WHERE formname='generic' AND formtype='psector' AND columnname='workcat_id_plan' AND tabname='tab_general';