/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2332

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_valve_status(varchar, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_valve_status(result_id_var varchar) 
RETURNS integer AS 
$BODY$

DECLARE

v_valverec record;
v_noderec record;
v_valvemode integer;
v_mincutresult integer;
v_networkmode integer;
v_querytext text;
    
BEGIN
 
	--  Search path
	SET search_path = "SCHEMA_NAME", public;
	

	-- get values from user
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);

	-- update shut-off valves
	IF v_networkmode = 1 THEN -- Because shut-off valves are not exported as a shortpipe, pipes closer shut-off valves will be setted

		UPDATE temp_arc SET status='CLOSED' 
		FROM (SELECT temp_arc.arc_id FROM temp_arc JOIN man_valve ON node_id=node_1 where closed is true
		UNION
		SELECT temp_arc.arc_id from temp_arc join man_valve ON node_id=node_2  where closed is true) a 
		WHERE a.arc_id=temp_arc.arc_id;
				
	ELSIF v_networkmode IN (2,3,4) THEN -- Because shut-off valves are exported as nodarcs, directly we can set the status of shut-off valves

		-- getting querytext for shutoff valves in function if they are TCV OR SHORTPIPES
		IF (SELECT value FROM config_param_system WHERE parameter = 'epa_shutoffvalve') = 'VALVE' THEN
			v_querytext = ' AND epa_type = ''VALVE'' and addparam::json->>''valv_type'' = ''TCV''';
		ELSE
			v_querytext = ' AND epa_type = ''SHORTPIPE''';
		END IF;
			
		EXECUTE ' UPDATE temp_arc a SET status=''CLOSED'' FROM man_valve v WHERE a.arc_id=concat(v.node_id,''_n2a'') AND closed=true '||v_querytext;
		EXECUTE ' UPDATE temp_arc a SET status=''OPEN'' FROM man_valve v WHERE a.arc_id=concat(v.node_id,''_n2a'') AND closed=false'||v_querytext;

		-- Set CV valves 
		UPDATE temp_arc a SET status='CV' FROM inp_shortpipe v WHERE a.arc_id=concat(v.node_id,'_n2a') AND v.status = 'CV';	
    END IF;
    
    -- all that not are closed are open
    UPDATE temp_arc SET status='OPEN' WHERE status IS NULL;

    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;