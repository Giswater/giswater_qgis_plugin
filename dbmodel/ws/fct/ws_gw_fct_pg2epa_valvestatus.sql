/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2332

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_valve_status(varchar, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_valve_status(result_id_var varchar)  RETURNS integer AS $BODY$
DECLARE
	v_valverec record;
	v_noderec record;
	v_valvemode integer;
	v_mincutresult integer;
	v_networkmode integer;
    
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- get values from user
	v_valvemode := (SELECT value from config_param_user where cur_user=current_user AND parameter ='inp_options_valve_mode');
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
	v_mincutresult :=(SELECT value::integer from config_param_user where cur_user=current_user AND parameter ='inp_options_valve_mode_mincut_result') ;

	-- update inp_valves (allways the same)
	UPDATE rpt_inp_arc SET status=inp_valve.status FROM inp_valve WHERE rpt_inp_arc.arc_id=concat(inp_valve.node_id,'_n2a') AND result_id=result_id_var;

	-- update shut-off valves
	IF v_networkmode = 1 OR v_networkmode = 3 THEN -- Because shut-off valves are not exported as a shortpipe, pipes closer shut-off valves will be setted

		IF v_valvemode = 3 THEN	--mincut results
			UPDATE rpt_inp_arc SET status='CLOSED' 
				FROM (SELECT arc_id FROM rpt_inp_arc join anl_mincut_result_valve ON node_id=node_1 AND result_id=v_mincutresult AND (proposed IS TRUE OR closed IS TRUE)
					UNION
					SELECT arc_id FROM rpt_inp_arc join anl_mincut_result_valve ON node_id=node_2 AND result_id=v_mincutresult AND (proposed IS TRUE OR closed IS TRUE)
					) a 
				WHERE a.arc_id=rpt_inp_arc.arc_id AND result_id=result_id_var;

		ELSIF v_valvemode = 2 THEN -- inventory
			UPDATE rpt_inp_arc SET status='CLOSED' 
				FROM (SELECT rpt_inp_arc.arc_id FROM rpt_inp_arc JOIN man_valve ON node_id=node_1 where closed is true
					UNION
				    SELECT rpt_inp_arc.arc_id from rpt_inp_arc join man_valve ON node_id=node_2  where closed is true) a 
				WHERE a.arc_id=rpt_inp_arc.arc_id AND result_id=result_id_var;		

		ELSIF v_valvemode = 1 THEN -- epa tables
			UPDATE rpt_inp_arc SET status=a.status 
				FROM (SELECT rpt_inp_arc.arc_id, CASE WHEN inp_shortpipe.status IS NULL THEN 'OPEN' ELSE inp_shortpipe.status END AS status FROM rpt_inp_arc join inp_shortpipe ON node_id=node_1
					UNION
					SELECT rpt_inp_arc.arc_id,  CASE WHEN inp_shortpipe.status IS NULL THEN 'OPEN' ELSE inp_shortpipe.status END AS status from rpt_inp_arc join inp_shortpipe ON node_id=node_2) a 
				WHERE a.arc_id=rpt_inp_arc.arc_id AND result_id=result_id_var;			
		END IF;
	
	ELSIF v_networkmode = 2 OR v_networkmode = 4 THEN -- Because shut-off valves are exported as nodarcs, directly we can set the status of shut-off valves
				
		IF v_valvemode = 3 THEN --mincut results
			UPDATE rpt_inp_arc a SET status='CLOSED' 
			FROM anl_mincut_result_valve v
			WHERE a.arc_id=concat(v.node_id,'_n2a') AND v.result_id = v_mincutresult AND (proposed IS TRUE OR closed IS TRUE) AND a.result_id=result_id_var;
			
		ELSIF v_valvemode = 2 THEN -- inventory
			UPDATE rpt_inp_arc a SET status='CLOSED'
			FROM man_valve v
				WHERE a.arc_id=concat(v.node_id,'_n2a') AND a.result_id=result_id_var AND closed=true;
		
		ELSIF v_valvemode = 1 THEN -- epa tables
			UPDATE rpt_inp_arc a SET status=p.status 
			FROM inp_shortpipe p
				WHERE a.arc_id=concat(p.node_id,'_n2a') AND a.result_id=result_id_var;
		
		END IF;
	
    END IF;
    
    -- Reset demands if node is into mincut affectation
    IF v_valvemode = 3 THEN
		UPDATE rpt_inp_node SET demand=0 WHERE rpt_inp_node.node_id IN (SELECT node_id FROM anl_mincut_result_node WHERE result_id=v_mincutresult) AND result_id=result_id_var;
    END IF; 

    -- all that not are closed are open
    UPDATE rpt_inp_arc SET status='OPEN' WHERE status IS NULL AND result_id=result_id_var;


    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;