/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "ws_sample"."gw_fct_deletevisitfile"(p_value text) RETURNS pg_catalog.json AS $BODY$
DECLARE

    v_resdelete boolean;
    v_apiversion json;

BEGIN


--    Set search path to local schema
    SET search_path = "ws_sample", public;    

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;
    
--    Get parameter id
    EXECUTE 'SELECT EXISTS(SELECT 1 FROM om_visit_file WHERE value = $1)'
    USING p_value
    INTO v_resdelete;

--    Return
    IF v_resdelete THEN

        EXECUTE 'DELETE FROM om_visit_file WHERE value = $1'
            USING p_value;

        RETURN ('{"status":"Accepted", "apiVersion":'|| v_apiversion ||'}')::json;
    ELSE
        RETURN ('{"status":"Failed", "message":"hash ' || p_value || ' does not exist", "apiVersion":'|| v_apiversion ||'}')::json;
    END IF;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

