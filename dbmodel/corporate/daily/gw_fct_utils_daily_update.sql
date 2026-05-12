/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION utils.gw_fct_utils_daily_update()

RETURNS json AS
$BODY$

DECLARE 
v_return integer;
v_error_context text;
v_message json;


BEGIN 

	-- Daily updates
    
    
    v_message = coalesce (v_message, '{}');

	-- Log
	INSERT INTO utils.audit_log (fprocesscat_id, log_message) VALUES (999, '{"status":"Accepted", "message":'||v_message||'}');
    
    
    RETURN ('{"status":"Accepted", "message":'||v_message||'}')::json;	
	

--  Exception handling
	EXCEPTION WHEN OTHERS THEN         
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;	
	INSERT INTO utils.audit_log (fprocesscat_id, log_message) VALUES (999, '{"status":"Failed",'NOSQLERR', SQLERRM, 'SQLSTATE', SQLSTATE,  ||',"SQLCONTEXT":' || to_json(v_error_context) || '}');
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

