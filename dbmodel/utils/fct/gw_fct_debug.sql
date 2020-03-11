/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2824

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_debug( p_data json)
  RETURNS json AS
$BODY$


/*
SELECT SCHEMA_NAME.gw_fct_debug($${"data":{"debug":{"status":false, "mode":"NOTICE"}, "message":"The values for arc, node, connec are:", "variables":"value"}}$$)
*/

DECLARE
    v_version text;
    v_type text;
    v_message text;
    v_variables text;
    v_debug json;

BEGIN
    
	SET search_path = "SCHEMA_NAME", public; 
    
	-- Get parameters from input json
   	v_type = (SELECT (p_data::json->>'data')::json->>'type');
	v_message = (SELECT (p_data::json->>'data')::json->>'message');
	v_variables = (SELECT (p_data::json->>'data')::json->>'variables');
	v_debug = (SELECT (p_data::json->>'data')::json->>'debug');

	-- todo: implement diferent status of debug ('NOTICE', 'NOTIFY', 'ONTRANSCTION'). Last one using another database to commit steps intro one transaction in order to enhance debug
	
	-- start process
	IF (v_debug ->>'status')::boolean IS TRUE THEN
	    	RAISE NOTICE ' % ', concat(v_message,' ',v_variables);
	END IF;

        --  Return
        RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Debug passed successfully"}}')::json;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;