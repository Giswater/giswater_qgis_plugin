/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- bug fix on node_type data
UPDATE node_type SET epa_table='inp_junction' WHERE id='TAP';


-- refactor
UPDATE inp_pump SET status='OPEN_PUMP' WHERE status='OPEN';
UPDATE inp_pump SET status='CLOSED_PUMP' WHERE status='CLOSED';

UPDATE inp_pump_additional SET status='OPEN_PUMP' WHERE status='OPEN';
UPDATE inp_pump_additional SET status='CLOSED_PUMP' WHERE status='CLOSED';

UPDATE inp_valve SET status='CLOSED_VALVE' WHERE status='CLOSED';
UPDATE inp_valve SET status='ACTIVE_VALVE' WHERE status='ACTIVE';
UPDATE inp_valve SET status='OPEN_VALVE' WHERE status='OPEN';

UPDATE inp_pipe SET status='CLOSED_PIPE' WHERE status='CLOSED';
UPDATE inp_pipe SET status='CV_PIPE' WHERE status='CV';
UPDATE inp_pipe SET status='OPEN_PIPE' WHERE status='OPEN';

UPDATE inp_shortpipe SET status='CLOSED_PIPE' WHERE status='CLOSED';
UPDATE inp_shortpipe SET status='CV_PIPE' WHERE status='CV';
UPDATE inp_shortpipe SET status='OPEN_PIPE' WHERE status='OPEN';


-- REACTIONS EL


-- ENERGY EL




-- refactor options / times / report
-- TODO
