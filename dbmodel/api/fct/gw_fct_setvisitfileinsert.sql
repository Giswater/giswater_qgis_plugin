/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "ws_sample"."gw_api_setvisitfileinsert"(p_visit_id int8, p_hash varchar, p_url text, p_compass float8) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    v_file integer;
    v_apiversion json;


BEGIN


--    Set search path to local schema
    SET search_path = "ws_sample", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

--    Event insert
    INSERT INTO om_visit_file (visit_id, value, text, compass) VALUES (p_visit_id, p_hash, p_url, p_compass) RETURNING id INTO v_file;

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| v_apiversion ||
        ', "id":"' || v_file || '"}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

