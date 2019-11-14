/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2218

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_trace(p_node_id character varying)  
RETURNS smallint AS 
$BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_flow_trace ('5100');

*/
DECLARE 
    v_use_arcsense boolean;
	v_call text;
 
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
	
	SELECT value::boolean INTO v_use_arcsense FROM config_param_system WHERE parameter = 'om_flowtrace_usearcsense';
    
	IF v_use_arcsense IS FALSE THEN

		-- Reset values
		DELETE FROM anl_flow_node WHERE cur_user="current_user"() AND context='Flow trace';
		DELETE FROM anl_flow_arc WHERE cur_user="current_user"() AND context='Flow trace' ; 
    
		-- Compute the tributary area using recursive function
		PERFORM gw_fct_flow_trace_recursive(p_node_id, 0);
	
	ELSIF v_use_arcsense IS TRUE THEN
	
		-- Compute the whole area using grafanalyics function
		v_call = concat('{"data":{"parameters":{"node":"',p_node_id,'"}}}');		
		PERFORM gw_fct_grafanalytics(v_call);
	
	END IF;

RETURN 1;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

