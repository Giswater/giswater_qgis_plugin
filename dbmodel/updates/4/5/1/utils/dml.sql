/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_message SET error_message = 'The %feature_type% with id %connec_id% has been successfully connected to the arc with id %arc_id%'
WHERE id = 4430;
