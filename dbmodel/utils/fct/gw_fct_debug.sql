/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2824

CREATE OR REPLACE FUNCTION ws.gw_fct_debug( p_data json)
  RETURNS json AS
$BODY$

/*
SELECT ws.gw_fct_debug($${"data":{"message":"The values for arc, node, connec are:", "variables":"value"}}$$)
SELECT ws.gw_fct_debug($${"data":{"message":"The values for arc, node, connec are:", "variables":"value"}}$$)
*/

DECLARE
    v_version text;
    v_type text;
    v_message text;
    v_variables text;
    v_debug boolean;

BEGIN
    
	SET search_path = "ws", public; 
    
	-- Get parameters from input json
   	v_type = (SELECT (p_data::json->>'data')::json->>'type');
	v_message = (SELECT (p_data::json->>'data')::json->>'message');
	v_variables = (SELECT (p_data::json->>'data')::json->>'variables');

	-- Get parameters from config table
	v_debug = (SELECT value FROM config_param_user WHERE parameter = 'edit_grafanalytics_lrs_debug' AND cur_user = current_user);
	v_debug =  true;

	IF v_debug THEN
	    	RAISE NOTICE ' % ', concat(v_message,' ',v_variables);
	END IF;

        --  Return
        RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Debug passed successfully"}, "version":"'||v_version||'","body":{"form":{}}}}')::json;
            

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;