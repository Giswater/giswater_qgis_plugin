/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/15
DROP VIEW IF EXISTS v_om_mincut_conflict_valve;
DROP VIEW IF EXISTS v_om_mincut_conflict_arc;
DROP VIEW IF EXISTS v_om_mincut_audit;


CREATE OR REPLACE VIEW vi_emitters AS 
SELECT inp_emitter.node_id,
   inp_emitter.coef
   FROM inp_emitter
   JOIN temp_node t USING (node_id)
   WHERE t.node_id NOT IN (SELECT node_id FROM anl_node WHERE fid = 232 AND cur_user = current_user);   