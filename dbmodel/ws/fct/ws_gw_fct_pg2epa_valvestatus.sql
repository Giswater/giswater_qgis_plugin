/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2332

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_valve_status(varchar);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_valve_status(result_id_var varchar, p_mandatory_nodarc boolean)  RETURNS integer AS $BODY$
DECLARE
    
    rec_options record;
    valve_rec record;
    node_rec record;
    

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

--  Looking for parameters
    SELECT * INTO rec_options FROM inp_options;

    IF p_mandatory_nodarc IS FALSE THEN
	
	-- Update valve status;
	UPDATE rpt_inp_arc SET status=inp_pipe.status FROM inp_pipe WHERE rpt_inp_arc.arc_id=inp_pipe.arc_id AND result_id=result_id_var;
	UPDATE rpt_inp_arc SET status=inp_shortpipe.status FROM inp_shortpipe WHERE rpt_inp_arc.arc_id=concat(inp_shortpipe.node_id,'_n2a') AND result_id=result_id_var;
	UPDATE rpt_inp_arc SET status=inp_valve.status FROM inp_valve WHERE rpt_inp_arc.arc_id=concat(inp_valve.node_id,'_n2a') AND result_id=result_id_var;
			
	IF rec_options.valve_mode='MINCUT RESULTS' THEN
		FOR valve_rec IN SELECT node_id FROM anl_mincut_result_valve WHERE result_id=rec_options.valve_mode_mincut_result AND (proposed IS TRUE OR closed IS TRUE)
		LOOP
			UPDATE rpt_inp_arc SET status='CLOSED' WHERE concat(valve_rec.node_id,'_n2a')=arc_id AND result_id=result_id_var;
		END LOOP;

	ELSIF rec_options.valve_mode='INVENTORY VALUES' THEN
		FOR valve_rec IN SELECT node_id FROM v_edit_man_valve WHERE closed IS TRUE
		LOOP
			UPDATE rpt_inp_arc SET status='CLOSED' WHERE concat(valve_rec.node_id,'_n2a')=arc_id AND result_id=result_id_var;
		END LOOP; 
	END IF;

    ELSE
	-- Update valve status;
	UPDATE rpt_inp_arc SET status=inp_pipe.status FROM inp_pipe WHERE rpt_inp_arc.arc_id=inp_pipe.arc_id AND result_id=result_id_var;
	UPDATE rpt_inp_arc SET status=inp_valve.status FROM inp_valve WHERE rpt_inp_arc.arc_id=concat(inp_valve.node_id,'_n2a') AND result_id=result_id_var;
	UPDATE rpt_inp_arc SET status=a.status FROM 
		(SELECT arc_id, status FROM arc join inp_shortpipe ON node_id=node_1
			union
		SELECT arc_id, status from arc join inp_shortpipe ON node_id=node_2)a 
		WHERE a.arc_id=rpt_inp_arc.arc_id AND result_id=result_id_var;
			
	IF rec_options.valve_mode='MINCUT RESULTS' THEN
		FOR valve_rec IN SELECT node_id FROM anl_mincut_result_valve WHERE result_id=rec_options.valve_mode_mincut_result AND (proposed IS TRUE OR closed IS TRUE)
		LOOP
			UPDATE rpt_inp_arc SET status='CLOSED' FROM (SELECT arc_id, status FROM arc join inp_shortpipe ON node_id=node_1
									union
								      SELECT arc_id, status from arc join inp_shortpipe ON node_id=node_2) a 
								WHERE a.arc_id=rpt_inp_arc.arc_id AND result_id=result_id_var;
		END LOOP;

	ELSIF rec_options.valve_mode='INVENTORY VALUES' THEN
		FOR valve_rec IN SELECT node_id FROM v_edit_man_valve WHERE closed IS TRUE
		LOOP
			UPDATE rpt_inp_arc SET status='CLOSED' FROM (SELECT arc_id, status FROM arc join inp_shortpipe ON node_id=node_1
									union
								      SELECT arc_id, status from arc join inp_shortpipe ON node_id=node_2) a 
								WHERE a.arc_id=rpt_inp_arc.arc_id AND result_id=result_id_var;		
		END LOOP; 
	END IF;

    END IF;
    

    -- Reset demands if node is into mincut polygon
    IF rec_options.valve_mode='MINCUT RESULTS' THEN
		FOR node_rec IN SELECT node_id FROM anl_mincut_result_node WHERE result_id=rec_options.valve_mode_mincut_result
		LOOP
			UPDATE rpt_inp_node SET demand=0 WHERE result_id=result_id_var;
		END LOOP;
    END IF;
     

    RETURN 1;


		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;