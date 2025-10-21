/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_message SET error_message = 'The %feature_type% with id %connec_id% has been successfully connected to the arc with id %arc_id%'
WHERE id = 4430;

DELETE FROM config_form_fields WHERE formname='generic' AND formtype='psector' AND columnname='chk_enable_all' AND tabname='tab_general';

UPDATE config_typevalue
SET idval = substring(idval FROM 12 FOR length(idval) - 12)
WHERE typevalue = 'sys_table_context' and idval like '{"levels":%';
