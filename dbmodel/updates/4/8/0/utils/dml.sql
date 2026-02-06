/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 03/02/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4540, 'The specified path is already in use on another document: %repeated_paths%', 'Use a different path or change it in the other document', 2, true, 'utils', 'core', 'UI');

UPDATE sys_fprocess SET query_text='SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc WHERE dma_id = -2 and sector_id > 0' WHERE fid=232;
UPDATE sys_fprocess SET query_text='SELECT node_id, nodecat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_node WHERE dma_id = -2 and sector_id > 0' WHERE fid=233;

-- 06/02/2026
INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
VALUES (4542,'Commit changes is not allowed using psectors','Unselect commit changes or use psectors option',2,true,'utils','core','UI');

