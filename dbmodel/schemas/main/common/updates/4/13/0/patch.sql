/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- include start in the message
UPDATE sys_message
SET error_message='There are no arcs without start/final nodes.'
WHERE id=3582;

UPDATE sys_message
SET error_message='There are %v_count_state1% arcs with state 1 without start/final nodes.'
WHERE id=3586;

UPDATE sys_message
SET error_message='There are %v_count_state2% arcs with state 2 without start/final nodes.'
WHERE id=3588;
