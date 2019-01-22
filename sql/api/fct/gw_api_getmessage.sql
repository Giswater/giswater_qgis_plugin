/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2594

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getmessage(p_data json, p_message integer)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getmessage($${"featureType":"visit", "idName":"visit_id", "id":"2001"}$$, 30)
*/

DECLARE
	v_record record;
	v_message text;
		
BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    SELECT * INTO v_record FROM config_api_message WHERE id=p_message;
    

    IF v_record.mtype='alone' THEN
		v_message = concat('{"level":"',v_record.loglevel,'", "text":"',v_record.message,'", "hint":"',v_record.hintmessage,'"}');
    ELSE 
		v_message = concat('{"level":"',v_record.loglevel,'", "text":"',(p_data)->>'featureType',' ',(p_data)->>'id',' ',v_record.message,'", "hint":"',v_record.hintmessage,'"}');
    END IF;
    
--    Return
    RETURN v_message::json;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

