/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/11
UPDATE connec SET pjoint_id = exit_id, pjoint_type = exit_type 
FROM (select feature_id, exit_id, exit_type from link where feature_id IN (select connec_id from connec where pjoint_id is null) 
AND exit_type IN ('NODE', 'VNODE'))a
WHERE connec_id  = feature_id AND pjoint_id IS NULL;